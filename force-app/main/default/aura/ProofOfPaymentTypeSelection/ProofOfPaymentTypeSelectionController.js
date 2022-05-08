({
	/**DBOOYSEN 2021-03-18
	 * Function sets the type of payment attribute (Once Off/Beneficiary) and
	 * navigates to the next flow screen
	 */
	onButtonClick: function (component, event, helper) {
		component.set("v.proofOfPaymentType", event.getSource().get("v.label"));
		//Navigate Next
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	}
});