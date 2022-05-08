({
	
	doInit: function (component, event, helper) {
		//helper.getApplicationExposuresFuture(component, event, helper);
		helper.getApplicationExposures(component, event, helper);
	},

	onChanged: function (component, event, helper) {
		helper.getApplicationExposures(component, event, helper);
	},
})