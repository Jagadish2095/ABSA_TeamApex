/**
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-10-12
**/
({
	doInit : function(component, event, helper) {

        var action = component.get("c.loadData");
      
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                 var thedata = response.getReturnValue();
                
                var caseIsOpen = thedata.isOpen;
                var caseInApprovalRequest = thedata.isExistingApprovalProcess;
                var isServiceRequest = thedata.isServiceRequest;

                component.set("v.isCaseOpen", caseIsOpen);

                if(!isServiceRequest){
                    component.set("v.isExistingApprovalProcess", caseInApprovalRequest);
                }

              
                component.set("v.isServiceRequest", isServiceRequest);
                
                component.set("v.ireason", "--None--");
                
                var ireason = component.find("ireason");
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    updateCase : function(component, event, helper) {

		helper.showSpinner(component);
        
        var action = component.get("c.reopenCase");
        
        var selectedReason = component.find("ireason").get("v.value");
        
        action.setParams({
            "recId" : component.get("v.recordId"),
            "reason" : selectedReason
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        	var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                // show success notification
                var serviceReq = component.get("v.isServiceRequest");
                var msg = "";

                if(serviceReq){
                    msg = "Case Successfully Reopen";
                }else{
                    msg = "Case submitted for Approval to Reopen";
                }

            	var toastEvent = helper.getToast("Success!", msg, "Success");
            	toastEvent.fire();
                
                helper.hideSpinner(component);
        		helper.closeFocusedTab(component);
                helper.navHome(component, event, helper);
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
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }else{
                
                // show error notification
                var toastEvent = helper.getToast("Error", "There was an error reopening this case", "error");

    			toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
        });

        $A.enqueueAction(action);
	},
    closeModel: function(component, event, helper) {
     
        component.set("v.isOpen", false);
        component.set("v.isOpenServ", false);
      
   },
    openModel: function(component, event, helper) {

     var serviceReq = component.get("v.isServiceRequest");

     if(serviceReq){
        component.set("v.isOpenServ", true);
     }else{
        component.set("v.isOpen", true);
     }
      
   }
})