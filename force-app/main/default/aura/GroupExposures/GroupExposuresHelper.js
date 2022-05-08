({
    
    loadGroupExposures: function (component, event, helper) {
        console.log('loadGroupExposures');
        var action = component.get("c.getGroupExposureFromService");
        var OppID = component.get("v.recordId");

        action.setParams({
            "OppID": OppID
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result::: ' + JSON.stringify(result['appGroupExposures']));

                var appGroupExposures = result['appGroupExposures'];
                var LastModifiedDate = (appGroupExposures != null ? null : appGroupExposures[0].LastModifiedDate);

                component.set("v.lastRefresh", LastModifiedDate);
                component.set("v.appGroupExposures", appGroupExposures);
            }
            else {
                this.showError(response, "getGroupExposureFromService");
            }
        });
        $A.enqueueAction(action);
    },

    loadGroupTotal: function (component, event, helper) {
        console.log('getGroupExposureRecord');
        var action = component.get("c.getGroupExposureRecord");
        var OppID = component.get("v.recordId");

        action.setParams({
            "OppID": OppID
        });

        console.log('!!! ' + OppID);

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('getGroupExposureRecord::: ' + result);
                component.set("v.gData", JSON.parse(result));
                this.setAppGroupTotals(component);
            }
            else {
                this.showError(response, "getTotalGroupExposureRecord");
            }
        });
        $A.enqueueAction(action);
    },

    setAppGroupTotals: function (component) {
        var data = component.get("v.gData");
        component.set("v.lastRefresh", data.LastModifiedDate);
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
        var toastEvent = this.getToast("Error: Exposure " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})