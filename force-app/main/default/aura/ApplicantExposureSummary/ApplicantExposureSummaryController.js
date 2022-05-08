({
    
    init: function (component, event, helper) {
        helper.loadApplicantExposures(component, event, helper);
    },
    onRender: function (component, event, helper) {
        helper.handleOnRender(component);
    },
})