({
    
        selectOpportunity: function(component, event, helper) {
        
         var action = component.get("c.getOppData");
            
            
            console.log('========>'+component.get("v.recordId"));
            
            
            var parentValue = event.getParam('arguments');
        if (parentValue) {
            var accountRecId = parentValue.oppId;//params
        }
        console.log('ACCOUNT ID in OnboardingRelatedParties------>:'+accountRecId);
            
        action.setParams({oppId: accountRecId
                         });
             action.setCallback(this, function(response) {
            var state = response.getState();
                 if (state === "SUCCESS") {
                     var respObj =response.getReturnValue();
                     console.log('respObj'+respObj);
                     console.log('respObj---->'+JSON.stringify(respObj));
                     component.set("v.respData",respObj);
                     
                     component.set('v.columns', [
                         {label: 'Client', fieldName: 'Client', type: 'text'},
                         {label: 'Account', fieldName: 'Account', type: 'text'},
                         {label:'Account Number', fieldName:'AccountNumber', type:'text'}
                         
                     ]);
                     
                     
                 }
                 else{
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "type": "error",
                         "title": "Error",
                         "message": "Something went wrong Please contact Administrator."
                     });
                     toastEvent.fire();
                 }
             });     
            
            
        $A.enqueueAction(action);
        
    }
  
    
})