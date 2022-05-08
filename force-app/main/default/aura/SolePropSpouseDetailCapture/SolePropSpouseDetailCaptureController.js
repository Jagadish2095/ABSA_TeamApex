({
    doInit: function (component, event, helper) {
        helper.handleDoInit(component);
    },

    handleApplicationEvent: function (component, event, helper) {
        var sourceComponent = event.getParam("sourceComponent");

        // Condition to not handle self raised event
        if (sourceComponent == 'Validation02') {
            //calling Init on App Event
            component.set("v.showSpinner", true);

            var a = component.get('c.doInit');
            $A.enqueueAction(a);
        }
    },

    submitSpouseAccount: function (component, event, helper) {
        helper.handleSubmitSpouseAccount(component);
    },

    delinkSpouseAcc: function (component, event, helper) {
        helper.handleDelinkSpouseAccount(component);
    },

    onRadioChange: function (component, event, helper) {
        var value = event.getParam("value");
        var spouseAccount = component.get("v.spouseAccount");

        if (String(event.getSource().getLocalId()) == 'isUndrDbtCns') {
            if (value == "Yes") {
                spouseAccount['isUnderDebtCounselling'] = true;
            } else {
                spouseAccount['isUnderDebtCounselling'] = false;
            }
        } else {
            if (value == "Yes") {
                spouseAccount['isSpouseContributing'] = true;
                component.set("v.showRemainFields", true);
            } else {
                spouseAccount['isSpouseContributing'] = false;
                component.set("v.showRemainFields", false);
            }
        }
    }
})