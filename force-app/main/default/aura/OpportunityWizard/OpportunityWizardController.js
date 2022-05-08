({
    //Initialization action
    doInit: function(component, event, helper)
    {
        component.set('v.showSpinner', true);
        component.set("v.showClientFinder", false);
        
        var action = component.get('c.isVirtualAdvisorCase');
        action.setParams({
            'caseId' : component.get('v.recordId')
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            
            if(state === 'SUCCESS'){
                var returnValue = response.getReturnValue();
                
                if(returnValue === true)
                {
                    component.set("v.showOppotunityRecordTypeSelection", true);
                    component.set("v.isVirtualAdvisorCase", true);
                    component.set("v.showOpportunityEdit", false);
                }
                else
                {
                    component.set("v.showClientFinder", true);
                    component.set("v.isVirtualAdvisorCase", false);
                }
                
                helper.getOpportunityRecordTypesList(component);
                component.set('v.showSpinner', false);
            }
        });
        $A.enqueueAction(action);
    },

    //Get selected client from client finder
    handleClientSelectionEvent: function(component, event, helper) {

        var selectedClient = event.getParam("accountValue");        
        if (selectedClient != null && selectedClient != "" && selectedClient != undefined) {
            component.set("v.accountData", selectedClient);
            component.set("v.FinderdisableNext",false);
        }

    },

    //Get selected product from client finder
    handleProductSelectionEvent: function(component, event, helper) {

            var accountNumber = event.getParam("accountNumber");
            var accountStatus = event.getParam("accountStatus");
            var accountProduct = event.getParam("accountProduct");
            var selectedProduct = {accountNumber: accountNumber, accountStatus: accountStatus, accountProduct: accountProduct};

            if (selectedProduct != null && selectedProduct != "" && selectedProduct != undefined) {

                if (selectedProduct.accountProduct === "WILL" && selectedProduct.accountStatus !== "CLOSED") {

                    component.set("v.productData", selectedProduct);
                    component.set("v.showWillTypeSelection", true);
                    helper.getWillDetails(component);
                }

            }

        },

    handleLoad: function(component, event, helper) {
        //Any actions to perform when record creation form is loaded
       	
    },

    //Any actions to perform when record creation form is submitted
    handleSubmit: function(component, event, helper) {
        event.preventDefault();
         var showValidationError = false;
         var newOppty = component.get("v.Oppty");
         let currentDate = new Date().toJSON().slice(0,10);
         console.log('newOppty OwnerId :'+newOppty.OwnerId);
         console.log('newOppty todayDate :'+currentDate);
         if(newOppty.CloseDate < currentDate){
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "title": "Info!",
                 "type" : 'error',
                 "message": "Close Date should not be Past Date"
             });
             toastEvent.fire();
             showValidationError = true;
             component.find('OppMessage').setError("Close Date should be future or today date"); 
         }
         else if((newOppty.OwnerId == undefined || newOppty.OwnerId == '') && !component.get("v.isinvestmentType"))
         {
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 "title": "Info!",
                 "type" : 'error',
                 "message": "Please Select Owner Before Submit"
             });
             toastEvent.fire();
             showValidationError = true;
             component.find('OppMessage').setError("Please Select Owner Before Submit");
         }
         
         
         if (!showValidationError) {
            component.find("opportunityEditFormVirtual").submit();  
        } 
         
     },
    //Actions for when record create form is successfully submitted
    handleSuccess: function(component, event, helper) {

        var recordId = event.getParams().response.id;
        var fields = event.getParams().response.fields;
        var newOppty = component.get("v.Oppty");
        if(component.get("v.selectedOpportunityRecordTypeName") === 'Investment Opportunity' && (newOppty.OwnerId != undefined && newOppty.OwnerId != fields.OwnerId))
        {
            if(newOppty.OwnerId != fields.OwnerId)
            {
                 var action = component.get("c.updateOppRecord"); 
          		 action.setParams({
                   oppId: recordId,
                   newOwner:newOppty.OwnerId
                });
            action.setCallback(this, function(response) {
            
            	var state = response.getState();
            	if (state === "SUCCESS") {
                     console.log('In handleSuccess line 136');
                    component.set("v.recordFormSubmitted", true);
                    component.set("v.recordId", recordId);
                    component.set("v.showOpportunityEdit", false);
                    component.set("v.showOpportunitySummary", true);
                    component.set("v.showSpinner", false);
                } 
                else if (state === "ERROR") {
                
                var errors = response.getError();
                	if (errors) {
                        
                        if (errors[0] && errors[0].message) {
                            
                            console.log("Error message: " +
                                        errors[0].message);
                            
                        }
                    } else {
                        
                        console.log("Unknown error");
                        
                    }
                    component.set("v.showSpinner", false);
            	}
            });
                $A.enqueueAction(action);
            }
          
        }
        else
        {
             console.log('In handleSuccess line 116');
            component.set("v.recordFormSubmitted", true);
            component.set("v.recordId", recordId);
            component.set("v.showOpportunityEdit", false);
            component.set("v.showOpportunitySummary", true);
            component.set("v.showSpinner", false);
        }
       
    },
    handleSuccessForNewOpp: function(component, event, helper)
    {
        console.log('handleSuccessForNewOpp : '+ JSON.stringify(event.getParams()));
        var recordId = event.getParams().id;        
       /* component.find('notifLib').showToast({
            "variant": "success",
            "title": "Opportunity Created",
            "message": "Record ID: " + recordId
        });*/
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Opportunity Created"            
        });
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:closeQuickAction").fire();
        //window.location.reload();
    },
    //Handles all changes on changeable markup
    handleChange: function(component, event, helper) {

        switch (event.getSource().getLocalId()) {
            case "opportunityRecordTypeGroup":
                //Set the opportunity recordTypeId
                component.set("v.selectedOpportunityRecordTypeId", event.getSource().get("v.value"));

                for (var i = 0; i < component.get("v.opportunityRecordTypesList").length; i ++) {
                    if (event.getSource().get("v.value") === component.get("v.opportunityRecordTypesList")[i].value) {

                        component.set("v.selectedOpportunityRecordTypeName", component.get("v.opportunityRecordTypesList")[i].label);

                        break;

                    }

                }

                helper.getSelectedOpportunityRecordTypeFields(component);

                break;
            case "willTypeRadioGroup":
                component.set("v.willTypeValue", event.getSource().get("v.value"));
                break;
        }
    },

    //Navigates to the previous tab depending on select criteria
    previousTab: function(component, event, helper) {

        if (component.get("v.showOppotunityRecordTypeSelection")) {

            component.set("v.showOppotunityRecordTypeSelection", false);
            component.set("v.showClientFinder", true);

        } else if (component.get("v.showOpportunityEdit")) {
            
            component.set("v.showOpportunityEdit", false);
            component.set("v.showOppotunityRecordTypeSelection", true);

        } else if (component.get("v.showOpportunitySummary")) {

            component.set("v.showOpportunitySummary", false);
            component.set("v.showOpportunityEdit", true);
        }
    },

    //Navigates to the next tab depending on select criteria
    nextTab: function(component, event, helper) {
		//Test By Divya
        console.log('Oppty is'+component.get("v.Oppty"));
        if (component.get("v.showClientFinder")) {

            component.set("v.showClientFinder", false);
            component.set("v.showOppotunityRecordTypeSelection", true);
            //Create selected client
            var client = component.get("v.accountData");
            if (client != null && client != "" && client != undefined) {

                var clientCif = client.CIF__c;

                if (clientCif != null && clientCif != "" && clientCif != undefined) {

                    helper.createClientCIF(component);

                }

            }

        } else if (component.get("v.showOppotunityRecordTypeSelection")) {

            if (component.get("v.selectedOpportunityRecordTypeId") != null || component.get("v.selectedOpportunityRecordTypeId") != undefined) {
                component.set("v.showOppotunityRecordTypeSelection", false);
                component.set("v.showSpinner", true);
                
                component.set("v.showOpportunityEdit", true);
                console.log('Object name'+ component.get("v.sObjectName") == 'Case');
                if((component.get("v.selectedOpportunityRecordTypeName") == 'Investment Opportunity' || component.get("v.selectedOpportunityRecordTypeName") == 'Virtual Advisor') && component.get("v.sObjectName") == 'Case')
                {
                    //Added By Divya
                    component.set("v.isinvestmentType",true);
                    var userId = $A.get("$SObjectType.CurrentUser.Id");
                    component.find("whoislookup").set("v.value",userId);
                    helper.getAccountId(component);
                }
                else
                {
                   helper.generateFormInputFields(component); 
                }
            } else {
                //Show error message
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An Opportunity Record Type must be selected.",
                    "type": "error"
                });
                toastEvent.fire();
            }

        }else if (component.get("v.showOpportunityEdit")) {
             
            var opportunityEditForm = component.find("opportunityEditForm");
            console.log('Owner is'+component.find("OwnerId"));
            //If Opp Record Type is Wills 
            if(component.get("v.selectedOpportunityRecordTypeName")=='Wills'){
                
                component.set("v.selectedAdviserId", component.get("v.selectedLookUpRecord").Id);
                component.set("v.selectedSiteId", component.get("v.selectedSiteRecord").Id);
                console.log('component.get("v.selectedAdviserId") '+  JSON.stringify(component.get("v.selectedAdviserId")));
                console.log('component.get("v.selectedSiteId")'+ JSON.stringify(component.get("v.selectedSiteId")));
                
               // Adviser Compulsary Code 
                if(component.get("v.selectedAdviserId")==null){
                    console.log('Inside Adviser Compulsary Code');
                    //Show error message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please Select Active Adviser ...",
                        "type": "error"
                    });
                    toastEvent.fire(); 
                }else if(component.get("v.selectedSiteId")==null){
                    
                    console.log('Inside Site Compulsary Code');
                    //Show error message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Please Select Active Site ...",
                        "type": "error"
                    });
                    toastEvent.fire();
                }else {
                    
                    
                    //Added to Check the Inactive broker selection
                    var action = component.get("c.CheckInactiveBroker");
                    
                    action.setParams({
                        AdviserId: component.get("v.selectedAdviserId")
                    });
                    
                    action.setCallback(this, function(response) {
                        
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            
                            console.log('response.getReturnValue' +response.getReturnValue()); 
                            component.set("v.inActiveBrokerSelected", response.getReturnValue());
                            
                            if(component.get("v.inActiveBrokerSelected") ==false) {
                                
                                console.log('Inside inActiveBrokerSelected');
                                //Show error message
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Inactive Broker Selected, Please Select Active Broker ...",
                                    "type": "error"
                                });
                                toastEvent.fire();
                                
                            }else{
                                
                                opportunityEditForm.submit();
                                
                            }
                            
                        } else if (state === "INCOMPLETE") {
                        } else if (state === "ERROR") {
                            
                            var errors = response.getError();
                            
                            if (errors) {
                                
                                if (errors[0] && errors[0].message) {
                                    
                                    console.log("Error message: " +
                                                errors[0].message);
                                    
                                }
                            } else {
                                
                                console.log("Unknown error");
                                
                            }
                        }
                    });
                    
                    $A.enqueueAction(action);
                    
                }      
            }else{
                let proceed = true;
               component.set("v.showSpinner", true);
                var newOppty = component.get("v.Oppty");
                 let currentDate = new Date().toJSON().slice(0,10);
                 
                if(newOppty.CloseDate < currentDate){
                     proceed =false;
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "title": "Info!",
                         "type" : 'error',
                         "message": "Close Date should not be Past Date"
                     });
                     toastEvent.fire();
                    component.set("v.showSpinner", false);
                 }
                if(proceed)
                {
                   opportunityEditForm.submit(); 
                }
                
            }
            
        }
        
        
    },

    //Action when opportunity creation is cancelled
    cancel: function(component, event, helper) {

        if (component.get("v.recordId") != null) {
            component.set("v.showSpinner", true);
            helper.deleteOpportunity(component);

            var homeEvent = $A.get("e.force:navigateToObjectHome");
            homeEvent.setParams({
                "scope": "Opportunity"
            });

            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                workspaceAPI.closeTab({tabId: focusedTabId});

            })
            .catch(function(error) {

                console.log(error);

            });

            //Fire navigation event
            homeEvent.fire();

        } else {

            var homeEvent = $A.get("e.force:navigateToObjectHome");

            homeEvent.setParams({
                "scope": "Opportunity"
            });

            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                workspaceAPI.closeTab({tabId: focusedTabId});

            })
            .catch(function(error) {

                console.log(error);

            });

            //Fire navigation event
            homeEvent.fire();

        }

    },

    finish: function(component, event, helper) {

        component.set("v.showSpinner", true);

        helper.updateOpportunity(component);

        var sObjectEvent = $A.get("e.force:navigateToSObject");
        var recordId = component.get("v.recordId");

       if (recordId != null && recordId != '') {
            //Close current tab
            var workspaceAPI = component.find("workspace");

            workspaceAPI.getFocusedTabInfo().then(function(response) {

                var focusedTabId = response.tabId;

                //Open created opportunity tab
                workspaceAPI.openTab({
                    url: '/lightning/r/Opportunity/' + recordId + '/view'
                })
                .then(function(response) {

                    workspaceAPI.closeTab({tabId: focusedTabId});
                    workspaceAPI.focusTab({tabId : response});

                })
                .catch(function(error) {

                    console.log(error);

                });

            })
            .catch(function(error) {

                console.log(error);

            });

        } 

    },
    handleError : function(component, event, helper)
    {
        // Get the error message
        var errorMessage = event.getParam("error");
        console.log('Error is'+JSON.stringify(errorMessage));
        component.set('v.showSpinner', false);
        //console.log('Error is'+errorMessage.body.message);
        //Handle Apex Errors
        if(errorMessage.body != undefined && errorMessage.body.output.errors.length>0)
        {
            var msg = errorMessage.body.output.errors[0].message;
            component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error !",
            "message": msg
        });
            console.log('Error from if'+msg);
        }
    }

})