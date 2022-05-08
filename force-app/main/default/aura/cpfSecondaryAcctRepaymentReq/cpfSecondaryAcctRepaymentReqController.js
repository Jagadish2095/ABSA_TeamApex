({
    doInit: function (component, event, helper) {
    },
    
    
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeSecondaryAcctRepaymentReq(component, event);
    },
    
    showFieldsRepaymentOptions: function (component, event,helper) {
        var repaymentoptions = event.getParam("value");
        component.set("v.repaymentoptions", repaymentoptions);
    },
    
    
    
})