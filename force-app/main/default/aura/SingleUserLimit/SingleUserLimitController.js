({
    doInit : function(component, event, helper) {
        
        
        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        action.setParams({clientAccountId:clientAccountId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('-----SUCCESS-----');
                var respObj = response.getReturnValue();
                console.log('Response : '+respObj);
                component.set('v.customerKey',respObj);
                helper.doInit(component, event,helper);  
            }
            
            else if(state === "ERROR"){
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Service Issue ..Please try again ",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
        });
        $A.enqueueAction(action);
    },
    
    onUserChange : function(component, event, helper) {
        
        var selectedUser = component.get('v.selectedUser');
        var respObj = component.get('v.responseList');
        
        var userNum = "";
        
        for(var key in respObj){
            
            if(respObj[key].userName == selectedUser){
                
                component.set('v.userNumber',respObj[key].userNo);
                console.log('user number : '+respObj[key].userNo);
                
            }
        }
        helper.getUserLimits(component, event); 
    },
    
    closeCase : function(component,event,helper){
        
        //debugger;
        helper.caseCurrentCaseHelper(component, event, helper);
        component.set("v.showCloseCase",false);
        
    }
    
    
    
})