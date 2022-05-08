({
	  // function automatic called by aura:doneWaiting event 
    changeOwner : function(component,event,helper,queueName,caseStatus){ 
        var caseId = component.get("v.recordId");
         console.log('caseId@@@ '+caseId);
         console.log('queueName@@@ '+queueName);
         console.log('caseStatus@@@ '+caseStatus);
        
        var action = component.get("c.changeOwner");
        action.setParams({"caseId" : caseId,
                          "processName" : queueName,
                          "caseStatus" : caseStatus});
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
           
            }else 
            {
                console.log ('error');
            }
             this.hideSpinner(component);
        });
       
        $A.enqueueAction(action);
    },
    
    
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})