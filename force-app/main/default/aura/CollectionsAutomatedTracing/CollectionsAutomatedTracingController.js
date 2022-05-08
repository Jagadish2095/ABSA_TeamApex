({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
	},

	//Load
	handleLoad: function (component, event, helper) {
		helper.hideSpinner(component);
	},

	//Call CPBValidate Service to get Contact Details
	refreshContactDetails: function (component, event, helper) {
		if ($A.util.isEmpty(component.find("idNumberField")) || $A.util.isEmpty(component.find("lastNameField"))) {
			helper.fireToast("Error!", "Unable to get new Contact details. ", "error");
			component.set(
				"v.errorMessage",
				"In order to get the latest contact information from CPB, this account needs to have both an ID Number and a Surname. "
			);
		} else {
			component.set("v.errorMessage", null);
			helper.getContactInformationHelper(component, event, helper);
		}
	}
});