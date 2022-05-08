({
    doInit : function(component, event, helper){
        
       var action = component.get("c.getdocument");
       var caseId = component.get("v.caseId");
       var DocumentType=component.get("v.DocumentType");
       action.setParams({
           'docType': DocumentType,
           'caseId': caseId,
       })
       action.setCallback(this, function(response) {
           var state = response.getState();
           console.log('state>>>'+state);
           if(component.isValid() && state === 'SUCCESS') {
               component.set("v.contents", response.getReturnValue()); 
               console.log('response.getReturnValue()>>>'+response.getReturnValue());
           }
       });
        $A.enqueueAction(action);
    },
})