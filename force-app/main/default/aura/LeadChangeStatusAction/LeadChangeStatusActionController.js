({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getLeadCloseStatus");
        console.log('Sub status ==> ' +component.get("v.selectedSubStatus"));
      
        action.setParams({
            "leadId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var isClose = response.getReturnValue();
                component.set("v.isLeadClosed", isClose);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    showLeadRatingFields : function(component, event, helper) {
        var status = component.find("iStatus").get("v.value");
        var subStatus = component.find("iSubStatus").get("v.value");
        console.log('on change Sub status ==> ' +component.get("v.selectedSubStatus"));
        if(status =="Closed" && (subStatus == "Declined" || subStatus == "Customer abandoned onboarding" || subStatus == "Customer Abandoned Appointment" || subStatus == "Incorrect Number" || subStatus == "Customer ultra-sensitive")){
            component.set("v.showLeadRating",true);
        }else{
            component.set("v.showLeadRating",false);
        }

    },
    
    changeStatus : function(component, event, helper) {
        
        var status = component.find("iStatus").get("v.value");
        var subStatus = component.find("iSubStatus").get("v.value");
        var statusReason = component.find("iStatusReason").get("v.value");
        var leadRating;
        var leadRatingComment;
        
        console.log('status**',status);
        console.log('subStatus**',subStatus);
        console.log('statusReason**',statusReason);
        
        if(subStatus == '' && (status == 'Working' || status == 'Closed')){
            var toast = helper.getToast("Validation Warning", "Please complete the sub status", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }
        
        if(statusReason == '' && subStatus.includes('On Hold')){
            var toast = helper.getToast("Validation Warning", "Please complete on hold reason", "warning");
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }

        //Validate Lead rating start_ Smanga
        if(status == "Closed"){
            leadRating = component.get("v.leadRating");
            leadRatingComment = component.get("v.leadRatingComment");

            if((leadRating =='' || leadRating == undefined) && (subStatus == "Declined" || subStatus == "Customer abandoned onboarding" || subStatus == "Customer Abandoned Appointment" || subStatus == "Incorrect Number" || subStatus == "Customer ultra-sensitive")){
                var toast = helper.getToast("Validation Warning", "Please complete Lead Rating", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }

            if((leadRatingComment =='' || leadRatingComment == null || leadRatingComment == undefined) && (subStatus == "Declined" || subStatus == "Customer abandoned onboarding" || subStatus == "Customer Abandoned Appointment" || subStatus == "Incorrect Number" || subStatus == "Customer ultra-sensitive")){
                var toast = helper.getToast("Validation Warning", "Please complete Lead Rating Comment", "warning");
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        
        }//Validate Lead rating end_ Smanga
        
        helper.showSpinner(component);
        
        var action = component.get("c.updateLeadStatus");
        
        action.setParams({
            "leadId" : component.get("v.recordId"),
            "status" : status,
            "subStatus" : subStatus,
            "statusReason" : statusReason,
            "leadRating":leadRating,
            "leadRatingComment": leadRatingComment
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Status successfully updated!",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
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
                
                if(message.includes('FIELD_CUSTOM_VALIDATION_EXCEPTION,')){
                    var exceptionMessage = message.split('FIELD_CUSTOM_VALIDATION_EXCEPTION,');
                    message = exceptionMessage[1];
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
        // Send action off to be executed
        $A.enqueueAction(action);
    }
})