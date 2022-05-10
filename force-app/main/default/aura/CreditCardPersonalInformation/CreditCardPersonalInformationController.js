({
    getInformation: function (component, event, helper) {
        helper.helperGetInformation(component, event);
    },
    assignContactInformation: function (component, event, helper) {
        helper.helperAssignCIFValues(component, event);
    },
    validateInput: function (component, event, helper) {
        helper.helperValidate(component, event);
    }
})