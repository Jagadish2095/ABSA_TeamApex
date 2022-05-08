({
    doInit : function(component, event, helper) {
        helper.showSpinner(component); 
        helper.checkOnInitValidity(component);
        helper.checkOnRegistrationError(component);
        helper.getAccountData(component);
        helper.getOpportunityData(component);
        helper.getApplicationData(component);
        helper.getAssetData(component);
        helper.hideSpinner(component);
    },
    
    callStockService : function(component, event, helper) {
        helper.showSpinner(component);
        helper.getStockNumber(component, event, helper);
        helper.hideSpinner(component);
    },
    
    callWillRevision : function(component, event, helper) {
        helper.showSpinner(component);
        helper.revisionDebitOrderInstruction(component, event, helper);
        helper.hideSpinner(component);
    }
})