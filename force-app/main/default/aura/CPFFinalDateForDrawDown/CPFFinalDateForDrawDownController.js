({
    doInit: function (component, event, helper) {
        helper.handleInit(component);
    },

    onSaveSuccess: function (component, event, helper) {
        helper.handleSaveSuccess(component);
    },

    onSaveError: function (component, event, helper) {
        helper.handleSaveError(component, event);
    },

    showHiddenFields: function (component, event, helper) {
        var finalDateVal = component.find("finalDateForDrawdown").get("v.value");

        if (String(finalDateVal).toUpperCase() == String("month(s) after the Signature Date").toUpperCase()) {
            component.set("v.showMonthsField", true);
        } else {
            component.set("v.showMonthsField", false);
        }
    }
});