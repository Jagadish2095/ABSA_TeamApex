({
	doInit: function (component, event, helper) {
		component.set("v.columns", [
			{ label: "POA Type", fieldName: "PAType", type: "text" },
			{ label: "Name", fieldName: "name", type: "text" },
			{ label: "Id Type", fieldName: "idType", type: "text" },
			{ label: "Id Number", fieldName: "idNbr", type: "text" }
		]);
		helper.getAccountProductsHelper(component);
	},

	onAccountSelect: function (component, event, helper) {
		component.set("v.data", []);
		if (component.get("v.selectedAccountNumber")) {
			helper.getGeneralPAHelper(component);
			helper.getSpecialPAHelper(component);
			if (component.get("v.data").length <= 0) {
				component.set("v.showNotification", true);
				component.set("v.errorMessage", "No Power of Attorney Returned");
			}
		} else {
			component.set("v.specialPAList", null);
			component.set("v.generalPAList", null);
		}
	},

	handleShowPowerOfAttorney: function (component, event, helper) {
		component.set("v.showModal", true);
	},

	handleCancelClick: function (component, event, helper) {
		component.set("v.showModal", false);
	}
});