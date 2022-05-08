({
	getGetLoggedInUserCaseTeam : function(component, event, helper) {
        var action = component.get("c.getMyHubDefaultCaseTeam");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var message = '';
            
            if (component.isValid() && state === "SUCCESS") {
                
                var caseTeamMap = response.getReturnValue();                
                console.log('caseTeamMap: ' + caseTeamMap);
                
                if(!caseTeamMap) {
                    //Show Error Message
                    component.set("v.errorMessage", "No Squad Members found");
                    component.set("v.showMySquad", false);
                    
                } else {
                    //Loop over list and to display My Squad 
                    component.set("v.userList", caseTeamMap);
                    component.set("v.showMySquad", true);
                    
                }
                
            }else if(state === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    for(var i=0; i < errors.length; i++) {
                        for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                        }
                        if(errors[i].fieldErrors) {
                            for(var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for(var j=0; j < thisFieldError.length; j++) {
                                    message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                                }
                            }
                        }
                        if(errors[i].message) {
                            message += (message.length > 0 ? '\n' : '') + errors[i].message;
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                var toast = helper.getToast("Error", message, "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            } else {
                var errors = response.getError();
                
                var toast = helper.getToast("Error", message, "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action); 
        
    },
    
    navigateToUser: function (component, event, helper) {
        //Get UserId baed on event
        var ctarget = event.currentTarget; 
        var userId = ctarget.dataset.value;
        
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": userId
        });
        navEvt.fire();
    }
    
})