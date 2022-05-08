({
	getOppRecords : function(cmp) {
        var action = cmp.get("c.getOppsList");
		action.setParams({"oppId" : cmp.get("v.recordId")});
		//action.setParams({"oppId" : '0063N0000061MAHQA2'});
               
        action.setCallback(this, function(response) {
              var state = response.getState(); 
              var result = JSON.stringify(response.getReturnValue());
             
              if (cmp.isValid() && state === "SUCCESS"){
                 cmp.set("v.oppList", response.getReturnValue()); 
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
    },
     //dynamic toast message alert function
    //It will take dynamic input parameters from controller methods
    //We use this for displaying error and success
    showToast: function (title, message, error) {
        let toastParams = {
            title: title,
            message: message, // Error message
            type: error
        };
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
})