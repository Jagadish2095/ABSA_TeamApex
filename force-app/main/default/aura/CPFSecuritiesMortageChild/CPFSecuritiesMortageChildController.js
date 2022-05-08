({
    doInit: function (component, event, helper) {
    },
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeUnlimitedAccount: function (component, event, helper) {
        helper.removeNewUnlimitedGuarantee(component, event);
    },
    
})