({
	doInit: function (component, event, helper) {
		component.set("v.isSpinner", true);
		helper.getCombiAccountListHelper(component, event, helper);
        helper.getLoggedInUserDetailsHelper(component, event, helper);
	},

	handleLoad: function (component, event, helper) {
		helper.getLoggedInUserDetailsHelper(component, event, helper);
	},

	onSelectCombiAccount: function (component, event, helper) {
		if (!component.get("v.selectedCombiValue")) {
			return;
		}
		component.set("v.mapValues", null);
		helper.getLoggedInUserDetailsHelper(component, event, helper);
	},

	handleSelect: function (component, event, helper) {
		var menuLabel = event.detail.menuItem.get("v.label");
		var instroNo = event.detail.menuItem.get("v.value");

		switch (menuLabel) {
			case "Edit":
				helper.handleClickUpdate(component, helper, instroNo);
				break;
			case "Delete":
				helper.handleClickRemove(component, helper, instroNo);
				break;
		}
	},

	closeEditBeneficiary: function (component, event, helper) {
		component.set("v.isEditBeneficiaryOpen", false);
	},

	closeRemoveBeneficiary: function (component, event, helper) {
		component.set("v.isRemoveBeneficiaryOpen", false);
	},

	onTargetAccTypeChange: function (component, event, helper) {
		component.set("v.selectedTargetAccType", component.find("iselectAccType").get("v.value"));
		console.log("selectedTargetAccType : " + component.get("v.selectedTargetAccType"));
	},

	actionEditBeneficiary: function (component, event, helper) {
		component.set("v.isSpinner", true);

		var accountId = component.get("v.recordId");
		var instrNo = component.get("v.instrNo");
		var beneficiaryNameValue = component.get("v.beneficiaryName");
		var accNo = component.get("v.accountNumber");
		var sourceAccType = component.get("v.accountNumberType");
		var targetAccType = component.find("iselectAccType").get("v.value");
		var targetAccountValue = component.get("v.targetAccount");
		var branchCodeId = component.get("v.selectedBranchCodeId");
		var sourceRefValue = component.get("v.sourceRef");
		var targetRefValue = component.get("v.targetRef");
		var ivrCustNo = component.get("v.ivrCode");
		var tieb = component.get("v.tieb");

		if (
			beneficiaryNameValue == undefined ||
			beneficiaryNameValue == "" ||
			beneficiaryNameValue == null ||
			branchCodeId == undefined ||
			branchCodeId == "" ||
			branchCodeId == null ||
			targetAccType == undefined ||
			targetAccType == "" ||
			targetAccType == null ||
			targetAccountValue == undefined ||
			targetAccountValue == "" ||
			targetAccountValue == null ||
			sourceRefValue == undefined ||
			sourceRefValue == "" ||
			sourceRefValue == null ||
			targetRefValue == undefined ||
			targetRefValue == "" ||
			targetRefValue == null
		) {
			component.set("v.isRequiredFieldsMissing", true);
			return;
		} else {
			component.set("v.isRequiredFieldsMissing", false);
		}

		var actionUpdateBeneficiary = component.get("c.updateIVRBeneficiary");

		actionUpdateBeneficiary.setParams({
			accId: accountId,
			instrNo: instrNo,
			beneficiaryName: beneficiaryNameValue,
			srcAccNumber: accNo,
			srcAccType: sourceAccType,
			trgAccType: targetAccType,
			trgAccNumber: targetAccountValue,
			trgBranchCodeId: branchCodeId,
			srcRef: sourceRefValue,
			trgRef: targetRefValue,
			ivrCustNo: ivrCustNo,
			tieb: tieb
		});

		// Add callback behavior for when response is received
		actionUpdateBeneficiary.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					var toast = helper.getToast("Error!", "Unable to update beneficiary. " + responseData, "Error");
					toast.fire();
				} else {
					var toast = helper.getToast("Success!", "Beneficiary successfully updated." + responseData + ".", "Success");
					toast.fire();
				}

				// Refresh table after update
				var a = component.get("c.handleLoad");
				$A.enqueueAction(a);

				component.set("v.isEditBeneficiaryOpen", false);
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			} else {
				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			}
			component.set("v.isSpinner", false);
		});

		// Send action off to be executed
		$A.enqueueAction(actionUpdateBeneficiary);
	},

	actionRemoveBeneficiary: function (component, event, helper) {
		component.set("v.isSpinner", true);

		var accountId = component.get("v.recordId");
		var instrNo = component.get("v.instrNo");
		var loggedInUser = component.get("v.userRecord");
		var tieb = component.get("v.tieb"); //added by Innocent

		var actionRemoveBeneficiary = component.get("c.removeBeneficiary");

		actionRemoveBeneficiary.setParams({
			accId: accountId,
			instrNo: instrNo,
			userRecord: loggedInUser,
			tieb:tieb, //added by Innocent
		});

		// Add callback behavior for when response is received
		actionRemoveBeneficiary.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var reponseRemoveBeneficiary = response.getReturnValue();

				var toast = helper.getToast("Success", reponseRemoveBeneficiary, "Success");
				toast.fire();

				component.set("v.isRemoveBeneficiaryOpen", false);
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			} else {
				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			}
			component.set("v.isSpinner", false);
		});

		// Send action off to be executed
		$A.enqueueAction(actionRemoveBeneficiary);
	},

	setIVRCode: function (component, event, helper) {
		let ivrBeneficiaryCheckbox = component.get("v.ivrBeneficiaryCheckbox");
		let ivrCode = component.get("v.ivrCode");
		let maxIVRCode = component.get("v.maxIVRCode");
		if (ivrBeneficiaryCheckbox && (ivrCode == "" || ivrCode == 0)) {
			let nextIVRCode = maxIVRCode + 1;
			component.set("v.ivrCode", nextIVRCode);
		}

		if (ivrBeneficiaryCheckbox == false && ivrCode > maxIVRCode) {
			component.set("v.ivrCode", "");
		}
	},

	actionAddBeneficiary: function (component, event, helper) {
		helper.addBeneficiary(component);
	},

	handleAddBeneficiary: function (component, event, helper) {
		component.set("v.isAddBeneficiary", true);
		component.set("v.isEditBeneficiaryOpen", true);
		component.set("v.beneficiaryName", "");
		component.set("v.targetAccount", "");
		component.set("v.sourceRef", "");
		component.set("v.targetRef", "");
		component.set("v.ivrCode", "");
		component.set("v.ivrBeneficiaryCheckbox", false);
		//component.find("ivrBeneficiary").set("v.disabled", false);
	},

	//function called when the Send Beneficiary List button is clicked to open the Send Beneficiary list modal
	handleSendBeneficiaryList: function (component, event, helper) {
		helper.openSendBeneficiaryListModalHelper(component, event, helper);
	},

	//function called when the Close button is clicked to close the Send Beneficiary list modal
	closeSendBeneficiaryListModal: function (component, event, helper) {
		helper.closeSendBeneficiaryListModalHelper(component, event, helper);
	},

	//DBOOYSEN. 2021/04/09
	//function to handle the post load actions of the caseEditFormModal
	handleAccountLoad: function (component, event, helper) {
		if (component.get("v.isBusinessAccountFromFlow") == "true") {
			//Business account
			component.set("v.clientEmailAddress", component.find("activeEmailFieldModal").get("v.value"));
		} else {
			//Non business account
			component.set("v.clientEmailAddress", component.find("personEmailFieldModal").get("v.value"));
		}
	},

	//DBOOYSEN. 2021/04/09
	//function to handle the actions of the caseEditFormModal when successfully saved
	handleCaseSuccessModal: function (component, event, helper) {
		var toast = helper.getToast("Success", "Beneficiary List sent and Case Closed Successfully", "success");
		toast.fire();
	},

	//function called when the Send Email button is clicked on the Send Beneficiary list modal
	sendEmail: function (component, event, helper) {
		if (component.find("clientEmailAddressField").checkValidity() == true) {
			component.set("v.clientEmailAddress", component.find("clientEmailAddressField").get("v.value"));
			helper.sendBeneficiaryListHelper(component, event, helper);
		} else {
			var toast = helper.getToast("Error!", "Email Address Is Not Valid", "error");
			toast.fire();
		}
	},

	//DBOOYSEN. 2021/04/14
	//Navigate to the next view to send the proof of payment for the selected payment
	navigateToComponent: function (component, event, helper) {
		//Navigate Next
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	}
});