({
	helperMethod : function() {
		
	},
    
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getMaterialDisclosureData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.data", data);   
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkOnInitValidity: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkInitValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                if(validity == 'Valid'){
                    //component.set("v.showMaterialScreen", false);
        			component.set("v.showFinishedScreen", true);
                    component.set("v.showRevalidate", false);
                }
                else if(validity == 'Incomplete'){
                    component.set("v.showFinishedScreen", false);
                    component.find("validateButton").set("v.disabled", true);
                    component.set("v.showRevalidate", true);
                }
                else{
                    //component.set("v.showMaterialScreen", true);
        			component.set("v.showFinishedScreen", false);
                    component.find("validateButton").set("v.disabled", true);
                    component.set("v.showRevalidate", false);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    saveData: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var clauses = component.get("v.allClauses");
        
        var action = component.get("c.saveMaterialDisclosureData");
        action.setParams({
            "oppId": oppId,
            "clauses": clauses,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
				// show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Material Disclosures Successfully Validated",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an error validating Material Disclosures. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    
})