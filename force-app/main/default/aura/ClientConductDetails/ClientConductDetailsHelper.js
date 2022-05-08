({
    getClientConductDetails: function (component, conItem) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getClientConduct");

        action.setParams({
            "oppId": oppId,
            "conductType": conItem
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    this.populateConductDetails(component, result);
                }
            }
            else{
                this.showError(response, "getClientConduct");
            }

            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    populateConductDetails: function (component, conData) {
        if (conData) {
            component.set("v.conData", conData.ChequeConductDetails);
            component.set("v.accountNameNumber", conData.AccountNameNumber);
            component.set("v.chequeProductType", conData.ChequeProductType);
        }
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
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
        var toastEvent = this.getToast("Error: ClientConductDetails " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})