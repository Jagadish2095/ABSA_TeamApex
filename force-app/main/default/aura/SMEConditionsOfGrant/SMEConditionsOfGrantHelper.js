({
	getApplication: function (component, event, helper) {
        component.set("v.showSpinner",true);
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getApplicationDetails");
        action.setParams({
            "oppId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue !== null) {

                    if (responseValue.Id != null) {
                        component.set("v.applicationId", responseValue.Id);
                        helper.getApplicationConditionRecords(component,event,helper);
                        helper.getApplicationConditionsRecordTypes(component,event,helper);
                    }
                    else {
                        
                    }
                }
                component.set("v.showSpinner",false);
            }
            else {
                component.set("v.showSpinner",false);
                this.showError(response, "getApplication");
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
        var toastEvent = this.getToast("Error: SMECnditionsOfGrant" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
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
    getApplicationConditionRecords: function (component, event, helper) {
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getApplicationConditions");
        action.setParams({
            "oppId": opportunityId
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue !== null) {
					
                    if (responseValue.length>0) {
                        var idlist=[];
                        var idlistIC=[];
                        for(var i=0;i<responseValue.length;i++){
                            if(responseValue[i].Type__c=='Customer Condition'){
                              idlist.push(responseValue[i].Id);  
                            }
                            else if(responseValue[i].Type__c=='Internal Condition'){
                              idlistIC.push(responseValue[i].Id);   
                            }
                            
                        }
                        console.log('idlist'+idlist);
                        if(idlist.length>0){
                           component.set("v.ExistingConditionsList",idlist);
                           component.set("v.showExistingSection",true); 
                        }
                        if(idlistIC.length>0){
                           component.set("v.ExistingConditionsListIC",idlistIC); 
                           component.set("v.showExistingSectionIC",true); 
                        }
                        
                    }
                    else {
                        
                    }
                }
                component.set("v.showSpinner",false);
            }
            else {
                component.set("v.showSpinner",false);
                this.showError(response, "getApplicationConditionsRecord");
            }
        });
        $A.enqueueAction(action);
    },
    getApplicationConditionsRecordTypes: function (component, event, helper) {
        var opportunityId = component.get("v.recordId");

        var action = component.get("c.getApplicationConditionsRecordTypes");
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log('responseValue',responseValue);
                if (responseValue !== null) {
                        var recordIdCC = responseValue.CustomerCondition;
                        var recordIdIC = responseValue.InternalCondition;
                        component.set("v.recordIdCC",recordIdCC);
                         component.set("v.recordIdIC",recordIdIC);
                    
                }
                component.set("v.showSpinner",false);
            }
            else {
                component.set("v.showSpinner",false);
                this.showError(response, "getApplicationConditionsRecordTypes");
            }
        });
        $A.enqueueAction(action);
    },
})