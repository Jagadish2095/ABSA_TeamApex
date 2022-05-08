({
    createAccountRecord: function (component, event, helper,resp,navigate) {
        var accRecord = component.get("v.newAccount");
        if (
            !accRecord.FirstName ||
            !accRecord.LastName ||
            !accRecord.ID_Number__pc ||
            !accRecord.PersonMobilePhone
        ) {
            var toastEvent = helper.getToast("Error!", "Required to fill all fields.", "Error");
            toastEvent.fire();
            helper.hideSpinner(component);
            return;
        } else {
            if(accRecord.ID_Number__pc){
               // helper.validateIdNumber(component, event, helper, accRecord.ID_Number__pc);
            }
            
            if(!component.get('v.isInvalidIdNumber')){ 
                var action = component.get("c.createPersonAccount");
                action.setParams({
                    acc: accRecord
                });
                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state == "SUCCESS") {
                        var result = response.getReturnValue();
                        if (result.Id != null) {
                            //Remove the following attribute Set statements if not needed
                            //component.set("v.accountId", result.Id);
                            //component.set("v.selectedAccountRecordTypeId" , result.RecordTypeId);
                            //component.set("v.selectedAccountRecordTypeName" , "Individual Prospect");
                            helper.hideSpinner(component);
                        	navigate(resp);
                        }
                        
                    } else {
                        var message = "An error Occured while attempting to create Preospect" +JSON.stringify(response.getError());
                        helper.getToast("Error!", message, "error");
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    validateIdNumber : function(component, event, helper, idNumber){
        var action = component.get("c.validateIdNumber");
        action.setParams({
            idNumber: idNumber
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    var toastEvent = helper.getToast("Error!", result, "Error");
                    component.set('v.isInvalidIdNumber', true);
                    toastEvent.fire();
                    return ;
                }
            }
        });
        $A.enqueueAction(action);
    },
    //Function to show spinner when loading
    showSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function(component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Function to show toast for Errors/Warning/Success
    getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
    
})