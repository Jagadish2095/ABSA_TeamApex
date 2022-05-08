({
    loadProductTypeExposures: function (component, event, helper) {
        //component.set("v.spinner", true);
        var opptyID = component.get("v.recordId");
        var action = component.get("c.getProductTypeExposureDetails");

        action.setParams({
            "oppID": opptyID
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result---'+JSON.stringify(result));
                component.set("v.prodTypeExpData", result);
                if(result.length > 0) {
                    component.set("v.lastRefresh", result[0].LastModifiedDate);
                }
            }
            else {
                this.showError(response, "getProductTypeExposureDetails");
            }

        });
        //component.set("v.spinner", false);
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
        var toastEvent = this.getToast("Error: ProductTypeExposureDetails " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
})