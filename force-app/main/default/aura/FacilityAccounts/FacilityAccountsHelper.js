({
    initPickLisOptions: function (component) {
        var selOptions = component.get("v.selOptions");

        component.set("v.selOverDrfPurpose", (selOptions != null ? selOptions.selOverDrfPurpose : null));
        component.set("v.selLimitTypes", (selOptions != null ? selOptions.selLimitTypes : null));
        component.set("v.selRedFrequency", (selOptions != null ? selOptions.selRedFrequency : null));
        component.set("v.selAltFundCode", (selOptions != null ? selOptions.selAltFundCode : null));
    },

    initPickLisValues: function (component) {
        var dataItems = component.get("v.accItem");
        if(dataItems.OverdraftPurpose != null){
            this.overdraftPurpose(component,dataItems.OverdraftPurpose);
        }

        if(dataItems.AlternativeFundIndicator != null){
            this.altFundChecked(component,dataItems.AlternativeFundIndicator);
        }

        if(dataItems.LimitType != null){
            this.limitType(component,dataItems.LimitType);
        }

        var minDate = new Date();
        var maxDate = (minDate.getFullYear() + 1) + "-" + (minDate.getMonth() + 1) + "-" + (minDate.getDate() - 1); //add year;
        minDate = minDate.getFullYear() + "-" + (minDate.getMonth() + 1) + "-" + minDate.getDate();

        component.set("v.minDate", minDate);
        component.set("v.maxDate", maxDate);
    },

    overdraftPurpose: function (component, dDValue) {
        component.set("v.isActiveOtherOverdraftPurpose", (dDValue == "99" ? true : false));
        component.set("v.isODPurposeOther", (dDValue == "99" ? true : false))
    },

    altFundChecked: function (component, chValue) {
        component.set("v.isActiveAlternativeFundCode", chValue);
    },

    limitType: function (component, selectCmp) {
        if (selectCmp == "Reducing - Once Off Only") {
            component.set("v.isActiveOnceOffOnly", true);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Reducing - Once Off And Recurring") {
            component.set("v.isActiveOnceOffOnly", true);
            component.set("v.isActiveOnceOffRecurring", true);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Reducing - Recurring Only") {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", true);
            component.set("v.isActiveVariable", false);
        }
        else if (selectCmp == "Variable") {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", true);
        }
        else {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", false);
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
        var toastEvent = this.getToast("Error: ChequeAndOverdraft " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})