({
	
	init: function (component, event, helper) {
		helper.loadApplicationRiskExposures(component, event, helper);
	},

	onChanged: function (component, event, helper) {
		helper.getWorstRiskGrade(component, event, helper);
	},
})