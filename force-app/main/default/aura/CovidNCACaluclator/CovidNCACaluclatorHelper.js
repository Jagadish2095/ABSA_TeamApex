({
    // function automatic called by aura:waiting event
    showSpinner: function (component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    // function automatic called by aura:doneWaiting event
    hideSpinner: function (component, event, helper) {
        // add slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getApplication: function (component) {
        var opportunityId = component.get("v.recordId");
        
        var action = component.get("c.getApplicationProduct");
        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                if (result !== null) {
                    component.set("v.apcId", result.Id);
                    console.log("result of apprpod---",result);
                    component.set("v.credvalue", (result.Credit_Agreement_at_Arms_Length__c == true ? "Yes" : "No"));
                    component.set("v.isCredValue",result.Credit_Agreement_at_Arms_Length__c);
                    
                    component.set("v.statevalue", (result.Client_State__c == "Yes" ? "Yes" : "No"));
                    component.set("v.textStateValue",result.Client_State__c);
                    
                    component.set("v.jurvalue", (result.Any_Juristic_Trustees__c == "Yes" ? "Yes" : "No"));
                    component.set("v.textjurValue",result.Any_Juristic_Trustees__c);
                    
                    component.set("v.Amenvalue", (result.TL_Secured_by_Mortgage_Bond__c == true ? "Yes" : "No"));
                    component.set("v.isAmenValue",result.TL_Secured_by_Mortgage_Bond__c);
                    component.set("v.showNCA",true);
                    
                    if (result != null && result.Id != null) {
                        component.set("v.applicationId", result.Id);
                        component.set('v.isHide', false);
                        
                    }
                    else {
                        component.set('v.isHide', true);
                    }
                }
            }
            else {
                this.showError(response, "getApplicationProduct");
            }
        });
        $A.enqueueAction(action);
    },
    updateClientDetails: function (component, event) {
        //updated by almas
        var toastEvent;
        var account1 = component.get("v.account");
        console.log("acounttt",JSON.stringify(account1));
        const account = JSON.parse(JSON.stringify(account1)); //(account1 != null ? JSON.parse(JSON.stringify(account1)) : null);  //change to proxy object
        
        console.log('account :::: ', account);
        console.log('accountssss :::: ', JSON.stringify(account));
        var toupdateAccount = true;
        //validate if stage moves or not
        component.set("v.isClntValidated", toupdateAccount);
        
        if (toupdateAccount) {
            var action = component.get("c.updateClient");
            this.showSpinner(component);
            
            action.setParams({
                "oppId": component.get("v.recordId"),
                "accountObj": JSON.stringify(account)
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                var result = response.getReturnValue();
                
                if (state === "SUCCESS") {
                    
                    if (result.accountUpdate == "Updated") {
                        toastEvent = this.getToast("Success!", "Client details updated successfully.", "success");
                        toastEvent.fire();
                    }
                }
                else {
                    toastEvent = this.getToast("Error!", 'Din\'t update client details', "error");
                    toastEvent.fire();
                }
                
                this.hideSpinner(component);
            });
            
            $A.enqueueAction(action);
        }
    },
    
    caluclateNCAStatus: function (component) {
        var action = component.get("c.calculateNCAFromService");
        action.setParams({
            "appProdId": component.get("v.apcId")
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                
                var result = response.getReturnValue();
                component.set("v.apProd",result);
                
                
                component.set("v.credvalue", (result.Credit_Agreement_at_Arms_Length__c == true ? "Yes" : "No"));
                component.set("v.isCredValue",result.Credit_Agreement_at_Arms_Length__c);
                
                component.set("v.statevalue", (result.Client_State__c == "Yes" ? "Yes" : "No"));
                component.set("v.textStateValue",result.Client_State__c);
                
                component.set("v.jurvalue", (result.Any_Juristic_Trustees__c == "Yes" ? "Yes" : "No"));
                component.set("v.textjurValue",result.Any_Juristic_Trustees__c);
                
                component.set("v.Amenvalue", (result.TL_Secured_by_Mortgage_Bond__c == true ? "Yes" : "No"));
                component.set("v.isAmenValue",result.TL_Secured_by_Mortgage_Bond__c);
                
                component.set("v.showNCA",true);
               
                // $A.get("e.force:refreshView").fire();
                //if successful update the opp stage
                this.updateOppStageName(component, event);
            }
        });
        $A.enqueueAction(action);     
    },
    updateOppStageName: function (component, event) {
        var isClntValidated = component.get("v.isClntValidated");
        // var isNcaValidated = component.get("v.isNcaValidated");
        
        if (isClntValidated ) {//&& isNcaValidated
            //update stage when validate
            var action = component.get("c.updateOpportunityStage");
            var toastEvent;
            
            action.setParams({
                "oppId": component.get("v.recordId")
            });
            
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue().toUpperCase() == "SUCCESS") {
                        toastEvent = this.getToast("Success!", "Opportunity Stage moved successfully!", "success");
                        toastEvent.fire();
                        
                        $A.get("e.force:refreshView").fire();
                    }
                    else {
                        this.showError(response, "updateOpportunityStage");
                    }
                }
                else {
                    this.showError(response, "updateOpportunityStage");
                }
            });
            $A.enqueueAction(action);
        }
    },
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
    
    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
        
        // show error notification
        var toastEvent = this.getToast("Error:  " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})