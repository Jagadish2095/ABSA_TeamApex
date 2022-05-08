({  
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var objectId = component.get("v.recordId");
        var action = component.get("c.getMissingData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    component.set("v.missingData", data.missingData);
                    component.set("v.missingDocuments", data.missingDocuments);
                    component.set("v.refreshableData", data.refreshableDocuments);
                    component.set("v.reusableData", data.reusableDocuments);
                    
                    if(data.addressAttested){
                        var chkBox = component.find("addressCheckbox");
                        chkBox.set("v.value", true);
                        component.set("v.addressAttestedCheckbox", true);
                    }
                    else{
                        var chkBox = component.find("addressCheckbox");
                        chkBox.set("v.value", false);
                        component.set("v.addressAttestedCheckbox", false);
                    }
                    
                    if(data.idAttested){
                        var chkBox = component.find("idCheckbox");
                        chkBox.set("v.value", true);
                        component.set("v.idAttestedCheckbox", true);
                    }
                    else{
                        var chkBox = component.find("idCheckbox");
                        chkBox.set("v.value", false);
                        component.set("v.idAttestedCheckbox", false);
                    }
                }
                else{
                    component.set("v.dataFound", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
                component.set("v.dataFound", false);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    updateChecks: function (component) {
        component.set("v.showSpinner", true);

        var objectId = component.get("v.recordId");
        var addressAttestedCheckbox = component.get("v.addressAttestedCheckbox");
        var idAttestedCheckbox = component.get("v.idAttestedCheckbox");
        
        var action = component.get("c.updateCheckboxes");
        action.setParams({
            "objectId": objectId,
            "addressAttestedCheckbox": addressAttestedCheckbox,
            "idAttestedCheckbox": idAttestedCheckbox,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'Success'){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Checks updated successfully!",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                     var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                console.log("Failed with state: " + state);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An unknow error has occured, please contact an administrator.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
})