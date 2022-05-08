({
    loadClientData: function (component, event, helper) {
        var OpportunityId = component.get("v.oppId");
        var action = component.get("c.returnClientDetails");

        action.setParams({
            oppId: OpportunityId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.Account", result);
                component.set("v.isComparerativeYearsVisible", true);
                component.set("v.isButtonDisabled", false);
            }
            else if (state == "ERROR") {
                this.showError(response, "returnClientDetails");
            }
        });
        $A.enqueueAction(action);
    },

    createCase: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var action = component.get("c.createCaseforCreditSupportConsultant");
        var clientRec = component.get("v.Account"); //change it to client.Name later

        console.log('clientNameId in helper' + clientRec.Id);
        console.log('clientName in helper' + clientRec.Name);

        action.setParams({
            accId: clientRec.Id,
            clientName: clientRec.Name
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = this.getToast("Success!", "Financial Capture Request and Case Submitted Successfully!", "Success");
                toastEvent.fire();
            }
            else if (state == "ERROR") {
                this.showError(response, "createCaseforCreditSupportConsultant");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
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
        var toastEvent = this.getToast("Error: ApplicationFinancialUpload " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})