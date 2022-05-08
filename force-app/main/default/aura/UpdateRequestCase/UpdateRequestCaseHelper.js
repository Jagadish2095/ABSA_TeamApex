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
    updateCase: function (component, event, helper) {
        this.showSpinner(component);
        var action2 = component.get("c.SendRequestCaseToDigital");
         var caseId = component.get("v.recordId");
        console.log('case id before submit'+ caseId);
        action2.setParams({
            "caseId": component.get("v.recordId")
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            
            if (state == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (response.getReturnValue().toUpperCase() == 'SUCCESS') {
                    toastEvent.setParams({
                        "title": "Success!",
                        "type": "success",
                        "message": responseValue
                    });                    
                } 
                else  {
                    //console.log("Failed with state: " + responseValue);
                    toastEvent.setParams({
                        "title": "ERROR",
                        "type": "ERROR",
                        "message": responseValue
                    });
                }
            } 
            else {
                //console.log("Failed with state: " + response.getReturnValue());
                toastEvent.setParams({
                    "title": "Error!",
                    "type": "error",
                    "message": responseValue
                });
            }
            
            toastEvent.fire();
            this.hideSpinner(component);
        });
        
        $A.enqueueAction(action2);
    },
})