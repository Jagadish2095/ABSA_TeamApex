({
    getClientHoldsWithStatus : function(component, event, helper) {
        
        var accountId= component.get("v.recordId");
        //console.log('accountId--'+accountId);
        var action = component.get("c.getHoldRecordTypes");
        action.setParams({
            accountId : component.get("v.recordId")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var RecordTypes = response.getReturnValue();
                component.set('v.displayClientHoldList', RecordTypes);
                component.set('v.clientHoldSize',RecordTypes.length);
                
            }else if(state == "ERROR"){
                var errors = response.getError();              
                component.set("v.showErrors",true);
                component.set("v.errorMessage",errors[0].message);
                
            }
            
        });     
        $A.enqueueAction(action);
    },
})