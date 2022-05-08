({   
    getCall7Response: function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.getPCO7Data");
        var oppId = component.get("v.recordId");
        
        action.setParams({
            "oppID": oppId,
            "stageId": '7'
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                
                console.log("@@@ v.record " + JSON.stringify(result));
                if(!$A.util.isEmpty(result)){
                    component.set("v.record", result);  
                }
                
               var appEvent = $A.get("e.c:initializeTobDataEvent"); //tob  once again                                     
               appEvent.fire(); 
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error PowerCurveValidationScoringController.getData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, PowerCurveValidationScoringController.getData state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    //Show Spinner
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },
    
    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.isSpinner", false);
    },
})