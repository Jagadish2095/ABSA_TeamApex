({
    doInit: function (component, event, helper) {
        component.set('v.appOtherFeesotherId',component.get('v.otherfeesItem').Id);
        component.set('v.includeotherfee',component.get('v.otherfeesItem').Include_other_fee_in_total_facility__c);
 
    },
    onCheckedRemoveAccount: function (component, event, helper) {
        var chkBoxCmp = component.find("chkRemoveThisAccount");
        component.set("v.isActiveRemoveAccount", chkBoxCmp.get("v.value"));
    },
    removeAccount: function (component, event, helper) {
        helper.removeotherfees(component, event);
    },
    
    saveAFA : function(component, event) {
        var params = event.getParam('arguments');
        if (params) {
            var message = params.message;
            if(message='message sent by parent component cpfMultiPhaseChild for otherfees'){
                component.find('iAppFeesotherRecord').submit();
            }            
            return message;
        }
    },
    
    iAppFeesotherRecordSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.appOtherFeesotherId',payload.id);
        /*if(payload.Include_other_fee_in_total_facility__c!='' && payload.Include_other_fee_in_total_facility__c!=null)
            component.set('v.includeotherfee',payload.Include_other_fee_in_total_facility__c);*/
        
    },
    
    iAppFeesotherRecordSubmit : function(component, event, helper) {
        event.preventDefault();
        var includeotherfee= component.get("v.includeotherfee");
        var eventFields = event.getParam("fields");
        eventFields.Include_other_fee_in_total_facility__c=includeotherfee;
        component.find('iAppFeesotherRecord').submit(eventFields);
    },
    
    
    iAppFeesotherRecordload: function (component) {
        
    }
    
    
    
    
    
})