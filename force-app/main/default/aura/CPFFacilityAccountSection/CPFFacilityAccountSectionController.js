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
     //   component.set("v.isActiveNewAccount", false);
       // component.set("v.isActiveRemoveAccount", false);
      //  component.set("v.isActiveOnceOffOnly", false);
    },
     handleSubmit : function(component, event, helper) {
       // component.set("v.showSpinner", true);
        //helper.UpdateAppFinAcc(component, event, helper);
        // helper.UpdateAppFinAcc(component, event, helper);
    },
   onChange: function (component, event, helper) {
       var acctobeClosed =component.find('select').get('v.value');
       if(acctobeClosed== 'No'){
             component.set("v.accounttobeclosedoptn", 'No');
        }
        else if(acctobeClosed=='Yes'){
            
            component.set("v.accounttobeclosedoptn", 'Yes');
            }
        // component.set ("v.accounttobeclosedoptn",acctobeClosed);
        component.getEvent("CPFApplicationFinAcctobeclosed").setParams({
             "AccTobeClosed" : component.get("v.accounttobeclosedoptn")
         }).fire();
    },
})