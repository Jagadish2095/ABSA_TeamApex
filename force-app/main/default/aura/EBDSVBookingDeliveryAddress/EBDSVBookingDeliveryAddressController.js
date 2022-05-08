({
	loadOptions: function (component, event, helper) {
		var inVal = component.get("v.deliveryType");
		var opts = [
			{ value: "Face To Face", label: "Face To Face" },
			{ value: "Branch", label: "Branch" }
		];
		if (inVal == "Knock and Drop") {
			opts.unshift({ value: "Knock and Drop", label: "Knock and Drop" });
		}

		component.set("v.options", opts);
		component.set("v.columns", [
			{ label: "Type", fieldName: "Address_Type__c", type: "text" },
			{ label: "Line1", fieldName: "Shipping_Street__c", type: "text" },
			{ label: "Line2", fieldName: "Shipping_Street_2__c", type: "text" },
			{ label: "Suburb", fieldName: "Shipping_Suburb__c", type: "text" },
			{ label: "City", fieldName: "Shipping_City__c", type: "text" },
			{ label: "Postal", fieldName: "Shipping_Zip_Postal_Code__c", type: "text" },
			{ label: "Country", fieldName: "Shipping_Country__c", type: "text" }
		]);

		var flowaddressData = component.get("v.addressDataTableList");
		//To show the address details consistency
		if ($A.util.isEmpty(flowaddressData)) {
			helper.getAccountRecord(component, helper); // Calling Helper method
		} else {
			// Setting the data table with previous data from the flow
			var flowAddData = JSON.parse(flowaddressData);
			component.set("v.data", flowAddData);
		}
	},

	updateSelectedText: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var notenumber = component.get("v.contactNumber");
		var addType = selectedRows[0].Address_Type__c;
		var addressline1 = selectedRows[0].Shipping_Street__c;
		var addressline2 = selectedRows[0].Shipping_Street_2__c;
		var country = selectedRows[0].Shipping_Country__c;
		var postal = selectedRows[0].Shipping_Zip_Postal_Code__c;
		var city = selectedRows[0].Shipping_City__c;
		var suburb = selectedRows[0].Shipping_Suburb__c;
		var accAddID = selectedRows[0].Id;
		component.set("v.addLine1", addressline1);
		component.set("v.addLine2", addressline2);
		component.set("v.addCountry", country);
		component.set("v.addressID", accAddID);
		component.set("v.addType", addType);
		component.set("v.addSuburb", suburb);
		component.set("v.addCity", city);
		component.set("v.addPostal", postal);
		component.set("v.addNotifyNumber", notenumber);

		component.set("v.isModalOpen", true);
	},

	siteSelected: function (component, event, helper) {
		var selectedSiteRecord = component.get("v.selectedSiteRecord");
		component.set("v.branchCode", JSON.stringify(selectedSiteRecord));
		helper.navigateNext(component);
	},

	alternativeAddressBtnClick: function (component, event) {
		component.set("v.isModalOpen", true);

		component.set("v.addLine1", "");
		component.set("v.addLine2", "");
		component.set("v.addCountry", "");
		component.set("v.addressID", "");
		component.set("v.addSuburb", "");
		component.set("v.addCity", "");
		component.set("v.addProvince", "");
		component.set("v.addPostal", "");
		component.set("v.addType", "");
		component.set("v.contactNumber", "");
		component.set("v.altNumber", "");
		component.set("v.splInstruction", "");
	},

	closeModal: function (component, event, helper) {
		// Set isModalOpen attribute to false
		component.set("v.isModalOpen", false);
		component.find("urgentDelivery").set("v.checked", false);
		component.find("addressTable").set("v.selectedRows", []);
	},

	submitDetails: function (component, event, helper) {
		// Set isModalOpen attribute to false
		//Add your code to call apex method or do some processing

		//component.find("addressTable").set("v.selectedRows", []);
		var addressList = component.get("v.data");
		var addID = component.find("addID").get("v.value");
		var atype = component.find("atype").get("v.value");
		var addressline1 = component.find("addressline1").get("v.value");
		var addressline2 = component.find("addressline2").get("v.value");
		var suburb = component.find("suburb").get("v.value");
		var city = component.find("city").get("v.value");
		var province = component.find("province").get("v.value");
		var postal = component.find("postal").get("v.value");
		var country = component.find("country").get("v.value");
		var notinumber = component.find("notinumber").get("v.value");
		var alternumber = component.find("alternumber").get("v.value");
		if ($A.util.isEmpty(alternumber)) {
			alternumber = notinumber;
		}
		var instruct = component.find("instruct").get("v.value");
		if ($A.util.isEmpty(instruct)) {
			instruct = "0";
		}

		if (!addID) {
			const alternativeId = Math.random().toString(15); // For Random Id Generation.
			var addrAlt = {
				Id: alternativeId,
				Address_Type__c: "Alternative",
				Shipping_Street__c: addressline1,
				Shipping_Street_2__c: addressline2,
				Shipping_Suburb__c: suburb,
				Shipping_City__c: city,
				Shipping_Zip_Postal_Code__c: postal,
				Shipping_Country__c: country
			};
			component.set("v.addressData", JSON.stringify(addrAlt));
			addressList.push(addrAlt);
		} else {
			for (var i = 0; i < addressList.length; i++) {
				var accAddID = addressList[i].Id;
				if (accAddID == addID) {
					addressList[i].Shipping_Street__c = addressline1;
					addressList[i].Shipping_Street_2__c = addressline2;
					addressList[i].Shipping_Suburb__c = suburb;
					addressList[i].Shipping_City__c = city;
					addressList[i].Shipping_Zip_Postal_Code__c = postal;
					addressList[i].Shipping_Country__c = country;
					addressList[i].Address_Type__c = atype;
					component.set("v.addressData", JSON.stringify(addressList[i]));
					break;
				}
			}
		}

		component.set("v.data", addressList);
		component.set("v.addressDataTableList", JSON.stringify(addressList));
		component.set("v.addProvince", province);
		component.set("v.postalCode", postal);
		component.set("v.contactNumber", notinumber);
		component.set("v.altNumber", alternumber);
		component.set("v.splInstruction", instruct);

		var selectedDeliveryMethod = component.get("v.selectedDeliveryMethod");
		component.set("v.deliveryType", selectedDeliveryMethod);
		var errorMessageModal;
		if (!addressline1) {
			errorMessageModal += "Address Line 1 cannot be empty. ";
		} else if (!addressline2) {
			errorMessageModal += "Address Line 2 cannot be empty. ";
		} else if (!suburb) {
			errorMessageModal += "Suburb cannot be empty. ";
		} else if (!city) {
			errorMessageModal += "Town cannot be empty. ";
		} else if (!province) {
			errorMessageModal += "Province cannot be empty. ";
		} else if (!postal) {
			errorMessageModal += "Postal code cannot be empty. ";
		} else if (!country) {
			errorMessageModal += "Country cannot be empty. ";
		} else if (!notinumber) {
			errorMessageModal += "Notification Number cannot be empty. ";
		} else {
			if (component.find("urgentDelivery").get("v.checked")) {
				helper.sendEmailHelper(component, event, helper);
			} else {
				component.set("v.errorMessageModal", "");
				if (selectedDeliveryMethod == "Face To Face") {
					helper.bookingDeliveryFaceToFace(component, helper, suburb, city);
				} else if (selectedDeliveryMethod == "Knock and Drop") {
					helper.navigateNext(component);
				}
				component.set("v.isModalOpen", false);
			}
		}
		component.set("v.errorMessageModal", errorMessageModal);
	},

	//Added by Chandra to stop propagation of selectedJobEvent dated 07/01/2021
	handleSelectedJobEvent: function (component, event, helper) {
		event.stopPropagation();
	},

	onDeliveryMethodChange: function (component, event, helper) {
		var selectedDeliveryMethod = event.getSource().get("v.value");
		component.set("v.deliveryType", selectedDeliveryMethod);
		component.set("v.selectedDeliveryMethod", selectedDeliveryMethod);
	},

	handleSiteChange: function (component, event, helper){
		var siteId = component.get("v.siteId");
		if(siteId){
			component.set("v.showBranchDetails", true);
		}
		else{
			component.set("v.showBranchDetails", false);
		}
	}
});