({
	fetchOtherPoliciesHelper : function(component, event, helper) {
        var caseIdValue = component.get("v.recordId");//c by h
        console.log("This is case id: "+caseIdValue);
        var action = component.get("c.showOtherPolicies");
        action.setParams({
           caseID : caseIdValue
        });
        action.setCallback(this, function(result){
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.OtherPolicyList",result.getReturnValue());   
            }
        });
        $A.enqueueAction(action);    
    },
    
})