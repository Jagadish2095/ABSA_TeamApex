({
    handleSubmit : function(component, event, helper) {
        var counter = component.get("v.correctAnsCounter");
        console.log('counter: '+counter);
        if(counter >= 4){
            console.log('pass');
            var toast = helper.getToast("Customer Verification Status!", "Customer is confirmed successfully.", "success");
            toast.fire();
            component.set("v.xdsDecision",true);
        }else{
            var toast = helper.getToast("Customer Verification Status!", "Customer is not confirmed successfully.", "warning");
            toast.fire();
            component.set("v.xdsDecision",false);
        }
        
    },
    
    onChange: function(component, event, helper) {
        var counter = component.get("v.correctAnsCounter");
        console.log('counter: '+counter);
        var inputName = event.getSource().get('v.name');
        console.log('inputName: '+inputName);
        var inputValue = event.getSource().get('v.checked');
        console.log('inputValue: '+inputValue);
        if(inputName == 'pass' && inputValue == true){
            counter = counter + 1;
        }else if(inputName == 'pass' && inputValue == false){
            counter = counter - 1;
        }
        console.log('counter1: '+counter);
        component.set("v.correctAnsCounter",counter);
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            component.set("v.clientID",component.get("v.accountRecord.ID_Number__pc"));
            
            if(component.get("v.clientID")){
                helper.getDHADetails(component, event, helper);
            }else{
                component.set("v.errorMessage","Need Id Number on Account to display DHA Certificate");
            }
           
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },

    onAttestDecisionChange: function (component, evt, helper) {
        component.set("v.saveDisabled",false);
    },

    onAttestDecisionSave: function (component, evt, helper) {
        var action = component.get("c.submitDhaAttestDecision");
        var decision = component.find('attestDecision').get('v.value');
        
        var clientID = component.get("v.clientID");

        console.log("Template Name: DHA Confirmation");
        console.log("ID NUmber: " + component.get("v.clientID"));
        console.log("decision:" + decision);
        console.log("record id:" + component.get("v.recordId"));

        action.setParams({
            templateName: "DHA Confirmations",
            recordId: component.get("v.recordId") ,
            decision : decision
        });

        component.set("v.saveDisabled",true);
        helper.showSpinner(component);

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(decision.startsWith("yes")){
                    var toast = helper.getToast("Saved", "Saved successfully", "success");
                    toast.fire();
                }else{
                    var toast = helper.getToast("Saved", "Saved successfully, but documents will be required to complete the process", "warning");
                    toast.fire();
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(`ERROR: ${JSON.stringify(errors)}`);
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
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
            helper.hideSpinner(component);

        });
        $A.enqueueAction(action);

        // var toast = helper.getToast("HANIS Certificate detail incorrect", result + "FOR:" + clientID + " : WE cannot proceed further with the inbound call. Please refer customer to contact the Department of Home Affairs to receive the correct details.", "error");
        // toast.fire();

        

    }
})