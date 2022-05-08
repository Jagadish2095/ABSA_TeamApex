({
	myAction : function(component, event, helper) {
		
	},
    
      changeOwner : function(component,event,helper){ 
        var applicationId = component.get("v.appId");
        var queueName = 'Sales Support Consultant';
        var caseStatus = 'Submit to Fulfillment';
         console.log('applicationId@@@ '+applicationId);
         console.log('Status@@@ '+caseStatus);
         console.log('Queue@@@ '+queueName);
        
        var action = component.get("c.updateCaseStatus");
        action.setParams({"applicationId" : applicationId,
                          "Status" : caseStatus,
                          "Queue" : queueName});
         
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();
            var result 	= JSON.stringify(response.getReturnValue());
            if (state == "SUCCESS")
            {                   
                var msg	= 'Submitted to SSC!'; 
                helper.successMsg(component, msg);
                
            }else 
            {
                console.log ('error');
                //var msg	= 'Something went wrong<br/>'+result; 
                //helper.errorMsg(component, msg);
            }
             
        });
       
        $A.enqueueAction(action);
    },
    
})