({
     doInit: function(component, event, helper)
    {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var action = component.get('c.getUserDetails');
        action.setParams({
            'userId' : userId
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                let user = response.getReturnValue();
                component.set("v.userRec",response.getReturnValue());
                if(user.User_Type__c != undefined && user.User_Type__c.includes('Trainee'))
                {
                     component.set("v.showAttestationModal",true);
                }
                else
                {
                    component.set("v.showAttestationModal",false);
                }
            }
            else if (state === "ERROR") {
                
                var errors = response.getError();
                	if (errors) {
                        
                        if (errors[0] && errors[0].message) {
                            
                            console.log("Error message: " +
                                        errors[0].message);
                            
                        }
                    } else {
                        
                        console.log("Unknown error");
                        
                    }
            }
        });
        $A.enqueueAction(action);
    },
	closeAttestationModal : function(component, event, helper) {
        component.set("v.showAttestationModal",false);
        console.log('in closeAttestationModal');
    }
})