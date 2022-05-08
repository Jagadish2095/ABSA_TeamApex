({
    getBusinessTraceData: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getBusinessTraceData");

        action.setParams({
            "oppID": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    //component.set("v.locateCallData", JSON.parse(result));
                    component.set("v.locateCallData", result);
                    component.set("v.isBusinessTraceComplete", "YES");
                    component.set("v.isSaveDisabled", false);
                }
                console.log("locateCallData::: " + JSON.stringify(component.get("v.locateCallData")));
            }
            else {
                this.showError(response, "getBusinessTraceData");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    saveBusinessTraceData: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var objData = component.get("v.KIMNumberDetail");
        var action = component.get("c.saveBusinessTraceData");

        action.setParams({
            "oppID": oppId,
            "objData": JSON.stringify(objData)
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var toastEvent = this.getToast("Success!", "Business Trace Saved Successfully!", "Success");
                toastEvent.fire();
            }
            else {
                this.showError(response, "saveBusinessTraceData");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    submitToPowerCurve: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.submitToPowerCurve");

        action.setParams({
            "oppID": oppId,
            "stageId": '05'
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var toastEvent = this.getToast("Success!", "Power Curve Service Submitted Successfully!" + result, "Success");
                toastEvent.fire();
            }
            else {
                this.showError(response, "saveBusinessTraceData");
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
        var toastEvent = this.getToast("Error: Locate Call " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})