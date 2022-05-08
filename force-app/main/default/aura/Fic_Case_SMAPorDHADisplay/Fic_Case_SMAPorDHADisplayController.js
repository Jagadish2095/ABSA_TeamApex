({
    doInit : function(cmp){
       let action = cmp.get("c.callDhaCertificate");
       let caseId = cmp.get("v.caseId");
       action.setParams({
           'caseId': caseId
       })
       action.setCallback(this, function(response) {
           var state = response.getState();
           if(cmp.isValid() && state === 'SUCCESS') {
               cmp.set("v.contents", response.getReturnValue()); 
           }
       });
        $A.enqueueAction(action);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.spinner", true);
    },
    hideSpinner : function(component,event,helper){
        component.set("v.spinner", false);
    }
})