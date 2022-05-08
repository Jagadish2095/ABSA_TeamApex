({
	getContactInformationHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getContactDetailsFromCPB");
		action.setParams({
			idNumber: component.find("idNumberField").get("v.value"),
			clientSurname: component.find("lastNameField").get("v.value")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			helper.hideSpinner(component);
			if (state === "SUCCESS") {
				if (resp.responseStatusCode == "0" && resp.statusCode == 200) {
					//Success
					if (!$A.util.isEmpty(resp.Person) && !$A.util.isEmpty(resp.Person.ContactInformation)) {
						component.find("phoneField").set("v.value", resp.Person.ContactInformation.WorkTelephoneNumber);
						component.find("homePhoneField").set("v.value", resp.Person.ContactInformation.HomeTelephoneNumber);
						component.find("mobilePhoneField").set("v.value", resp.Person.ContactInformation.MobileNumber);
					} else {
						//Objects are null
						helper.fireToast("Error!", "Unable to get contact information from Service response.", "error");
						component.set("v.errorMessage", "CPBValidate Response: " + JSON.stringify(resp));
					}
				} else {
					//Service Error
					helper.fireToast("Error!", "A service error occurred while trying to refresh contact information.", "error");
					component.set("v.errorMessage", "CPBValidate Response: " + JSON.stringify(resp));
				}
			} else if (state === "ERROR") {
				var errorMessage = "An Unexpected error occurred: " + JSON.stringify(response.getError());
				helper.fireToast("Error!", errorMessage, "error");
				component.set("v.errorMessage", errorMessage);
			} else {
				helper.fireToast("Error!", "An Unexpected state returned: " + state, "error");
				component.set("v.errorMessage", "An Unexpected state returned: " + state);
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