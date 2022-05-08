({
    initPickLisOptions: function (component) {
        var selOptions = component.get("v.selOptions");

        component.set("v.selChqPrdTypes", (selOptions != null ? selOptions.selChqPrdTypes : null));
        component.set("v.selOverDrfPurpose", (selOptions != null ? selOptions.selOverDrfPurpose : null));
        component.set("v.selLimitTypes", (selOptions != null ? selOptions.selLimitTypes : null));
        component.set("v.selRedFrequency", (selOptions != null ? selOptions.selRedFrequency : null));
        component.set("v.selAltFundCode", (selOptions != null ? selOptions.selAltFundCode : null));
    },

    initPickLisValues: function (component) {
        var dataItems = component.get("v.accItem");
        if (dataItems.OverdraftPurpose != null) {
            this.overdraftPurpose(component, dataItems.OverdraftPurpose);
        }

        if (dataItems.AlternativeFundIndicator != null) {
            this.altFundChecked(component, dataItems.AlternativeFundIndicator);
        }

        if (dataItems.LimitType != null) {
            this.limitType(component, dataItems.LimitType);
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

            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Variable amounts table.",
                message: "Please make sure to complete the variable amounts and dates in the variable amounts table.",
                type: "info", mode: 'pester'
            });
            toastEvent.fire();
        }
        else {
            component.set("v.isActiveOnceOffOnly", false);
            component.set("v.isActiveOnceOffRecurring", false);
            component.set("v.isActiveVariable", false);
        }
    },

    removeNewAccount: function (component) {
        var accUniqIds = component.get("v.newChequeAccounts");
        var accUniqueID = component.find("uniqueID").get("v.value");

        if (accUniqueID.length == 18) {
            accUniqueID = accUniqueID.substring(4, 18);
        }
        else {
            accUniqueID = accUniqueID.replace("CHQ-", "");
        }

        if (accUniqIds != null) {

            for (var i = 0; i < accUniqIds.length; i++) {
                var nChqAcc = accUniqIds[i];

                if (nChqAcc.TempAccountNumber == accUniqueID) {
                    var index = accUniqIds.indexOf(accUniqIds[i]);
                    var appPrdId = nChqAcc.Id;

                    if (appPrdId) {
                        Promise.all([this.deleteNewChequeAccTempId(component, nChqAcc.Id)]).then(function (results) {
                            var p1Results = results[0];
                            if (p1Results = ! null) {
                                accUniqIds.splice(index, 1);
                                component.set("v.newChequeAccounts", accUniqIds);
                            }
                        }).catch(function (err) {
                            var toastEvent = this.getToast("Error deleteNewChequeTempId!", err, "Error");
                            toastEvent.fire();
                        });
                    }
                }
            }
        }
    },

    deleteNewChequeAccTempId: function (component, appId) {
        return new Promise(function (resolve, reject) {
            component.set("v.showSpinner", true);
            var action = component.get("c.deleteNewChequeTempId");

            action.setParams({
                "appPrdId": appId
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state == 'SUCCESS') {
                    resolve.call(this, response.getReturnValue());
                }
                else if (state == 'ERROR') {
                    var errors = response.getError();
                    reject.call(this, response.getError()[0]);
                }
                component.set("v.showSpinner", false);
            });

            $A.enqueueAction(action);
        });
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });

        return toastEvent;
    }
});