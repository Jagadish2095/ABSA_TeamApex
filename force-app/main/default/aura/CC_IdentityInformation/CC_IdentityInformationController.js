({
    assignInformation: function (component, event, helper) {
        helper.helperAssignCIFValues(component, event);
    },
    doInit: function (component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
    },
    onFieldchange: function (component, event, helper) {
        var gender = event.getSource().get('v.value');
    },
    getInformation: function (component, event, helper) {
        helper.helperGetInformation(component, event);
    },
    validateInput: function (component, event, helper) {
        helper.helperValidate(component, event);
    }
})