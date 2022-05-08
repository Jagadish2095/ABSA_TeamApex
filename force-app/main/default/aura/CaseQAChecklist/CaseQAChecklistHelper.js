({
	createCaseChecklist : function(cmp) {
        
        var action = cmp.get("c.createCaseChecklistrecs");
        action.setParams({"caseId" : cmp.get('v.recordId')});
   
         action.setCallback(this, function(response) {
              var state = response.getState(); 
              var result = JSON.stringify(response.getReturnValue());

              if (cmp.isValid() && state === "SUCCESS"){
                 //$A.get('e.force:refreshView').fire();
              }
         });   
        $A.enqueueAction(action);		
	},
    
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    }
})