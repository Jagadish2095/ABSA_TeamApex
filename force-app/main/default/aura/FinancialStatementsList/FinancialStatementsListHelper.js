({
    getFinancialByAccountId: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getFinancialByAccountId");
        action.setParams({
            "acntId": component.get("v.recordId"),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.listOfRec", result);
            }
            else {
                this.showError(response, "getFinancialByAccountId")
            }

        });
        $A.enqueueAction(action);
    },

    getAccClientType: function (component) {
        var getAccount = component.get("c.getAccClientType");

        getAccount.setParams({
            "acntId": component.get("v.recordId")
        });
        getAccount.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.fromAccnt", result);
            }
            else {
                this.showError(response, "getAccClientType")
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(getAccount);
    },

    createCase: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.createCaseforCreditSupportConsultant");

        action.setParams({
            acntId: component.get("v.recordId")
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
        var toastEvent = this.getToast("Error: FinancialStatementList " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})