({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		helper.getPolicyData(component, event, helper);
	},

	handleReasonChange: function (component, event, helper) {
		var selectedValue = event.getSource().get("v.value");
		if (selectedValue == "Other") {
			component.set("v.isReasonOther", true);
		} else {
			component.set("v.isReasonOther", false);
		}
	},

	handleCancelRLapsePolicy: function (component, event, helper) {
		helper.validateRequiredInputs(component, event, helper);
	},

	closePolicyCancellation: function (component) {
		component.set("v.confirmCancelPolicy", false);
	},

	confirmPolicyCancellation: function (component, event, helper) {
		helper.cancelRLapsePolicyHelper(component, event, helper);
	}
});