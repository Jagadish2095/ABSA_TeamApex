({
	doInit: function (component, event, helper) {
		if (component.get("v.productNameFromFlow") === "ML") {
			helper.setUpHomeLoansView(component, event, helper);
		} else if (component.get("v.productNameFromFlow") === "LI") {
			helper.setUpAbsaLifeView(component, event, helper);
		} else if (component.get("v.productNameFromFlow") === "LX") {
			helper.setUpAbsaLifeExergyView(component, event, helper);
		}
	},

	handleBankChange: function (component, event, helper) {
		if (component.get("v.productNameFromFlow") === "LX") {
			component.set("v.branchCode", "");
			component.set("v.branchName", "");
			component.set("v.bankDetailsChanged", true);
		}
	},

	onPicklistAccTypeChange: function (component, event, helper) {
		component.set("v.accountType", event.getSource().get("v.value"));
	},

	onPickListDebitDayChange: function (component, event, helper) {
		component.set("v.premiumCollectionDay", event.getSource().get("v.value"));
	},

	onBankingDetailsTabActive: function (component, event, helper) {
		var bankingDetailsTabLoaded = component.get("v.bankingDetailsTabLoaded");
		var bankName = component.get("v.bankName");
		var branchName = component.get("v.branchName");

		if (!bankingDetailsTabLoaded) {
			component.set("v.bankingDetailsTabLoaded", true);

			if (bankName && branchName) {
				helper.setSelectedBankAndBranchName(component, bankName, branchName);
			}
		}
	},

	handleBrachCodeComponentEvent: function (component, event, helper) {
		var selectedBranchCodeFromEvent = event.getParam("recordBranchCodeEvent");
		component.set("v.branchCode", selectedBranchCodeFromEvent);
	},

	validateRequiredFields: function (component, event, helper) {
		 
			if (helper.allFieldsValid(component, event, helper)) {
				component.set("v.showConfirmation", "true");
			} else {
				helper.fireToastEvent("Error!", "Please ensure all required fields are populated", "Error");
			}
	},

	handleCancelClick: function (component) {
		component.set("v.showConfirmation", "false");
	},

	handleOkClick: function (component, event, helper) {
		if (component.get("v.productNameFromFlow") === "ML" || component.get("v.productNameFromFlow") === "LI") {
			helper.submit(component, event, helper);
		} else if (component.get("v.productNameFromFlow") === "LX") {
			helper.submitExergyChanges(component, event, helper);
		}
	},

	handleCloseCase: function (component, event, helper) {
		helper.closeCase(component, event, helper);
	}
});