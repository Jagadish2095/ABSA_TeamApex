({
	//DBooysen 2021-03-05
	//function called when the component is initialized
	doInit: function (component, event, helper) {
		helper.IDnVPollingHelper(component, event, helper);
	},

	//function called when the reinitialize is set to true by Parent component
	doReinitialize: function (component, event, helper) {
		if (component.get("v.reinitialize")) {
			component.set("v.reinitialize", false);
			$A.enqueueAction(component.get('c.doInit'));
		}
	}
});