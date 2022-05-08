({
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getDeclarationData");
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
                console.log('Recordcount=='+component.get("v.quoterecords").length);
                //Added by Kalyani to fetch quote records count for Direct Delivery
                //if(component.get("v.quoterecords").length == 0 || component.get("v.quoterecords").length > 1 || (component.get("v.quoterecords").length == 1 && (component.get("v.quoterecords")[0].Description != 'Flexi Funeral' && component.get("v.quoterecords")[0].Description != 'Health Assistance'))) {
 				if(component.get("v.quoterecords").length == 0 || ((component.get("v.quoterecords").length == 1 || component.get("v.quoterecords").length > 0)  && (component.get("v.quoterecords")[0].Description != 'Flexi Funeral' && component.get("v.quoterecords")[0].Description != 'Health Assistance'))){
                	var validity = response.getReturnValue();
                    // console.log('==product=='+component.get("v.quoterecords")[0].Description);
                    if(validity[0] == 'Valid'){
                        component.set("v.showCloseScreen", false);
                        component.set("v.showFinishedScreen", true);
                        component.set("v.showInvalidScreen", false);
                    }
                    else if(validity[0] == 'Invalid - Not Done'){
                        component.set("v.showCloseScreen", true);
                        component.set("v.showFinishedScreen", false);
                        component.set("v.showInvalidScreen", false);
                        component.find("validateButton").set("v.disabled", true);
                    }
                        else{
                            component.set("v.showCloseScreen", false);
                            component.set("v.showFinishedScreen", false);
                            component.set("v.showInvalidScreen", true);
                            component.set("v.invalidMessages", validity[1]);
                        }
                    //Added by Kalyani to fetch quote records count for Direct Delivery
                }else if(component.get("v.quoterecords").length > 0 && (component.get("v.quoterecords")[0].Description == 'Flexi Funeral' || component.get("v.quoterecords")[0].Description == 'Health Assistance')) {
                    component.set("v.showCloseScreen", false);
                    component.set("v.showFinishedScreen", true);
                    component.set("v.showInvalidScreen", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    checkEmailValidity: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        
        var action = component.get("c.checkIfShowWrningMessage");
        action.setParams({
            "oppId": oppId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.saveData(component);
            }
            
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    saveData: function (component) {
        var oppId = component.get("v.recordId");
        var clauses = component.get("v.allClauses");
        
        var action = component.get("c.saveDeclarationData");
        action.setParams({
            "oppId": oppId,
            "clauses": clauses,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Added by Kalyani to fetch quote records count for Direct Delivery
                console.log('response=='+JSON.stringify(response.getReturnValue()));
                component.set("v.quoterecords",response.getReturnValue());
				// show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Declaration Successfully Submitted",
                    "type":"success"
                });
                toastEvent.fire();
            }
            else {
                console.log("Failed with state: " + state);
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "There was an error submitting declaration. Please try again",
                    "type":"error"
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    
})