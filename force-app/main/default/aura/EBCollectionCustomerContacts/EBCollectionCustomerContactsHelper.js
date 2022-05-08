({

    handleSendSms: function(component, event, helper) {
        component.set("v.showSpinner", true);
        if(component.get("v.selectedValue")=='Send an SMS'){
               var action = component.get("c.sendSms");
        }else{
          var action = component.get("c.notifyClient");
        }
      
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            phoneNumber: component.get("v.phoneNumber") 

        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseVal = response.getReturnValue();
                
                if(component.get("v.selectedValue")=='Call the customer'){
                
                    this.fireToastEvent("Success!", "SMS was sent", "Success");
                     
                    var strText='An SMS has been sent to '+ component.get("v.clientName") +' following the failed attempt to get hold of the client.';
                    
                     component.set("v.messageSent", strText);
                       component.find("sendSMS").set("v.disabled", true);
                       component.set("v.pauseAndWaitButton", true);
                     
                     }else{
                       //$A.get("e.force:refreshView").fire();
                       window.location.reload();
                     }
                   
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set(
                    "v.errorMessage",
                    "handleSendSms Error: " + JSON.stringify(errors)
                );
            } else {
                component.set("v.errorMessage", "Error State: " + state);
            }
            component.set("v.showSpinner", false);

        });
        $A.enqueueAction(action); 
    },
    createConsultantReminder: function(component, event, helper) {
        component.set("v.showSpinner", true);
        let action = component.get("c.transferCaseAndCreateReminder");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            dateFromCalendar: component.get("v.getDateFromCalendar"),
            caseOutcome: component.find('picklistCaseOutcome').get("v.value"),
            selectedAccNumber: component.get("v.selectedAccountNumberFromFlow")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set("v.showSpinner", false);
                this.fireToastEvent("Success!", "Reminder was created", "Success");
                window.location.reload();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors[0].message);
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
             component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);

    },
     pauseAndAwaitResponse : function(component, event, helper) {
        component.set("v.showSpinner", true);
        let action = component.get("c.pauseAndAwaitResponse");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            selectedAccNumber: component.get("v.selectedAccountNumberFromFlow")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 
                this.fireToastEvent("Success!", "You can wait for customer to come back and process this case further.", "Success");
               
                window.location.reload();
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors[0].message);
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
             component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);

    },
    fireToastEvent: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },

})