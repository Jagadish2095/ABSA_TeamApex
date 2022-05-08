({
	getUserEmail : function(component,event,currentcaseid)
    {        
       var action = component.get("c.getAdvisorFace2Face");
        action.setParams({            
            'caseId': currentcaseid,
        });
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               console.log('--json--'+ storeResponse);
                component.set("v.usrEmail", storeResponse);                
            }
         
         });
        // enqueue the Action  
        $A.enqueueAction(action);
    }
})