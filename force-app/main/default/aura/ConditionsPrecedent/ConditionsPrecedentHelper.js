({
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            duration: 10000,
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
     getApplicationPrecedentt:function(component, event, helper){
       component.set("v.showSpinner",true);
       var opportunityId = component.get("v.recordId");    
       var action = component.get("c.getApplicationConditionPrecedent");
        action.setParams({
            "oppId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.showSpinner",false);
                var responseValue = response.getReturnValue();
                var values = [];
                if (responseValue !== null) {
                    
                    if (responseValue.length>0) {
                            values.push(responseValue[0].SignedByBothParties__c);
                                                                                              
                            values.push(responseValue[0].Copy_of_BR_CD__c);
                            values.push(responseValue[0].SignedCopyECI__c);
                                                                                              
                            values.push(responseValue[0].FormAcceptable__c);
                            values.push(responseValue[0].CertifiedCopyResolution__c);
                                                                                              
                            values.push(responseValue[0].FICA_Info_Reqd__c);
                            values.push(responseValue[0].No_Conditions_Precedent__c);
                            component.set("v.values",values);
                        
                    }
                    else {
                     this.showError(response, "getApplicationPrecedent"); 
                     component.set("v.showSpinner",false);
                    }
                }
            }
            else {
                this.showError(response, "getApplicationPrecedent");
            }
        });
        $A.enqueueAction(action);  
         
         
     },
    saveCoPP:function(component, event, helper,values){
    component.set("v.showSpinner",true);
    var opportunityId = component.get("v.recordId");    
    var action = component.get("c.saveCoP");
        action.setParams({
            "values": values,
            "oppId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.showSpinner",false);
                var toastEvent = this.getToast('Success' + '!','Condition of Precedent Updated Successfully', 'success');
                    toastEvent.fire();
                
            }
            else {
                this.showError(response, "saveCoP");
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
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
        var toastEvent = this.getToast("Error: ConditionsPrecedent" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
})