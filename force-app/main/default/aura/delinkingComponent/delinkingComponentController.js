({
    doInit : function(component, event, helper) {
        helper.getChequeAccountNumbers(component);
        helper.getAccountCharges(component);
    },

    handleChequeAccountChange : function(component, event, helper) {
        component.set("v.showPricingScheme", false);
        component.set('v.accountNumber', event.getParam('value'));
        helper.getChargesDetails(component);
    },

    accountChargeClick : function(component, event, helper) {
        component.set('v.chequeAccountIsPartOfPackage', true);
    },

    confirmChangesClick : function(component, event, helper) {
        if (component.get("v.confirmChangesValue") == 'Yes') {
            component.set('v.delinkButtonDisabled', false);
        } else {
            component.set('v.delinkButtonDisabled', true);
        }
    },

    delinkButtonClick : function(component, event, helper) {
        helper.handleDelink(component);
    },

    navigateToHomePage : function(component, event, helper) {
        helper.handleNavigate(component);
    }
})