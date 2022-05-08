({
    checkIfCIFExists: function (component) {
        component.set("v.showSpinner", true);
        
        var accId = component.get("v.recordId");
        var action = component.get("c.validateIfCIFExists");
        action.setParams({
            "accId": accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();  
                if(resp == true){
                    component.set("v.isCreate", false);
                }
                else{
                   component.set("v.isCreate", true);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
	createOrUpdate: function (component) {
        component.set("v.showSpinner", true);
        
        var accId = component.get("v.recordId");
        var action = component.get("c.createOrUpdateAccountInCIF");
        action.setParams({
            "accId": accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();  
                if(resp == 'Success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Account Successfully Created in CIF",
                        "type":"success"
                    });
                    toastEvent.fire();
                    
                    var a = component.get('c.doInit');
                    $A.enqueueAction(a);
                }
                else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": resp,
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An unknow error has occured. Please contact a system administrator.",
                    "type":"error"
                });
                toastEvent.fire();
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
})