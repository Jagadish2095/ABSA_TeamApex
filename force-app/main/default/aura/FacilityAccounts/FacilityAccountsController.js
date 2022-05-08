({
    doInit: function (component, event, helper) {
        helper.initPickLisOptions(component);
        helper.initPickLisValues(component);
    },

    onOverdraftChange: function (component, event, helper) {
        var target = event.getSource();
        var slValue = target.get("v.value"); //is option selected

        helper.overdraftPurpose(component, slValue);
    },

    onAltFundChecked: function (component, event, helper) {
        var target = event.getSource();
        var chValue = target.get("v.checked"); //is checkbox selected

        helper.altFundChecked(component, chValue);
    },

    onLimitSelectChange: function (component, event, helper) {
        var target = event.getSource();
        var selectCmp = target.get("v.value"); //which dropdownlist option is selected

        helper.limitType(component, selectCmp);
    },

    onSetMinDate: function (component, event, helper) {
        var accitems = component.get("v.accItem.VariableData");
        var itemId = event.getSource().get("v.name");
        var currDate = event.getSource().get("v.value");
        var len = accitems.length;

        for(var i = 0; i < len; i++) {
            if(accitems[i].Id == itemId) {
                var nextDate = new Date((new Date(accitems[i + 1].VariableDate)).valueOf());
                var nowDate = new Date((new Date(currDate)).valueOf());

                if (nextDate != null && nextDate.getFullYear() == nowDate.getFullYear() && nextDate.getMonth() == nowDate.getMonth() && nextDate.getDate() < nowDate.getDate()) {
                    var toastEvent = helper.getToast("Error!", "Your dates must be in sequencial order!", "error");
                    toastEvent.fire();
                    event.getSource().set("v.value", null);
                }
                else {
                    for (var j = i; j < len; j++) {
                        if (j < (len - 1)) {
                            var newDate = new Date((new Date(currDate)).valueOf() + 86400000);
                            accitems[j + 1].MinDate = newDate.getFullYear() + "-" + (newDate.getMonth() + 1) + "-" + newDate.getDate();
                            //accitems[j + 1].MaxDate = (newDate.getFullYear() + 1) + "-" + (newDate.getMonth() + 1) + "-" + (newDate.getDate() - 2); //add year
                        }
                    }
                }
            }
        }

        component.set("v.accItem.VariableData", accitems);
    },

    doValidityCheck: function (component, event) {
        var allValid = component.find("inputCurrAcc").reduce(function (validSoFar, inputFld) {
            // Displays error messages for invalid fields
            inputFld.showHelpMessageIfInvalid();
            return validSoFar && inputFld.get("v.validity").valid;
        }, true);

        return allValid;
    }
})