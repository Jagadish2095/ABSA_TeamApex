({
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
        helper.callPickListValues(component, event);
        helper.helperGetAccountByIdNumber(component, event);
    },
    handleNavigate: function (component, event, helper) {
        helper.helperNavigate(component, event, helper);
    },
    inlineEdit: function (component, event, helper) {
        component.set("v.isEditMode", false);
    }
})