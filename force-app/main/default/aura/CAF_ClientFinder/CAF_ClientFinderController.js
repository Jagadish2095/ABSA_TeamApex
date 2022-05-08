/**
 * Lightning Component Controller for Client Finder
 *
 * @author  Tracy de Bruin : CloudSmiths
 * @version v1.0
 * @since   2018-07-20 
 *
 **/
({
    doInit: function(component, event, helper) {
        var selectedJob = component.get("v.jobname");
        
        console.log('selectedJob : ' + selectedJob);
        console.log('selectedJob Process Type : ' + selectedJob.Process_Type__c);
        console.log('ProcessName : ' + component.get("v.ProcessName"));
        
        helper.fetchCountryValues(component, event, helper);
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Client Finder" 
            });
            
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "action:new_account", 
                iconAlt: "Client Finder" 
            });
        })
        
        // Prepare a new record from template
        component.find("caseRecordCreator").getNewRecord(
            "Case",
            null,
            false,
            $A.getCallback(function() {
                var rec = component.get("v.newCase");
                var error = component.get("v.newCaseError");
                
                if (error || rec === null) {
                    console.log("Error initializing record template: " + error);
                } else {
                    console.log("Record template initialized: " + rec.apiName);
                }
            })
        );
        
        console.log('showCreateIndividualProspectOnboarding : ' + component.get("v.showCreateIndividualProspectOnboarding"));
        
        //call hepler method to get recordTypeId
        helper.getRecordTypeId(component, event, helper);
        //get roles
        helper.fetchPickListVal(component, "Roles", "Roles");
        helper.fetchPickListVal(component, "Designation__c", "Designation__c");
        helper.getloggedinUserProfileName(component, event, helper);
        console.log('Process Type from OnboardingRelatedParties:::'+component.get('v.processTypeP'));
    },

    handleStartOnboardingEvent: function(component, event, helper) {
            $A.createComponent("c:BranchCustomerFlow", "{Api:BranchCustomer}", function(newCmp) {
            component.set("v.body", newCmp);
            });      
    },
    
    handleComponentEvent: function(component, event, helper) {
        //var selectedJob = event.getParam("selectedJob");
        var selectedJob = component.get("v.jobname");
        
        var accountId = component.get("v.accountSelected.Id");
        var accountRecord = component.get("v.accountSelected");
        
        //Fire Event to Initiate the Onboarding New To Bank Client Flow
        var appEvent = $A.get("e.c:navigateToFlowCmp");
        if (selectedJob.Service_Type__r.Name === "Onboard New To Bank Client") {
            appEvent.setParams({
                navigate: "true",
                accountId: component.get("v.accountSelected.Id")
            });
        } else {
            appEvent.setParams({
                navigate: "false",
                accountId: component.get("v.accountSelected.Id")
            });
        }
        
        appEvent.fire();
        if (accountId != undefined) {
            component.set("v.newCaseField.AccountId", accountId);
        }
        
        if (selectedJob.Service_Type__r.Name != undefined) {
            component.set(
                "v.newCaseField.Subject",
                accountRecord.Name + " " + $A.get("$Label.c.Onboarding")
            );
        } else if (
            selectedJob.Service_Type__r.Case_Record_Type__c != "Onboarding"
        ) {
            component.set(
                "v.newCaseField.Subject",
                accountRecord.Name + " " + selectedJob
            );
        }
        
        if (accountRecord.Name === null) {
            component.set(
                "v.newCaseField.Subject",
                accountRecord.FirstName +
                " " +
                accountRecord.LastName +
                " " +
                selectedJob.Service_Type__r.Name
            );
        } else {
            component.set(
                "v.newCaseField.Subject",
                accountRecord.Name + " " + selectedJob.Service_Type__r.Name
            );
        }
        if (selectedJob.Service_Type__r.Case_Record_Type__c === "Onboarding") {
            component.set(
                "v.newCaseField.Status",
                $A.get("$Label.c.Complete_Client_Details")
            );
        } else {
            component.set("v.newCaseField.Status", $A.get("$Label.c.In_Progress"));
        }
        
        //   component.set("v.newCaseField.Status", $A.get("$Label.c.Complete_Client_Details"));
        component.set(
            "v.newCaseField.Case_Ownership__c",
            $A.get("$Label.c.I_will_Resolve")
        );
        component.set(
            "v.newCaseField.Origin",
            $A.get("$Label.c.What_do_you_want_to_do_today")
        );
        
        if (component.get("v.serviceRequestRecordTypeId") != undefined) {
            component.set(
                "v.newCaseField.RecordType",
                component.get("v.serviceRequestRecordTypeId")
            );
        }
        if (selectedJob.Service_Type__r.Type__c != undefined) {
            component.set("v.newCaseField.Type", selectedJob.Service_Type__r.Type__c);
        }
        if (selectedJob.Service_Type__r.Name != undefined) {
            component.set("v.newCaseField.Type__c", selectedJob.Service_Type__r.Name);
        }
        if (selectedJob.Service_Type__r.Subtype__c != undefined) {
            component.set(
                "v.newCaseField.Subtype__c",
                selectedJob.Service_Type__r.Subtype__c
            );
        }
        if (selectedJob.Service_Type__r.Product__c != undefined) {
            component.set(
                "v.newCaseField.Product__c",
                selectedJob.Service_Type__r.Product__c
            );
        }
        
        if (selectedJob.Service_Group__r.Name != undefined) {
            component.set(
                "v.newCaseField.sd_Service_Group__c",
                selectedJob.Service_Group__r.Name
            );
            component.set(
                "v.newCaseField.sd_Original_Service_Group__c",
                selectedJob.Service_Group__r.Name
            );
        }
        
        if (selectedJob.Id != undefined) {
            component.set(
                "v.newCaseField.sd_Service_Group_Type_Id__c",
                selectedJob.Id
            );
        }
        
        if (selectedJob.Service_Group__r.Queue__c != undefined) {
            component.set(
                "v.newCaseField.sd_Original_Service_Queue__c",
                selectedJob.Service_Group__r.Queue__c
            );
        }
        
        if (selectedJob.Service_Level__c != undefined) {
            component.set(
                "v.newCaseField.sd_Service_Level_Id__c",
                selectedJob.Service_Level__c
            );
        }
        
        if (selectedJob.Service_Group__c != undefined) {
            component.set(
                "v.newCaseField.sd_Service_Group_Id__c",
                selectedJob.Service_Group__c
            );
        }
        
        if (selectedJob.sd_Communication_Plan_Id__c != undefined) {
            component.set(
                "v.newCaseField.sd_Communication_Plan_Id__c",
                selectedJob.sd_Communication_Plan_Id__c
            );
        }
        
        if (selectedJob.Service_Group__r.Business_Hours__c != undefined) {
            component.set(
                "v.newCaseField.BusinessHoursId",
                selectedJob.Service_Group__r.Business_Hours__c
            );
        }
        
        if (selectedJob.Service_Group__r.Response_Email_Address__c != undefined) {
            component.set(
                "v.newCaseField.sd_Response_Email_Address__c",
                selectedJob.Service_Group__r.Response_Email_Address__c
            );
        }
        
        if (component.get("v.accountRecord.Phone") != undefined) {
            component.set(
                "v.newCaseField.Phone__c",
                component.get("v.accountRecord.Phone")
            );
        }
        if (component.get("v.accountRecord.PersonEmail") != undefined) {
            component.set(
                "v.newCaseField.Email__c",
                component.get("v.accountRecord.PersonEmail")
            );
        }
        if (component.get("v.accountRecord.Communication_Method__c") != undefined) {
            component.set(
                "v.newCaseField.Communication_Method__c",
                component.get("v.accountRecord.Communication_Method__c")
            );
        }
        
        component.find("caseRecordCreator").saveRecord(function(saveResult) {
            var caseRecord = component.get("v.newCaseField");
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                var workspaceAPI = component.find("workspace");
                
                workspaceAPI
                .getFocusedTabInfo()
                .then(function(response) {
                    var focusedTabId = response.tabId;
                    
                    console.log(focusedTabId);
                    
                    //Opening New Tab
                    workspaceAPI
                    .openTab({
                        url: "#/sObject/" + saveResult.recordId + "/view"
                    })
                    .then(function(response) {
                        workspaceAPI.focusTab({ tabId: response });
                    })
                    .catch(function(error) {
                        console.log(error);
                    });
                    
                    //Closing old tab
                    workspaceAPI.closeTab({ tabId: focusedTabId });
                })
                .catch(function(error) {
                    console.log(error);
                });
                
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    title: "Saved",
                    type: "success",
                    message: "New case created."
                });
                resultsToast.fire();
            } else if (saveResult.state === "INCOMPLETE") {
            } else if (saveResult.state === "ERROR") {
                // handle the error state
                console.log(
                    "Problem saving case, error: " + JSON.stringify(saveResult.error)
                );
            } else {
                console.log(
                    "Unknown problem, state: " +
                    saveResult.state +
                    ", error: " +
                    JSON.stringify(saveResult.error)
                );
            }
        });
    },
    
    //Ajit
    Showhide: function(component, event, helper) {
        let checkBoxState = event.getSource().get("v.value");
        console.log(event.getSource().get("v.value"));
        component
        .find("createBusinessProspectOnboarding")
        .set("v.disabled", !checkBoxState);
    },
    
    //Validate search value entered - If more than 2 then enable Search button
    validateSearchValueLength: function(component, event, helper) {
        //Get Search value character size
        var searchValue = component.find("iSearchValue").get("v.value");
        var searchValueLength;
        
        if (searchValue != null) {
            searchValueLength = searchValue.length;
            
            //Set disable property
            if (searchValueLength > 1) {
                component.set("v.isNotValidSearchValue", false);
            } else {
                component.set("v.isNotValidSearchValue", true);
            }
        } else {
            component.set("v.isNotValidSearchValue", true);
        }
    },
    
    //Get Client column headers from Account Field Sets based on "isCompactView" attribute/parameter
    getColumnHeaders: function(component, event, helper) {
        //Set Client Columns
        helper.getClientFieldSet(component, event);
    },
    
    //Get Client RecordTpe Ids
    getClientRecordType: function(component, event, helper) {
        //Set Client Columns
        helper.getAccountRecordType(component, event);
        //TdB - Set Individual Prospect Record Type Id
        helper.getIndividualProspectRecordType(component, event);
    },
    
    //Open Create New Contact Modal
    showNewContactModal: function(component, evt, helper) {
        component.set("v.isCreateContact", true);
    },
    
    //Close Create New Contact Modal
    closeNewContactModal: function(component, event, helper) {
        component.set("v.isCreateContact", false);
    },
    
    //Open Create New Individual Prospect Modal
    showNewIndividualProspectModal: function(component, evt, helper) {
        //Start -- Added by Srini G
        var idNumber = component.find("iSearchValue").get("v.value");
        component.set("v.newIndivProspect.ID_Number__pc", idNumber);
        // End
        component.set("v.isCreateIndividualProspect", true);
    },
    //Open Create New Individual Prospect Modal for Branch khaliq Added
    showNewBranchIndividualProspectModal: function(component, evt, helper) {
        //Start -- Added by Srini G
        var idNumber = component.find("iSearchValue").get("v.value");
        component.set("v.newIndivProspect.ID_Number__pc", idNumber);
        // End
        component.set("v.isCreateBranchIndividualProspect", true);     
        
    },
    //Select rdaio button for Branch khaliq Added
    confirmSelection: function(cmp, evt) {
        //var selected = evt.getSource().get("v.label");
        var selected = cmp.get("v.consentVal");
        cmp.set("v.showNewProductOnboarding", true); 
        cmp.set("v.isConsentSelected", selected);        
        cmp.set("v.isSelectionConfermed", true);
        var idSelected = cmp.get("v.accountSelected.ID_Number__pc");       
    },
    
    //Close Create New Individual Prospect Modal
    closeNewIndividualProspectModel: function(component, event, helper) {
        component.set("v.isCreateIndividualProspect", false);
    },

    //Close Create New Branch Individual Prospect Modal khaliq Added
    closeNewBranchIndividualProspectModel: function(component, event, helper) {
         component.set("v.isCreateBranchIndividualProspect", false);

    },
    
    //Open Create New Business Prospect Modal
    showNewBusinessProspectModal: function(component, evt, helper) {
        component.set("v.isCreateBusinessProspect", true);
    },
    
    //Close Create New Business Prospect Modal
    closeNewBusinessProspectModel: function(component, event, helper) {
        component.set("v.isCreateBusinessProspect", false);
    },
    
    
    //W-004914 - Manoj 07022020 - Selecting Client Group, Client Type when creating Related Party
    selectClientType : function(component, evt, helper) {
        //console.log('SELECTING CLIENT TYPE');
        
        $A.createComponent("c:ClientTypeSelection", {                                                                
        },
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLib').showCustomModal({
                                       header: "Select Client Type",
                                       body: content,
                                       cssClass: "mymodal"
                                   })
                               }                               
                           });
        
    },
    //W-004914 - Manoj 07022020 - Selecting Client Group, Client Type when creating Related Party
    relatedPartyTemplate : function(component, event, helper) {
        var selectedClientType = event.getParam("selectedclienttype");
        var searchValue = component.find('iSearchValue').get('v.value');
        var parentId=component.get("v.parentId");
        
        if(selectedClientType=='Private Individual'){
            $A.enqueueAction(component.get('c.showNewRelatedPartyModal'));
            
        }
        //Diksha Wasekar: Added for non-individual related parties commented to switch off complex  
        else if(selectedClientType=='Trusts' || selectedClientType=='Private Company' || selectedClientType=='Close Corporation' || 
                  selectedClientType=='Foreign Listed Company'|| selectedClientType=='Foreign Trust'|| selectedClientType=='Public Listed Company'||
                  selectedClientType=='Foreign Company'|| selectedClientType=='Co-operative' || selectedClientType=='Incorporated Company' ||
                  selectedClientType=='Not for Profit Organizations (NGO)' || selectedClientType=='Clubs/Societies/Associations/Other Informal Bodies'||selectedClientType=='Not for Profit Companies'){
            //Diksha's Component
            console.log('placeofresidence'+event.getParam("selectedplaceOfResidence"));
            console.log('Process Type inside relatedPartyTemplate::'+component.get('v.processTypeP'));
            $A.createComponent("c:onboardingNonIndividualRelatedParties",{parentId: parentId,clienttype:selectedClientType,
                                                                          primaryEntityId:component.get("v.primaryEntityId"),
                                                                          parentRelationshipId:component.get("v.parentRelationshipId"),
                                                                          clientgroup:event.getParam("selectedclientgroup"),
                                                                          placeofresidence:event.getParam("selectedplaceOfResidence"),
                                                                          searchvalue:searchValue,                                     // event.getParam("selectedsearchvalue")
                                                                          processType:component.get('v.processTypeP')
                                                                         },
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       component.find('overlayLib').showCustomModal({
                                           header: "New Related Party",
                                           body: content,
                                           cssClass: "mymodal"
                                       })
                                   }                               
                               });
        }else{
            var message = "You are only allowed to Onboard Individuals as Related Parties";
            var toastEvent = helper.getToast("Error", message, "error");
            toastEvent.fire();
            
        }
    },
    //Selecting onboarding Entity - Manoj-09102020-W005563 
    //Signle New Prospect Design
    selectOnboardingEntity : function(component, event, helper) {
        component.set("v.showEntityTypeSelection",true);	
    },
    closeEntityTypeSelection : function(component, event, helper) {
        component.set("v.showEntityTypeSelection",false);	
    },
    selectEntityType: function(component, event, helper) {
        var clientTypeValue = component.find("clientTypeId").get("v.value");
        var clientGroupValue = component.find("clientGroupId").get("v.value");
        var placeofResValue = component.find("placeOfResidenceId").get("v.value");
        console.log('Selected Entity Type:'+clientTypeValue);
        
        if(clientTypeValue!='' && clientGroupValue!='' && placeofResValue!=''){
            component.set("v.showEntityTypeSelection",false);
            if(clientTypeValue=='Private Individual' || clientTypeValue=='Sole Trader'){ // Sole Proprieter change to Sole Trader
                //Navigate to OnboardingIndividualClientDetails Bigfom
                var indv = component.get('c.navigateToOnbOardingIndvDetails');
                $A.enqueueAction(indv);
            } else{
                //Navigate to OnboardingClientDetails Bigfom
                //this.navigateToOnbOardingIndvDetails(component);
                var nonIndv = component.get('c.navigateToOnbOardingClientDetails');
                $A.enqueueAction(nonIndv);
            }
        } else{
            var toastEvent = helper.getToast("Error", "Please complete all required fields", "error");
            toastEvent.fire();
        }
        
    },
    
    //Open Create New Related Party Modal
    showNewRelatedPartyModal: function(component, evt, helper) {
        
        //Get selected account id
        var selectedAccountRecord = component.get("v.accountSelected");
        var selectedAccountRecordId = component.get("v.accountSelected.Id");
        helper.showSpinner(component);
        var actionHanisService = component.get("c.callHanisService");
        var idNumber = component.find("iSearchValue").get("v.value");
        
        actionHanisService.setParams({
            idNumber: idNumber
        });
        
        actionHanisService.setCallback(this, function(response) {
            var state = response.getState();
            var message = "";
            if (component.isValid() && state === "SUCCESS") {
                var respObjHanisData=response.getReturnValue();
                
                
                var respObjHanis = JSON.parse(response.getReturnValue());
                if (respObjHanis.statusCode == 200) {
                    console.log("HANIS SERVICE SUCCESS ; " + respObjHanis);
                    console.log("HANIS SERVICE Stringify ; " + JSON.stringify(respObjHanis));
                    component.set("v.hanisResponse", respObjHanis);
                    
                    
                    //Populate Hanis details
                    component.set("v.newIndivProspect.LastName", respObjHanis.surname);
                    
                    component.set("v.newIndivProspect.ID_Number__pc", respObjHanis.idNumber);
                    
                    component.set("v.newIndivProspect.FirstName", respObjHanis.name);
                    
                    
                    //Call CPB Service
                    helper.showSpinner(component);
                    var actionCPBservice = component.get("c.callCPBService");
                    var idNumber = component.find("iSearchValue").get("v.value");
                    var hanisResponseValues = component.get("v.hanisResponse");
                    console.log("HANIS surname: " + hanisResponseValues.surname);
                    if (
                        hanisResponseValues.surname != null &&
                        hanisResponseValues.surname != "" &&
                        hanisResponseValues.surname != "undefined" &&
                        hanisResponseValues.surname != undefined
                    ) {
                        actionCPBservice.setParams({
                            idNumber: idNumber,
                            lastName: hanisResponseValues.surname
                        });
                        
                        actionCPBservice.setCallback(this, function(response) {
                            var state = response.getState();
                            var message = "";
                            if (component.isValid() && state === "SUCCESS") {
                                helper.showSpinner(component);
                                var respObjCPBData = response.getReturnValue();
                                if(respObjCPBData!="undefined" && respObjCPBData!=undefined && respObjCPBData!=null)
                                {
                                    var respObjCPB = JSON.parse(response.getReturnValue());
                                    if (respObjCPB.statusCode == 200) {
                                        
                                        console.log("CPB SERVICE SUCCESS : " + respObjCPB);                    
                                        
                                        //TdB - Display error if CPB returns Null
                                        if(respObjCPB.Person == null) {
                                            var toastEvent = helper.getToast(
                                                "CPB Service Error!",
                                                "We cannot complete the request now, please try again if error persist contact administrator.",
                                                "warning"
                                            );
                                            toastEvent.fire();
                                            
                                            //Show create related parties so that User can manully capture the data
                                            component.set("v.isCreateRelatedParty", true);
                                            
                                            helper.hideSpinner(component);
                                        }
                                        else if (
                                            respObjCPB.Person.PersonInformation == undefined ||
                                            respObjCPB.Person.PersonInformation == null ||
                                            respObjCPB.Person.PersonInformation == ""
                                        ) {
                                            console.log("CPB SERVICE ERROR OCCURRED");
                                            var message = "Client not found by CPB service.";
                                            var toastEvent = helper.getToast(
                                                "CPB Service Warning!",
                                                message,
                                                "warning"
                                            );
                                            toastEvent.fire();
                                            component.set("v.isCreateRelatedParty", true);
                                            helper.hideSpinner(component);
                                        } else {
                                            helper.showSpinner(component);
                                            //component.set('v.newIndivProspect.LastName',respObjHanis.surname);
                                            //component.set('v.newIndivProspect.ID_Number__pc',respObjHanis.idNumber);
                                            //component.set('v.newIndivProspect.FirstName',respObjHanis.name);
                                            component.set("v.newIndivProspect.PersonTitle", respObjCPB.Person.PersonInformation.Title);
                                            
                                            component.set( "v.newIndivProspect.Initials__pc",respObjCPB.Person.PersonInformation.Initials);
                                            component.set("v.newIndivProspect.Gender__pc",respObjCPB.Person.PersonInformation.Gender);
                                            
                                            component.set("v.newIndivProspect.PersonMobilePhone",respObjCPB.Person.ContactInformation.MobileNumber);
                                            
                                            component.set("v.newIndivProspect.PersonHomePhone",respObjCPB.Person.ContactInformation.HomeTelephoneNumber);
                                            
                                            component.set("v.newIndivProspect.Phone",respObjCPB.Person.ContactInformation.WorkTelephoneNumber);
                                            
                                            component.set( "v.newIndivProspect.PersonEmail", respObjCPB.Person.ContactInformation.EmailAddress);
                                            
                                            component.set( "v.newIndivProspect.BillingStreet", respObjCPB.Person.AddressInformation.ResidentialAddress.Line1);
                                            
                                            component.set( "v.newIndivProspect.BillingCity",respObjCPB.Person.AddressInformation.ResidentialAddress.Line3);
                                            
                                            component.set( "v.newIndivProspect.BillingPostalCode",respObjCPB.Person.AddressInformation.ResidentialAddress.PostalCode);
                                            
                                            component.set( "v.newIndivProspect.BillingState", respObjCPB.Person.AddressInformation.ResidentialAddress.Line4);
                                            
                                            component.set("v.newIndivProspect.BillingCountry",respObjCPB.Person.AddressInformation.ResidentialAddress.Line2);
                                            
                                            
                                            
                                            //Salesforce date format is YYYY-MM-DD
                                            if (
                                                respObjCPB.Person.PersonInformation.DateOfBirth != null &&
                                                respObjCPB.Person.PersonInformation.DateOfBirth != "" &&
                                                respObjCPB.Person.PersonInformation.DateOfBirth != "undefined"
                                            ) {
                                                var dob = respObjCPB.Person.PersonInformation.DateOfBirth.substring(6,10 ) + "-" +respObjCPB.Person.PersonInformation.DateOfBirth.substring(3,5) + "-" +respObjCPB.Person.PersonInformation.DateOfBirth.substring( 0,2);
                                                component.set("v.newIndivProspect.PersonBirthdate", dob);
                                            }
                                            component.set("v.isCreateRelatedParty", true);
                                            helper.hideSpinner(component);
                                        }
                                    }
                                    else if (respObjCPB.statusCode == 404) {
                                        console.log("CPB SERVICE ERROR OCCURRED");
                                        var message = respObjCPB.message;
                                        var toastEvent = helper.getToast(
                                            "CPB Service Error!",
                                            message,
                                            "error"
                                        );
                                        toastEvent.fire();
                                    } 
                                        else {
                                            console.log("CPB SERVICE ERROR OCCURRED");
                                            var message =
                                                "We cannot complete the request now, please try again if error persist contact administrator.";
                                            var toastEvent = helper.getToast(
                                                "CPB Service Error!",
                                                message,
                                                "error"
                                            );
                                            toastEvent.fire();
                                        }
                                }
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                if (errors) {
                                    for (var i = 0; i < errors.length; i++) {
                                        for (
                                            var j = 0;
                                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                                            j++
                                        ) {
                                            message +=
                                                (message.length > 0 ? "\n" : "") +
                                                errors[i].pageErrors[j].message;
                                        }
                                        if (errors[i].fieldErrors) {
                                            for (var fieldError in errors[i].fieldErrors) {
                                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                                for (var j = 0; j < thisFieldError.length; j++) {
                                                    message +=
                                                        (message.length > 0 ? "\n" : "") +
                                                        thisFieldError[j].message;
                                                }
                                            }
                                        }
                                        if (errors[i].message) {
                                            message +=
                                                (message.length > 0 ? "\n" : "") + errors[i].message;
                                        }
                                    }
                                } else {
                                    message += (message.length > 0 ? "\n" : "") + "Unknown error";
                                }
                                
                                var toast = helper.getToast("Error", message, "error");
                                toast.fire();
                                helper.hideSpinner(component);
                            } else {
                                var errors = response.getError();
                                var toast = helper.getToast("Error", message, "error");
                                toast.fire();
                                helper.hideSpinner(component);
                            }
                        });
                        $A.enqueueAction(actionCPBservice);
                    } else {
                        component.set("v.isCreateRelatedParty", true);
                        helper.hideSpinner(component);
                    }
                } 
                else if (respObjHanis.statusCode == 404) {
                    console.log("HANIS SERVICE ERROR OCCURRED");
                    var message = respObjHanis.message;
                    var toastEvent = helper.getToast(
                        "Hanis Service Error!",
                        message,
                        "error"
                    );
                    toastEvent.fire();
                    component.set("v.isCreateRelatedParty", true);
                    helper.hideSpinner(component);
                }
                    else {
                        console.log("HANIS SERVICE ERROR OCCURRED");
                        var message = "Client not found by Hanis service.";
                        var toastEvent = helper.getToast(
                            "Hanis Service Error!",
                            message,
                            "warning"
                        );
                        toastEvent.fire();
                        component.set("v.isCreateRelatedParty", true);
                        helper.hideSpinner(component);
                    }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
                                }
                            }
                        }
                        if (errors[i].message) {
                            message += (message.length > 0 ? "\n" : "") + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? "\n" : "") + "Unknown error";
                }
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            } else {
                var errors = response.getError();
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
                helper.hideSpinner(component);
            }
        });
        $A.enqueueAction(actionHanisService);
    },
    
    //New function for Add related Party
    handleAddUpdateRealtedparty: function(component, evt, helper) {
        var selectedAccountRecord = component.get("v.accountSelected");
        var selectedAccountRecordId = component.get("v.accountSelected.Id");
        
        console.log('selectedAccountRecord'+selectedAccountRecord);
        console.log('selectedAccountRecordId'+selectedAccountRecordId);
        var selectedClientType = selectedAccountRecord.Client_Type__c;
        console.log('parentClientType'+component.get("v.accountParentRecord.Client_Type__c"));
        console.log('selectedClientType'+selectedClientType);
        
        if(selectedClientType=='Individual' || selectedClientType=='Sole Proprietor' || selectedClientType=='Sole Trader' || selectedClientType ==''  || selectedClientType == undefined){
            
            component.set("v.isUpdateRelatedParty", true);
            component.set("v.editedAccountId",selectedAccountRecordId);
            helper.fetchAccDetails(component,selectedAccountRecordId);
            var objCompB = component.find('addressComp');
            if(objCompB != undefined){ 
                objCompB.getAccountId(selectedAccountRecordId);
                
            }
            
            //Added by chandra dated 02/08/2020
            var selectedRole = component.get("v.selectedRole");
            if(selectedRole.includes("Shareholder/Controller") || selectedRole.includes("Members/Controllers") || selectedRole.includes("Named Beneficiaries") || selectedRole.includes("Trustees") ){
                component.find("editSharePercent").set("v.disabled", false);
            }
            
        }   
        //Diksha Wasekar: Added for non-individual related parties commented to switch off Complex   
        else if(selectedClientType=='Trusts' || selectedClientType=='Private Company' || selectedClientType=='Close Corporation' ){
            //Diksha's Component
            var parentId=component.get("v.parentId");
            console.log('parentId'+parentId);
            
            $A.createComponent("c:onboardingNonIndividualRelatedParties",{parentId: parentId,clienttype:selectedClientType,
                                                                          primaryEntityId:component.get("v.primaryEntityId"),
                                                                          clientgroup:'Non Individual',
                                                                          selectedAccountRecordId:selectedAccountRecordId,
                                                                          parentRelationshipId : component.get("v.parentRelationshipId"),
                                                                          processType : component.get("v.processTypeP")
                                                                          // placeofresidence:event.getParam("selectedplaceOfResidence"),
                                                                          // searchvalue:searchValue                                     // event.getParam("selectedsearchvalue")
                                                                         },
                               function(content, status) {
                                   if (status === "SUCCESS") {
                                       component.find('overlayLib').showCustomModal({
                                           header: "Add Related Party",
                                           body: content,
                                           cssClass: "mymodal"
                                       })
                                   }                               
                               });
            
        }else{
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Selected ClientType is not correct for Adding Existing Related Party.",
                "type":"error"
            });
            
            toastEvent.fire(); 
        } 
        
    },
    
    //Added by chandra dated 02/08/2020
    handleUpdateRelatedPartyLoad : function(component, event, helper) {
        console.log('Inside handleUpdateRelatedPartyLoad');
        component.find("editSharePercent").set("v.value",'');
    },
    
    closeEditRelatedPartyModal: function(component, event, helper) {
        component.set("v.isUpdateRelatedParty", false);
    },
    updateRelatedParty: function(component, event, helper) {
        var editedAccount = component.get("v.editedAccount");
        var roles = component.get("v.selectedRole");
        var flag = false;
        console.log('roles '+roles);
        console.log('editedAccount.ID_Number__pc '+editedAccount.ID_Number__pc);
        console.log('editedAccount.ID_Type__pc '+editedAccount.ID_Type__pc);
        console.log('editedAccount.FirstName '+editedAccount.FirstName);
        console.log('editedAccount.LastName '+editedAccount.LastName);
        console.log('editedAccount.PersonTitle '+editedAccount.PersonTitle);
        console.log('editedAccount.PersonBirthdate '+editedAccount.PersonBirthdate);
        console.log('editedAccount.Country_of_Residence__c '+editedAccount.Country_of_Residence__c);
        console.log('editedAccount.Country_of_Citizenship__c '+editedAccount.Country_of_Citizenship__c);
        console.log('editedAccount.Country_of_Birth__pc '+editedAccount.Country_of_Birth__pc);
        console.log('editedAccount.Gender__pc '+editedAccount.Gender__pc);
        console.log('editedAccount.Phone '+editedAccount.Phone);
        console.log('editedAccount.PersonEmail '+editedAccount.PersonEmail);
        editedAccount.Country_of_Citizenship__c = component.get("v.countryOfCitizenShip");
        
        
        if(roles != null && roles != '' && roles != undefined && editedAccount.Occupation_Status__pc != null && editedAccount.Occupation_Status__pc != '' &&
           editedAccount.ID_Number__pc != null && editedAccount.ID_Number__pc != '' && editedAccount.ID_Number__pc != undefined && 
           editedAccount.ID_Type__pc != null && editedAccount.ID_Type__pc != '' && editedAccount.ID_Type__pc != undefined && 
           editedAccount.PersonBirthdate != null && editedAccount.PersonBirthdate != '' && editedAccount.PersonBirthdate != undefined &&
           editedAccount.Country_of_Citizenship__c != null && editedAccount.Country_of_Citizenship__c != '' && editedAccount.Country_of_Citizenship__c != undefined &&
           editedAccount.Country_of_Birth__pc != null && editedAccount.Country_of_Birth__pc != '' && editedAccount.Country_of_Birth__pc != undefined &&
           editedAccount.Gender__pc != null && editedAccount.Gender__pc != '' && editedAccount.Gender__pc != undefined &&
           ((editedAccount.Phone != null && editedAccount.Phone != '' && editedAccount.Phone != undefined) || (editedAccount.PersonEmail != null && editedAccount.PersonEmail != '' && editedAccount.PersonEmail != undefined))){
            flag = true;
        }
        if(!flag){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please fill all required fields.",
                "type":"error"
            });
            toastEvent.fire(); 
            return;
        }
        
         //TdB - Occupation validation
        var occupationStatusValue = editedAccount.Occupation_Status__pc;
        if(occupationStatusValue == 'Full Time Employed' || occupationStatusValue == 'Part Time Employed' || occupationStatusValue == 'Self Employed Professional' || occupationStatusValue == 'Self Employed-Non-Professional' || occupationStatusValue == 'Temporary Employed') {
            if(!editedAccount.Occupation__pc ||
               !editedAccount.Occupation_Category__pc ||
               !editedAccount.Employer_Name__pc ||
               !editedAccount.Employer_Sector__pc ) {
                
                var toast = helper.getToast(
                    "Required fields",
                    "Please complete Occupation Section",
                    "Error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
                
            }
        }
        
        var parentId = component.get("v.parentId");
        var selectedOptionValue = component.get("v.selectedRole");//Added by chandra dated 02/08/2020
        
        //Newly added by Rajesh to validate First and Last Name length to 30
        if(selectedOptionValue.includes("Contact Person")){
            var totalSize = parseInt(editedAccount.FirstName.length) + parseInt(editedAccount.LastName.length);
            //alert(totalSize);
            if(totalSize > 30){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "The name of the contact person must be less than 30 character.",
                    "type":"error"
                });
                
                toastEvent.fire();
                return;
            }
        }
        
        if(selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)")){
            var iCountryDateIssued = component.find("iCountryDateIssuedEdit").get("v.value");
            console.log('iCountryDateIssuedEdit '+iCountryDateIssued);
            if(iCountryDateIssued == null || iCountryDateIssued == '' || iCountryDateIssued == undefined){
                var toast = helper.getToast(
                    "Error!",
                    "Please enter Date issued when Operator is selected.",
                    "error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
        }
        
        //Added by chandra dated 02/08/2020
        if(selectedOptionValue.includes("Shareholder/Controller") && 
           (component.find("editSharePercent").get("v.value") == '' || component.find("editSharePercent").get("v.value")=='0')){
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Error!",
                "message": "Share Percentage is required to fill when role Shareholder/Controller is selected.",
                "type":"error"
            });
            
            toastEvent.fire(); 
        }else if(selectedOptionValue.includes("Members/Controllers") && 
                 (component.find("editSharePercent").get("v.value") == '' || component.find("editSharePercent").get("v.value")=='0')){
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Error!",
                "message": "Share Percentage is required to fill when role  Members/Controllers is selected.",
                "type":"error"
            });
            
            toastEvent.fire(); 
        }else{
            //Added by chandra against W-006169
            var action = component.get("c.validateExitedAccountRealionship");
            action.setParams({
                "account":editedAccount,
                "parentId":component.get("v.parentId"),
                "primaryEntityId":component.get("v.primaryEntityId")
            });
            action.setCallback(this, function(response) {
                if (response.getState() == "SUCCESS") {
                    var returnValue = response.getReturnValue();
                    if(returnValue != null){
                        var toast = helper.getToast(
                            "Error!",
                            "Entity Relation already existed, Please update the existed relationship.",
                            "Error"
                        );
                        
                        helper.hideSpinner(component);
                        toast.fire();
                        return null;
                    }else{
                        
                        helper.updateAccAndCreateAccConRelation(component,editedAccount,parentId);
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    //Close Create New Related Party Modal
    closeNewRelatedPartyModal: function(component, event, helper) {
        component.set("v.isCreateRelatedParty", false);
    },
    
    navigateToClient : function(component, event, helper){
        helper.showSpinner(component);
        
        var clientId = component.get("v.accountId");
        var clientDetails = component.get("v.accountSelected");
        
        if(!clientId) {
            var actionCreateCIFClient = component.get("c.createCIFClientInSF");
            
            actionCreateCIFClient.setParams({
                "newAcc" : clientDetails
            });
            
            // Add callback behavior for when response is received
            actionCreateCIFClient.setCallback(this, function(response) {
                
                var state = response.getState();
                var message = '';
                
                if (component.isValid() && state === "SUCCESS") {
                    
                    var responseValue = response.getReturnValue();
                    
                    if(responseValue.includes('Success')) {
                        component.set("v.accountId",responseValue.substring(8, 26));
                        
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": component.get("v.accountId")
                        });
                        navEvt.fire();
                        
                    } else {
                        var toast = helper.getToast("Error", responseValue, "error");
                        toast.fire();
                    }
                    
                    helper.hideSpinner(component);
                    
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
                    
                    var toast = helper.getToast("Error", message, "error");
                    
                    toast.fire();
                    
                    helper.hideSpinner(component);
                } else {
                    var errors = response.getError();
                    
                    var toast = helper.getToast("Error", message, "error");
                    
                    toast.fire();
                    
                    helper.hideSpinner(component);
                }
            });
            
            // Send action off to be executed
            $A.enqueueAction(actionCreateCIFClient); 
        } else {
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.accountId")
            });
            navEvt.fire();
            
            helper.hideSpinner(component);
        }
        
        
    },
    
    
    
    
    
    
    
    
    
    
    navigateToOnbOardingClientDetails: function(component, evt, helper) {
        var searchValue = component.find("iSearchValue").get("v.value");
        var accId = component.get("v.accountId");
        var processName = component.get("v.ProcessName"); // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
        
        //TdB - Pass Process Type to Onboarding Form
        var selectedJob = component.get("v.jobname");
        
        //Get FocusTabId
        var workspaceAPI = component.find("workspace");
        var clientFinderTabId;
        var onboardingClientDetailsTabId;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            clientFinderTabId = response.tabId;
        });
        
        //Navigate to OnboardingClientDetails Components and set parameters
        var evt = $A.get("e.force:navigateToComponent");
        
        if (!accId) {
            console.log("searchValue : " + searchValue);
            evt.setParams({
                componentDef: "c:OnboardingClientDetails",
                componentAttributes: {
                    registrationNumber: searchValue,
                    ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                    processType: selectedJob.Process_Type__c, //TdB - Process Type New to Bank/Lite Onboarding
                    clientGroup: component.find("clientGroupId").get("v.value"),	//W-005563- Manoj- 0914202 - Single New Prospect button design
                    clientType2: component.find("clientTypeId").get("v.value"),		//W-005563- Manoj- 0914202 - Single New Prospect button design
                    placeOfResidence: component.find("placeOfResidenceId").get("v.value")		//W-005563- Manoj- 0914202 - Single New Prospect button design
                }
            });
        } else {
            console.log("accId : " + accId);
            evt.setParams({
                componentDef: "c:OnboardingClientDetails",
                componentAttributes: {
                    accRecordId: accId,
                    registrationNumber: searchValue, // PJAIN: 202003401
                    ProcessName: processName // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                }
            });
        }
        
        evt.fire();
        
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        
        /*workspaceAPI.getFocusedTabInfo().then(function(response) {
              var focusedTabId = response.tabId;
              workspaceAPI.setTabLabel({
                  tabId: focusedTabId,
                  label: "New-To-Bank Onboarding" 
              });
              
              workspaceAPI.setTabIcon({
                  tabId: focusedTabId,
                  icon: "utility:flow", 
                  iconAlt: "New-To-Bank Onboarding" 
              });
          })*/
        
        //Closing old tab
        workspaceAPI.closeTab({
            tabId: clientFinderTabId
        });
    },
    
    navigateToOnbOardingIndvDetails: function(component, evt, helper) {
        var searchValue = component.find("iSearchValue").get("v.value");
        var accId = component.get("v.accountId");
        var processName = component.get("v.ProcessName"); // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
        var selectedJob = component.get("v.jobname"); 
        
        //Get FocusTabId
        var workspaceAPI = component.find("workspace");
        var clientFinderTabId;
        var onboardingClientDetailsTabId;
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            clientFinderTabId = response.tabId;
        });
        
        //Navigate to OnboardingIndividualClientDetails Components and set parameters
        var evt = $A.get("e.force:navigateToComponent");
        
        if (!accId) {
            console.log("searchValue : " + searchValue);
            evt.setParams({
                componentDef: "c:OnboardingIndividualClientDetails",
                componentAttributes: {
                    IdentityNumber: searchValue,
                    processType: selectedJob.Process_Type__c, //TdB - Process Type New to Bank/Lite Onboarding
                    clientGroupValue: component.find("clientGroupId").get("v.value"),	//W-005563- Manoj- 0914202 - Single New Prospect button design
                    clientTypeValue: component.find("clientTypeId").get("v.value"),		//W-005563- Manoj- 0914202 - Single New Prospect button design
                    ProcessName: processName // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                }
            });
        } else {
            console.log("accId : " + accId);
            evt.setParams({
                componentDef: "c:OnboardingIndividualClientDetails",
                componentAttributes: {
                    accRecordId: accId,
                    IdentityNumber: searchValue, // PJAIN: 202003401
                    ProcessName: processName // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                }
            });
        }
        
        evt.fire();
        
        //Closing old tab
        workspaceAPI.closeTab({
            tabId: clientFinderTabId
        });
    },
    
    //Close Create New Business Prospect Modal Onboarding
    closeNewBusinessProspectModelOnboarding: function(component, event, helper) {
        component.set("v.isCreateBusinessProspectOnboarding", false);
    },
    
    //Function to create new Contact based on values entered in the Contact Modal
    createNewContact: function(component, event, helper) {
        //helper.showSpinner(component);
        var newContactRecord = component.get("v.contactRecord");
        //Calling the Apex Function to create Contact
        var createContactAction = component.get("c.createNewBusinessContact");
        
        //Setting the Apex Parameter
        createContactAction.setParams({
            newContactRecord: newContactRecord
        });
        
        //Setting the Callback
        createContactAction.setCallback(this, function(response) {
            var stateCase = response.getState();
            if (stateCase === "SUCCESS") {
                //Set Contact
                var contactRecord = response.getReturnValue();
                
                // show success notification
                var toastEvent = helper.getToast(
                    "Success!",
                    "Contact successfully created in Salesforce",
                    "Success"
                );
                toastEvent.fire();
                
                helper.getContactData(component);
                
                helper.hideSpinner(component);
                
                var setEvent = $A.get("e.c:setContactInfo");
                
                setEvent.setParams({ contactRecord: contactRecord });
                setEvent.fire();
                
                component.set("v.isCreateContact", false);
            } else if (stateCase === "ERROR") {
                var message = "";
                var errors = response.getError();
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
                                }
                            }
                        }
                        if (errors[i].message) {
                            message += (message.length > 0 ? "\n" : "") + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? "\n" : "") + "Unknown error";
                }
                
                if (message.includes("DUPLICATES_DETECTED")) {
                    message =
                        "Duplicate Contact detected, please use a diffrent Email Address or search for an existing Contact";
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        //adds the server-side action to the queue
        $A.enqueueAction(createContactAction);
    },
    
    //Function to validate entered Contact information, also determine if Client needs to be created first
    validateContact: function(component, event, helper) {
        helper.showSpinner(component);
        
        //** TdB - Validation section **
        //FirstName, LastName required
        /*var contactRecordValidation = component.get("v.contactRecord");
        if(!contactRecordValidation.Salutation || !contactRecordValidation.FirstName || !contactRecordValidation.LastName){
            var toast = helper.getToast("Required fields", "Please complete all required fields indicated with a red asterisk (*)", "Error");
            
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }     
        //Method of Communication required
        if(!contactRecordValidation.Email && !contactRecordValidation.MobilePhone && !contactRecordValidation.Phone){
            var toast = helper.getToast("Required fields", "Please provide contact details (Email,Phone or Mobile)", "Error");
            
            helper.hideSpinner(component);
            toast.fire();
            return null;
        }    */
        
        var accountId = component.get("v.accountSelected.Id");
        var accountRecord = component.get("v.accountSelected");
        
        //Create new client (if not in Salesforce)
        if (!accountId) {
            //Calling the Apex Function to create Contact
            var createClientAction = component.get("c.createNewBusinessClient");
            
            //Setting the Apex Parameter
            createClientAction.setParams({
                newClientRecord: accountRecord
            });
            
            //Setting the Callback
            createClientAction.setCallback(this, function(response) {
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    //Set Contact
                    var newlyCreatedAccount = response.getReturnValue();
                    
                    // show success notification
                    var toastEvent = helper.getToast(
                        "Success!",
                        "Client successfully created in Salesforce",
                        "Success"
                    );
                    toastEvent.fire();
                    
                    helper.hideSpinner(component);
                    
                    component.set("v.accountSelected", newlyCreatedAccount);
                    var newAccountId = component.get("v.accountSelected.Id");
                    component.set("v.contactRecord.AccountId", newAccountId);
                    component.set("v.accountId", newAccountId);
                    
                    if (!newAccountId) {
                        component.set("v.isAccountInSalesforce", false);
                    } else {
                        component.set("v.isAccountInSalesforce", true);
                    }
                    
                    var setEvent = $A.get("e.c:setClientInfo");
                    var indivClientIdentifier = true;
                    var clientSelected = component.get("v.accountSelected");
                    if (
                        component.get("v.accountSelected.Client_Type__c") ==
                        "NON-INDIVIDUAL" ||
                        component.get("v.accountSelected.Client_Type__c") ==
                        "JOINT & SEVERAL" ||
                        component.get("v.accountSelected.Client_Type__c") == "Business"
                    ) {
                        indivClientIdentifier = false;
                    } else {
                        clientSelected.Name = null;
                    }
                    setEvent.setParams({ accountValue: clientSelected });
                    setEvent.setParams({ isIndivClient: indivClientIdentifier });
                    setEvent.fire();
                    
                    //Enqueue action to create contact
                    var a = component.get("c.createNewContact");
                    $A.enqueueAction(a);
                } else if (state === "ERROR") {
                    var message = "";
                    var errors = response.getError();
                    if (errors) {
                        for (var i = 0; i < errors.length; i++) {
                            for (
                                var j = 0;
                                errors[i].pageErrors && j < errors[i].pageErrors.length;
                                j++
                            ) {
                                message +=
                                    (message.length > 0 ? "\n" : "") +
                                    errors[i].pageErrors[j].message;
                            }
                            if (errors[i].fieldErrors) {
                                for (var fieldError in errors[i].fieldErrors) {
                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                    for (var j = 0; j < thisFieldError.length; j++) {
                                        message +=
                                            (message.length > 0 ? "\n" : "") +
                                            thisFieldError[j].message;
                                    }
                                }
                            }
                            if (errors[i].message) {
                                message += (message.length > 0 ? "\n" : "") + errors[i].message;
                            }
                        }
                    } else {
                        message += (message.length > 0 ? "\n" : "") + "Unknown error";
                    }
                    
                    if (message.includes("DUPLICATES_DETECTED")) {
                        message =
                            "Duplicate Client detected, please use a diffrent CIF number or search for an existing Client";
                    }
                    
                    // show Error message
                    var toastEvent = helper.getToast("Error!", message, "Error");
                    toastEvent.fire();
                    
                    helper.hideSpinner(component);
                }
            });
            
            //adds the server-side action to the queue
            $A.enqueueAction(createClientAction);
        } else {
            component.set("v.contactRecord.AccountId", accountId);
            //Enqueue action to create case
            var a = component.get("c.createNewContact");
            $A.enqueueAction(a);
        }
    },
    
    //Validate search limit and display create new Prospect buttons
    validateSearchLimit: function(component, event, helper) {
        //Set search counter to 0
        var tempCount = 0;
        component.set("v.currentCount", tempCount);
        var action = component.get("c.loadSearchOptions");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var qeueuMap = response.getReturnValue();
                component.set("v.searchTypeList", qeueuMap);
                component.set("v.salesforceSearchLabel", qeueuMap[0]);
                component.set("v.searchTypeSelected", qeueuMap[0]);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
        
        //SearchLimit set
        var action = component.get("c.getSearchLimit");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                var qeueuMap = response.getReturnValue();
                component.set("v.clientSearchLimit", qeueuMap);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Function to create new Individual/Business Prospect
    createClient: function(component, event, helper) {
        helper.showSpinner(component);
        
        //getting the candidate information
        var accountRecord;
        var isIndvProspect = component.get("v.isCreateIndividualProspect");
        var isbusniessprspct = component.get("v.isCreateBusinessProspect");
        var isbusniessprspctboardng = component.get(
            "v.isCreateBusinessProspectOnboarding"
        );
        //khaliq added
    var isBranchIndvProspect = component.get(
        "v.isCreateBranchIndividualProspect"
    );
        
        //** TdB - Validation section **
        //Individual Prospect
        if (isIndvProspect == true) {
            accountRecord = component.get("v.newIndivProspect");
            
            if (
                !accountRecord.FirstName ||
                !accountRecord.LastName 
                // !accountRecord.Client_Creation_Reason__c
            ) {
                var toast = helper.getToast(
                    "Required fields",
                    "Please complete all required fields indicated with a red asterisk (*)",
                    "Error"
                );

        helper.hideSpinner(component);
        toast.fire();
        return null;
        }
    } //khaliq added
        else if (isBranchIndvProspect == true) {
        accountRecord = component.get("v.newIndivProspect");
        isIndvProspect = isBranchIndvProspect;         
        var mobPattern = '[0]{1}[678]{1}[0-9]{8}';
            
        if (
        !accountRecord.FirstName ||
        !accountRecord.LastName 
        
        ) {
        var toast = helper.getToast(
            "Required fields",
            "Please complete all required fields indicated with a red asterisk (*)",
            "Error"
        );

        helper.hideSpinner(component);
        toast.fire();
        return null;
        }
        if(!accountRecord.PersonMobilePhone || accountRecord.PersonMobilePhone.length != 10 || !accountRecord.PersonMobilePhone.match(mobPattern)) {            
            var toast = helper.getToast(
                "Mobile number validation",
                "Invalid Cell phone Number",
                "Error"
            );
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        } else if (isbusniessprspct == true) {
            accountRecord = component.get("v.newBusinessProspect");
            
            if (!accountRecord.Name) {
                var toast = helper.getToast(
                    "Required fields",
                    "Please complete all required fields indicated with a red asterisk (*)",
                    "Error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        } else {
            accountRecord = component.get("v.newBusinessProspectOnboarding");
            var contactRecord = component.get("v.contactRecord");
            
            /*if(!accountRecord.Name || !accountRecord.Registration_Number__c || !accountRecord.Phone || !contactRecord.FirstName || !contactRecord.LastName ){
                var toast = helper.getToast("Required fields", "Please complete all required fields indicated with a red asterisk11 (*)", "Error");*/
            
            if (!accountRecord.Registration_Number__c) {
                var toast = helper.getToast(
                    "Required fields",
                    "Please complete all required fields indicated with a red asterisk (*)",
                    "Error"
                );
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            
            /*if(accountRecord.Client_Type__c != 'Private Company' || !accountRecord.Client_Type__c){
                var toast = helper.getToast("Please select Client Type as Private Company", "Error");
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }*/
        }
        
        //Calling the Apex Function
        var action = component.get("c.createNewClient");
        
        //Setting the Apex Parameter
        action.setParams({
            newAccountRecord: accountRecord,
            isIndividualProspect: isIndvProspect,
            isBusinessProspect: isbusniessprspct
        });
        
        //Setting the Callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Set Account Id
                var accountRecordId = response.getReturnValue();
                component.set("v.isNewClientCreated", true);
                var buttonName = event.getSource().get("v.name");
                
                if (buttonName == "CreateBusinessProspect") {
                    component.set("v.maxRowSelection", 1);
                    component.set("v.Onboardingselection", buttonName);
                    //component.set("v.isBusinessAccountOnboarding",false);
                } else {
                    component.set("v.maxRowSelection", 0);
                }
                //Close Modal
                component.set("v.isCreateIndividualProspect", false);
                component.set("v.isCreateBusinessProspect", false);
                component.set("v.isCreateBusinessProspectOnboarding", false);
                component.set("v.isCreateBranchIndividualProspect", false);
                // show success notification
                var toastEvent = helper.getToast(
                    "Success!",
                    "Prospect successfully created in Salesforce",
                    "Success"
                );
                toastEvent.fire();
                
                helper.hideSpinner(component);
                
                var changeElement = component.find("newClientCardId");
                $A.util.toggleClass(changeElement, "slds-hide");
                
                helper.showSpinner(component);
                
                var actionSearchClient = component.get("c.searchClientLogic");
                
                var selectedSearchType = component.get("v.searchTypeSelected");
                
                actionSearchClient.setParams({
                    newAccountId: accountRecordId
                });
                
                actionSearchClient.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (component.isValid() && state === "SUCCESS") {
                        //Set Account Id
                        component.set("v.relatedAccountId", accountRecordId);
                        var accountList = response.getReturnValue();
                        component.set("v.accountsReturned", accountList);
                        //component.set("v.allData", accountList);
                        
                        component.set("v.accountSelected", accountList[0]);
                        component.set("v.accountSelected.id", accountRecordId);
                        
                        //Enqueue action to create case
                        if (buttonName != "CreateBusinessProspect") {
                            var a = component.get("c.setClientSelected");
                            $A.enqueueAction(a);
                        }
                        helper.hideSpinner(component);
                    }
                });
                
                // Send action off to be executed
                $A.enqueueAction(actionSearchClient);
                if (buttonName == "CreateBusinessProspect") {
                    component.set("v.contactRecord.AccountId", accountRecordId);
                    var acccontact = component.get("c.createNewContact");
                    $A.enqueueAction(acccontact);
                }
                //Show Search Table
                var changeElement = component.find("ClientResultTable");
                $A.util.removeClass(component.find("ClientResultTable"), "slds-hide");
                
                //$A.util.addClass(component.find("ClientOnBoardingbutton"), "slds-hide");
                //$A.util.addClass(component.find("CreateNewCase"), "slds-hide");
            } else if (state === "ERROR") {
                var message = "";
                var errors = response.getError();
                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
                                }
                            }
                        }
                        if (errors[i].message) {
                            message += (message.length > 0 ? "\n" : "") + errors[i].message;
                        }
                    }
                } else {
                    message += (message.length > 0 ? "\n" : "") + "Unknown error";
                }
                
                if (message.includes("DUPLICATES_DETECTED")) {
                    message =
                        "Duplicate Client detected, please use a diffrent Email Address or search for an existing Client";
                }
                
                // show Error message
                var toastEvent = helper.getToast("Error!", message, "Error");
                toastEvent.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        //adds the server-side action to the queue
        $A.enqueueAction(action);
    },
    
    //Function to create new Related Party (Individual Prospect)
    createRelatedParty: function(component, event, helper) {
        helper.showSpinner(component);
        //getting the candidate information
        var accountRecord;
        var isRelatedParty = component.get("v.isCreateRelatedParty");
        var shareholderPercentage;
        var processTypeLite = component.get('v.processTypeP');
        if(processTypeLite!='Lite Onboarding'){
            var designation = component.find("selectedDesignationId").get("v.value");
        }
        if (
            component.find("iSharePercentage").get("v.value") != "" &&
            component.find("iSharePercentage").get("v.value") != null
        ) {
            shareholderPercentage = component.find("iSharePercentage").get("v.value");
        } else {
            shareholderPercentage = "0.00";
        }
        var flag = false;
        var personAccRecord = component.get("v.newIndivProspect");
        var title = component.find("iClientPersonTitle").get("v.value");
        var Lastname = component.find("iClientLastName").get("v.value");
        console.log('Lastname '+Lastname);
        console.log('personAccRecord.PersonTitle '+personAccRecord.PersonTitle);
        console.log('personAccRecord.PersonBirthdate '+personAccRecord.PersonBirthdate);
        console.log('personAccRecord.LastName '+personAccRecord.LastName);
        console.log('personAccRecord.Country_of_Citizenship__c '+personAccRecord.Country_of_Citizenship__c);
        console.log('personAccRecord.Country_of_Birth__pc '+personAccRecord.Country_of_Birth__pc);
        console.log('personAccRecord.Gender__pc '+personAccRecord.Gender__pc);
        console.log('personAccRecord.BillingState'+personAccRecord.BillingState);
        console.log('personAccRecord.BillingCountry'+personAccRecord.BillingCountry);
        console.log('personAccRecord.Phone'+personAccRecord.Phone);
        console.log('personAccRecord.PersonEmail'+personAccRecord.PersonEmail);
        
        
        if(processTypeLite!='Lite Onboarding'){
            if(personAccRecord.Occupation_Status__pc != null && personAccRecord.Occupation_Status__pc != '' &&
               personAccRecord.PersonBirthdate != null && personAccRecord.PersonBirthdate != '' && personAccRecord.PersonBirthdate != undefined &&
               personAccRecord.Country_of_Citizenship__c != null && personAccRecord.Country_of_Citizenship__c != '' && personAccRecord.Country_of_Citizenship__c != undefined &&
               personAccRecord.BillingCity != null && personAccRecord.BillingCity != '' &&
               personAccRecord.Country_of_Birth__pc != null && personAccRecord.Country_of_Birth__pc != '' && personAccRecord.Country_of_Birth__pc != undefined &&
               personAccRecord.Gender__pc != null && personAccRecord.Gender__pc != '' && personAccRecord.Gender__pc != undefined &&((personAccRecord.Phone != null && personAccRecord.Phone != '' && personAccRecord.Phone != undefined) ||
                                                                                                                                    (personAccRecord.PersonEmail != null && personAccRecord.PersonEmail != '' && personAccRecord.PersonEmail != undefined))){
                flag = true;
            }
        }
        
        if(processTypeLite=='Lite Onboarding'){
            if(personAccRecord.Country_of_Citizenship__c != null && personAccRecord.Country_of_Citizenship__c != '' && personAccRecord.Country_of_Citizenship__c != undefined &&
               personAccRecord.Country_of_Birth__pc != null && personAccRecord.Country_of_Birth__pc != '' && personAccRecord.Country_of_Birth__pc != undefined
              ){
                flag = true;
            }
        }
        
        if(!flag){
            var toast = helper.getToast(
                "Required fields",
                "Please select all applicable Roles and complete all required fields indicated with a red asterisk (*)",
                "Error"
            );
            
            helper.hideSpinner(component);
            toast.fire();
            return;
        }
        
        
        if(processTypeLite!='Lite Onboarding'){
            //Newly added by Rajesh to validate First and Last Name length to 30
            var selectedOptionValue = component.get("v.selectedRole");
            if(selectedOptionValue.includes("Contact Person")){
                var totalSize = parseInt(personAccRecord.FirstName.length) + parseInt(personAccRecord.LastName.length);
                //alert(totalSize);
                if(totalSize > 30){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "The name of the contact person must be less than 30 character.",
                        "type":"error"
                    });
                    
                    toastEvent.fire();
                    return;
                }
            }
        }
        
        
        if (isRelatedParty == true) {
            accountRecord = component.get("v.newIndivProspect");
            
            if (
                !accountRecord.ID_Type__pc ||
                component.get("v.selectedRole") == ""
            ) {
                var toast = helper.getToast(
                    "Required fields",
                    "Please select all applicable Roles and complete all required fields indicated with a red asterisk (*)",
                    "Error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
            if(component.get('v.processTypeP')!='Lite Onboarding'){
                
                //TdB - Occupation validation
                var occupationStatusValue = accountRecord.Occupation_Status__pc;
                if(occupationStatusValue == 'Full Time Employed' || occupationStatusValue == 'Part Time Employed' || occupationStatusValue == 'Self Employed Professional' || occupationStatusValue == 'Self Employed-Non-Professional' || occupationStatusValue == 'Temporary Employed') {
                    if(!accountRecord.Occupation__pc ||
                       !accountRecord.Occupation_Category__pc ||
                       !accountRecord.Employer_Name__pc ||
                       !accountRecord.Employer_Sector__pc ) {
                        
                        var toast = helper.getToast(
                            "Required fields",
                            "Please complete Occupation Section",
                            "Error"
                        );
                        
                        helper.hideSpinner(component);
                        toast.fire();
                        return null;
                        
                    }
                }
            }
        }
        
        //Added by chandra to validate share Percentage is not blank when "Shareholder/Controller" role is selected
        if (isRelatedParty == true) {
            var selectedOptionValue = component.get("v.selectedRole");
            if((selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers"))&& 
                (component.find("iSharePercentage").get("v.value") == '' || component.find("iSharePercentage").get("v.value")=='0')){
                var toast = helper.getToast(
                    "Error!",
                    "Share Percentage is required to fill when role Shareholder/Controller is selected.",
                    "error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }
        if(selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)")){
            var iCountryDateIssued = component.find("iCountryDateIssued").get("v.value");
            console.log('iCountryDateIssued '+iCountryDateIssued);
            if(iCountryDateIssued == null || iCountryDateIssued == '' || iCountryDateIssued == undefined){
                var toast = helper.getToast(
                    "Error!",
                    "Please enter Date issued when Operator is selected.",
                    "error"
                );
                
                helper.hideSpinner(component);
                toast.fire();
                return;
            }
        }
        
        //Added by chandra against W-006169
        var action = component.get("c.validateExitedAccount");
        action.setParams({
            "idNumber":accountRecord.ID_Number__pc,
            "idType":accountRecord.ID_Type__pc
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var returnValue = response.getReturnValue();
                if(returnValue != null){
                    component.set("v.isEntityAlreadyExisted", true);
                    var toast = helper.getToast(
                        "Error!",
                        "Entity already exists in Salesforce. Please use the Add Related Party button for an already existing entity.",
                        "Error"
                    );
                    
                    helper.hideSpinner(component);
                    toast.fire();
                    return null;
                }
                else{
                    
                    //Calling the Apex Function
                    var action = component.get("c.createNewClient");
                    
                    //Setting the Apex Parameter
                    action.setParams({
                        newAccountRecord: accountRecord,
                        isRelatedParty: isRelatedParty
                    });
                    //Setting the Callback
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            //Set Account Id
                            var accountRecordId = response.getReturnValue();
                            component.set("v.isNewClientCreated", true);
                            var buttonName = event.getSource().get("v.name");
                            component.set("v.maxRowSelection", 0);
                            //    var clienttype =component.get("v.accountParentRecord").Client_Type__c;
                            if (isRelatedParty) { 
                                helper.createAccountContactRelationship(
                                    component,
                                    accountRecordId,
                                    component.get("v.parentId"),
                                    component.get("v.selectedRole"),
                                    shareholderPercentage,
                                    designation
                                );
                            }
                            
                            //Close Modal
                            component.set("v.isCreateRelatedParty", false);
                            
                            // show success notification
                            if (isRelatedParty) {
                                toastEvent = helper.getToast(
                                    "Success!",
                                    "Related Party successfully created in Salesforce",
                                    "Success"
                                );
                            }
                            
                            toastEvent.fire();
                            helper.hideSpinner(component);
                            var changeElement = component.find("newClientCardId");
                            $A.util.toggleClass(changeElement, "slds-hide");
                            helper.showSpinner(component);
                            var actionSearchClient = component.get("c.searchClientLogic");
                            var selectedSearchType = component.get("v.searchTypeSelected");
                            actionSearchClient.setParams({
                                newAccountId: accountRecordId
                            });
                            
                            actionSearchClient.setCallback(this, function(response) {
                                var state = response.getState();
                                
                                if (component.isValid() && state === "SUCCESS") {
                                    //Set Account Id
                                    component.set("v.relatedAccountId", accountRecordId);
                                    var accountList = response.getReturnValue();
                                    component.set("v.accountsReturned", accountList);
                                    //component.set("v.allData", accountList);
                                    
                                    component.set("v.accountSelected", accountList[0]);
                                    component.set("v.accountSelected.id", accountRecordId);
                                    
                                    //Enqueue action to create case
                                    if (buttonName != "CreateBusinessProspect") {
                                        var a = component.get("c.setClientSelected");
                                        $A.enqueueAction(a);
                                    }
                                    helper.hideSpinner(component);
                                }
                            });
                            
                            // Send action off to be executed
                            $A.enqueueAction(actionSearchClient);
                            //Show Search Table
                            var changeElement = component.find("ClientResultTable");
                            $A.util.removeClass(component.find("ClientResultTable"), "slds-hide");
                        } else if (state === "ERROR") {
                            var message = "";
                            var errors = response.getError();
                            if (errors) {
                                for (var i = 0; i < errors.length; i++) {
                                    for (
                                        var j = 0;
                                        errors[i].pageErrors && j < errors[i].pageErrors.length;
                                        j++
                                    ) {
                                        message +=
                                            (message.length > 0 ? "\n" : "") +
                                            errors[i].pageErrors[j].message;
                                    }
                                    if (errors[i].fieldErrors) {
                                        for (var fieldError in errors[i].fieldErrors) {
                                            var thisFieldError = errors[i].fieldErrors[fieldError];
                                            for (var j = 0; j < thisFieldError.length; j++) {
                                                message +=
                                                    (message.length > 0 ? "\n" : "") +
                                                    thisFieldError[j].message;
                                            }
                                        }
                                    }
                                    if (errors[i].message) {
                                        message += (message.length > 0 ? "\n" : "") + errors[i].message;
                                    }
                                }
                            } else {
                                message += (message.length > 0 ? "\n" : "") + "Unknown error";
                            }
                            if (message.includes("DUPLICATES_DETECTED")) {
                                message =
                                    "Duplicate Client detected, please use a diffrent Email Address or search for an existing Client";
                            }
                            // show Error message
                            var toastEvent = helper.getToast("Error!", message, "Error");
                            toastEvent.fire();
                            helper.hideSpinner(component);
                        }
                    });
                    
                    //adds the server-side action to the queue
                    $A.enqueueAction(action);}}
        });
        $A.enqueueAction(action);
    },
    
    //Logic to search for Client in CIF and SF based on search type and search value entered
    searchClient: function(component, event, helper) {
        helper.showSpinner(component);
        
        //Hide Client Search Table Results
        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
        
        var toastEvent;
        var selectedSearchType = component.get("v.searchTypeSelected");
        var selectedSearchValue = component.find("iSearchValue").get("v.value");
        component.set("v.searchTypeValue", selectedSearchValue);
        
        component.set("v.maxRowSelection", 1);
        
        //Clear prev selected values
        component.set("v.isNewClientCreated", false);
        component.set("v.isRelatedContent", false);
        component.set("v.participantSelected", "");
        component.set("v.productSelected", "");
        component.set("v.accountSelected", "");
        component.set("v.accountsReturned", "");
        component.set("v.isBusinessAccount", false);
        component.set("v.isBusinessAccountOnboarding", false);
        component.set("v.isNewCaseCreation", false);
        component.set("v.isNewCreditOpportunity", false);
        component.set("v.isNewProductOpportunity", false);
        component.set("v.isNewCPFOpportunity", false);
        component.set("v.isParticipantDetail", false);
        component.set("v.isCIFSearch", false);
        component.set("v.isPersonAccount", false);
        component.set("v.isIndividualAccountOnboarding", false);
        component.set("v.isBusinessAccountOnboarding", false);
        component.set("v.showSearchByNameCIFSection", false);
        component.set("v.searchByNameResultOption", '');
        component.set("v.searchByNameOptionSelected", '');
        component.set("v.showNewProductOnboarding", false); 
        //Clear Client and Product Beans
        component.set("v.clientDetailsBean", null);
        component.set("v.MDMclientDetailsBean", null);
        component.set("v.clientParticipantsBean", null);
        
        //###Increment methods
        var actionIncrementCount = component.get("c.incrementCount");
        //var actionValidateId = component.get("c.validateId");
        var counterTemp = component.get("v.currentCount");
        var counterIncrement = counterTemp + 1;
        var counterLimit = component.get("v.clientSearchLimit");
		
        /*
        //AndrÃ© Added method W-006950
        actionValidateId.setParams({
            idNumber: selectedSearchValue
        });

        actionValidateId.setCallback(this, function(response) {
            var isIdValid = response.getReturnValue();
            if (!isIdValid) {
                toastEvent = helper.getToast(
                "Failed!",
                "Please provide a valid South African ID.",
                "error"
                );
                helper.hideSpinner(component);
                toastEvent.fire();
                return;
            }
        });        

        if (selectedSearchType == 'ID Number') {
            $A.enqueueAction(actionValidateId);
        }
		*/        
        actionIncrementCount.setParams({
            counter: counterIncrement
        });
        
        actionIncrementCount.setCallback(this, function(response) {
            var stateIncrementCount = response.getState();
            
            if (component.isValid() && stateIncrementCount === "SUCCESS") {
                //Get and set the isLimit attribute
                var splitcount = response.getReturnValue();
                if (counterIncrement >= counterLimit) {
                    //Enable create Prospects button
                    component.set("v.isPersonAccount", true);
                    component.set("v.isBusinessAccount", true);
                    component.set("v.isBusinessAccountOnboarding", true);
                    //component.set("v.isNewCaseCreation", true);
                    component.set("v.isLimitReached", false);
                }
                
                component.set("v.currentCount", splitcount);
                component.set("v.isPersonAccount", false);
                component.set("v.isBusinessAccount", false);
                component.set("v.isBusinessAccountOnboarding", false);
                //component.set("v.isNewCaseCreation", false);
            }
        });
        
        $A.enqueueAction(actionIncrementCount);
        
        //Clear prev selected account before searching
        var setAccountEvent = $A.get("e.c:setClientInfo");
        setAccountEvent.setParams({ accountValue: "" });
        setAccountEvent.setParams({ isIndivClient: false });
        setAccountEvent.fire();
        
        //Clear prev selected product before searching
        var setProductEvent = $A.get("e.c:setProductInfo");
        setProductEvent.setParams({ accountNumber: "" });
        setProductEvent.setParams({ accountStatus: "" });
        setProductEvent.setParams({ accountProduct: "" });
        setProductEvent.fire();
        
        //Clear prev selected participant before searching
        var setParticipantEvent = $A.get("e.c:setParticipantInfo");
        setParticipantEvent.setParams({ participantRecord: "" });
        setParticipantEvent.fire();
        
        //Method to search Client logic
        //Only search in Salesforce
        if (selectedSearchType != null && selectedSearchValue != null) {
            if (selectedSearchType.includes("Salesforce")) {
                helper.searchInSalesforceOnly(component);
            }
            
            //Search by Name in CIF
            else if(selectedSearchType == "Name") {
                helper.searchCifByName(component, event);
            }
            
            //CIF and Salesforce search
                else {
                    helper.retrieveClientDetailsBean(component);
                }
        }
    },
    
    // Fired when the filter changes
    updateContactFilter: function(component, event, helper) {
        helper.filterContacts(component);
    },
    
    //OnRowSelection function for Client data table to set selected value
    setClientSelected: function(component, event, helper) {
        //  $A.util.removeClass(component.find("ClientOnBoardingbutton"), "slds-show");
        var selectedAccount;
        var newlyCreatedClient = component.get("v.isNewClientCreated");
        var selectedSearchType = component.get("v.searchTypeSelected");
        var selectedSearchValue = component.find("iSearchValue").get("v.value");
        component.set("v.searchTypeValue", selectedSearchValue);
        var isbusniessprspctboardng1 = component.get("v.Onboardingselection");
        
        //component.set("v.simpleNewContact.AccountId", component.get("v.recordId"));
        //Clear prev selected values
        component.set("v.contactId", "");
        component.set("v.participantSelected", "");
        component.set("v.productSelected", "");
        component.set("v.isParticipantDetail", false);
        component.set("v.isRelatedContent", false);
        component.set("v.participantData", "");
        component.set("v.productData", "");
        component.set("v.relatedCases", "");
        component.set("v.relatedLeads", "");
        component.set("v.isPersonAccount", false);
        component.set("v.isBusinessAccount", false);
        component.set("v.isBusinessAccountOnboarding", false);
        component.set("v.isNewCaseCreation", true);
        component.set("v.isNewCreditOpportunity", true);
        component.set("v.isNewSPMOpportunity", true);
        component.set("v.isNewProductOpportunity", true);
        component.set("v.isNewCPFOpportunity", true);

        
        //Determine if new Prospect were created or Data table used to set value
        if (newlyCreatedClient == true) {
            selectedAccount = component.get("v.accountSelected");
            if (
                isbusniessprspctboardng1 != undefined ||
                isbusniessprspctboardng1 != null
            ) {
                component.set("v.maxRowSelection", 1);
            } else {
                component.set("v.maxRowSelection", 0);
            }
            component.set("v.isRelatedContent", true);
        } else {
            var selectedRows = event.getParam("selectedRows")[0];
            if (typeof selectedRows != "undefined") {
                selectedAccount = selectedRows;
                if (
                    selectedAccount.FirstName != null &&
                    selectedAccount.FirstName != undefined
                ) {
                    selectedAccount.Name = null;
                }
                component.set("v.accountSelected", selectedAccount);
                component.set("v.isRelatedContent", true);
            }
        }
        
        component.set("v.accountId", component.get("v.accountSelected.Id"));
        
        //Set SF account flag
        if (!component.get("v.accountSelected.Id")) {
            component.set("v.isAccountInSalesforce", false);
        } else {
            component.set("v.isAccountInSalesforce", true);
        }
        
        //Set CIF Client flag
        if (
            selectedAccount != null &&
            selectedAccount.Source__c != null &&
            selectedAccount.Source__c.includes("CIF")
        ) {
            component.set("v.isCIFSearch", true);
        } else {
            component.set("v.isCIFSearch", false);
        }
        
        //Hide create new Client
        $A.util.removeClass(component.find("newClientCardId"), "slds-show");
        $A.util.addClass(component.find("newClientCardId"), "slds-hide");
        
        //Set Individual and Business flags
        
        if (selectedAccount != null && isbusniessprspctboardng1 != undefined) {
            component.set("v.isPersonAccount", false);
            component.set("v.isBusinessAccount", false);
            component.set("v.isIndividualAccountOnboarding", true);
            component.set("v.isBusinessAccountOnboarding", true);
            //component.set("v.isNewCaseCreation", false);
        } else if (
            selectedAccount != null &&
            component.get("v.showCreateNewCase") == true
        ) {
            component.set("v.isPersonAccount", false);
            component.set("v.isBusinessAccount", false);
            component.set("v.isBusinessAccountOnboarding", false);
            component.set("v.isIndividualAccountOnboarding", false);
            //component.set("v.isNewCaseCreation", true);
            $A.util.removeClass(
                component.find("ClientOnBoardingbutton"),
                "slds-hide"
            );
            //$A.util.removeClass(component.find("CreateNewCaseButton"), "slds-hide");
        } else if (selectedAccount != null) {
            if (
                component.get("v.accountSelected.FirstName") ||
                component.get("v.accountSelected.isPersonAccount")
            ) {
                component.set("v.isPersonAccount", true);
                component.set("v.isBusinessAccount", false);
                component.set("v.isBusinessAccountOnboarding", false);
                //component.set("v.isNewCaseCreation", false);
            } else if (
                component.get("v.accountSelected.Name") ||
                component.get("v.accountSelected.isBusinessAccount")
            ) {
                //component.set("v.isPersonAccount", true); // Added by Diksha for Non individual to add as Related Party 
                component.set("v.isBusinessAccount", true);
                component.set("v.isBusinessAccountOnboarding", false);
                //component.set("v.isNewCaseCreation", false);
            }
        }
        
        //Show and hide Proceed to onboarding buttons
        var businessOnboardBtn = component.get(
            "v.showCreateBusinessProspectOnboarding"
        );
        var individualOnboardBtn = component.get(
            "v.showCreateIndividualProspectOnboarding"
        );
        
        if (
            businessOnboardBtn == true &&
            component.get("v.isBusinessAccount") == true
        ) {
            component.set("v.isBusinessAccountOnboarding", true);
            component.set("v.isIndividualAccountOnboarding", false);
        } else if (
            individualOnboardBtn == true &&
            component.get("v.isPersonAccount") == true
        ) {
            component.set("v.isIndividualAccountOnboarding", true);
            component.set("v.isBusinessAccountOnboarding", false);
        }
        
        //setonboarding for existing businessprospect without CIF
        /*var cifkey =  component.get("v.accountSelected.CIF__c");
        var selectedJob = component.get("v.jobname");
     	if(selectedJob === undefined || selectedJob.length != 0 && component.get("v.showCreateBusinessProspectOnboarding") == true){
            if(selectedJob.Service_Type__r.Name=='Onboard New To Bank Client'){
                component.set("v.isPersonAccount", false);
                component.set("v.isBusinessAccount", false); 
                component.set("v.isBusinessAccountOnboarding", true); 
                component.set("v.isNewCaseCreation", false);
                $A.util.removeClass(component.find("ClientOnBoardingbutton"), "slds-hide");
            }  else {
                component.set("v.isPersonAccount", false);
                component.set("v.isBusinessAccount", false); 
                component.set("v.isNewCaseCreation", true); 
                component.set("v.isBusinessAccountOnboarding", false); 
                $A.util.removeClass(component.find("CreateNewCaseButton"), "slds-hide");
            } 
        } */
        //Set Product columns
        component.set("v.productColumns", [
            { label: "Account Number", fieldName: "Account", type: "text" },
            { label: "Account Status", fieldName: "Status", type: "text" },
            { label: "Product", fieldName: "Product", type: "text" }
        ]);
        
        //Set relatedCases columns/mapping
        component.set("v.relatedCasesColumns", [
            {
                label: "Case Number",
                fieldName: "linkName",
                type: "url",
                typeAttributes: {
                    label: { fieldName: "CaseNumber" },
                    target: "_parent"
                }
            },
            { label: "Subject", fieldName: "Subject", type: "text" },
            { label: "Status", fieldName: "Status", type: "text" },
            { label: "Created Date", fieldName: "CreatedDate", type: "date" }
        ]);
        
        //Get related Cases
        var actionGetCases = component.get("c.getCasesLinkedToClient");
        actionGetCases.setParams({
            newAccountId: component.get("v.accountSelected.Id")
        });
        
        actionGetCases.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record) {
                    record.linkName = "/" + record.Id;
                });
                component.set("v.relatedCases", records);
            }
        });
        
        $A.enqueueAction(actionGetCases);
        
        //Set relatedLeads columns/mapping
        component.set("v.relatedLeadsColumns", [
            {
                label: "Name",
                fieldName: "linkName",
                type: "url",
                typeAttributes: { label: { fieldName: "Name" }, target: "_parent" }
            },
            { label: "Company", fieldName: "Company", type: "text" },
            { label: "Phone", fieldName: "Phone", type: "text" },
            { label: "Created Date", fieldName: "CreatedDate", type: "date" }
        ]);
        
        //Get related Leads
        var actionGetLeads = component.get("c.getLeadsLinkedToClient");
        actionGetLeads.setParams({
            newAccountId: component.get("v.accountSelected.Id")
        });
        
        actionGetLeads.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                records.forEach(function(record) {
                    record.linkName = "/" + record.Id;
                });
                component.set("v.relatedLeads", records);
            }
        });
        
        $A.enqueueAction(actionGetLeads);
        
        //Get related Contacts
        helper.getContactData(component);
        
        //Set Individual flag
        var setEvent = $A.get("e.c:setClientInfo");
        var indivClientIdentifier = true;
        var jointParticipants;
        //var clientSelected = component.get("v.accountSelected");
        if (selectedAccount != null) {
            if (
                selectedAccount.Client_Type__c == "INDIVIDUAL" ||
                selectedAccount.Client_Type__c == "Individual"
            ) {
                indivClientIdentifier = true;
                selectedAccount.Name = null;
            } else {
                indivClientIdentifier = false;
            }
            
            //Get Products and Participants for CIF searched Clients only
            if (selectedSearchType != null && selectedAccount.Source__c != null) {
                if (
                    !selectedSearchType.includes("Salesforce") &&
                    selectedAccount.Source__c.includes("CIF")
                ) {
                    if (
                        indivClientIdentifier == false &&
                        selectedAccount.Client_Type__c == "JOINT & SEVERAL"
                    ) {
                        //Get participants
                        helper.getParticipantsBean(component);
                    } else {
                        var setClientInfoEvent = $A.get("e.c:setClientInfo");
                        setClientInfoEvent.setParams({ accountValue: selectedAccount });
                        setClientInfoEvent.setParams({
                            isIndivClient: indivClientIdentifier
                        });
                        setClientInfoEvent.fire();
                    }
                    
                    //Get client products
                    helper.getClientProducts(component);
                } else {
                    var setClientInfoEvent = $A.get("e.c:setClientInfo");
                    setClientInfoEvent.setParams({ accountValue: selectedAccount });
                    setClientInfoEvent.setParams({
                        isIndivClient: indivClientIdentifier
                    });
                    setClientInfoEvent.fire();
                }
            }
        }
    },
    
    //OnRowSelection function for Participant data table to set selected value
    setParticipantSelection: function(component, event, helper) {
        //Set participantRecord based on data table selection
        var selectedRows = event.getParam("selectedRows")[0];
        if (typeof selectedRows != "undefined") {
            var selectedParticipant = selectedRows;
            component.set("v.participantSelected", selectedParticipant);
            
            //Show additional info
            component.set("v.isParticipantDetail", true);
            
            var setEvent = $A.get("e.c:setParticipantInfo");
            
            setEvent.setParams({
                participantRecord: component.get("v.participantSelected")
            });
            setEvent.fire();
        }
    },
    
    //OnRowSelection function for Product data table to set selected value
    setProductSelection: function(component, event, helper) {
        //Set productRecord based on data table selection
        var selectedRows = event.getParam("selectedRows")[0];
        if (typeof selectedRows != "undefined") {
            var selectedProduct = selectedRows;
            component.set("v.productSelected", selectedProduct);
            
            var setEvent = $A.get("e.c:setProductInfo");
            
            setEvent.setParams({
                accountNumber: component.get("v.productSelected.Account")
            });
            setEvent.setParams({
                accountStatus: component.get("v.productSelected.Status")
            });
            setEvent.setParams({
                accountProduct: component.get("v.productSelected.Product")
            });
            setEvent.fire();
        }
    },
    
    //OnRowSelection function for Product data table to set selected value
    setContactSelection: function(component, event, helper) {
        //Set productRecord based on data table selection
        var selectedRows = event.getParam("selectedRows")[0];
        if (typeof selectedRows != "undefined") {
            var selectedContact = selectedRows;
            component.set("v.contactSelected", selectedContact);
            
            var setEvent = $A.get("e.c:setContactInfo");
            
            setEvent.setParams({ contactRecord: selectedContact });
            setEvent.fire();
        }
    },
    
    //OnChange event for Search Type to set value
    setSearchType: function(component, event, helper) {
        var qSelect = component.find("iSearchType").get("v.value");
        component.set("v.searchTypeSelected", qSelect);
    },
    
    //Set Id of Contact selected for Event
    logContactId: function(component, event, helper) {
        //Get Contact Id
        var contactId = component.get("v.contactId");
        var contactRecord = component.get("v.contactRecord");
        
        //setContactId Lightning Event with ContactId
        var setEvent = $A.get("e.c:setContactInfo");
        
        setEvent.setParams({
            contactRecordId: contactId,
            contactRecord: contactRecord
        });
        setEvent.fire();
    },
    
    //Set Contact selected  for Event
    logNewContact: function(component, event, helper) {
        //Get Contact
        var contactRecord = component.get("v.contactRecord");
        
        //setContactId Lightning Event with ContactId
        var setEvent = $A.get("e.c:setContactId");
        
        setEvent.setParams({ contactRecord: contactRecord });
        setEvent.fire();
    },
    
    //Next button function on Product Pagination
    nextProduct: function(component, event, helper) {
        helper.nextProductSet(component, event);
    },
    
    //Prev button function on Product Pagination
    previousProduct: function(component, event, helper) {
        helper.previousProductSet(component, event);
    },
    handleChangeCountryOfCitzn : function(component, event, helper) {
        var slectedVal = component.get("v.countryOfCitizenShip");
        //alert(slectedVal);
        var personAccount = component.get("v.newIndivProspect");
        personAccount.Country_of_Citizenship__c = slectedVal.join(';');
        component.set("v.newIndivProspect",personAccount);
    },
    handleSharePercentChange : function(component, event, helper) {
        var share = event.getSource().get("v.value");
        /*if(share >= 10){
            component.find("uboFld").set("v.value",'Yes');
        }else{
            component.find("uboFld").set("v.value",'No');
        }*/
    },
    
    //TdB - Create new Credit Opprotunity
    createCreditOpportunity: function(component, event, helper) {
        
        helper.showSpinner(component);
        
        //Get logged in User details
        var action = component.get("c.createNewCreditOpportunity");
        
        action.setParams({
            "accRecord" : component.get("v.accountSelected")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var message;
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var oppId = response.getReturnValue();
                
                //Navigate to Opportunity
                if(oppId != null) {
                    console.log('opportunityRecordId : ' + oppId);
                    
                    helper.closeFocusedTabAndOpenNewTab(component, oppId);
                } 
                //Error when inserting Opportunity
                else {
                    var toast = helper.getToast("Error", 'Credit Opportunity could not be created. Please contact your Salesforce Admin', "error");
                    
                    toast.fire();
                }
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                
                var toast = helper.getToast("Error", 'Credit Opportunity could not be created. Please contact your Salesforce Admin', "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //Diksha 11/19/2020 - Create new CPF Opprotunity
    createCPFOpportunity: function(component, event, helper) {
        
        helper.showSpinner(component);
        
        //Get logged in User details
        var action = component.get("c.createNewCPFOpportunity");
        
        action.setParams({
            "accRecord" : component.get("v.accountSelected")
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var message;
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var oppId = response.getReturnValue();
                
                //Navigate to Opportunity
                if(oppId != null) {
                    console.log('opportunityRecordId : ' + oppId);
                    
                    helper.closeFocusedTabAndOpenNewTab(component, oppId);
                } 
                //Error when inserting Opportunity
                else {
                    var toast = helper.getToast("Error", 'CPF Opportunity could not be created. Please contact your Salesforce Admin', "error");
                    
                    toast.fire();
                }
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                
                var toast = helper.getToast("Error", 'CPF Opportunity could not be created. Please contact your Salesforce Admin', "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            }
        });
        
        // Send action off to be executed
        $A.enqueueAction(action);
    },

    //Diksha - Create new SPM Opprotunity if Client already exists
    createSPMOpportunity: function(component, event, helper) {
        var loggedinUserProfile =component.get("v.loggedinUserProfile");
        console.log("loggedinUserProfile"+loggedinUserProfile);
        if(loggedinUserProfile != 'Stock Broker Portfolio Manager') { 
            component.set("v.isModalOpenforPM", true);
            helper.showPmuserlist(component, event, helper);
        }
        else{
            helper.creatingSPMOpp(component, event, helper);
            component.set("v.isModalOpenforPM", false);
        }
    },
    //TdB - Call gaolden sources after Search by Name
    callGoldenSources : function(component, event, helper) {
        var selectedCIF = component.find('searchByNameCIF').get('v.value');
        
        component.set("v.searchTypeSelected", "CIF No");
        component.set("v.searchTypeValue", selectedCIF);
        component.find("iSearchValue").set("v.value", selectedCIF);
        
        helper.retrieveClientDetailsBean(component);
    },
    
    /****************@ Author: Chandra****************************************
 	****************@ Date: 06/07/2020****************************************
 	****************@ Work Id: W-004939***************************************
 	***@ Description: Method Added by chandra to handle Roles selection*******/
    handleChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        if(selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers") || selectedOptionValue.includes("Trustees") || selectedOptionValue.includes("Named Beneficiaries")){
            component.find("iSharePercentage").set("v.disabled", false);
        }
        else{
            component.find("iSharePercentage").set("v.value", "");
            component.find("iSharePercentage").set("v.disabled", true);
        }
    },
    
    
    /****************@ Author: Chandra*****************************************************
 	****************@ Date: 02/08/2020*****************************************************
 	****************@ Work Id: W-004939****************************************************
 	***@ Description: Method Added by chandra to handle Roles selection while update*******/
    handleRoleChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        
        if(selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers") || selectedOptionValue.includes("Trustees") || selectedOptionValue.includes("Named Beneficiaries")){
            component.find("editSharePercent").set("v.disabled", false);
        }
        else{
            component.find("editSharePercent").set("v.value", "");
            component.find("editSharePercent").set("v.disabled", true);
        }
    },
    
    /** TdB - Set additional Occupation fields **/
    setOccupationFields : function(component, event, helper){
        var occupationStatusValue = component.find("iOccupationStatus").get("v.value");
        
        if(occupationStatusValue == 'Full Time Employed' || occupationStatusValue == 'Part Time Employed' || occupationStatusValue == 'Self Employed Professional' || occupationStatusValue == 'Self Employed-Non-Professional' || occupationStatusValue == 'Temporary Employed') {
            component.set("v.isEmployed", true);
        } else {
            component.set("v.isEmployed", false);
        }
    },
    //Added by Diksha for SPM to select PM on opp creation  
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpenforPM", false);
    },
    
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        helper.creatingSPMOpp(component, event, helper);
        
        component.set("v.isModalOpenforPM", false);
    },
    //TdB - Navigate to Onboarding from (Business or Individual)
    navigateToOnboardingBigForm: function(component, evt, helper) {
        
        var searchValue = component.find("iSearchValue").get("v.value");
        var accId = component.get("v.accountId");
        var clientDetails = component.get("v.accountSelected");
        var clientType = clientDetails.Client_Type__c.toUpperCase();
        
        var action = component.get("c.checkCompliant");
        action.setParams({ 
            "cifKeyP" : clientDetails.CIF__c 
        });
		action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if(responseValue) {
                    helper.showSpinner(component);
                    
                    if(clientType != null && clientType != '' && clientType != undefined) {
                        clientType = clientDetails.Client_Type__c.toUpperCase();
                    }
                    
                    var processName = component.get("v.ProcessName"); // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                    
                    //TdB - Pass Process Type to Onboarding Form
                    var selectedJob = component.get("v.jobname");
                    
                    //Get FocusTabId
                    var workspaceAPI = component.find("workspace");
                    var clientFinderTabId;
                    var onboardingClientDetailsTabId;
                    workspaceAPI.getFocusedTabInfo().then(function(response) {
                        clientFinderTabId = response.tabId;
                    });
                    
                    //Create Client in Salesforce (if not existing)
                    if (!accId) {
                        var actionCreateCIFClient = component.get("c.createCIFClientInSF");
                        
                        actionCreateCIFClient.setParams({
                            "newAcc" : clientDetails
                        });
                        
                        // Add callback behavior for when response is received
                        actionCreateCIFClient.setCallback(this, function(response) {
                            
                            var state = response.getState();
                            var message = '';
                            
                            if (component.isValid() && state === "SUCCESS") {
                                
                                var responseValue = response.getReturnValue();
                                
                                if(responseValue.includes('Success')) {
                                    component.set("v.accountId",responseValue.substring(8, 26));
                                    accId = component.get("v.accountId");
                                    
                                    var evt = $A.get("e.force:navigateToComponent");
                                    if (accId != null && accId != '' && accId != undefined) {
                                        //Navigate to OnboardingClientDetails - Business Entities
                                        if(clientType != 'INDIVIDUAL' && clientType != 'SOLE TRADER' && clientType != 'SOLE PROPRIETOR') {
                                            console.log("In Business accId : " + accId);
                                            evt.setParams({
                                                componentDef: "c:OnboardingClientDetails",
                                                componentAttributes: {
                                                    accRecordId: accId,
                                                    registrationNumber: searchValue, // PJAIN: 202003401
                                                    ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                                                    processType: component.get("v.jobname").Process_Type__c
                                                }
                                            });
                                        }
                                        
                                        //Navigate to OnboardingIndividualClientDetails - Individual and Sole Trader
                                        else {
                                            console.log("In Individual accId : " + accId);
                                            evt.setParams({
                                                componentDef: "c:OnboardingIndividualClientDetails",
                                                componentAttributes: {
                                                    accRecordId: accId,
                                                    registrationNumber: searchValue, // PJAIN: 202003401
                                                    ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                                                    processType: component.get("v.jobname").Process_Type__c
                                                }
                                            });
                                        }
                                        
                                        evt.fire();
                                        
                                        //Closing old tab
                                        workspaceAPI.closeTab({
                                            tabId: clientFinderTabId
                                        });
                                    }
                                    
                                } else {
                                    var toast = helper.getToast("Error", responseValue, "error");
                                    toast.fire();
                                }
                                
                                helper.hideSpinner(component);
                                
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
                                
                                var toast = helper.getToast("Error", message, "error");
                                
                                toast.fire();
                                
                                helper.hideSpinner(component);
                            } else {
                                var errors = response.getError();
                                
                                var toast = helper.getToast("Error", message, "error");
                                
                                toast.fire();
                                
                                helper.hideSpinner(component);
                            }
                        });
                        
                        // Send action off to be executed
                        $A.enqueueAction(actionCreateCIFClient); 
                    } else {
                        var evt = $A.get("e.force:navigateToComponent");
                        if (accId != null && accId != '' && accId != undefined) {
                            //Navigate to OnboardingClientDetails - Business Entities
                            if(clientType != 'INDIVIDUAL' && clientType != 'SOLE TRADER' && clientType != 'SOLE PROPRIETOR') {
                                console.log("In Business accId : " + accId);
                                evt.setParams({
                                    componentDef: "c:OnboardingClientDetails",
                                    componentAttributes: {
                                        accRecordId: accId,
                                        registrationNumber: searchValue, // PJAIN: 202003401
                                        ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                                        processType: component.get("v.jobname").Process_Type__c
                                    }
                                });
                            }
                            
                            //Navigate to OnboardingIndividualClientDetails - Individual and Sole Trader
                            else {
                                console.log("In Individual accId : " + accId);
                                evt.setParams({
                                    componentDef: "c:OnboardingIndividualClientDetails",
                                    componentAttributes: {
                                        accRecordId: accId,
                                        registrationNumber: searchValue, // PJAIN: 202003401
                                        ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                                        processType: component.get("v.jobname").Process_Type__c
                                    }
                                });
                            }
                            
                            evt.fire();
                            
                            //Closing old tab
                            workspaceAPI.closeTab({
                                tabId: clientFinderTabId
                            });
                        }
                    }
                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        message: "The client is not Compliant. Please check for remediation",
                        type: "error"
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
        

  },
    //TdB - Create new Credit covid Opprotunity Almas Aleem
      createCovidOpportunity: function(component, event, helper) {
          
          helper.showSpinner(component);
          
          //Get logged in User details
          var action = component.get("c.createNewCovidOpportunity");
          
          action.setParams({
              "accRecord" : component.get("v.accountSelected")
          });
          
          // Add callback behavior for when response is received
          action.setCallback(this, function(response) {
              var message;
              
              var state = response.getState();
              
              if (component.isValid() && state === "SUCCESS") {
                  
                  var oppId = response.getReturnValue();
                  
                  //Navigate to Opportunity
                  if(oppId != null) {
                      console.log('opportunityRecordId : ' + oppId);
                      
                      helper.closeFocusedTabAndOpenNewTab(component, oppId);
                  } 
                  //Error when inserting Opportunity
                  else {
                      var toast = helper.getToast("Error", 'Credit Opportunity could not be created'+ response.getReturnValue() +'Please contact your Salesforce Admin', "error");
                      
                      toast.fire();
                  }
                  
                  helper.hideSpinner(component);
                  
              }else if(state === "ERROR"){
                  
                  var toast = helper.getToast("Error", 'Credit Opportunity could not be created. Please contact your Salesforce Admin', "error");
                  
                  toast.fire();
                  
                  helper.hideSpinner(component);
              }
          });
          
          // Send action off to be executed
          $A.enqueueAction(action);
      },

      // Handler for BranchProductOnboarding button - Sync with CIF and initiate flow 
      handleStartProductOnboarding : function(component, event, helper){
            helper.showSpinner(component);
            var selectedAccount = component.get("v.accountSelected");
            var selectedJob = component.get("v.jobname");
            var selectedConsent = component.get("v.isConsentSelected");
            var flowNameVal = selectedJob.Flow__c;
            var IdRecord = ''; 
            var Cif = '';
            var Idnumber = '';
            var action = component.get("c.UpdateCreateAccountWithCIF");
        
            if (!$A.util.isUndefinedOrNull(component.get("v.accountSelected.Id"))){
                IdRecord = component.get("v.accountSelected.Id");
            }
            if (!$A.util.isUndefinedOrNull(component.get("v.accountSelected.CIF__c"))){
            Cif = component.get("v.accountSelected.CIF__c");
            }
            if (!$A.util.isUndefinedOrNull(component.get("v.accountSelected.ID_Number__pc"))){
            Idnumber = component.get("v.accountSelected.ID_Number__pc");
            }
            
            //Setting the Apex Parameter
            action.setParams({            
                accId: IdRecord,
                CIFcode: Cif ,
                IdNumber: Idnumber,
                consent: selectedConsent
            });
            
            //Setting the Callback
            action.setCallback(this, function(response) {
                helper.hideSpinner(component);
                var state = response.getState();
                if(state != 'SUCCESS')
                {
                alert(state);
                }
                if (state === "SUCCESS") {
                IdRecord = response.getReturnValue(); 
                console.log('In Navigate to Product Onboarding branches');
                var evt = $A.get("e.force:navigateToComponent");     
                evt.setParams({
                    componentDef : "c:BranchCustomerProductOnboardingFlow",
                    componentAttributes: { 
                        flowName:flowNameVal,
                        recordId:IdRecord
                    }
                });  
                evt.fire();            
                }
            });
            $A.enqueueAction(action);
        //end added
    },
});