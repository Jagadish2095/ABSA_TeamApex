({

    doInit: function (component, event, helper) {
      //helper.getAppFinAccCpfRec(component, event, helper);
    },
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeNewAccount(component, event);

    },
  

})