({
	doinit : function(component, event, helper) {
		var action = component.get("c.getaccountid"); 
        action.setParams({
            caseId : component.get("v.recordId")
        });   
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()) {
                component.set("v.accountid",response.getReturnValue());
            }else{
                component.find('notifLib').showToast({
                "title": "Error!",
                "variant":"error",
                "message": "There is no account linked to this case"
            });
            }
        });
        $A.enqueueAction(action);
	}
})