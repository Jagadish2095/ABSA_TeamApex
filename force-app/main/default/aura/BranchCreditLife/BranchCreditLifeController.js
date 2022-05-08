({
    creditLifeButtonIcon: function (component, event) {
        if (component.get(' v.creditLifeSelected ' )) {
            component.set(' v.creditLifeSelected ', false);
            component.set(' v.creditLifeIconName ', 'utility:add' );
        } else {
            component.set(' v.creditLifeSelected ', true );
            component.set(' v.creditLifeIconName ', 'utility:success' );
        }
    },
    
    creditLifeFnBsChange: function (component, event, helper) {
        var globalId = component.getGlobalId();
        var creditLifeFnBs = document.getElementById( globalId + '_CreditLifeFnBs' );
        component.set(' v.creditLifeFnBsChecked ', creditLifeFnBs.checked );
    },
    
    validateComponent: function (component, event, helper) {
        return helper.checkCreditLife(component);
    }
})