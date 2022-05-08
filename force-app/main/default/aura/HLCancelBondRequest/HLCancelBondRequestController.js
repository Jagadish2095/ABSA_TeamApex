({
	doInit: function (component, event, helper) {
		component.find("btnSubmit").set("v.disabled", true);

		helper.showSpinner(component);
		helper.updateCaseAccountNumber(component);
		helper.getAccountInformationCancellation(component);
	},

	handleCancelReasonChange: function (component, event, helper) {
		var selectedValue = event.getSource().get("v.value");
		component.set("v.selectedCancelReason", selectedValue);
	},

	viewTermsAndConditions: function (component, event, helper) {
		component.set("v.showTermsAndConditions", true);
	},

	closeTermsAndConditions: function (component, event, helper) {
		component.set("v.termsAndConditionsAccepted", false);
		component.find("btnSubmit").set("v.disabled", true);
		component.set("v.showTermsAndConditions", false);
	},

	acceptTermsAndConditions: function (component, event, helper) {
		component.set("v.termsAndConditionsAccepted", true);
		component.find("btnSubmit").set("v.disabled", false);
		component.set("v.showTermsAndConditions", false);
	},

	handleSubmit: function (component, event, helper) {
		helper.showSpinner(component);
		helper.validateFieldValues(component);
	},

	confirmCancellationSubmission: function (component, event, helper) {
		helper.showSpinner(component);
		helper.updateAccountInformationCancellation(component);
		component.set("v.showConfirmSubmission", false);
	},

	closeCancellationConfirmation: function (component, event, helper) {
		component.set("v.showConfirmSubmission", false);
		component.set("v.termsAndConditionsAccepted", false);
		component.find("btnSubmit").set("v.disabled", true);
		helper.hideSpinner(component);
	}
});