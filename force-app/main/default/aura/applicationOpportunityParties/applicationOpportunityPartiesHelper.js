({
	helperMethod : function() {
		
	},
    
    checkOnInitValidity: function (component) {
        this.showSpinner(component);
        
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
        			component.set("v.showFinishedScreen", true);
                }
                else{
        			component.set("v.showFinishedScreen", false);
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    checkIfValid: function (component) {
        this.showSpinner(component);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkDependantValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var validity = response.getReturnValue();
                var continueWithSave = true;

                if(validity == 'Invalid Dependant'){
                    var confirmation = confirm("A Family Funeral Benefit product was selected but no dependants have been added, are you sure you want to continue?");
                    if (confirmation == true) {
                        continueWithSave = true;
                    } else {
                        continueWithSave = false;
                    }
                }
              	
                if(continueWithSave){
                    var action = component.get("c.checkValidity");
                    action.setParams({
                        "oppId": oppId
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var validity = response.getReturnValue();
                            
                            if(validity == 'Invalid Beneficiaries'){
                                // show error notification
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Beneficiaries must all add up to 100%.",
                                    "type":"error"
                                });
                                toastEvent.fire();
                            }
                            else if(validity == 'Invalid Spouse'){
                                // show error notification
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "A spouse needs to be added if a quote was done on spouse.",
                                    "type":"error"
                                });
                                toastEvent.fire();
                            }
                                else{
                                    // show success notification
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Success!",
                                        "message": "Application Parties Successfully Validated.",
                                        "type":"success"
                                    });
                                    toastEvent.fire();
                                    component.set("v.showFinishedScreen", true);                 
                                }
                        }
                    });
                    $A.enqueueAction(action);
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})