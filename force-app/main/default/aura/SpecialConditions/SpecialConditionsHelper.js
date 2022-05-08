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
     getSpecialCondition:function(component, event, helper){
       component.set("v.showSpinner",true);
       var opportunityId = component.get("v.recordId");    
       var action = component.get("c.getSpecialCondition");
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
                            values.push(responseValue[0].Subordination_Agreement__c);
                                                                                              
                            values.push(responseValue[0].Negative_Pledge__c);
                            
                            component.set("v.values",values);
                        if(responseValue[0].Subordination_Agreement__c=="Yes"){
                            component.set("v.showCOG",true);
                        }
                            component.set("v.ShareholderDirectorVal",responseValue[0].Shareholder_s_Directors_s__c );
                            component.set("v.ExternalCOG",responseValue[0].External_Conditions_of_Grant__c);
                            component.set("v.InternalCOG",responseValue[0].Internal_Conditions_of_Grant__c);
                        
                    }
                    else {
                     this.showError(response, "getSpecialCondition"); 
                     component.set("v.showSpinner",false);
                    }
                }
            }
            else {
                this.showError(response, "getSpecialCondition");
            }
        });
        $A.enqueueAction(action);  
         
         
     },
    saveSC:function(component, event, helper,values){
    component.set("v.showSpinner",true);
    var opportunityId = component.get("v.recordId"); 
    var ShareholderDirectorVal = component.get("v.ShareholderDirectorVal"); 
    var ExternalCOG = component.get("v.ExternalCOG"); 
    var InternalCOG = component.get("v.InternalCOG"); 
    var action = component.get("c.saveSpecialCondition");
        action.setParams({
            "values": values,
            "oppId": opportunityId,
            "ShareholderDirectorVal":ShareholderDirectorVal,
            "ExternalCOG":ExternalCOG,
            "InternalCOG":InternalCOG
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.showSpinner",false);
                var toastEvent = this.getToast('Success' + '!','Special Condition Updated Successfully', 'success');
                    toastEvent.fire();
                
            }
            else {
                this.showError(response, "saveSC");
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
        var toastEvent = this.getToast("Error: SpecialConditions" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
})