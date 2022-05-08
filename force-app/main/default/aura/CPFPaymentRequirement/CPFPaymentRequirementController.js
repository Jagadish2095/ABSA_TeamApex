({
    doInit: function (component, event, helper) {
        helper.getAppPrdctCpfRec(component);
    },

    onSaveSuccess: function (component, event, helper) {
        helper.handleSaveSuccess(component);
    },

    onSaveError: function (component, event, helper) {
        helper.handleSaveError(component, event);
    }
});