({
    initializeOptions: function (component) {
        var options = [
            { label: "Yes", value: "Yes" },
            { label: "No", value: "No" }
        ];

        component.set("v.options", options);
    },

    getFacilities: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getNonScoredApprovedFacilities");

        action.setParams({
            "oppId": oppId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    console.log('non score '+JSON.parse(result));
                    console.log('non score lenght '+JSON.parse(result).length);
                    component.set("v.nonfacData", JSON.parse(result));
                    this.setLastRefreshDate(component);
                }
            }
            else {
                this.showError(response, "getNonScoredApprovedFacilities");
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    saveFacilities: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var isNonScored = component.get("v.isAppFacInstNonScored");
        var nonScdAppFacObj = component.get("v.nonfacData");

        var action = component.get("c.saveNonScoredApprovedFacilities");

        action.setParams({
            "oppId": oppId,
            "jsonObj": JSON.stringify(nonScdAppFacObj),
            "isNonScored": isNonScored
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    this.getFacilities(component);
                    var tostType = (result.Status.search("Save Failed") > 0 ? "Error" : "Success");

                    console.log("NonScored::: " + result.Status);
                    var toastEvent = this.getToast(tostType + '!', result.Status, tostType);
                    toastEvent.fire();

                    var oppId = component.get("v.recordId");
                    var eventHandler = $A.get("e.c:creditOriginationEvent");
                    eventHandler.setParams({ "sourceComponent": "NonScoredApprovedFacilities" });
                    eventHandler.setParams({ "opportunityId": oppId });
                    eventHandler.fire();
                }
            }
            else if (state == "ERROR") {
                this.showError(response, "saveNonScoredApprovedFacilities");
            }
            //component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    setLastRefreshDate: function(component) {
        var data = component.get("v.nonfacData");
        if(data.length > 0) {
            component.set("v.lastRefresh", data[0].LastRefreshDate);
            if(data[0].LastRefreshDate != null) {
                component.set("v.value", "Yes");
                this.selectDefaultRadioValue(component, "Yes");
            }
        }
    },

    selectDefaultRadioValue: function(component, value) {
        component.set("v.isAppFacInstNonScored", (value == "Yes" ? true : false));
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
        var toastEvent = this.getToast("Error: NonScoredApprovedFacilities " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})