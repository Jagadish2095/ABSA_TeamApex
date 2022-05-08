({
    doInit : function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "LOADED"){
            helper.checkFieldValidations(component,event);
        }        
    },    
    sendMail : function(component, event, helper) {
        component.set("v.openModel",true);        
    },
    toOpenAttachments : function(component, event, helper) {
        component.set("v.open", true);
    },    
    send : function(component, event, helper) {
        var isvalid = event.getParam("isvalid");
        if(isvalid){helper.invokeSendEmail(component,event);}
    }    
})