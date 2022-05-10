({
    doInit: function(component, event, helper){

    },
    assignInformation: function (component, event, helper) {
        helper.helperAssignCIFValues(component, event);
    },
    getEmployInformation: function (component, event, helper) {
        helper.getInformation(component, event);
    },
    validateInput: function (component, event, helper) {
        helper.helperValidate(component, event);
    },
})