({
     
	 submitD : function(component, event, helper) {
        
        component.set("v.showSpinner", true);
         var decision=component.get("v.selectedOption");
         if(decision== 'Accepted'){
             var reason ='';
         } else{
             var reason = component.find("reasons");
             reason = Array.isArray(reason) ? reason[0].get("v.value") : reason.get("v.value");
             console.log("-=-=-= reason" + reason);
         }
         var action = component.get("c.submitDecision");
         
         action.setParams({
             "oppId"            : component.get("v.recordId"),
             "decision"         : decision,
             "reason"           : reason,
             "comments"         : component.get("v.comments"),
             "defaultApprover"  : component.get("v.defaultApprover"),
         }); 
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var results = response.getReturnValue();
                console.log("-=-=-= results" + results);   
                if(results== "SUCCESS"){
                   // component.set("v.disableBtn",true);
                    var toastEvent = this.getToast("Success!", "Decision Submitted Successfully", "Success");
                    toastEvent.fire();
                }else{
                    this.showError(response, "Submit Decision Error:");
                   // component.set("v.disableBtn",false);
                }
                
            } else {
                this.showError(response, "Submit Decision Error:");
                //component.set("v.disableBtn",false);
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
        
    },
    
    
     showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
        
        // show error notification
        var toastEvent = this.getToast("Error: TermLoans " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
    
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });
        
        return toastEvent;
    },
})