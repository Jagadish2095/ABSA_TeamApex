({
    doInit: function (component, event, helper) {
        helper.setBelowDetailsLabels(component);
        helper.doBaseInit(component);
    },

    handleBasicOptionsChange: function (component, event, helper) {
        helper.updateComponentData(component, helper);
    }
})