({
	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to handle init event
	 * @param component
	 * @param event
	 * @param helper
	 */
	doInit: function (component, event, helper) {
		helper.loadTemplatesHelper(component, event);
		helper.setDefaultValuesHelper(component, event);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to handle onclick event of "Next" button
	 * @param component
	 * @param event
	 * @param helper
	 */
	onNext: function (component, event, helper) {
		component.set("v.formTotal", 0);
		helper.validateScreensHelper(component, event);
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to handle onclick event of "Previous" button
	 * @param component
	 * @param event
	 * @param helper
	 */
	onPrevious: function (component, event, helper) {
		var currentStep = component.get("v.currentStep");
		if (currentStep == "employmentDetails") {
			component.set("v.currentStep", "contactInformation");
		} else {
			component.set("v.currentStep", "personalDetails");
		}
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to handle onsubmit event of recordEditForms
	 * @param component
	 * @param event
	 * @param helper
	 */
	onsubmitValidateFields: function (component, event, helper) {
		event.preventDefault();
		var currentStep = component.get("v.currentStep");
		var screensMap = component.get("v.screensMap");
		var formTotal = component.get("v.formTotal") + 1;
		component.set("v.formTotal", formTotal);

		if (component.get("v.formTotal") == screensMap[currentStep].formCount) {
			helper.nextScreenHelper(component, event, helper, screensMap[currentStep].nextScreen);
		}

		event.stopPropagation();
	},

	/**
	 * @author: Simangaliso Mathenjwa: Absa: 02 July 2021
	 * @description function to handle change event of employed Attribute
	 * @param component
	 * @param event
	 * @param helper
	 */
	handleOccupationStatusChange: function (component, event, helper) {
		var occupationStatus = component.get("v.acc.Occupation_Status__pc");
		if (occupationStatus == "Temporary Employed" || occupationStatus == "Full Time Employed" || occupationStatus == "Part Time Employed") {
			component.set("v.employed", true);
		} else {
			component.set("v.employed", false);
		}
	}
});