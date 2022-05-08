({
    getPolicDetails : function(component, event, helper) {       
        var action = component.get("c.getPolicyDetails");
        var caseId=component.get("v.recordId");
        action.setParams({caseId:caseId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS"){
                console.log('getPolicyDetails : '+JSON.stringify(response.getReturnValue()));
                component.set("v.policyList",response.getReturnValue());   
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