({
	doInit: function (component, event, helper) {
        
    },
   onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removePerphases(component, event);
        },
    removeprelodgmentAccount: function (component, event, helper) {
        helper.removeprelodgment(component, event);
        },
    removepredisbursementAccount: function (component, event, helper) {
        helper.removepredisbursement(component, event);
        },
})