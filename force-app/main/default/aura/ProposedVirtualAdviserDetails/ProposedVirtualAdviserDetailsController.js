({
    doInit : function(component, event, helper) {
        var action = component.get("c.getVirtualAdviserDetails");
        var caseId=component.get("v.recordId");
        action.setParams({caseId:caseId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.VADetails",response.getReturnValue());                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });        
        $A.enqueueAction(action);
    }
})