({
	init: function (component, event, helper) {
		helper.getAccountFinancialInformationHelper(component, event, helper);
	},

	navigateNext: function (component, event, helper) {
		helper.showSpinner(component);
		if ($A.util.isEmpty(component.get("v.agentContactNumber")) || $A.util.isEmpty(component.get("v.agentEmail"))) {
			helper.hideSpinner(component);
			helper.fireToast("Error!", "Fill the required field", "error");
		} else {
			helper.sendEmailHelper(component, event, helper);
		}
	},

	navigatePrevious: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("BACK");
	}
});