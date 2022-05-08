({ 
    doInit : function(component, event, helper) {
        // Get a reference to the getWeather() function defined in the Apex controller
        //var action = component.get("c.PushToPortal");
         debugger;
        helper.checkOnInitValidity(component);
         helper.pushLeadToPortal(cmp, event, helper);
        //var idtest = component.get("v.recordId");
        //console.log(idtest);
        //action.setParams({
         //   OpportunityId: component.get("v.recordId")
        //});
        
        // Invoke the service
        //$A.enqueueAction(action);
    },
    
    pushLeadToPortalController : function(cmp, event, helper) { 
        helper.pushLeadToPortal(cmp, event, helper);   
    },

    handleLeadUpdate : function(component, event, helper) { 

        console.log('BEFORE CALLING UPDATELEADDETAILS SERVICE');
        helper.updateLeadDetailsService(component, event, helper); 
    },
})