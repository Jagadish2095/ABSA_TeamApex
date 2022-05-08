({
    getUserLocation : function(component, event, helper) {
        var action = component.get("c.getLoggedInUserLocation");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            var message = '';
            
            if (component.isValid() && state === "SUCCESS") {
                
                var userCityLocation = response.getReturnValue();
                
                component.set("v.isUserLocation", false);
                component.set("v.userLocation", userCityLocation);
                 component.set("v.isUserLocation", true);
                
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
    
    updateLocation: function(component, event, helper) {
        var cityLocation = component.get("v.userLocation");
        var container = component.find("container");
        $A.createComponent("wk_smw_comp:weather",
                           {DefaultLocation: cityLocation,FDays : 2,},
                           function(cmp) {
                               container.set("v.body", [cmp]);
                           });
    }
})