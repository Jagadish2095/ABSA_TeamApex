({
	doInit : function(component, event, helper) {
		helper.initPickLisOptions(component);
	},
    
     calculateConditions : function(component, event, helper) {
        // call out to service and get response
        helper.updateConditions(component);
    },
    
})