({
    getCPBServiceDetails: function(component, event, helper){
        var action = component.get("c.getCPBServiceDetails");
        action.setParams({
            "accountId":component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var message = "";
            
            if (component.isValid() && state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                
                if (respObj.statusCode == 200) {
                    console.log("CPB SERVICE SUCCESS : " + JSON.stringify(respObj));
                    component.set("v.CPBResponse", respObj);
                    
                    if (respObj.Person != null) {
                        var jsonStr = respObj.Person.AddressInformation.ResidentialAddress.AddCert;
                        component.set('v.pdfData',jsonStr);
                        
                        
                    } else {
                        console.log("CPB SERVICE ERROR OCCURRED");
                        var message = "CPB Service Error";
                        
                        if (respObj.responseStatusDescription != null) {
                            message = respObj.responseStatusDescription;
                        } else if (respObj.errorDescription != null) {
                            message = respObj.errorDescription;
                        }
                        
                        var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                        toastEvent.fire();
                    }
                    
                }
                else if (respObj.statusCode == 404) {
                    console.log("CPB SERVICE ERROR OCCURRED");
                    var message = respObj.message;
                    var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                    toastEvent.fire();
                    
                } else {
                    console.log("CPB SERVICE ERROR OCCURRED");
                    var message = "We cannot complete the request now, please try again if error persist contact administrator.";
                    var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                    toastEvent.fire();
                }
            }
            else if (state === "ERROR") {
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
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                
            } else {
                var errors = response.getError();
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
            }
            this.getExistingAddDetails(component, event, helper);
            
        });
        $A.enqueueAction(action);
        
    },
    
    getExistingAddDetails: function(component, event, helper){
        this.showSpinner(component, event, helper);
        var action = component.get("c.getExistingAddress");
        var cpbObj= component.get("v.CPBResponse");
        action.setParams({
            "accountId":component.get("v.recordId"),
            "CPBResponse":JSON.stringify(cpbObj)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var existingAdd = response.getReturnValue();
                
                if(existingAdd!=null && existingAdd!=''){
                    component.set('v.addressEditRecId',existingAdd[0].Id);
                } 
            }else if (state === "ERROR") {
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
            this.hideSpinner(component, event, helper);
            
        });
        $A.enqueueAction(action);
        
    },
    
    
    
    //Function to show spinner when loading
    showSpinner: function (component, event, helper) {
        var spinner = component.find("TheSpinner");  
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component, event, helper) { 
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide"); 
    },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    
})