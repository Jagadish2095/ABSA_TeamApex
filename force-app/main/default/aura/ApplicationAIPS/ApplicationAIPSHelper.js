({
	handleInit: function (component) {
		component.set("v.showSpinner", true);
		var opportunityId = component.get("v.opportunityId");
		var action = component.get("c.getAipsData");
		action.setParams({
			opportunityId: opportunityId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var data = response.getReturnValue();
				component.set("v.applicationAIPS", data);
				if (data) {
					if (data.Error) {
						this.showToast("error", "Error!", data.Error);
					}
				}
			} else {
				var errors = response.getError();

				if (errors) {
					if (errors[0] && errors[0].message) {
						this.showToast("error", "Error!", errors[0].message);
					}
				} else {
					this.showToast("error", "Error!", "AIPS unknown error");
				}
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	showToast: function (type, title, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: type,
			title: title,
			message: message
		});
		toastEvent.fire();
	}
});