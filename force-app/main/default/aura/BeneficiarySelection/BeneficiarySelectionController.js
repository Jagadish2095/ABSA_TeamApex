({
	/**DBOOYSEN 2021-03-25
	 * Function called when the component loads
	 */
	doInit: function (component, event, helper) {
		helper.doInit(component, event);
	},

	/**DBOOYSEN 2021-03-25
	 * Function called to get Beneficiaries linked to the select combi card
	 * When a combi card is selected
	 */
	onSelectCombiAccount: function (component, event, helper) {
		component.set("v.accBeneficiaryList", null);
		helper.getAccountBeneficiariesHelper(component, event);
		component.set("v.showTable", true);
	}
});