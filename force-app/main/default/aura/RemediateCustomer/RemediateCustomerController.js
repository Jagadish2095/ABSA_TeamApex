({
	doInit : function(component, event, helper) {
        console.log('Entered');
        helper.fetchopp(component);
        
		
	},
    closeModel:function (component, event, helper) {
       component.set('v.isShowRemediate',false); 
    },
   // Redirecting to existing opportunity record
    redirectOppRecord: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject"); 
        navEvt.setParams({
            "recordId": component.get("v.existOpp")
        });
        navEvt.fire();
        component.set('v.isShowRemediate',false); 
        component.set('v.isExistingOpp',false);
      
    },
    
    //Redirecting to big form after assigned owner is updated 
    redirectOnboardAssign :function (component, event, helper) {
        component.set("v.showSpinner", true);
        var opptId = component.get("v.existOppAsgn");
        if(opptId!=''|| opptId!=undefined){
        var action = component.get("c.updateOwner"); 
        action.setParams({
            "oppId": opptId
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
               // alert('success')
                var oppRec = response.getReturnValue();
                component.set("v.opportunityRecord",oppRec);
                helper.navigateToEditCmp(component,event);
                
            }
            component.set('v.isShowRemediate',false); 
            component.set('v.isExistingOppAssign',false);
            component.set("v.showSpinner", false);
            
            });
        $A.enqueueAction(action);
    }
    },
    
   //Redirecting to big form after creation of opportunity
   redirectOnboard :function (component, event, helper) {
        
        component.set("v.showSpinner", true);
        var objectId = component.get("v.recordId");
        if(objectId!=''|| objectId!=undefined){
        var action = component.get("c.createOpp"); 
        action.setParams({
            "accountId": objectId
        });
        action.setCallback(this, function(response) { 
            var state = response.getState();
            if (state === "SUCCESS") {
              //  alert('success')
                var oppRec = response.getReturnValue();
              //  alert('New Opportunity Details-->'+JSON.stringify(oppRec))
                component.set("v.opportunityRecord",oppRec);
                helper.navigateToEditCmp(component,event);
                
            }
            component.set('v.isShowRemediate',false);
            component.set('v.isNewOpp',false);
            component.set("v.showSpinner", false);
            
            });
        $A.enqueueAction(action);
    }
        
} 

})