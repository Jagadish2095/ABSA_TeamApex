({
	faceToFaceBookingHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.bookingRequest");
		action.setParams({
			deliveryTownCode: component.get("v.townCode"),
			deliverySuburb: component.get("v.suburbSelected"),
			clientName: component.get("v.personName"),
			clientIDPassport: component.get("v.iDNumber"),
			clientContactNo: component.get("v.contactNumber"),
			clientDelivery1: component.get("v.deliveryAddressLine1"),
			clientDelivery2: component.get("v.suburbSelected"),
			clientDelivery3: component.get("v.city"),
			referenceValue: component.get("v.regNumber"),
			productCode: component.get("v.prodCode"),
			deliveryPostalCode: component.get("v.postalCode"),
			deliveryCountryCode: component.get("v.deliveryCountry"),
			deliveryDateTime: component.get("v.selectedDateValue"),
			tripSheetID: component.get("v.tripSheet"),
			tripServiceTime: component.get("v.selectedTimeSlot"),
			notificationCellNo: component.get("v.altNumber"),
			clientSpecialInstructions: component.get("v.splInstruction"),
			deliveryType: 1,
			deliveryProvinceCode: component.get("v.addProvince")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var responseBean = response.getReturnValue();
				var responseMessage = JSON.stringify(responseBean.Messages);
				if (responseBean.Successful == "Y") {
					helper.fireToast("Success!", responseMessage, "success"); //message response is too quick to read, so displaying toast
				} else {
					helper.fireToast("Error!", responseMessage, "error");
				}

				if (!component.get("v.isLastCard")) {
					var tempCard = component.get("v.cardNumber");
					var newProcessedCard = component.get("v.processedCards");
					var passCard = newProcessedCard + ";" + tempCard;
					component.set("v.processedCards", passCard);
					helper.navigateNext(component);
				} else {
					component.set("v.isCloseCase", true);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("Error!", "Error occurred", "error");
						component.set("v.errorMessage", errors[0].message);
					}
				}
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	requestArrayBookingHelper: function (component, event, helper, deliveryType) {
		helper.showSpinner(component);
		var action = component.get("c.receiveInstructionArray");
		if (deliveryType == "Knock and Drop") {
			action.setParams({
				branchCode: "",
				cardIssueType: component.get("v.issueType"),
				cellNumber: component.get("v.contactNumber"),
				idPassportNumber: component.get("v.iDNumber"),
				operatorName: component.get("v.personName"),
				noOfItems: 1,
				secureItemNo: component.get("v.regNumber"),
				stockType: component.get("v.prodCode"),
				deliveryAddress1: component.get("v.deliveryAddressLine1"),
				deliveryAddress2: component.get("v.deliveryAddressLine2"),
				deliveryTown: component.get("v.city"),
				deliverySuburb: component.get("v.suburbSelected"),
				postalCode: component.get("v.postalCode"),
				altNumber: component.get("v.altNumber"),
				splInstruction: component.get("v.splInstruction") //Special Instruction
			});
		} else {
			//Delivery type is Branch
			var branch = JSON.parse(component.get("v.branchCode"));
			action.setParams({
				branchCode: branch.Site_Code__c,
				cardIssueType: component.get("v.issueType"),
				cellNumber: component.get("v.contactNumber"),
				idPassportNumber: component.get("v.iDNumber"),
				operatorName: component.get("v.personName"),
				noOfItems: 1,
				secureItemNo: component.get("v.regNumber"),
				stockType: component.get("v.prodCode"),
				deliveryAddress1: "",
				deliveryAddress2: "",
				deliveryTown: "",
				deliverySuburb: "",
				postalCode: "",
				altNumber: "",
				splInstruction: ""
			});
		}

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var responseBean = response.getReturnValue();

				var responseObj = responseBean.ReceiveInstructionRequestArrayResponse.ReceiveInstructionRequestArrayResult.Items.InstructionItemArrayReply;

				if (responseObj[0].Success == "Y") {
					helper.fireToast("Success!", "Booking submission is successful", "success"); //message response is too quick to read, so displaying toast
				} else {
					helper.fireToast("Error!", responseObj[0].ErrorDetails, "error"); //message response is too quick to read, so displaying toast
				}

				if (!component.get("v.isLastCard")) {
					var tempCard = component.get("v.cardNumber");
					var newProcessedCard = component.get("v.processedCards");
					var passCard = newProcessedCard + ";" + tempCard;

					component.set("v.processedCards", passCard);
					helper.navigateNext(component);
				} else {
					component.set("v.isCloseCase", true);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("Error!", "Error Occurred", "error");
						component.set("v.errorMessage", errors[0].message);
					}
				}
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	dateAndTimeSlotHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getDateTimeData");
		action.setParams({
			deliveryResponse: component.get("v.bookAvailSlots")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				//store the return response from server (map<string,List<string>>)
				var response = response.getReturnValue();

				// once set #response to timeSlotValuesMap attribute
				component.set("v.timeSlotValuesMap", response);

				// create a empty array for store map keys(@@--->which is controller picklist values)
				var dateList = ["--- None ---"]; // for store all map keys (controller picklist values)

				// play a for loop on Return map
				// and fill the all map key on dateList variable.
				for (var key in response) {
					dateList.push(key);
				}

				// set the dateList variable values to dateValues(controller picklist field)
				component.set("v.dateValues", dateList);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("Error!", "Error Occurred", "error");
						component.set("v.errorMessage", errors[0].message);
					}
				}
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	fetchTimeValuesHelper: function (component, timeSlotList) {
		// create a empty array var for store dependent picklist values for controller field
		var timeValues = ["--- None ---"];

		for (var i = 0; i < timeSlotList.length; i++) {
			timeValues.push(timeSlotList[i]);
		}
		// set the timeValues variable values to store(dependent picklist field) on lightning:select
		component.set("v.timeSlotValueList", timeValues);
	},

	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
			mode: "sticky"
		});
		toastEvent.fire();
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", "false");
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", "true");
	},

	navigateNext: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	navigateBack: function (component, event) {
		var navigate = component.get("v.navigateFlow");
		navigate("BACK");
	}
});