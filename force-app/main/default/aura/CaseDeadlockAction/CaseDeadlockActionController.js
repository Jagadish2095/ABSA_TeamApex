/**
* Lightning Component Controller for Deadlock
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-16
*
**/


({
    //Check to see if approval process already in progress
    doInit : function(component, event, helper) {
        
        var action = component.get("c.approvalProccessChecks");
        
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var thedata = response.getReturnValue();
                
                var statusList = thedata.closeStatusList;
                var slaStatus = thedata.isInSLA;
                
                component.set("v.isValid", thedata);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    
    //Koketso - handle multiple files, and display selected file names
    handleFilesChange: function(component, event, helper) {
        
        var uploadedFileIds = [];
        var uploadedFiles = event.getParam("files");
        console.log('uploadedFiles:',uploadedFiles);
        //alert('File Uploaded')
        
        /**if(uploadedFiles.length > 0) {

            var filenames = '';
            var uploadedFileNames = component.find('uploadedFileNames');

            for(var f = 0; f < uploadedFiles.length; f++){
                uploadedFileIds.push(uploadedFiles[f]['documentId']);
                filenames += uploadedFiles[f]['name']+"; ";
            }
            if(filenames != '') {
                var forensicFileText = component.find('forensicFileText');
                $A.util.removeClass(forensicFileText, 'slds-text-color_error');
                $A.util.addClass(forensicFileText, 'slds-text-color_success');
                var complaintFileText = component.find('complaintFileText');
                $A.util.removeClass(complaintFileText, 'slds-text-color_error');
                $A.util.addClass(complaintFileText, 'slds-text-color_success');                
                $A.util.removeClass(uploadedFileNames, 'slds-text-color_error');
                $A.util.addClass(uploadedFileNames, 'slds-text-color_success');
            }
            else {
               	var forensicFileText = component.find('forensicFileText');
                $A.util.removeClass(forensicFileText, 'slds-text-color_success');
                $A.util.addClass(forensicFileText, 'slds-text-color_error'); 
                var complaintFileText = component.find('complaintFileText');
                $A.util.removeClass(complaintFileText, 'slds-text-color_success');
                $A.util.addClass(complaintFileText, 'slds-text-color_error');
                $A.util.removeClass(uploadedFileNames, 'slds-text-color_success');
                $A.util.addClass(uploadedFileNames, 'slds-text-color_error');
            }
            console.log('uploadedFileIds:',uploadedFileIds);
            component.set("v.fileStr", filenames);
            component.set("v.fileIds", uploadedFileIds);
        }*/       
    },
    
    //Submit for approval
    submitDeadlockApproval : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.deadlockApproval");
        var deadlockReason = component.find("iDeadlockReason").get("v.value");
        
        //Make sure Deadlock REason was provided
        if(!deadlockReason ) {
            // show success notification
            var toastEvent = helper.getToast("Validation", "Please provide a Deadlock Reason/Motiviation", "Warning");
            toastEvent.fire();
            helper.hideSpinner(component);
            return null;
            
        }
                
        action.setParams({
            "recId" : component.get("v.recordId"),
            "reason" : deadlockReason
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                // show success notification
                var toastEvent = helper.getToast("Success!", "Deadlock Submitted for Approval", "success");
            	toastEvent.fire();

                // refresh record detail
                $A.get("e.force:refreshView").fire();
                
            } else if(state === "ERROR"){
                
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
            }
        });
        
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
})