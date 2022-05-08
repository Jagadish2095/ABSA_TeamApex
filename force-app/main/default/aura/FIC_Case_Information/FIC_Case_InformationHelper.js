({
    getCaseRecord : function( component ) {
        var action = component.get("c.getCase"); //Calling Apex class controller 'getAccountRecord' method
        var recId = component.get("v.recordId");
        action.setParams({
        "caseId":recId
            });
        action.setCallback(this, function(response) {
            var state = response.getState(); //Checking response status
            var result = JSON.stringify(response.getReturnValue());
            if (component.isValid() && state === "SUCCESS")
                component.set("v.caseLst", response.getReturnValue());  // Adding values in Aura attribute variable.
            console.log(response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})