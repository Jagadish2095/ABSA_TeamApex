({
	getSelectedRadioValue: function (component, event, helper) {
		var isSelectedRadioValue = component.find("contactClient").get("v.value");
		component.set("v.clientContactStatus", isSelectedRadioValue);
		if (isSelectedRadioValue) {
			component.set("v.isLatestContactDate", true);
		}
	},

	handleOnLoad: function (component, event, helper) {
		var surname = component.find("surnameField").get("v.value");
		var personEmail = component.find("personEmailField").get("v.value");
		component.set("v.clientSurname", surname);
		component.set("v.clientEmail", personEmail);
	},

	navigateNext: function (component, event, helper) {
		var latestContactDate;
		if (component.get("v.isLatestContactDate")) {
			if ($A.util.isEmpty(component.get("v.latestContactDate"))) {
				latestContactDate = true;
			} else {
				latestContactDate = false;
			}
		}
		if (!component.find("contactClient").get("v.value")) {
			helper.fireToast("Error!", "Select the client contact status", "error");
		} else if (latestContactDate) {
			helper.fireToast("Error!", "Date field cannot be empty", "error");
		} else if (component.get("v.latestContactDate") <= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")) {
			helper.fireToast("Error!", "Date must be a future date", "error");
		} else {
			var navigate = component.get("v.navigateFlow");
			navigate("NEXT");
		}
	},

	navigatePrevious: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("BACK");
	}
});