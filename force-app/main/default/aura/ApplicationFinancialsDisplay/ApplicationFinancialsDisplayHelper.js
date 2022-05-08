({
    getFinancialInformation: function (component) {
        component.set("v.showSpinner", true);
        var accId = component.get("v.recordId");
        var action = component.get("c.getFinancialInformation");

        action.setParams({
            "accId": accId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    component.set("v.isComparerativeYearsVisible", true);
                    this.populateFinStaInfo(component, result);
                }
                else { component.set("v.isComparerativeYearsVisible", false);}
            }
            else if (state == "ERROR") {
                this.showError(response, "getFinancialInformation");
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    populateFinStaInfo: function (component, objectData) {
        component.set("v.finStatInfo", objectData.FinStatList);
        component.set("v.finStatBalSheetInfo", objectData.FinStatBalSheetList);
        component.set("v.finStatIncomeStatInfo", objectData.FinStatIncomeStatList);
        component.set("v.finStatFinNeedsInfo", objectData.FinStatFinNeedsList);
        component.set("v.finStatProfRatiosInfo", objectData.FinStatProfRatiosList);
        component.set("v.finStatOperRatiosInfo", objectData.FinStatOperRatiosList);
        component.set("v.finStatDebtCapKeyRatioInfo", objectData.FinStatDebtCapKeyRatioList);
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
        var toastEvent = this.getToast("Error: ApplicationFinancialDisplay " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})