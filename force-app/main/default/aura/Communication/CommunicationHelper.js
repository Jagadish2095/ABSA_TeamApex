({
    //Retrieves the  Application by opportunity
    getApplicationByOpportunity: function(component) {
        var action = component.get("c.getApplicationByOpportunityId");        
        action.setParams({
            opportunityId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.applicationByOpportunity", results);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },    
    
    //Checks whether a communication preference has been set
    checkCommunicationPreferenceSet: function(component) {
        var action = component.get("c.checkCommunicationPreferenceSet");
        action.setParams({
            opportunityId : component.get("v.recordId") 
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var communicationPreferenceSet = response.getReturnValue();
                component.set("v.communicationPreferenceSet", communicationPreferenceSet)
                if (communicationPreferenceSet) {
                    this.checkCommunicationPreferenceSetType(component);
                }                
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {                
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);                        
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);
    },
    
    //Checks which field has been set as the communication preference
    checkCommunicationPreferenceSetType: function(component) {        
        var action = component.get("c.checkCommunicationPreferenceSetType");
        action.setParams({
            opportunityId : component.get("v.recordId")
        });     
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var communicationPreferenceType = response.getReturnValue();
                component.set("v.communicationPreferenceType", communicationPreferenceType);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },    
    
    //Retrieves emails associated with the client and the opportunity
    getEmailsList: function (component) {        
        var action = component.get("c.getEmailsList");
        action.setParams({
            opportunityId : component.get("v.recordId")
        });
        var opts = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                if (response.getReturnValue() != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- Please select an email option ---",
                        value: ""
                    });
                } else {
                    opts.push({
                        class: "optionClass",
                        label: "--- No valid email addresses available ---",
                        value: ""
                    });
                }                
                for (var i = 0; i < response.getReturnValue().length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: response.getReturnValue()[i],
                        value: response.getReturnValue()[i]
                    });                    
                }                
                component.set("v.emailsList", opts);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //Retrieves phones associated with the client and the opportunity
    getPhonesList: function (component) {
        var action = component.get("c.getPhonesList");
        action.setParams({
            opportunityId : component.get("v.recordId")
        });
        var opts = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                if (response.getReturnValue() != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- Please select mobile phone option ---",
                        value: ""
                    });
                } else {
                    opts.push({
                        class: "optionClass",
                        label: "--- No valid mobile phone available ---",
                        value: ""
                    });
                }
                for (var i = 0; i < response.getReturnValue().length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: response.getReturnValue()[i],
                        value: response.getReturnValue()[i]
                    });
                }
                component.set("v.phonesList", opts);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {                    
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);
    },
    
    //Updates the Application record
    updateApplication: function(component) {        
        var action = component.get("c.updateApplication");
        var communicationPreferenceType = component.get("v.communicationPreferenceType");
        var value;       
        switch (communicationPreferenceType) {
            case "Email":                
                if (component.get("v.showAltEmail")) {
                    value = component.get("v.altEmail");
                } else {
                    value = component.get("v.currentEmail");
                }
                break;
            case  "SMS":                
                if (component.get("v.showAltSMS")) {
                    value = component.get("v.altSMS");                 
                } else {
                    value = component.get("v.currentSMS");
                }
                break;                
            default:
                component.set("v.showAltSMS", "");
                component.set("v.showAltEmail", "");
                break;              
        }        
        action.setParams({
            opportunityId: component.get("v.recordId"),
            communicationPreferenceType: communicationPreferenceType,
            value: value
        });        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Communication Preference has been updated successfully",
                    "type":"success"
                });                
                toastEvent.fire(); 
                this.checkCommunicationPreferenceSet(component);
                this.getApplicationByOpportunity(component);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });        
        $A.enqueueAction(action);        
    },
    
    //Check if valid emails are present
    checkValidEmailPhone: function(component) {
        var action = component.get("c.validEmailPhone");        
        action.setParams({
            opportunityId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                component.set("v.validEmailExists", results.hasValidEmail);
                component.set("v.validPhoneExists", results.hasValidPhone);
                if(results.ClientType=='Joint & Several'){
                   component.set("v.joinClientType", 'true'); 
                }
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})