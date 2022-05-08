({
    doInit: function(component, event, helper) {
        helper.checkOnInitValidity(component);
        helper.checkWBIFErrors(component);
        helper.checkUltimateProtector(component);
    },
    
    validate: function(component, event, helper) {
        helper.validate(component);
    },
    
    priNumber: function(component, event, helper) {
        helper.getPriNumber(component);
    },
    
    submit: function(component, event, helper) {
        helper.submit(component);
    }
})