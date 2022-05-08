({
	//JQUEV 2020/11/19
	getIFrameData: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getIFrameURL");
		action.setParams({
			claimNumber: component.find("claimNumber").get("v.value")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set("v.iframeURL", resp);

				console.log("AICCodeplexIFrame.getIFrameData.iframeURL: " + resp);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AICCodeplexIFrameController.getIFrameURL: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, AICCodeplexIFrameController.getIFrameURL state returned: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	}
});