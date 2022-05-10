({
	doInit: function (component, event, helper) {
		component.set("v.cancelReasonList", JSON.parse($A.get("$Label.c.VoiceCreditOnboardingCancelReasons")));
	}

	/*handleLoad: function (component, event, helper) {
		component.set("v.showSpinner", true);
		//document.getElementById("submitButton").click();
		console.log("handleLoad Stage field " + component.find("StageField").get("v.value"));
	},

	handleSuccess: function (component, event, helper) {
		console.log("in success");
		console.log("handleSuccess Stage field " + component.find("StageField").get("v.value"));
		//var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: "success",
			title: "Application Cancelled",
			message: "Application was cancelled as per customers's request"
		});
		toastEvent.fire();
		//$A.get("e.force:closeQuickAction").fire();
		component.set("v.showSpinner", false);
	},

	handleError: function (component, event, helper) {
		console.log("in handleError");
		var errors = event.getParams();
		console.log("response " + JSON.stringify(errors));
	}*/
});