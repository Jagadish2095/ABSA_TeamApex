({
    getAddresses: function (component, event, helper, accId, type) {

        var action = component.get("c.getAddresses");
        action.setParams({
            "accId": accId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                if (type == 'Client') {
                    component.set("v.CompanyaddressList", res.getReturnValue());
                }
                else {
                    component.set("v.addressList", res.getReturnValue());
                }

                console.log('<<<success>>');
            } else if (state === "ERROR") {
                var errors = res.getError();
                console.log('Callback to getAddresses Failed. Error : [' + JSON.stringify(errors) + ']');
            } else {
                console.log('Callback to getAddresses Failed.');
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
        var toastEvent = this.getToast("Error: OtherSecurities" + errorMethod + "! ", message, "Error");
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
})