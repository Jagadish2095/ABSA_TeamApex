({
    sendEmailToadvisor: function(cmp, event, helper) {
        
        var action = cmp.get("c.finishButton");
        action.setParams({ CaseId : cmp.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {               
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({	
                    "title": "Success!",
                    "type" : 'success',
                    "mode" : 'dismissible',
                    "duration" : 5000,
                    "message": "Broker Note email send to virtual advisor successfully."
                });
                toastEvent.fire();
            
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log('In error condition');
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        
        $A.enqueueAction(action);
    }
})