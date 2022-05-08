({
    doInit: function (component, event, helper) {
    component.set('v.appOtherFeesIdFaci',component.get('v.otherfeesItem').Id);

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
            if(message='message sent by parent component cpfMultiPhaseChild for facifees'){
            component.find('iAppFeesRecordFaci').submit();
            }
            return message;
        }
    },

    
    iAppFeesRecordFaciSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        component.set('v.appOtherFeesIdFaci',payload.id);
    },
    iAppFeesFaciRecordSubmit : function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        component.find('iAppFeesRecordFaci').submit(eventFields);
    },

    iDynamicPicklistOnChange: function (component, event, helper) {
        var selectedValues = event.getSource().get("v.value");
        component.find('acc2BeClosed').set('v.value',selectedValues);
    },
    
    iAppFeesFaciRecordload: function (component) {
        var acc2BeClosed = component.find('acc2BeClosed');
        if(acc2BeClosed){
            acc2BeClosed = Array.isArray(acc2BeClosed) ? acc2BeClosed[0].get("v.value") : acc2BeClosed.get("v.value");
            
            if(acc2BeClosed != component.find('iDynamicPicklist').get('v.value')){
                component.set('v.iDynamicPicklist',acc2BeClosed);
            }
        }
    },
    
    
    
    
    
})