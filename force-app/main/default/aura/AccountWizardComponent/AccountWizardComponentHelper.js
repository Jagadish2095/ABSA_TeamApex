({ 
    createNewAccount: function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.createAccount");
        
        action.setParams({
            oppId: component.get("v.recordId"),
            accountData: component.get("v.accountData")
        });
        
        action.setCallback(this, function(response) {
            
            var resp = response.getReturnValue();
            
            var state = response.getState();
            if (state === "SUCCESS") {
                if(resp.includes('Success')){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Successfully created/updated Account",
                        "type":"success"
                    });
                    toastEvent.fire();
                    
                    var accId = resp.substring(resp.indexOf(':') + 1);
                    var eUrl= $A.get("e.force:navigateToURL");
                    eUrl.setParams({
                        "url": '/lightning/r/Account/' + accId + '/view'
                    });
                    eUrl.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resp,
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            } 
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An unknow error has occured, please contact an administrator",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
    },
})