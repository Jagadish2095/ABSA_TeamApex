({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		helper.fetchPolicyData(component);
	},

	handleBankChange: function (component, event, helper) {
		component.set("v.branchCode", "");
		component.set("v.branchName", "");
	},

	handleBranchCodeEvent: function (component, event, helper) {
		var selectedBranchCode = event.getParam("recordBranchCodeEvent");
		component.set("v.branchCode", selectedBranchCode);
	},

	handleAccountTypeChange: function (component, event, helper) {
		component.set("v.accountType", event.getSource().get("v.value"));
	},

	handleEdit: function (component, event, helper) {
		component.set("v.showBankSearchFields", true);
		component.find("fCollectionDate").set("v.disabled", false);
		component.find("fAccountName").set("v.disabled", false);
		component.find("fAccountNumber").set("v.disabled", false);
		component.find("fBankAccountType").set("v.disabled", false);
	},

	handleSubmit: function (component, event, helper) {
		helper.handleFormValidations(component);
	},

	confirmSubmission: function (component, event, helper) {
		helper.showSpinner(component);
		component.find("bCancelSubmit").set("v.disabled", true);
		component.find("bConfirmSubmit").set("v.disabled", true);
		helper.scheduleAdhocDebitOrder(component);
	},

	cancelSubmission: function (component, event, helper) {
		component.set("v.showConfirmSubmission", false);
		helper.hideSpinner(component);
	},

	/**
	 * method for the transactional history story
	 * fetches the transactional history data
	 * @author Bhanumurty Rayala
	 */
	handleTransactionalHistory: function (component, event, helper) {
		component.find("startDate").set("v.value", "");
		component.find("endDate").set("v.value", "");
		component.set("v.transactionalHistoryColumns", [
			{ label: "Date", fieldName: "CreatedDate", type: "text" },
			{ label: "Description", fieldName: "TransTypeDesc", type: "text" },
			{ label: "Amount", fieldName: "Amount", type: "text" },
			{ label: "Balance", fieldName: "Balance", type: "text" }
		]);
		helper.handleTransactionalHistoryHelper(component, event, helper);
	},

	/**
	 * method to filter the transactional history data story
	 * filter the transactional history data within the date range.
	 * @author Bhanumurty Rayala
	 */
	filterDateRange: function (component, event, helper) {
		helper.filterDateRangeHelper(component, event, helper);
	}
});