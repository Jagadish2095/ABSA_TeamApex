/**
* Lightning Component Helper for CaseOverride
*
* @author  Tracy de Bruin : CloudSmiths
* @version v1.0
* @since   2018-07-20
*
**/
({
    //Show lightning spinner
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Hide lightning spinner
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    //Function to navigate home 
    navHome : function (component) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Case"
        });
        homeEvent.fire();
    },
    
    
    //Function to close tab
    closeFocusedTab : function(component) {
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    //Function to close all Tabs
    closeAllTabs : function(component) {
        
        var workspaceAPI = component.find("workspace");
        var focusedTabId = '';
        
        //Get focus tab
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            focusedTabId = response.tabId;
            
        });
        
        workspaceAPI.getAllTabInfo().then(function(response) {
            console.log('Close all Tabs : ' + response);
            response.forEach(function(tabRecord) {
                var tabRecordId =  tabRecord.tabId;
                if(focusedTabId != tabRecordId) {
                    workspaceAPI.closeTab({tabId: tabRecordId});
                } 
            });
        })
        .catch(function(error) {
            console.log(error);
        });
    },  
    
    //Function to close focus tab and open a new tab
    closeFocusedTabAndOpenNewTab : function( component, caseId) {
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
            
            //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/' + caseId + '/view'
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : response});
            })
            .catch(function(error) {
                console.log(error);
            });
            
            //Closing old tab
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    //Set Record type buttons based on Profile and default
    getCaseRecordTypes : function( component ) {
        //Set CaseType default selection
        var action = component.get("c.getLoggedInUserCaseRecordType");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var caseRecordTypes = response.getReturnValue();
                console.log('****helper caseRecordTypes****'+caseRecordTypes);
                if(caseRecordTypes != null) {
                    caseRecordTypes.forEach(function(record) {
                        //Set default record type
                        if(record.isDefault == true){
                            component.set("v.caseTypeSelected", record.value);
                            component.set("v.serviceGroupFilter", record.label);
                            if(record.value == 'Life_Complaint'){
                                component.set("v.isLifeComplaint", true);
                            }
                           else if(record.value == 'Non_Confidential_Fraud') {
                                
                                component.set("v.isNonConfidentialFraud", true); 
                                
                            } else if (record.value == 'Complaint') {
                                
                                component.set("v.isComplaint", true);
                                
                            }else if (record.value == 'Service_Request') {
                                
                                component.set("v.isServiceRequest", true);
                                
                            }else if (record.value == 'ATM') {
                                
                                component.set("v.isATM", true);
                            }else if (record.value == 'Compliment') {	
                                
                                component.set("v.isCompliment", true);	
                                
                            }else if(record.value == 'Short_term_Complaint'){ //MD:Added short term complaint record type
                                component.set("v.isShortTermComplaint", true);
                            }
                        }
                    }); 
                    
                }
                
                component.set("v.caseTypeOption", caseRecordTypes);
            }else if(state === "ERROR"){
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
                            console.log('****helper  errors****'+errors);
                        }
                    }
                }else{
                    message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                    console.log('****helper unknown errors****'+errors);
                }
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Set navigation buttons based on Permission Sets and Profiles
    getUserPermissionSets : function( component ) {
        //Set CaseType default selection
        var action = component.get("c.getComplaintsPermissionSets");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var userPermissionSets = response.getReturnValue();
                if(userPermissionSets != null) {
                    userPermissionSets.forEach(function(record) {

                        if(record == 'Yes') {
                            component.set("v.showCaseOverride", false);
                            component.set("v.hideAIPCase", true);
                        } else if (record == 'No') {
                            component.set("v.showCaseOverride", true);
                        }
                        
                         //Ashok added this code for AIP
                           else if (record == 'AIP'){
                            component.set("v.hideAIPCase", false);
                            component.set("v.showCaseOverride", false);
                            console.log("showCaseOverride1 : " + component.get("v.showCaseOverride"));
                            console.log("hideAIPCase1 : " + component.get("v.hideAIPCase"));
                        }
                        
                        //Set default record type
                        if(record == 'Route') {
                            component.set("v.showRoutingBtn", true);
                        } else if (record == 'FPOC') {
                            component.set("v.showFpocBtn", true);
                        } else if (record == 'I will Resolve') {
                            component.set("v.showIwillResolveBtn", true);
                        }
                    });  
                }
                
            }else if(state === "ERROR"){
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
                
                var toast = this.getToast("Error", message, "error");
                
                toast.fire();
                
                this.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Moves uploaded files to the case.
    doUpdateContentDocuments : function(component, caseId, uploadedFileIds) {
        
        if(uploadedFileIds.length > 0) {
            
            var action = component.get("c.uploadContentDocuments");
            
            action.setParams({
                caseId : caseId, 
                contentDocumentIds : uploadedFileIds
            }); 
            
            action.setCallback(this, function(response) {
                var state = response.getState();            
                if (state === "SUCCESS") {
                    this.doSendEmailWithAttachments(component, caseId, uploadedFileIds);
                }  
                else {
                    this.doHandleErrors(component, response.getError());
                }          
            });
            
            $A.enqueueAction(action);
        }
        else {
            this.doSendEmailWithAttachments(component, caseId, uploadedFileIds);
        }
    },
    
    //Used to send email directly, bypasses auto response.
    doSendEmailWithAttachments : function(component, caseId, uploadedFileIds) {
        
        var isCreateAndEmail =  component.get("v.isCreateAndEmail");
        var action = component.get("c.sendEmailWithAttachments");
        var serviceGroupEmailTemplate = component.get("v.serviceGroupRecord.Email_Template_Case_Creation__c");
        var serviceGroupEmailAddress = component.get("v.serviceGroupRecord.Response_Email_Address__c");
        var serviceGroupRecord2 = component.get("v.serviceGroupRecord");
        console.log('serviceGroupEmailTemplate ==> '+serviceGroupEmailTemplate);
        console.log('serviceGroupEmailAddress ==> '+serviceGroupEmailAddress);
        console.log('service Group Id ==> '+component.get("v.serviceGroupRecord.Id"));
        
        
        if(isCreateAndEmail) {
            action.setParams({
                caseId : caseId, 
                responseEmailAddress : serviceGroupEmailAddress,
                uploadedFileIds : uploadedFileIds,
                serviceGroupEmailTemplate : serviceGroupEmailTemplate,
                alternateEmailToAddress: component.get("v.alternateEmailAddress")
            });   
            
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                
                if(state === "SUCCESS") {
                    this.doHandleNavigation(component, caseId);
                }
                else {
                    this.disableButton(component, event, false); //Simangaliso Mathenjwa - to enable the buttons in the event of an error
                    this.doHandleErrors(component, response.getError());
                }
            });
            
            $A.enqueueAction(action);        
        }
        else {
            this.doHandleNavigation(component, caseId);
        }       
    },
    
    //Handles navigation after case creation.
    doHandleNavigation : function(component, caseId) {
        
        var routingCase = component.get("v.isRouting");
        var iWillResolveCase = component.get("v.isIwillResolve");
        var fpocCase = component.get("v.isFPOC");
        var NBFS = component.get("v.isNBFSServiceGroup");
        var isCloseCase = component.get("v.isCloseCase");
        //Fire success
        var successMessage;
        if(isCloseCase == true){
        	successMessage = 'Case created and closed successfully.';
        }else{
            successMessage = 'Case created.';
        }
        
        var toastEvent = this.getToast("Success!", successMessage, 'success');
        toastEvent.fire();
        
        //Navigate to Resolution screen 
         if(fpocCase == true) {
            // Added to show the NBFS Page Layout for NBFS Service Groups:
            if(NBFS != true){
                var evt = $A.get("e.force:navigateToComponent");      
            	evt.setParams({
                	componentDef:"c:CaseResolutionAndClosure",
                	componentAttributes: {
                    caseRecordId: caseId
                }
            });
            
            this.closeAllTabs(component);            
            this.closeFocusedTab(component);            
            evt.fire(); 
         } 
          else
             this.closeFocusedTabAndOpenNewTab(component, caseId);
		 }

        
        //Navigate to case
        //RN - add logic to close the previouse focused tab and opening a new tab 
        //to the new case
        if(iWillResolveCase == true || isCloseCase == true) {
            this.closeFocusedTabAndOpenNewTab(component, caseId);
            
        } else if (routingCase == true) {
            this.closeFocusedTab(component);
            this.navHome(component);
        }
    },
    
    
    //Disable "FPOC", "I Will Resolve", "Route" buttons after click - Simangaliso Mathenjwa
    disableButton: function(component, event, disButton){
        
        //Disable button after click - Simangaliso Mathenjwa
        var caseRecordType = component.get("v.caseTypeSelected");
        if(caseRecordType == 'ATM' || caseRecordType == 'Complaint' || caseRecordType == 'Service_Request'){
            //component.set("v.isButtonDisabled", disButton);
            //Added to compensate the disable button functionality for NBFS -- Poulami
        	var btnRoute = component.find("ibtnServiceGroupRouting");
            if(btnRoute !== undefined)
        		btnRoute.set('v.disabled',disButton);
        	var btnResolve = component.find("ibtnIwillResolve");
            if(btnResolve !== undefined)
        		btnResolve.set('v.disabled',disButton);
         	var btnFPOC = component.find("ibtnFPOC");
            if(btnFPOC !== undefined)
        		btnFPOC.set('v.disabled',disButton);
        	var btnCancel = component.find("ibtnCancel");
            if(btnCancel !== undefined)
        		btnCancel.set('v.disabled',disButton);
            var btnClose = component.find("ibtnClose");
            if(btnClose !== undefined)
        		btnClose.set('v.disabled',disButton);
        }
    },
    
     //function for showing the reminder to choose a product - Simangaliso Mathenjwa 22 Sep 2020
     showReminderAction : function(component, event, open){
        component.find('notifLib').showNotice({
               "variant": "Warning",
               "header": "Friendly Reminder!",
               "message": "Please select the relevant product related to the complaint under Client Finder Products.",
               closeCallback: function() {
                component.set("v.showTheReminder", false);
               }
               
           });
   },

   //function for showing the reminder to send email - Simangaliso Mathenjwa 22 Sep 2020
   showStaffReminderAction : function(component, event){
    component.find('notifLib').showNotice({
           "variant": "Warning",
           "header": "Friendly Reminder!",
           "message": "Please remember to send an email to the staff member to receive the compliment",
           closeCallback: function() {
            component.set("v.showStaffTheReminder", false);
           }
           
       });
},
    
    //Generic method to display error messages in toast.
    doHandleErrors : function(component, errors) {
        
        //Hide spinner when there is an error.
        this.hideSpinner(component);
        
        let toastParams = {
            title: "Error",
            message: "Unknown error", // Default error message
            type: "error",
            mode: 'sticky'
        };
        
        if(errors && Array.isArray(errors) && errors.length > 0) {
            toastParams.message = errors[0].message;
        }
        
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams(toastParams);
        toastEvent.fire();
    },
})