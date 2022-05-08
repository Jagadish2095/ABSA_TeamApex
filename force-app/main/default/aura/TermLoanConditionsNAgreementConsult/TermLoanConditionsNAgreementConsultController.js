({
	doInit : function(component, event, helper) {
		helper.initPickLisOptions(component);
	},
    
     calculateConditions : function(component, event, helper) {
        // call out to service and get response
        helper.updateConditions(component);
    },
    save : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": " details saved successfully!",
            "type": "success",
            "duration": 1500
        });
        toastEvent.fire();
         
        $A.get("e.force:refreshView").fire();
	},
    
})