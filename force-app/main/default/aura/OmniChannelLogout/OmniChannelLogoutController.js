({
    onLogout : function(component, event, helper) {
     
      var action = component.get("c.RassignCase");
        
          $A.enqueueAction(action);
    },
     onLoginSuccess  : function(component, event, helper) {
         
         var action = component.get("c.RassignCase");
         
         action.setParams({statusId :  event.getParam('statusId') });
    } 
})