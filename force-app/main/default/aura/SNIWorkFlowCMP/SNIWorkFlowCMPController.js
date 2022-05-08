({
	doInit : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOpp");
        action.setParams({"oppId":recordId});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "INCOMPLETE") {
                //cmp.set('v.showSpinner', true);
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //    console.log("Error message: " +errors[0].message);
                    }
                }
            }
            
        });
        $A.enqueueAction(action);
    }
})