({
    doInit: function (component, event, helper) {
              var type=component.find('inputtype').get("v.value");
        console.log('type :'+type);
        //if()
    },
    
    
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeNewSecurityCession(component, event);
    },
    
    
})