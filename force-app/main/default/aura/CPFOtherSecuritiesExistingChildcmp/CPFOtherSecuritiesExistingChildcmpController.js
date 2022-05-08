({
    doInit: function (component, event, helper) {
    },

    renderfields : function (component, event, helper) {
         var TypeValue = component.find("cntrlOfficerType").get("v.value")
         console.log('TypeValue'+TypeValue);

    },

	onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeOtherSecurityAccount: function (component, event, helper) {
        helper.removeNewOtherSecurity(component, event);
    },

})