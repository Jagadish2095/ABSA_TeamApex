/**
* @author  Rudolf Niehaus : CloudSmiths
* @version v1.0
* @since   2018-06-14
**/
({
    doInit : function(component, event, helper) {
        
        helper.getRecordTypeName(component);
        
        var action = component.get("c.loadData");
        action.setParams({
            "recId" : component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var thedata = response.getReturnValue();
                
                var statusList = thedata.closeStatusList;
                var slaStatus = thedata.isOutOfSla;
                var closeStatus = thedata.isClosed;
                var classifyStatus = thedata.isNotClassified;
                var linkStatus = thedata.isNotLinked;
                var defaultStatus = thedata.defaultStatus;

                component.set("v.closeStatuses", statusList);
                component.set("v.isOutOfSla", slaStatus);
                component.set("v.isCaseClosed", closeStatus);
                component.set("v.isNotClassified", classifyStatus);
                component.set("v.isNotLinkedToAccount", linkStatus);
                component.set("v.selectedStatus", defaultStatus);
                component.set("v.ireason", "--None--");
                
                var ireason = component.find("ireason");
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
    },
    updateCase : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.closeCase");
        
        var selectedStatus = component.get("v.selectedStatus");
        var selectedReason = component.find("ireason").get("v.value");
        var selectedUnresolve = component.find("ureason").get("v.value");
        var selectedResolvedInFavour = component.find("iResolvedInFavour").get("v.value");
        var comments = component.find("icomm").get("v.value");
        
        console.log('selectedUnresolve : ' + selectedUnresolve);
        console.log('selectedResolvedInFavour : ' + selectedResolvedInFavour);
        
        action.setParams({
            "recId" : component.get("v.recordId"),
            "reason" : selectedReason,
            "status" : selectedStatus,
            "comment" : comments,
            "unresolvedReason" : selectedUnresolve,
            "resolvedInFavour" : selectedResolvedInFavour
        });
        console.log('selectedResolvedInFavour---'+selectedResolvedInFavour);
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case Closed",
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
                } else {
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                }
                
                // show error notification 
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
            }
        });
        
        if(selectedStatus === '--None--'){
            
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Warning",
                "message": "Please select a Closed Status before closing this case",
                "type":"warning"
            });
            
            toastEvent.fire();
            
            helper.hideSpinner(component);
            
        }else{
            
            if(!selectedReason && component.get("v.isOutOfSla")){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Out of SLA Reason before closing this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( !comments && component.get("v.isOutOfSla") ){
                
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please provide an Out of SLA Comment",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( ( !selectedUnresolve || selectedUnresolve === '--None--' ) && selectedStatus === 'Unresolved'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Unresolved Reason for this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else if( ( !selectedResolvedInFavour || selectedResolvedInFavour === '--None--' ) && 
                     selectedStatus === 'Resolved' && component.get("v.serviceRequestRecordTypeName") != 'Service_Request'){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Warning",
                    "message": "Please select an Resolved in Favour of for this case",
                    "type":"warning"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
                return null;
                
            }else{
                
                $A.enqueueAction(action);
            }
            
        }
    },
    onSelectChange : function(component, event, helper) {
        
        var selected = component.find("stselect").get("v.value");
        
        if(selected == 'Resolved') {
            $A.util.addClass(component.find("ureason"), "slds-hide");
            $A.util.removeClass(component.find("iResolvedInFavour"), "slds-hide");
        } else if (selected == 'Unresolved') {
            $A.util.addClass(component.find("iResolvedInFavour"), "slds-hide");
            $A.util.removeClass(component.find("ureason"), "slds-hide");
        }
        
        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
        component.set("v.selectedStatus", selected);
        
    }
})