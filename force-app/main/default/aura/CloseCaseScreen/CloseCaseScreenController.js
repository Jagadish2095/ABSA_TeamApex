({
	//JQUEV 2020-11-12
	doInit: function (component, event, helper) {
		if ($A.util.isEmpty(component.get("v.caseIdFromFlow"))) {
			//Error - required fields missing
			component.set("v.errorMessage", "Case Id is Required to perform this action");
			component.set("v.isFormReadOnly", true);
		}

		//Set Beneficiary fields -Simangaliso Mathenjwa 21 March 2021
		if (component.get("v.activeTabFromFlow") == "onceOffPayment") {
			var addBenFieldsFromFlow = component.get("v.addBenFieldsToFromFlow");
			var beneficiaryFields = JSON.parse(addBenFieldsFromFlow);
			component.set("v.selectedProductValue", beneficiaryFields.selectedProductTypeFromFlow);
			component.set("v.selectedAccountNumber", beneficiaryFields.selectedAccountNumberToFlow);
			component.set("v.recipientRefName", beneficiaryFields.beneficiaryName);
			component.set("v.targetAccountNo", beneficiaryFields.accountNumber);
			component.set("v.targetBankName", beneficiaryFields.selectedBankName);
			component.set("v.selectedBranchCode", beneficiaryFields.branchCode);
			component.set("v.selectedTargetAccType", beneficiaryFields.selectedTargetAccType);
			component.set("v.recipientReference", beneficiaryFields.beneficiaryReference);
			component.set("v.paymentRefName", beneficiaryFields.ownReference);
			component.set("v.respFromCIGetAccLink", beneficiaryFields.respFromCIGetAccLink);
		}
	},

	//Load
	handleLoad: function (component, event, helper) {
		if (component.get("v.closeCaseFromFlow") && component.get("v.sendEmailFromFlow")) {
			component.find("actionBtn").set("v.label", "Send Email & Close Case");
		} else if (component.get("v.closeCaseFromFlow")) {
			component.find("actionBtn").set("v.label", "Close Case");
		} else if (component.get("v.sendEmailFromFlow")) {
			component.find("actionBtn").set("v.label", "Send Email");
		}
		helper.hideSpinner(component);
	},

	//Submit
	handleSubmit: function (component, event, helper) {
		helper.showSpinner(component);
	},

	//Success
	handleSuccess: function (component, event, helper) {
		helper.hideSpinner(component);
		component.set("v.isFormReadOnly", true);
		component.set("v.errorMessage", null);
		//Fire Toast message
		helper.fireToast("Success!", component.get("v.toastMessage"), "success");
	},

	//Error
	handleError: function (component, event, helper) {
		helper.hideSpinner(component);
		helper.fireToast("Error!", "There has been an error saving the data. ", "error");
		component.set("v.errorMessage", "There has been an error saving the data: " + JSON.stringify(event.getParams()));
	},

	//JQUEV 2020-11-12
	handleAction: function (component, event, helper) {
		if (component.get("v.sendEmailFromFlow")) {
			if ($A.util.isEmpty(component.get("v.emailAddressFromFlow"))) {
				//Email is null
				helper.fireToast("Error!", "Please supply an Email Address. ", "error");
			} else {
				helper.sendEmailHelper(component, event, helper);
			}
		} else if (component.get("v.closeCaseFromFlow")) {
			helper.showSpinner(component);

			//Disable Add Beneficiary / Make another Payment Button Simangaliso Mathenjwa 21 March 2021
			if (!$A.util.isEmpty(component.get("v.activeTabFromFlow"))) {
				var makeAnotherPaymentButton = component.find("NEXT");
				makeAnotherPaymentButton.set("v.disabled", true);

				if (component.get("v.activeTabFromFlow") == "onceOffPayment") {
					var addBeneficiaryButton = component.find("addBeneficiary");
					addBeneficiaryButton.set("v.disabled", true);
				}
			}

			component.set("v.toastMessage", "Case Successfully Closed. ");
			//Close case
			component.find("statusField").set("v.value", "Closed");
			component.find("caseEditForm").submit();
		}
	},

	//handle make another payment navigation - Simangaliso Mathenjwa 21 March 2021
	onButtonPressed: function (component, event, helper) {
		component.set("v.makeAnotherPaymentToFlow", true);
		component.set("v.showPaymentStatusSuccessFromFlow", false);
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	//Open Add Beneficiary Function - Simangaliso Mathenjwa 21 March 2021
	openAddBeneficiaryModal: function (component, event, helper) {
		component.set("v.showAddBeneficiary", true);
	},

	//Close Open Beneficiary function - Simangaliso Mathenjwa 21 March 2021
	closeAddBeneficiarayModal: function (component, event, helper) {
		component.set("v.showAddBeneficiary", false);
	}
});