({
	
	init: function (component, event, helper) {
		helper.loadApplicationRiskIdentifiers(component, event, helper);
	},
    onChanged: function (component, event, helper) {
		helper.getWorstRiskIdentifier(component, event, helper);
	},
})