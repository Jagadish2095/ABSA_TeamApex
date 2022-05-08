({
	doInit: function (component, event, helper) {
		helper.getCardDetailsHelper(component, event);
		helper.getPicklistTranslationsHelper(component, event);
	},

	handleStopReplaceCard: function (component, event, helper) {
		helper.validateFieldsHelper(component, event);
	},

	checkboxSelect: function (component, event, helper) {
		var isActive = event.getSource().get("v.value");
		var selectedRecord = event.getSource().get("v.text");
		component.set("v.checked", isActive);
		if (isActive) {
			component.set("v.selectedRecord", selectedRecord);
			component.set("v.showSelectedRecord", true);
		} else {
			component.set("v.selectedRecord", null);
			component.set("v.showSelectedRecord", false);
		}
	},

	handleStopOptionSelect: function (component, event, helper) {
		var selectedStopOption = event.getSource().get("v.value");
		if (selectedStopOption == "Stop Card") {
			component.set("v.showForm", true);
			component.set("v.showReplaceFields", false);
		} else if (selectedStopOption == "Stop and Replace Card") {
			component.set("v.showForm", true);
			component.set("v.showReplaceFields", true);
		}
	}
});