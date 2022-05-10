({
	doInit: function (component, event, helper) {
		helper.getApplicationData(component, event, helper);
		component.set("v.cancelReasonList", JSON.parse($A.get("$Label.c.VoiceCreditOnboardingCancelReasons")));
	},

	handleCancelApplication: function (component, event, helper) {
		helper.cancelApplicationHelper(component, event, helper);
	},

	handleLoad: function (component, event, helper) {
		if (!$A.util.isUndefinedOrNull(component.find("applicationNumberField").get("v.value"))) {
			component.set("v.disableButton", false);
		}
	},

	handleSuccess: function (component, event, helper) {
		helper.showSpinner(component, event, helper);
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: "success",
			title: "Application Cancelled",
			message: "Application was cancelled as per customers's request"
		});
		toastEvent.fire();
		$A.get("e.force:closeQuickAction").fire();
		helper.hideSpinner(component, event, helper);
	}
});