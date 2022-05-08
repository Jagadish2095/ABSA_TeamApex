({
	 //Function to show toast for Errors/Warning/Success
	 getToast: function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
	showSpinner: function (component, event, helper) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
	},
	getErrorMessage: function (response){

		var message = '';
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

		return message;
	},
	closeFocusedTab : function(component) {
         
        var workspaceAPI = component.find("workspace");
         
        workspaceAPI.getFocusedTabInfo().then(function(response) {
			
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }).catch(function(error) {
            console.log(error);
        });
    },
    navHome : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "sd_Communication_Rule__c"
        });
        homeEvent.fire();
    }
})