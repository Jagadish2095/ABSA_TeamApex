({
	doInit: function (component, event, helper) {
		console.log("Opportunity Id: " + component.get("v.recordId"));
		helper.getFraudResults(component, event, helper);
	},

	showButton: function (component, event, helper) {
		if (component.find("fraudCheckbox").get("v.checked")) {
			$A.util.removeClass(component.find("fraudSubmitButton"), "slds-hide");
		} else {
			$A.util.addClass(component.find("fraudSubmitButton"), "slds-hide");
		}
	},

	submitFraudScreening: function (component, event, helper) {
		helper.submitFraudRisk(component, event, helper);
	},

	refreshFraudScreening: function (component, event, helper) {
		helper.submitFraudRisk(component, event, helper);
	}
});