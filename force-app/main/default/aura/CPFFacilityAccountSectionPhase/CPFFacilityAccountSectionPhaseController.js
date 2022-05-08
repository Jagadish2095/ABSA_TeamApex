({
    
    doInit: function (component, event, helper) {
        component.set('v.appFinAccRecId',component.get('v.accItem').Id);
        component.set('v.accounttobeclosedoptn',component.get('v.accItem').Account_to_be_closed__c);

    },
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeNewAccount(component, event);
    },
    
    
    saveAFA : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            component.find('iAppFinAccRecord').submit();
            return message;
        }
    },
    
    iAppFinAccRecordSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.appFinAccRecId',payload.id);

    },
    
    iAppFinAccRecordSubmit : function(component, event, helper) {
        event.preventDefault();
        var accounttobeclosedoptn= component.get("v.accounttobeclosedoptn");
        var eventFields = event.getParam("fields");
        eventFields.Account_to_be_closed__c = accounttobeclosedoptn;
        component.find('iAppFinAccRecord').submit(eventFields); //iFireAppRecord
        
    },
    
    
    iAppFinAccRecordload: function (component,event, helper) {

    }
})