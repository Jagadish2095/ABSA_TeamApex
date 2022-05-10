({
	callCreateUpdate: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var recordId = component.get("v.recordId");
		var action = component.get("c.createOrUpdate");
		action.setParams({
			objId: recordId
		});

		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			var response = response.getReturnValue();
			var isCalledFromFlow = component.get("v.isCalledFromFlow");
			if (state == "SUCCESS") {
				if (response == "Success") {
					if (isCalledFromFlow) {
						var navigate = component.get("v.navigateFlow");
						navigate("NEXT");
					} else {
						component.set("v.cardStatus", "Status : ");
						component.set("v.cardStatusValue", "Successful");
						component.set("v.showSuccess", true);
						component.set("v.isSuccessful", true);
					}
				} else {
					this.handleError(component, response);
				}
			} else {
				this.handleError(component, "An error occurred on calling the CVS service");
			}
		});
		$A.enqueueAction(action);
	},

	handleError: function (component, Error) {
		var isCalledFromFlow = component.get("v.isCalledFromFlow");
		component.set("v.showError", true);
		if (isCalledFromFlow) {
			component.find("branchFlowFooter").set("v.heading", "Something went wrong");
			component.find("branchFlowFooter").set("v.message", Error);
			component.find("branchFlowFooter").set("v.showDialog", true);
		} else {
			component.set("v.hasProcessStopped", true);
			component.set("v.errorDisplay", true);
			component.set("v.errorMessage", Error);
		}
	}
});