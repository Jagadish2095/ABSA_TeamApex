({
	//JQUEV 2020/11/05
	//Send Email
	sendEmailHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.sendEmail");
		action.setParams({
			caseId: component.get("v.caseIdFromFlow"),
			emailAddress: component.get("v.emailAddressFromFlow"),
			emailTemplateName: component.get("v.emailTemplateFromFlow"),
			fromEmailAddress: component.get("v.fromEmailAddressFromFlow")
		});
		action.setCallback(this, function (response) {
			helper.hideSpinner(component);
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.includes("Error")) {
					component.set("v.errorMessage", resp);
					helper.fireToast("Error!", resp, "error");
				} else {
					//Success
					component.set("v.isFormReadOnly", true);
					if (component.get("v.closeCaseFromFlow")) {
						component.set("v.toastMessage", "Email sent Successfully and Case Closed. ");
						//Close case
						component.find("statusField").set("v.value", "Closed");
						component.find("caseEditForm").submit();
					} else {
						helper.fireToast("Success!", "Email sent Successfully. ", "success");
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error sendEmailGeneric.sendEmail: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, sendEmailGeneric.sendEmail state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
		component.set("v.isFormReadOnly", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
		component.set("v.isFormReadOnly", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});