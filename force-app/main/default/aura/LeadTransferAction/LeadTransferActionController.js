/**
* Quick action that allows a user to transfer a lead between teams
*
* @author  Sipho Mbulawa
* @version v1.0
* @since   2020-03-03
*
**/
({
    doInit : function(component, event, helper) {
        
        /*var transferReason = component.find("iReason");
        transferReason.set("v.value", "");
        var transferComments = component.find("iComments");
        transferComments.set("v.value", "");*/
        
        
        var action = component.get("c.getLeadCloseStatus");
      
        action.setParams({
            "leadId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var isClose = response.getReturnValue();
                component.set("v.isCaseClosed", isClose);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
     getServiceGroup : function(component, event, helper) {
    	
        helper.showSpinner(component);
        
        var action = component.get("c.findServiceGroupRecord");
        var serviceGroupId = component.find("serviceGroupLookupSearch").get("v.value");
        
        action.setParams({
            "serviceGroupId" :serviceGroupId
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                component.set("v.serviceGroupRecord", response.getReturnValue());
                
                var queueName = component.find("serviceGroupLookupSearch");
                var serviceGroupName = component.find("serviceGroupLookupSearch");
                var serviceGroupId = component.find("serviceGroupLookupSearch");

                queueName.set("v.value", component.get("v.serviceGroupRecord.Queue__c")); 
                serviceGroupName.set("v.value", component.get("v.serviceGroupRecord.Name"));
                serviceGroupId.set("v.value", component.get("v.serviceGroupRecord.Id"));
                
                helper.hideSpinner(component);
                
            }else{
                
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error searching for the relevant Service Group",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    clickTransfer : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.transferLead");
        
        var selectedQueue = component.get("v.qname");
        var serviceGroupRecord = component.get("v.serviceGroupRecord");

        action.setParams({
            "leadId" : component.get("v.recordId"),
            //"reason" : component.find("iReason").get("v.value"),
            //"comments" : component.find("iComments").get("v.value"),
            "serviceGroupRecord" : serviceGroupRecord
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Lead successfully transferred",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                // refresh record detail
                $A.get("e.force:refreshView").fire();
                
            }else if(state === "ERROR"){
                
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
                
                // show Error message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": message,
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
        
        });

         //Validation
		if( !serviceGroupRecord.Name){
            //if( !serviceGroupRecord.Name || !component.find("iReason").get("v.value") )
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Warning",
                "message": "Please select a Service Group AND Transfer Reason before transferring this Case",
                "type":"warning"
            });
            
            toastEvent.fire();
            helper.hideSpinner(component);
            
        }else{
            // Send action off to be executed
        	$A.enqueueAction(action);
        }
    }
})