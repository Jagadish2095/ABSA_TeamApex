({

   	myAction : function(component, event, helper) {
		
	},
    
      changeOwner : function(component,event,helper){ 
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");
        console.log("sanctioningStatus 2 " + sanctioningStatus);

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            helper.showToast("Error!", "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes.", "error");
        } else {   
          
        var applicationId = component.get("v.appId");
        var queueName = 'Sales Support Consultants';
        var caseStatus = 'Complete Contract';
         console.log('applicationId@@@ '+applicationId);
         console.log('Status@@@ '+caseStatus);
         console.log('Queue@@@ '+queueName);
        
        var action = component.get("c.updateCaseStatus");
        action.setParams({"applicationId" : applicationId,
                          "Status" : caseStatus,
                          "Queue" : queueName});
         
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
           
            }else 
            {
                console.log ('error');
            }
             
        });
       
        $A.enqueueAction(action);
            
        }
    },
})