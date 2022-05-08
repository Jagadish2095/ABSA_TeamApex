({
	/****************@ Author: Chandra**********************************
	 ****************@ Date: 15/10/2020*********************************
	 ****************@ Work Id: W-006912,007776*************************
	 ***@ Description: Method Added by chandra to handle init function*/
	doInit: function (component, event, helper) {
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 16/02/2021
		component.set("v.isSpinner", true);
		component.set("v.columns", [
			{ label: "First Name", fieldName: "firstName", type: "text" },
			{ label: "Surname", fieldName: "surname", type: "text" },
			{ label: "Relationship Type", fieldName: "relationshipCode", type: "text" },
			{ label: "Percentage", fieldName: "percentSplit", type: "percentage", editable: true },
			{
				label: "Action",
				type: "button",
				initialWidth: 100,
				typeAttributes: {
					label: "Edit",
					name: "Edit",
					title: "Edit",
					disabled: false,
					value: "edit",
					iconPosition: "left",
					iconName: "action:edit"
				}
			},
			{
				type: "button",
				typeAttributes: {
					label: "Delete",
					name: "Delete",
					title: "Delete",
					disabled: false,
					value: "delete",
					iconPosition: "left",
					iconName: "action:delete"
				}
			}
		]);
		component.find("addBeneficiary").set("v.disabled", false);
		component.set("v.showRefreshButton", false);
		component.set("v.errorMessage", "");
		// Added by chandra dated 16/02/2021
		if (selectedProductType != "LX") {
			component.set("v.keyField", "lifeClientCode");
			helper.getBeneficiaryDetailList(component, event, helper);
		} else {
			component.set("v.keyField", "clientGID");
			helper.getBeneficiaryDetailListForExergy(component, event, helper);
			helper.getSessionId(component, event, helper);
		}
	},

	/****************@ Author: Chandra*********************************
	 ****************@ Date: 15/10/2020********************************
	 ****************@ Work Id: W-006901,006906,007778,007777**********
	 ***@ Description: Method Added by chandra to handle row Action***/
	handleRowAction: function (component, event, helper) {
		var row = event.getParam("row");
		var actionName = event.getParam("action").name;
		if (actionName == "Edit") {
			helper.showEditModal(component, row);
		} else if (actionName == "Delete") {
			component.set("v.pendingRow", row);
			component.set("v.showDeleteConfirmationModal", true);
		}
	},

	/****************@ Author: Chandra***************************************
	 ****************@ Date: 15/10/2020**************************************
	 ****************@ Work Id: W-006280,007783******************************
	 ***@ Description: Method Added by chandra to handle Add Beneficiary****/
	handleAddBeneficiary: function (component, event, helper) {
		helper.showAddModal(component);
	},

	/****************@ Author: Chandra***************************************************************
	 ****************@ Date: 19/10/2020**************************************************************
	 ****************@ Work Id: W-006280,006906,006901,006929,007772,007778,007777,007783************
	 ***@ Description: Method Added by chandra to handle percentage save****************************/
	handleSaveEdition: function (component, event, helper) {
		var sumOfPercentage = 0;
		var includeZeroValue = false;
		var existingDataItems = component.get("v.data");
		var draftValues = event.getParam("draftValues");
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 16/02/2021
		if (selectedProductType != "LX") {
			var draftValuesMap = helper.convertListToMapWithStringKey(draftValues, "lifeClientCode");
		} else {
			var draftValuesMap = helper.convertListToMapWithStringKey(draftValues, "clientGID");
		}

		existingDataItems.forEach(function (dataItem) {
			// Added by chandra dated 16/02/2021
			if (selectedProductType != "LX") {
				var currentDraftValue = draftValuesMap[dataItem.lifeClientCode];
			} else {
				var currentDraftValue = draftValuesMap[dataItem.clientGID];
			}

			if (currentDraftValue) {
				dataItem.percentSplit = currentDraftValue.percentSplit;

				if (!component.get("v.pendingRow")) {
					component.set("v.pendingRow", dataItem);
				}
			}

			if (dataItem.percentSplit == 0) {
				includeZeroValue = true;
			} else {
				sumOfPercentage += Number(dataItem.percentSplit);
			}
		});

		if (includeZeroValue == true) {
			helper.fireToastEvent("Error!", "Percentage of beneficiary should not be zero", "error");
			return;
		}

		if (sumOfPercentage != 100) {
			helper.fireToastEvent("Error!", "Sum of Percentage should must be equal to 100", "error");
			return;
		}

		component.set("v.data", existingDataItems);
		if (!component.get("v.pendingAction")) {
			component.set("v.pendingAction", "M");
		}
		helper.saveEditPercentage(component, event, helper);
	},

	/****************@ Author: Chandra************************************
	 ****************@ Date: 20/10/2020***********************************
	 ****************@ Work Id: W-006906,007777***************************
	 ***@ Description: Method Added by chandra to handle Cancel function*/
	handleCancel: function (component, event, helper) {
		component.find("overlayLib").notifyClose();
		component.set("v.showDeleteConfirmationModal", false);
	},

	/****************@ Author: Chandra************************************
	 ****************@ Date: 20/10/2020***********************************
	 ****************@ Work Id: W-006906,007777***************************
	 ***@ Description: Method Added by chandra to handle Delete function*/
	handleDelete: function (component, event, helper) {
		var pendingRow = component.get("v.pendingRow");
		var existingDataItems = component.get("v.data");
		const index = existingDataItems.indexOf(pendingRow);

		if (index > -1) {
			existingDataItems.splice(index, 1);
		}

		if (existingDataItems.length == 0) {
			helper.fireToastEvent("Error!", "Deletion of single  beneficiary is not allowed.", "error");
			component.set("v.showDeleteConfirmationModal", false);
			return;
		} else {
			component.set("v.data", existingDataItems);
			component.set("v.pendingAction", "P");
			component.set("v.showDeleteConfirmationModal", false);
			component.set("v.showMaintainBeneficiaryPercentMsg", true);
			component.find("addBeneficiary").set("v.disabled", true);
			var columns = component.get("v.columns");
			columns[4].typeAttributes.disabled = true;
			columns[5].typeAttributes.disabled = true;
			component.set("v.columns", columns);
		}
	},

	/****************@ Author: Chandra*************************************************************
	 ****************@ Date: 20/10/2020************************************************************
	 ****************@ Work Id: W-006280,006906,006901,006929,007772,007778,007777,007783**********
	 ***@ Description: Method Added by chandra to handle Submit Beneficiary***********************/
	handleSubmitBeneficiary: function (component, event, helper) {
		component.set("v.isSpinner", true);
		var existingDataItems = component.get("v.data");
		var pendingAction = component.get("v.pendingAction");
		var pendingRow = component.get("v.pendingRow");
		var serviceResponse = component.get("v.serviceResponse");
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 16/02/2021
		var requestBean = {};

		if (selectedProductType != "LX") {
			if (pendingRow.lifeClientCode === "defaultLifeClientCode") {
				pendingRow.lifeClientCode = null;
			}

			var percentSplitArray = [];
			var lifeClientCodeCounter = 0;

			existingDataItems.forEach(function (dataItem) {
				lifeClientCodeCounter++;
				var percentSplitArrayItem = {};
				percentSplitArrayItem["lifeClientCodeCounter"] = lifeClientCodeCounter;
				percentSplitArrayItem["lifeClientCodeArray"] = dataItem.lifeClientCode;
				percentSplitArrayItem["roleType"] = "Beneficiary";
				percentSplitArrayItem["roleNumber"] = lifeClientCodeCounter;
				percentSplitArrayItem["percentSplit"] = dataItem.percentSplit;

				percentSplitArray.push(percentSplitArrayItem);
			});

			var changeEffectiveDate = $A.localizationService.formatDate(new Date(), "yyyy-MM-dd");
			if (pendingRow.firstName) {
				var initial = pendingRow.firstName
					.trim()
					.split(" ")
					.map((n) => n[0])
					.join("")
					.toUpperCase();
			}

			requestBean["LAupdateBeneficiaryDetailsV2"] = {};
			requestBean["LAupdateBeneficiaryDetailsV2"]["nbsapdpi"] = {};
			requestBean["LAupdateBeneficiaryDetailsV2"]["nbsapdpi"]["channel"] = "I";
			requestBean["LAupdateBeneficiaryDetailsV2"]["nbsapdpi"]["application"] = "ALVS";
			requestBean["LAupdateBeneficiaryDetailsV2"]["nbsapdpi"]["trace"] = "N";

			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"] = {};
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["action"] = pendingAction;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["policyNumber"] = serviceResponse.policyNumber;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["businessSourceIndicator"] = serviceResponse.businessSourceIndicator;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["sourceOfIncome"] = serviceResponse.sourceOfIncome;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["sourceOfFund"] = serviceResponse.sourceOfFund;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["lifeClientCode"] = pendingRow.lifeClientCode;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["changeEffectiveDate"] = changeEffectiveDate;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["surname"] = pendingRow.surname;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["initial"] = initial;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["dateOfBirth"] = pendingRow.dateOfBirth;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["titleCode"] = pendingRow.titleCode;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["language"] = "E";
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["identityNumber"] = pendingRow.idNumber;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["idType"] = pendingRow.idType;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["contactPerson"] = pendingRow.firstName;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["contactTelephoneNumber"] = pendingRow.contactTelephoneNumber;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["preferredCommunication"] = "1";
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["emailAddress"] = pendingRow.emailAddress;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["addressLine1"] = pendingRow.addressLine1;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["addressLine2"] = pendingRow.addressLine2;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["suburb"] = pendingRow.suburb;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["city"] = pendingRow.city;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["postalCode"] = pendingRow.postalCode;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["relationshipCode"] = pendingRow.relationshipCode;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["lifeClientCodeCount"] = lifeClientCodeCounter;
			requestBean["LAupdateBeneficiaryDetailsV2"]["la950p9i"]["percentSplitArray"] = percentSplitArray;

			helper.callLAUpdateBeneficiaryDetailsV2(component, event, helper, requestBean);
		} else {
			// Added by chandra dated 16/02/2021
			var v3_BeneficaryCaptureInformationArray = [];
			var policyNumberFromFlow = component.get("v.policyNumberFromFlow");
			policyNumberFromFlow = Number(policyNumberFromFlow).toString();

			existingDataItems.forEach(function (dataItem) {
				if (dataItem.firstName) {
					var initial = pendingRow.firstName
						.trim()
						.split(" ")
						.map((n) => n[0])
						.join("")
						.toUpperCase();
				}

				var v3_BeneficaryCaptureInformation = {};
				v3_BeneficaryCaptureInformation["AddressLine1"] = dataItem.addressLine1;
				v3_BeneficaryCaptureInformation["AddressLine2"] = dataItem.addressLine2;
				v3_BeneficaryCaptureInformation["City"] = dataItem.city;
				if (dataItem.clientGID == "defaultClientGID") {
					v3_BeneficaryCaptureInformation["ClientGID"] = "";
				} else {
					v3_BeneficaryCaptureInformation["ClientGID"] = dataItem.clientGID;
				}
				v3_BeneficaryCaptureInformation["ContactNumber"] = dataItem.contactTelephoneNumber;
				v3_BeneficaryCaptureInformation["ContactTypeID"] = dataItem.contactTypeID;
				v3_BeneficaryCaptureInformation["DateOfBirth"] = $A.localizationService.formatDate(dataItem.dateOfBirth, "yyyyMMdd");
				v3_BeneficaryCaptureInformation["EmailAddress"] = dataItem.emailAddress;
				v3_BeneficaryCaptureInformation["FirstName"] = dataItem.firstName;
				v3_BeneficaryCaptureInformation["IdentificationNumber"] = dataItem.idNumber;
				v3_BeneficaryCaptureInformation["IdentifyTypeID"] = dataItem.idType;
				v3_BeneficaryCaptureInformation["Initials"] = initial;
				v3_BeneficaryCaptureInformation["Percentage"] = dataItem.percentSplit;
				v3_BeneficaryCaptureInformation["PostalCode"] = dataItem.postalCode;
				v3_BeneficaryCaptureInformation["RelationShipID"] = dataItem.relationshipCode;
				v3_BeneficaryCaptureInformation["Suburb"] = dataItem.suburb;
				v3_BeneficaryCaptureInformation["Surname"] = dataItem.surname;
				v3_BeneficaryCaptureInformation["TitleID"] = dataItem.titleCode;

				v3_BeneficaryCaptureInformationArray.push(v3_BeneficaryCaptureInformation);
			});

			requestBean["Contract_Capture_Beneficary"] = {};
			requestBean["Contract_Capture_Beneficary"]["pstrSessionGID"] = component.get("v.exergySessionId");
			requestBean["Contract_Capture_Beneficary"]["pstrPolicyNumber"] = policyNumberFromFlow;
			requestBean["Contract_Capture_Beneficary"]["pintSourceofFundsID"] = 13540;
			requestBean["Contract_Capture_Beneficary"]["pobjBeneficaryInformation"] = {};
			requestBean["Contract_Capture_Beneficary"]["pobjBeneficaryInformation"]["V3_BeneficaryCaptureInformation"] = v3_BeneficaryCaptureInformationArray;

			helper.callContractCaptureBeneficiary(component, event, helper, requestBean);
		}
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 20/10/2020*************************************
	 ****************@ Work Id: W-006280,006901,007783,007778***************
	 ***@ Description: Method Added by chandra to handle application event*/
	handleApplicationEvent: function (component, event, helper) {
		var dataItemFromEvent = event.getParam("policyBeneficiaryList")[0];
		var actionType = event.getParam("actionType");
		var existingDataItems = component.get("v.data");
		var selectedProductType = component.get("v.selectedProductTypeFromFlow"); // Added by chandra dated 16/02/2021

		if (actionType == "Add") {
			existingDataItems.push(dataItemFromEvent);
			component.set("v.data", existingDataItems);
			component.set("v.pendingAction", "A");
			component.set("v.pendingRow", dataItemFromEvent);
			component.set("v.showMaintainBeneficiaryPercentMsg", true);
			component.find("addBeneficiary").set("v.disabled", true);
			var columns = component.get("v.columns");
			columns[4].typeAttributes.disabled = true;
			columns[5].typeAttributes.disabled = true;
			component.set("v.columns", columns);
		} else {
			var updatedDataItems = [];

			// Added by chandra dated 16/02/2021
			if (selectedProductType != "LX") {
				var lifeClientCodeFromEvent = dataItemFromEvent.lifeClientCode;
				existingDataItems.forEach(function (existingDataItem) {
					if (existingDataItem.lifeClientCode == lifeClientCodeFromEvent) {
						updatedDataItems.push(dataItemFromEvent);
					} else {
						updatedDataItems.push(existingDataItem);
					}
				});
			} else {
				var clientGIDFromEvent = dataItemFromEvent.clientGID;
				existingDataItems.forEach(function (existingDataItem) {
					if (existingDataItem.clientGID == clientGIDFromEvent) {
						updatedDataItems.push(dataItemFromEvent);
					} else {
						updatedDataItems.push(existingDataItem);
					}
				});
			}
			console.log("updatedDataItems: " + JSON.stringify(updatedDataItems));
			component.set("v.data", updatedDataItems);
			component.set("v.pendingAction", "M");
			component.set("v.pendingRow", dataItemFromEvent);
			component.set("v.showSubmitBeneficiary", true);
			component.find("addBeneficiary").set("v.disabled", true);
			var columns = component.get("v.columns");
			columns[4].typeAttributes.disabled = true;
			columns[5].typeAttributes.disabled = true;
			component.set("v.columns", columns);
		}
	}
});