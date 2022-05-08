({
    createCases: function (component, event, helper) {
            helper.createSFCase(component, event, helper);  
    },
    updateSFCase:function (component, event, helper) {
            helper.updateCaseInBCMS(component, event, helper);
    },
});