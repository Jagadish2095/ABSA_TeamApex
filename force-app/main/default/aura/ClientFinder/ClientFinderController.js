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
        console.log('selectedJob : ' + JSON.stringify(selectedJob));
        //console.log('selectedJob : ' + selectedJob);
        //console.log('selectedJob Process Type : ' + selectedJob.Process_Type__c);
        //console.log('ProcessName : ' + component.get("v.ProcessName"));
        if(selectedJob != ''){
            if (selectedJob.FIC_Refresh_Required__c){
                component.set("v.FicLockRequired", true);
            }
            if (!$A.util.isUndefinedOrNull(selectedJob.Service_Group__r) && selectedJob.Service_Group__r.Name === "Home Loans" ){
                component.set("v.HomeLoanServiceGroup", selectedJob.Service_Group__r.Name);
            }
        }


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

        if(selectedJob.Service_Type__r && selectedJob.Service_Type__r.Case_Record_Type__c){
            //console.log("selectedJob: " + selectedJob.Service_Type__r.Case_Record_Type__c);
            helper.getRecordTypeIdByServiceType(component);
        }else{
            helper.getRecordTypeId(component);
        }
        if(selectedJob != undefined && selectedJob.Service_Type__r != undefined && selectedJob.Service_Type__r.Name != null)
        {
            component.set("v.FlowName", selectedJob.Service_Type__r.Name);
        }
        if( selectedJob != undefined && selectedJob.Service_Type__r != undefined  &&  selectedJob.Service_Type__r.Name == 'Maintain Related Parties')
        {
            component.set("v.showCreateIndividualProspect", false);
             component.set("v.showCreateBusinessProspect", false);
         }
        //call hepler method to get recordTypeId
        //helper.getRecordTypeId(component, event, helper);
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
    //Added for Home loans Event --Start
    complianceStatusEvent : function(component, event, helper) {
        var valueFromChild = event.getParam("complianceStatus");
       
        component.set("v.complianceStatus", valueFromChild);
    },
	//Added for Home loans Event --Start	

    //Updated by Sandeep Golla for FIC Refresh Triggers (W-009646)
    handleComponentEvent: function(component, event, helper) {
        //var selectedJob = event.getParam("selectedJob");
        var selectedJob = component.get("v.jobname");
        var accountId = component.get("v.accountSelected.Id");
        var accountRecord = component.get("v.accountSelected");
        var clientTyp = accountRecord.Client_Type__c;

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

        /* Modified on 12th April 2021
         * Before proceeding to create a case,
         *  1.If service job doesn't require FIC refresh then proceed with creating a respective case of that service job
         *  2.If service job require FIC refresh then check whether customer is Complaint and Not Complaint
         *    2.1. If Complaint the proceed with creating a respective case of that service job
         *    2.2. If not complaint then create a FIC refresh case not the service job case.
         */

        var complianceStatus;
        var daysDue;
        if(!selectedJob.FIC_Refresh_Required__c || accountId == undefined){
            helper.createCaseRecord(component,selectedJob,accountRecord,'');
        }
        else if (selectedJob.FIC_Refresh_Required__c && accountId != undefined) {

            component.set("v.showSpinner", true);
            var action = component.get("c.checkComplianceStatus");
            action.setParams({
                "accId": accountId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    console.log('Dataa----'+JSON.stringify(data));
                    if(data != null && data.complianceStatus && data.message == null){
                        complianceStatus = data.complianceStatus;
                        daysDue = data.daysDue;
                        component.set("v.complianceStatus",data.complianceStatus);
                        console.log('complianceStatus after response------'+complianceStatus);
                        component.set("v.showSpinner", false);
                        if(complianceStatus.toLowerCase() === 'compliant'){
                            if(selectedJob.Service_Type__r.Name.toLowerCase() === "beneficiary maintenance" && daysDue && daysDue > 0 && daysDue < 180) {
                                helper.getExistingFICRefreshCase(component, event, helper);
                            }
                            else if (selectedJob.Service_Type__r.Name.toLowerCase() === "product information" && daysDue && daysDue > 0 && daysDue < 365) {
                                helper.getExistingFICRefreshCase(component, event, helper);
                            }
							//Deferral US W-011318 by Mohammed Junaid U
                            else if (selectedJob.Service_Type__r.Name.toLowerCase() === "fic deferral" || selectedJob.Service_Type__r.Name.toLowerCase() === "special deferral") {
                                var msg = "Deferrals cannot be applied as the customer is already Compliant";
                                var toast = helper.getToast("Info", msg, "Compliant Customer");
                                toast.fire();
                                component.set("v.showSpinner", false);
                            }
                            else{
                            helper.createCaseRecord(component,selectedJob,accountRecord,complianceStatus);
                        }
                    }
                        else{
                            //adding a if condition for closure of account US W-010672
                            if(selectedJob.Service_Type__r.Name.toLowerCase() === "closure of account"){
                                //console.log('The Client Type is : '+clientTyp +' and registration number ends with :'+regNumberValue);
                                if( clientTyp =='Private Company'  || clientTyp =='Close Corporation' || clientTyp =='Incorporated Company'  || clientTyp =='Public Listed Company' ) {
                                    console.log('Inside Calling Experian Service');
                                    var action = component.get("c.callExperianHandler");
                                    action.setParams({"accId" : accountId});
                                    action.setCallback(this, function(response) {
                                        var state = response.getState();
                                        if (state == "SUCCESS") {
                                            var respObj = JSON.parse(response.getReturnValue());
                                            if(respObj.statusCode==200 && respObj.message==null){
                                                var status = respObj.companyDownload.results.kreditSearchFile.companyDetails.status;
                                                if(status.toLowerCase() == 'active'){
                                                    console.log('The Experain Status is Active');
                                                    component.set("v.showSpinner", false);
                                                    component.set("v.showAccountClosureConfirmation", true);
                                                }
                                                else{
                                                    var action1 = component.get("c.sendTemplatedEmail");
                                                    action1.setParams({"whatId" : accountId});
                                                    action1.setCallback(this, function(response) {
                                                        var state = response.getState();
                                                        if (state == "SUCCESS") {
                                                            var msg = "All the Relevant Users have been notified that the Company is Deregistered."
                                                            var toast = helper.getToast("Success", msg, "Dereegistered Entity");
                                                            toast.fire();
                                                        }else{
                                                            var errors = response.getError();
                                                            var msg = errors[0].message;
                                                            component.set("v.showSpinner", false);
                                                            var toast = helper.getToast("error", msg, "Dereegistered Entity");
                                                            toast.fire();
                                                        }
                                                    });
                                                    $A.enqueueAction(action1);
                                                }
                                            }else if(respObj.statusCode > 399 || respObj.statusCode < 500){
                                                component.set("v.showSpinner", false);
                                                var message = respObj.message;
                                                var toast = helper.getToast("error", message, "Experian Service");
                                                toast.fire();
                                            }else{
                                                component.set("v.showSpinner", false);
                                                var message = "We cannot complete the request now, please try again if error persist contact administrator.";
                                                var toast = helper.getToast("error", message, "Experian Service");
                                                toast.fire();
                                            }
                                        }else if(state === "ERROR"){
                                            var errors = response.getError();
                                            var msg = errors[0].message;
                                            component.set("v.showSpinner", false);
                                            var toast = helper.getToast("error", msg, "Experian Service");
                                            toast.fire();
                                        }else{
                                            component.set("v.showSpinner", false);
                                            var message = "We cannot complete the request now, please try again if error persist contact administrator.";
                                            var toast = helper.getToast("error", message, "Experian Service");
                                            toast.fire();
                                        }
                                    });
                                    $A.enqueueAction(action);
                                }else{
                                    component.set("v.showSpinner", false);
                                    component.set("v.showAccountClosureConfirmation", true);} 
                            }
							//Deferral US W-011318 by Mohammed Junaid U
                            else if(selectedJob.Service_Type__r.Name.toLowerCase() === "fic deferral" || selectedJob.Service_Type__r.Name.toLowerCase() === "special deferral"){
                                if(data.FICLockStatus.toLowerCase() == 'hard lock' || data.FICLockStatus.toLowerCase() == 'soft lock'){
                                    var toast = helper.getToast("info", "Deferrals Cannot be applied because the customer is in Lock status", "Compliance Pack Service");
                        			toast.fire();
                                    component.set("v.showSpinner", false);
                                }
                                else{
                                    helper.createCaseRecord(component,selectedJob,accountRecord,complianceStatus);
                                }
                            }
                            else{
                                component.set("v.showSpinner", false);
                                helper.getExistingFICRefreshCase(component, event, helper);}
                        }
                    }
                    else if(data != null && data.message != null){
                        component.set("v.showSpinner", false);
                        var toast = helper.getToast("info", data.message, "Compliance Pack Service");
                        toast.fire();
                    }
                    else{
                        component.set("v.showSpinner", false);
                        var toast = helper.getToast("info", "There is no data found for this Account", "Compliance Pack Service");
                        toast.fire();
                    }
                }
                else{
                    console.log("Failed with state: " +state);
                    component.set("v.showSpinner", false);
                    var errors = response.getError();
                    var toast = helper.getToast("error", errors[0].message , "Compliance Pack Service");
                    toast.fire();
                }
            });
            $A.enqueueAction(action);
        }
    },

    closeConfirmation: function(component, event, helper) {
        component.set("v.showFICRefreshConfirmation", false);
    },

    proceed: function(component, event, helper) {

        var ficCaseRec = component.get("v.ficCase");
        if(ficCaseRec && ficCaseRec != undefined){
            /* Modified on 14th June 2021 by Sandeep Golla
             * When redirecting it should close the existing tab and open the case in new tab
             */
            var workspaceAPI = component.find("workspace");
            workspaceAPI
            .getFocusedTabInfo()
            .then(function(response) {
                var focusedTabId = response.tabId;
                //Opening New Tab
                workspaceAPI
                .openTab({
                    url: "#/sObject/" + ficCaseRec.Id + "/view"
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
            component.set("v.showFICRefreshConfirmation", false);
        }
        else{
            component.set("v.showFICRefreshConfirmation", false);
            component.set("v.showSpinner", true);

            var selectedJob = component.get("v.jobname");
            var accountRecord = component.get("v.accountSelected");
            var comStatus = component.get("v.complianceStatus");
            var action = component.get("c.getFICRefreshServGrpTypeAndRecordTypeId");
            action.setParams({
                "groupId": selectedJob.Service_Group__c
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    if(data != null){
                        component.set("v.serviceTypeRecordTypeId",data.caseRecordTypeId);
                        component.set("v.showSpinner", false);
                        helper.createCaseRecord(component,data.serviceGroupTypeRecord,accountRecord,comStatus);
                    }
                    else{
                        component.set("v.showSpinner", false);
                        var toast = helper.getToast("error", "No Service Job found", "FIC Refresh Service Job");
                        toast.fire();
                    }
                }
                else{
                    component.set("v.showSpinner", false);
                    var errors = response.getError();
                    var toast = helper.getToast("error", errors[0].message , "FIC Refresh Service Job");
                    toast.fire();
                }
            });
            $A.enqueueAction(action);
        }
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
        helper.getServiceJobUser(component, event);
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
        var loggedInUserProfileName = component.get("v.loggedinUserProfile"); //added by Short Term Insurance
        if(loggedInUserProfileName != null && loggedInUserProfileName != 'Standard User (Contact Centre)' && loggedInUserProfileName != 'Standard User (Personal Lines Insurance)'){//added by Short Term Insurance
            var idNumber = component.find("iSearchValue").get("v.value");
            component.set("v.newIndivProspect.ID_Number__pc", idNumber);
            component.set("v.newIndivProspect",{'sobjectType':'Account',
            'FirstName': '',
            'LastName': '',
            'PersonMobilePhone': ''
            // End
        });
    }
        var selectedJob = component.get("v.jobname");
        if(selectedJob.Show_Sales_Prospect_Pop_Up__c){
            //Show the Voice Sales Pop Up to create an Individual Prospect
        
            component.set("v.showIndividualCustomerPopUP", true);
        }else{
            //Show the Default Pop Up to create an Individual Prospect
            component.set("v.isCreateIndividualProspect", true);
        }
    },

    //Open Create New Individual Prospect Modal for Branch khaliq Added
    showNewBranchIndividualProspectModal: function(component, evt, helper){
        var idNumber = component.find("iSearchValue").get("v.value");
        component.set("v.newIndivProspect",{'sobjectType':'Account',
        'FirstName': '',
        'LastName': '',
        'PersonMobilePhone': '',
        'ID_Number__pc': idNumber
     });
     component.set("v.isCreateBranchIndividualProspect", true);
    },

    //Restricting mobile field to numbers only for Create New Individual Prospect Modal for Branch
    NumberCheck: function(component, event, helper){
        var charCode = (event.which) ? event.which : event.keyCode;
        if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)){
            if (event.preventDefault) {
                event.preventDefault();
            } else {
                event.returnValue = false;
            }
        }
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
    //enable next on stokvel
    CreateStokvelProspect: function(cmp, evt) {
        cmp.set('v.isButtonActive',false);
     },
     //close new stokvel prospect modal
     closeNewStokvelProspectModel: function(component, event, helper) {
         component.set("v.CreateStokvelProspect", false);
     },
    //Close Create New Individual Prospect Modal
    closeNewIndividualProspectModel: function(component, event, helper) {
        component.set("v.isCreateIndividualProspect", false);
        component.set("v.showIndividualCustomerPopUP", false);

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


        if(selectedClientType=='Individual - Minor' || selectedClientType=='Private Individual'){
            var placeOfResVal = event.getParam("selectedplaceOfResidence");
            component.set("v.placeOfResidence",placeOfResVal);

             //Clear prev selected values
             component.set("v.newIndivProspect",{'sobjectType':'Account',
             'FirstName': '',
             'LastName': '',
             'PersonTitle' : '',
             'Initials__pc' : '',
             'ID_Number__pc' : '',
             'Gender__pc' : '',
             'Phone': '',
             'PersonMobilePhone': '',
             'PersonHomePhone' : '',
             'PersonEmail' : '',
             'PersonBirthdate': ''});

             component.set("v.newIndivProspect.Place_of_Residence__c", placeOfResVal);

            $A.enqueueAction(component.get('c.showNewRelatedPartyModal'));

        }
        //Diksha Wasekar: Added for non-individual related parties commented to switch off complex
        else if(selectedClientType=='Trusts' || selectedClientType=='Private Company' || selectedClientType=='Close Corporation' ||
                  selectedClientType=='Foreign Listed Company'|| selectedClientType=='Foreign Trust'|| selectedClientType=='Public Listed Company'||
                  selectedClientType=='Foreign Company'|| selectedClientType=='Co-operative' || selectedClientType=='Incorporated Company' ||
                  selectedClientType=='Non Profit Organizations (NGO)' || selectedClientType=='Clubs/Societies/Associations/Other Informal Bodies'||selectedClientType=='Non Profit Companies' || selectedClientType == 'Central Bank or Regulator'
                  || selectedClientType=='PARTNERSHIP' || selectedClientType=='Funds' || selectedClientType=='Regulated Credit Entities and Financial Institutions' || selectedClientType=='Schools' || selectedClientType=='Churches' || selectedClientType=='Body Corporates'){
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
        }
    },
    //stokvel onboarding
    createStokvelOnboardingEntity : function(component, event, helper) {
        var selectedSearchType = component.get("v.searchTypeSelected");
    if (selectedSearchType.includes("Reg. No / Passport")) {
        
        var toastEvent = helper.getToast("Error", "You cannot create a stokvel using reg.no/passport", "Error");
        toastEvent.fire();  
    } else {
        var StokvelSearch = component.find("iSearchValue").get("v.value");
        component.set("v.CreateStokvelProspect", true);
    }
    },
        handleStokvelOnLoad: function (cmp, event, helper) {
            var StokvelSearch = cmp.find("iSearchValue").get("v.value");
            cmp.find("iEntityName").set("v.value", StokvelSearch);
         },
    //Selecting onboarding Entity - Manoj-09102020-W005563
    //Signle New Prospect Design
    selectOnboardingEntity : function(component, event, helper) {
        component.set("v.showEntityTypeSelection",true);
        helper.fetchClientGroupValues(component, event, helper);
    },

   setClientTypeValue : function(component, event, helper) {
        helper.fetchClientTypeValues(component, event, helper);
    },

    setClientPlaceOfResidenceValue : function(component, event, helper) {
        if(component.find("clientTypeIdField")) {
            component.find("clientTypeIdField").set("v.value", component.find("clientTypeId").get("v.value"));
        }
    },
    closeEntityTypeSelection : function(component, event, helper) {
        component.set("v.showEntityTypeSelection",false);
    },
    selectEntityType: function(component, event, helper) {
        var clientTypeValue = component.find("clientTypeId").get("v.value");
        var clientGroupValue = component.find("clientGroupId").get("v.value");
        var placeofResValue = component.find("placeOfResidenceId").get("v.value");
        console.log('Selected Entity Type:'+clientTypeValue);

        component.set("v.placeOfResidence", placeofResValue);
        if(clientTypeValue!='' && clientGroupValue!='' && placeofResValue!=''){
            component.set("v.showEntityTypeSelection",false);
            if(clientTypeValue == 'Deceased Estate' || clientTypeValue == 'Individual - Minor' || clientTypeValue =='Individual' || clientTypeValue=='Private Individual' || clientTypeValue=='Sole Trader'){ // Sole Proprieter change to Sole Trader
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

                                            component.set( "v.newAddressRecord.Shipping_Street__c", respObjCPB.Person.AddressInformation.ResidentialAddress.Line1);

                                            component.set( "v.newAddressRecord.Shipping_Suburb__c",respObjCPB.Person.AddressInformation.ResidentialAddress.Line3);

                                            component.set( "v.newAddressRecord.Shipping_Zip_Postal_Code__c",respObjCPB.Person.AddressInformation.ResidentialAddress.PostalCode);

                                            component.set( "v.newAddressRecord.Shipping_City__c", respObjCPB.Person.AddressInformation.ResidentialAddress.Line4);

                                            component.set("v.newAddressRecord.Shipping_Street_2__c",respObjCPB.Person.AddressInformation.ResidentialAddress.Line2);

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

                                            component.set("v.isCreateRelatedParty", true);
                                            helper.hideSpinner(component);
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
        //console.log('parentClientType'+component.get("v.accountParentRecord.Client_Type__c"));
        //console.log('selectedClientType'+selectedClientType);

        if(selectedClientType=='Individual - Minor' || selectedClientType=='Private Individual' || selectedClientType=='Individual' || selectedClientType=='Sole Proprietor' || selectedClientType=='Sole Trader' || selectedClientType ==''  || selectedClientType == undefined){

            component.set("v.isUpdateRelatedParty", true);
            component.set("v.editedAccountId",selectedAccountRecordId);
            helper.fetchAccDetails(component,selectedAccountRecordId);
            var objCompB = component.find('addressComp');
            if(objCompB != undefined){
                objCompB.getAccountId(selectedAccountRecordId);

            }

            //Added by chandra dated 02/08/2020
            var selectedRole = component.get("v.selectedRole");
            if(selectedRole.includes("Shareholder/Controller") || selectedRole.includes("Members/Controllers") || selectedRole.includes("Named Beneficiaries") || selectedRole.includes("Trustees") || selectedRole.includes("Partner/Controller")){
                component.find("editSharePercent").set("v.disabled", false);
            }

        }
        //Diksha Wasekar: Added for non-individual related parties commented to switch off Complex
        else {
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
        var processType = component.get("v.processTypeP");
        var editedAccount = component.get("v.editedAccount");
        var roles = component.get("v.selectedRole");
        var flag = false;

        if(processType != 'Surety Onboarding') {

            editedAccount.Country_of_Citizenship__c = component.get("v.countryOfCitizenShip");


            if(roles != null && roles != '' && roles != undefined &&
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
            if(roles.includes('Operators')){
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
        }

            var parentId = component.get("v.parentId");
            var selectedOptionValue = component.get("v.selectedRole");//Added by chandra dated 02/08/2020
            if(component.get('v.processTypeP')!='Lite Onboarding'){//Anka - component error fix
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
        }
        //TdB - Validate Operating Role
        var isOperatingRoleVal = component.get("v.isOperatingRole");
     if(component.get('v.processTypeP')!='Lite Onboarding'){// Anka -component error fix
        if(isOperatingRoleVal == true && (!editedAccount.Operating_Roles__c || editedAccount.Occupation_Status__pc == null || editedAccount.Occupation_Status__pc == undefined || editedAccount.Occupation_Status__pc == '')){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please complete Occupation and Operating Role",
                "type":"error"
            });
            toastEvent.fire();
            return;
        }
    }
         //TdB - Validate Tem Resident Fields
        var isShowTempResidentSection = component.get("v.showTempResidentSection");
        if(isShowTempResidentSection == true && (!editedAccount.Country_of_Permanent_Residency__c || !editedAccount.Purpose_of_Visit__c || !editedAccount.Date_of_Arrival_in_South_Africa__c || !editedAccount.Period_of_Visit__c )){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please complete all fields required for Temporary Resident",
                "type":"error"
            });
            toastEvent.fire();
            return;
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
            } else if(selectedOptionValue.includes("Partner/Controller") && 
            (component.find("editSharePercent").get("v.value") == '' || component.find("editSharePercent").get("v.value")=='0')){
            var toastEvent = $A.get("e.force:showToast");
            
            toastEvent.setParams({
                "title": "Error!",
                "message": "Share Percentage is required to fill when role  Partner/Controller is selected.",
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

        } //TdB - Surety Onboarding
        else {
            if(roles != null && roles != '' && roles != undefined &&
               editedAccount.ID_Number__pc != null && editedAccount.ID_Number__pc != '' && editedAccount.ID_Number__pc != undefined &&
               editedAccount.ID_Type__pc != null && editedAccount.ID_Type__pc != '' && editedAccount.ID_Type__pc != undefined &&
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
            var parentId = component.get("v.parentId");
            var selectedOptionValue = component.get("v.selectedRole");//Added by chandra dated 02/08/2020

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
        var placeofResValue = component.find("placeOfResidenceId").get("v.value");
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
                    ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                    placeofResValue: component.find("placeOfResidenceId").get("v.value")
                }
            });
        } else {
            console.log("accId : " + accId);
            evt.setParams({
                componentDef: "c:OnboardingIndividualClientDetails",
                componentAttributes: {
                    accRecordId: accId,
                    IdentityNumber: searchValue, // PJAIN: 202003401
                    ProcessName: processName, // 20200312: Prashant Jain and Tinashe Shoko: Merchant Onboarding
                    placeofResValue: component.find("placeOfResidenceId").get("v.value"),
                    clientGroupValue: component.find("clientGroupId").get("v.value"),	//W-005563- Manoj- 0914202 - Single New Prospect button design
                    clientTypeValue: component.find("clientTypeId").get("v.value"),		//W-005563- Manoj- 0914202 - Single New Prospect button design
                    placeofResValue: component.find("placeOfResidenceId").get("v.value")
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
                        component.get("v.accountSelected.Client_Type__c") ==
                         "Joint & Several" ||
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
        var selectedJob = component.get("v.jobname");
        if(selectedJob.Service_Type__r != null){
            action.setParams({serviceTypeName : selectedJob.Service_Type__r.Name});
        }
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
    //create stokvel client
    createStokvelClient: function(component, event, helper) {
        helper.showSpinner(component);
        const globalId = component.getGlobalId();
        console.log('Saving information before proceeding to stokvel Entity information');
        var phoneNumber = component.find("iClientPersonMobilePhone").get("v.value");
        var regularExpression = new RegExp('^[0-9]{10}$');
        if(phoneNumber == null || !regularExpression.test(phoneNumber)) {
            helper.fireToast("Error", "Please enter a valid phone number. ", "error");
       }else{
            document.getElementById(globalId + '_phone_submit').click();
       }
    },
    handleStokvelSubmit: function (component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var phone = component.find("iClientPersonMobilePhone").get("v.value"); 
        var mobPattern = '[0]{1}[678]{1}[0-9]{8}';
        if( !phone.match(mobPattern)) 
        {
            eventFields["Phone"] ='';
            eventFields["Employer_Phone__c"] = phone;
        }
        else
        {
            eventFields["Employer_Phone__c"] = '';
             eventFields["Phone"] = phone;
        }
        eventFields["Valid_Update_Bypass__c"] = true;
        component.find("iCreateStokvelClient").submit(eventFields);
    },
    //handle submit for stokvel
    handleSuccess : function(component, event, helper) {
        helper.hideSpinner(component);
        var newAccount = event.getParams().response;
        console.log('newAccount: ' + newAccount);
        console.log('newAccount: ' + JSON.stringify(newAccount));
        console.log('newAccount id: ' + newAccount.id);
        var selectedJob = event.getParam("selectedJob");
        var StokvelSearch = component.find("iSearchValue").get("v.value");
        var Lstname = component.find("iClientLastName").get("v.value");
        var Firtname = component.find("iClientFirstName").get("v.value");
        var mobile = component.find("iClientPersonMobilePhone").get("v.value");

                var navService = component.find('navService');
                var pageReference = {
                    type: 'standard__recordPage',
                    attributes: {
                        recordId:  newAccount.id,
                        objectApiName: "Account",
                        actionName: 'view'
                    }
                }
                navService.navigate(pageReference);
    },
    //handle submit for stokvel
    // handleSubmit : function(component, event, helper) {
    //     helper.showSpinner(component);
    // },
    //handle submit for stokvel
    handleError : function(component, event, helper) {
        helper.hideSpinner(component); //hide the spinner
        var componentName = 'iCreateStokvelClient';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "There has been an error saving the data.", "error");
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
    var userProfileName = component.get("v.loggedinUserProfile"); //added by Short term Insurance
        //** TdB - Validation section **
        //Individual Prospect
        if (isIndvProspect == true) {
            accountRecord = component.get("v.newIndivProspect");

            if (
                !accountRecord.FirstName ||
                !accountRecord.LastName && (userProfileName != 'Standard User (Contact Centre)' || userProfileName != 'Standard User (Personal Lines Insurance)')
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

        //Added by Short Term Insurance
        if (userProfileName == 'Standard User (Contact Centre)' || userProfileName == 'Standard User (Personal Lines Insurance)') {
            if (
                !accountRecord.FirstName ||
                !accountRecord.Client_Creation_Reason__c ||
                !accountRecord.ID_Type__c ||
                !accountRecord.ID_Number__pc ||
                !accountRecord.PersonBirthdate ||
                !accountRecord.LastName) {

                var toast = helper.getToast(
                    "Required fields",
                    "Please complete all required fields indicated with a red asterisk (*)",
                    "Error"
                );
                helper.hideSpinner(component);
                toast.fire();
                return null;
            }
        }

    } //khaliq added
        else if (isBranchIndvProspect == true) {
        accountRecord = component.get("v.newIndivProspect");
        isIndvProspect = isBranchIndvProspect;
        var mobPattern = '[0]{1}[678]{1}[0-9]{8}';
        var namePatternNotNumonly= '^[0-9 ]*$';

        if (
        !accountRecord.FirstName || accountRecord.FirstName.match(namePatternNotNumonly)||
         !accountRecord.LastName || accountRecord.LastName.match(namePatternNotNumonly)

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
        var addressRecord = component.get("v.newAddressRecord");
        //Setting the Apex Parameter
        action.setParams({
            newAccountRecord: accountRecord,
            isIndividualProspect: isIndvProspect,
            isBusinessProspect: isbusniessprspct,
            addressRec : addressRecord
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
        var flag = false;
        var personAccRecord = component.get("v.newIndivProspect");
         var addressRecord = component.get("v.newAddressRecord");
        var Lastname = component.find("iClientLastName").get("v.value");

        if(processTypeLite != 'Surety Onboarding') {
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

            if(processTypeLite!='Lite Onboarding'){
            var title = component.find("iClientPersonTitle").get("v.value");
                if(personAccRecord.PersonBirthdate != null && personAccRecord.PersonBirthdate != '' && personAccRecord.PersonBirthdate != undefined &&
                   personAccRecord.Country_of_Citizenship__c != null && personAccRecord.Country_of_Citizenship__c != '' && personAccRecord.Country_of_Citizenship__c != undefined &&
                   addressRecord.Shipping_City__c != null &&  addressRecord.Shipping_City__c != '' &&
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

                    //TdB - Validate Operating Role
                    var isOperatingRoleVal = component.get("v.isOperatingRole");
                if(component.get('v.processTypeP')!='Lite Onboarding'){// Anka -component error fix
                    if(isOperatingRoleVal == true && (!accountRecord.Operating_Roles__c || accountRecord.Occupation_Status__pc == null || accountRecord.Occupation_Status__pc == undefined || accountRecord.Occupation_Status__pc == '')){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please complete Occupation and Operating Role",
                            "type":"error"
                        });
                        toastEvent.fire();
                        return;
                    }
                }
                     //TdB - Validate Tem Resident Fields
                    var isShowTempResidentSection = component.get("v.showTempResidentSection");
                    if(isShowTempResidentSection == true && (!accountRecord.Country_of_Permanent_Residency__c || !accountRecord.Purpose_of_Visit__c || !accountRecord.Date_of_Arrival_in_South_Africa__c || !accountRecord.Period_of_Visit__c )){
                      var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "message": "Please complete all fields required for Temporary Resident",
                            "type":"error"
                        });
                        toastEvent.fire();
                        return;
                    }
                }
            }

            //Added by chandra to validate share Percentage is not blank when "Shareholder/Controller" role is selected
            if (isRelatedParty == true) {
                var selectedOptionValue = component.get("v.selectedRole");
                if((selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers") || selectedOptionValue.includes("Partner/Controller"))&& 
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
            if(component.get('v.processTypeP')!='Lite Onboarding'){// Anka -component error fix
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
        }
            //TdB - Surety Onboarding
        } else {
            if((personAccRecord.Phone != null && personAccRecord.Phone != '' && personAccRecord.Phone != undefined) || (personAccRecord.PersonEmail != null && personAccRecord.PersonEmail != '' && personAccRecord.PersonEmail != undefined)){
                flag = true;
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

                    //Set place for residence
                    accountRecord.Place_of_Residence__c =  component.get("v.placeOfResidence");

                    //Calling the Apex Function
                    var action = component.get("c.createNewClient");

                    //Setting the Apex Parameter
                    action.setParams({
                        newAccountRecord: accountRecord,
                        isRelatedParty: isRelatedParty,
                        addressRec : addressRecord
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
        component.set("v.isRemediateExistingCustomer", false);
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
        component.set("v.isSICCodeChange", false); //W-013580
        //Clear Client and Product Beans
        component.set("v.clientDetailsBean", null);
        component.set("v.MDMclientDetailsBean", null);
        component.set("v.clientParticipantsBean", null);
        //component.set("v.newIndivProspect", "");
        component.set("v.editedAccount", "");
        component.set("v.accountSelected", "");

        //###Increment methods
        var actionIncrementCount = component.get("c.incrementCount");
        var actionValidateId = component.get("c.validateId");
        var counterTemp = component.get("v.currentCount");
        var counterIncrement = counterTemp + 1;
        var counterLimit = component.get("v.clientSearchLimit");


        //André Added method W-006950
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
                component.set("v.isLimitReached", true);
                counterIncrement = 1;
                helper.hideSpinner(component);
                toastEvent.fire();
                return;
            }
        });

        if (selectedSearchType == 'ID Number') {
            $A.enqueueAction(actionValidateId);
        }

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
        component.set("v.isRemediateExistingCustomer", true);
        component.set("v.isNewSPMOpportunity", true);
        component.set("v.isNewProductOpportunity", true);
        component.set("v.isNewCPFOpportunity", true);
        component.set("v.isSICCodeChange", true); //W-013580

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
                component.set("v.isBranchLinkingSelected", true);
                if(!$A.util.isUndefinedOrNull(selectedAccount.RecordTypeId) && selectedAccount.RecordTypeId != ""){
					console.log("selectedAccount.RecordTypeId: " + selectedAccount.RecordTypeId);
					component.set("v.selectedAccountRecordTypeId" , selectedAccount.RecordTypeId);
                    component.set("v.selectedAccountRecordTypeName" , selectedAccount.RecordType.Name);
				}
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

            component.set("v.disableAddRelatedPartyBtn", false);
        }

        //Show and hide Proceed to onboarding buttons
        var businessOnboardBtn = component.get(
            "v.showCreateBusinessProspectOnboarding"
        );
        var individualOnboardBtn = component.get(
            "v.showCreateIndividualProspectOnboarding"
        );
        var StokvelProspectOnboardingBtn = component.get(
            "v.showCreateStokvelProspectOnboarding"
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

        var showBranchCreateIndividualProspectOnboarding = component.get(
            "v.showBranchCreateIndividualProspectOnboarding"
        );
        if(showBranchCreateIndividualProspectOnboarding){
            component.set('v.consentVal', '');
            component.set("v.isSelectionConfermed", false);
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
                        (indivClientIdentifier == false &&
                        selectedAccount.Client_Type__c == "JOINT & SEVERAL")
                        ||
                        (indivClientIdentifier == false &&
                          selectedAccount.Client_Type__c == "Joint & Several")
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
                var error = action.getError();
                var toast = helper.getToast("Error", 'Credit Opportunity could not be created '+ error[0].message +' Please contact your Salesforce Admin', "error");
                toast.fire();

                helper.hideSpinner(component);
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    
    //TdB - Create new Credit Opprotunity
    createComplexCreditOpportunity: function(component, event, helper) {
        
        helper.showSpinner(component);
        
        //Get logged in User details
        var action = component.get("c.createNewComplexCreditOpportunity");
        
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
                    var toast = helper.getToast("Error", 'Complex Credit Opportunity could not be created. Please contact your Salesforce Admin', "error");
                    
                    toast.fire();
                }
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                var error = action.getError();
                 var toast = helper.getToast("Error", 'Complex Credit Opportunity could not be created '+ error[0].message +' Please contact your Salesforce Admin', "error");
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
        var processType = component.get('v.processTypeP');
        var selectedOptionValue = event.getParam("value");
        if(processType != 'Surety Onboarding') {
            if(selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers") || selectedOptionValue.includes("Trustees") || selectedOptionValue.includes("Named Beneficiaries") || selectedOptionValue.includes("Partner/Controller")){
                component.find("iSharePercentage").set("v.disabled", false);
            }
            else{
                component.find("iSharePercentage").set("v.value", "");
                component.find("iSharePercentage").set("v.disabled", true);
            }

             //TdB - Set Participant Indicator
             if(selectedOptionValue.includes("Participant")) {
                component.set('v.isParticipant', true);
                component.set('v.newIndivProspect.Client_Group__c', 'Individual');
             } else {
                 component.set('v.isParticipant', false);
             }

             //TdB - Set Occupation section to show based on Role
            if(selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)") || selectedOptionValue.includes("Operators on primary accounts (Internet Main Users,Signatories,Card users)")) {
                component.set('v.isOperatingRole', true);
            } else {
                component.set('v.isOperatingRole', false);
            }
        }
    },


    /****************@ Author: Chandra*****************************************************
 	****************@ Date: 02/08/2020*****************************************************
 	****************@ Work Id: W-004939****************************************************
 	***@ Description: Method Added by chandra to handle Roles selection while update*******/
    handleRoleChange : function(component, event, helper) {
        var processType = component.get('v.processTypeP');
        var selectedOptionValue = event.getParam("value");
        if(processType != 'Surety Onboarding') {
            if(selectedOptionValue.includes("Shareholder/Controller") || selectedOptionValue.includes("Members/Controllers") || selectedOptionValue.includes("Trustees") || selectedOptionValue.includes("Named Beneficiaries") || selectedOptionValue.includes("Partner/Controller")){
                component.find("editSharePercent").set("v.disabled", false);
            }
            else{
                component.find("editSharePercent").set("v.value", "");
                component.find("editSharePercent").set("v.disabled", true);
            }

            //TdB - Set Participant Indicator
            if(selectedOptionValue.includes("Participant")) {
                component.set('v.isParticipant', true);
                component.set('v.newIndivProspect.Client_Group__c', 'Individual');
            } else {
                component.set('v.isParticipant', false);
            }

            //TdB - Set Occupation section to show based on Role
            if(selectedOptionValue.includes("Operators on primary accounts ( Internet Main Users, Signatories, Card Users)") || selectedOptionValue.includes("Operators on primary accounts (Internet Main Users,Signatories,Card users)")) {
                component.set('v.isOperatingRole', true);
            } else {
                component.set('v.isOperatingRole', false);
            }
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

        //TdB - Set Participant Indicator
        if(selectedOptionValue.includes("Participant")) {
            component.set('v.isParticipant', true);
            component.set('v.newIndivProspect.Client_Group__c', 'Individual');
        } else {
            component.set('v.isParticipant', false);
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
        
        var selectedJob = component.get("v.jobname");
        var clientDetails = component.get("v.accountSelected");
        var accId = component.get("v.accountId");
        
        /* Modified on 23rd August 2021 - Sandeep Golla
         * Before proceeding to Account Protability,
         *  1.If service job doesn't require FIC refresh then proceed with creating a respective service job
         *  2.If service job require FIC refresh then check whether customer is Complaint and Not Complaint.
         *    2.1. If Complaint the proceed with creating the actual service job.
         *    2.2. If not complaint then create a FIC refresh case not the actual service job.
         */
        var complianceStatus;
        if(!selectedJob.FIC_Refresh_Required__c || accId == undefined){
            helper.navigateToOnboardingBigFormHelper(component);
        }
        else if (selectedJob.FIC_Refresh_Required__c){
            
            component.set("v.showSpinner", true);
            var action = component.get("c.checkComplianceStatus");
            action.setParams({
                "accId": accId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    console.log('Compliance Response----'+JSON.stringify(data));
                    if(data != null && data.complianceStatus && data.message == null){
                        complianceStatus = data.complianceStatus;
                        component.set("v.complianceStatus",data.complianceStatus);
                        
                        if(complianceStatus.toLowerCase() === 'compliant'){
                            component.set("v.showSpinner", false);
                            helper.navigateToOnboardingBigFormHelper(component);
                        }
                        else if(complianceStatus.toLowerCase() === 'partialcompliant' || complianceStatus.toLowerCase() === 'noncompliant' || complianceStatus.toLowerCase() === 'unknown'){
                            component.set("v.showSpinner", false);
                            helper.getExistingFICRefreshCase(component, event, helper);
                        }
                            else {
                                component.set("v.showSpinner", false);
                                helper.getExistingFICRefreshCase(component, event, helper);
                            }
                    }
                    else if(data != null && data.message != null){
                        component.set("v.showSpinner", false);
                        var toast = helper.getToast("info", data.message, "Compliance Pack Service");
                        toast.fire();
                    }
                        else{
                            component.set("v.showSpinner", false);
                            var toast = helper.getToast("info", "There is no data found for this Account", "Compliance Pack Service");
                            toast.fire();
                        }
                }
                else{
                    console.log("Failed with state: " +state);
                    component.set("v.showSpinner", false);
                    var errors = response.getError();
                    var toast = helper.getToast("error", errors[0].message , "Compliance Pack Service");
                    toast.fire();
                }
            });
            $A.enqueueAction(action);
        }
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
                      console.log('in success block'+response.getReturnValue());
                      toast.fire();
                  }

                  helper.hideSpinner(component);

              }else if(state === "ERROR"){
                var error = action.getError();
                console.log('in failure block'+error[0].message);
                var toast = helper.getToast("Error", 'Credit Opportunity could not be created'+ error[0].message +' Please contact your Salesforce Admin', "error");
                  toast.fire();
                  helper.hideSpinner(component);
              }
          });

          // Send action off to be executed
          $A.enqueueAction(action);
      },

      TitlesAndIDSubmit: function(component, event, helper){
        component.set('v.BranchLoading', true);
        event.preventDefault();
        var titles = component.get("v.BranchPersonTitle");
        var eventFields = event.getParam('fields');
        eventFields['Titles__pc'] = titles;
        eventFields['ID_Type__pc'] = "SA Identity Document";
        eventFields['Valid_Update_Bypass__c'] = true;
        var recordEditForm = component.find("Branch_personal_Individual");
        recordEditForm = Array.isArray(recordEditForm) ? recordEditForm[0] : recordEditForm;
        recordEditForm.submit(eventFields);
    },

    TitlesAndIDLoaded: function(component, event, helper) {
        helper.showSpinner(component);
        var payload = event.getParam('recordUi');
        var personTitle = payload.record.fields['Titles__pc'].value;
        component.set('v.BranchPersonTitle', personTitle);
        helper.hideSpinner(component);
    },

    TitlesAndIDSuccess: function(component, event, helper) {
        if ($A.util.isUndefinedOrNull(component.get("v.accountSelected.ID_Number__pc"))) {
            component.set('v.errorMessage', 'accountSelected.ID_Number__pc is Undefined or Null');
			component.set('v.showTitleError', true);
        } else {
            var promise = helper.exeUpdateCreateAccountWithCIF(component, helper)
            .then(
                $A.getCallback(function(result) {
                    helper.navigate(component);
                }),
                $A.getCallback(function(error) {
                    component.set('v.BranchLoading', false);
                    alert(error);
                })
            )
            }
    },

    TitlesAndIDError: function(component, event, helper) {
        component.set('v.BranchLoading', false);
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        alert('Error: ' + JSON.stringify(eventDetails));
    },

    // Handler for BranchProductOnboarding button - Sync with CIF and initiate flow
    handleStartProductOnboarding : function(component, event, helper){
        var cienttype = component.get("v.accountSelected.Client_Type__c").toUpperCase();
        if(cienttype == "INDIVIDUAL" || cienttype == "INDIVIDUAL CLIENT" || cienttype == "STAFF"){
        var globalId = component.getGlobalId();
        var titles = component.get("v.BranchPersonTitle");
        var SelectedAccount = component.get('v.accountSelected.Id');
        if((!$A.util.isUndefinedOrNull(SelectedAccount)) ){
            if (($A.util.isUndefinedOrNull(titles)) || (titles == '') ) {
                component.set('v.errorMessage', 'Title not selected.');
                component.set("v.showTitleError", true);
            } else {
                document.getElementById(globalId + 'branch_personal_Individual_submit').click();
                }
        }else {
            var promise = helper.exeUpdateCreateAccountWithCIF(component, helper)
            .then(
                $A.getCallback(function(result) {
                    helper.navigate(component);
                }),
                $A.getCallback(function(error) {
                    component.set('v.BranchLoading', false);
                    alert(error);
                })
            );
        }
    }else{
        var toast = helper.getToast("Please Note", "This process is only available for Individual client groups");
        toast.fire();
    }
    },
    //start link
    handleStartLink : function(component, event, helper){
        var globalId = component.getGlobalId();
        var SelectedAccount = component.get('v.accountSelected.Id');
       // if(($A.util.isUndefinedOrNull(SelectedAccount)) ){
            // document.getElementById(globalId + 'branch_personal_Individual_Link_submit').click();
            var promise = helper.exeUpdateCreateAccountWithCIF(component, helper)
            .then(
                $A.getCallback(function(result) {
                    helper.navigateLink(component);
                }),
                $A.getCallback(function(error) {
                    component.set('v.BranchLinkLoading', false);
                    alert(error);
                })
            	)
           // }
    },

    LinkSubmit: function(component, event, helper){
       // component.set('v.BranchLinkLoading', true);
       // event.preventDefault();
        //   var titles = component.get("v.BranchPersonTitle");
        // var eventFields = event.getParam('fields');
        //eventFields['Titles__pc'] = titles;
        // eventFields['ID_Type__pc'] = "SA Identity Document";
        var recordEditForm = component.find("Branch_personal_Individual_Link");
        recordEditForm = Array.isArray(recordEditForm) ? recordEditForm[0] : recordEditForm;
       // recordEditForm.submit(eventFields);
        recordEditForm.submit();
    },

    handleStartDelink : function(component, event, helper) {

        let cif = component.get('v.accountSelected').CIF__c;

        if (!cif) {
            let noCifToast = $A.get("e.force:showToast");

            noCifToast.setParams({
                title: "Error",
                type: "error",
                message: "The CIF (CIF__c) field of current Account is blank!"
            });
            noCifToast.fire();

            return;
        }

        let idNumber = component.get('v.accountSelected').ID_Number__pc;

        if (!idNumber) {
            let noIdNumberToast = $A.get("e.force:showToast");

            noIdNumberToast.setParams({
                title: "Error",
                type: "error",
                message: "The ID Number (ID_Number__pc) field of current Account is blank!"
            });
            noIdNumberToast.fire();

            return;
        }

        var evt = $A.get("e.force:navigateToComponent");

        let eventParams = {
            componentDef : "c:delinkingContainer",             
            componentAttributes: {
                clientKey: cif
            }
        };

        let accountId = component.get('v.accountSelected').Id;
        if (accountId) {
            eventParams.componentAttributes.accountId = accountId;
        }
        if (idNumber) {
            eventParams.componentAttributes.idNumber = idNumber;
        }

        evt.setParams(eventParams);

        evt.fire();
    },

    confirmSelectionLink: function(cmp, evt) {
        var selected = cmp.get("v.consentVal");
        cmp.set("v.showLinkingButton", true);
        cmp.set("v.isConsentSelected", selected);
        cmp.set("v.isSelectionConfermed", true);
        var idSelected = cmp.get("v.accountSelected.ID_Number__pc");
    },

     TitlesAndIDLoadedLink: function(component, event, helper) {
        //var payload = event.getParam('recordUi');
       // var personTitle = payload.record.fields['Titles__pc'].value;
        //component.set('v.BranchPersonTitle', personTitle);
        helper.hideSpinner(component);
    },

    TitlesAndIDSuccessLink: function(component, event, helper) {
        if ($A.util.isUndefinedOrNull(component.get("v.accountSelected.ID_Number__pc"))) {
            component.set('v.errorMessage', 'accountSelected.ID_Number__pc is Undefined or Null');
			component.set('v.showTitleError', true);
        } else {
            var promise = helper.exeUpdateCreateAccountWithCIF(component, helper)
            .then(
                $A.getCallback(function(result) {
                    helper.navigate(component);
                }),
                $A.getCallback(function(error) {
                   // component.set('v.BranchLinkLoading', false);
                    alert(error);
                })
            )
        }
    },

    TitlesAndIDErrorLink: function(component, event, helper) {
       // component.set('v.BranchLinkLoading', false);
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        alert('Error: ' + JSON.stringify(eventDetails));
    },

    //link Submit end

     //TdB: display Reason for not providing SA TAX Number
    showReasonForTaxNA : function(component, event, helper){
        var reasonForTaxNA= component.find("reasonForTaxNA");
        if(event.getSource().get("v.checked") == false){
            component.set("v.showNoTaxReason", true);
        }else{
            component.set("v.showNoTaxReason", false);
        }

    },

    //TdB: display Country For Foreign Tax
    showCountryForeignTax : function(component, event, helper){
        var countryForeignTax= component.find("registeredForeignTax");
        if(event.getSource().get("v.checked") == true){
            component.set("v.showCountryForeignTax", true);
        }else{
            component.set("v.showCountryForeignTax", false);
        }

    },

    //TdB : display FAIS details
    handleCheckboxChange: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showFsp", true);
        }else{
            component.set("v.showFsp", false);
        }
    },

    handleChangeOperatingRole : function(component, event, helper) {
        var selectedOperatingRole = component.get("v.newIndivProspect.Operating_Roles__c");
        
        if(selectedOperatingRole.includes('Mandate & Indemnity User')) {
            component.set("v.isMandatIndemnityUser",true);
        } else {
            component.set("v.isMandatIndemnityUser",false);
        }
        
    },
    
    handleChangeEditOperatingRole : function(component, event, helper) {
        var selectedOperatingRole = component.get("v.editedAccount.Operating_Roles__c");
        
        if(selectedOperatingRole.includes('Mandate & Indemnity User')) {
            component.set("v.isMandatIndemnityUser",true);
        } else {
            component.set("v.isMandatIndemnityUser",false);
        }
        
    },
    
     handleTempResidentSection: function (component, event, helper) {
        if(event.getSource().get("v.checked") == true){
            component.set("v.showTempResidentSection", true);
        }else{
            component.set("v.showTempResidentSection", false);
        }

    },

    // Added by Santosh Kumar 27/May/2021 for show Individual Customer Pop Modal to Create Person Account Record Work-Id-012428 -->
    createAccountRecord: function (component, event, helper) {

        var accRecord = component.get("v.newAccount");
        if (
            accRecord.FirstName == null ||
            accRecord.FirstName == "" ||
            accRecord.FirstName == undefined ||
            accRecord.LastName == null ||
            accRecord.LastName == "" ||
            accRecord.LastName == undefined ||
            accRecord.ID_Number__pc == null ||
            accRecord.ID_Number__pc == "" ||
            accRecord.ID_Number__pc == undefined ||
            accRecord.PersonMobilePhone == null ||
            accRecord.PersonMobilePhone == "" ||
            accRecord.PersonMobilePhone == undefined
        ) {
            var toastEvent = helper.getToast("Error!", "Required to fill all fields.", "Error");
            toastEvent.fire();
            return;
        } else {
            var action = component.get("c.createPersonAccount");
            action.setParams({
                acc: accRecord
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == "SUCCESS") {
                    var result = response.getReturnValue();
                    if (result.Id != null) {
                        component.set("v.accountId", result.Id);
                        component.set("v.selectedAccountRecordTypeId" , result.RecordTypeId);
                        component.set("v.selectedAccountRecordTypeName" , "Individual Prospect");
                    }
                    // Reset value to newAccount for not shwoing error fields getting 'null' or '' values after save record and recreate record
                    var newAccountResetValue = { sobjectType: "Account", FirstName: "", LastName: "", ID_Number__pc: "", PersonMobilePhone: "" };
                    component.set("v.newAccount", newAccountResetValue);
                    helper.getToast("Success!", "Prospect successfully created in Salesforce", "success"); 
                    component.set("v.showIndividualCustomerPopUP", false);
                    helper.callVoiceProductOnboardingFlow(component, event); // call Voice Sales Product Onboarding flow
                } else {
                    var message = "An error Occured while attempting to create Preospect" +JSON.stringify(response.getError());
                    helper.getToast("Success!", message, "error");
                }
            });
            $A.enqueueAction(action);
        }
    },

    //function executes when the Proceed to Sales Onboarding button is clicked
    handleSalesOnboarding: function (component, event, helper) {
        var selectedAccount = component.get("v.accountSelected");
        var accId = component.get("v.accountId");

        if(accId){
            helper.callVoiceProductOnboardingFlow(component, event);
        }else{

            //Prepoulate Fields
            component.set("v.newAccount.FirstName", selectedAccount.FirstName);
            component.set("v.newAccount.LastName", selectedAccount.LastName);
            component.set("v.newAccount.ID_Number__pc", selectedAccount.ID_Number__pc);
            component.set("v.newAccount.PersonMobilePhone", selectedAccount.PersonMobilePhone);
            component.set("v.showIndividualCustomerPopUP", true);

        }
    },


    //added for enquiry
    handleComponentEventWithAccountCreating: function(component, event, helper) {
        let handleComponentEvent = component.get('c.handleComponentEvent');
        let accountId = component.get("v.accountId");

        if (!$A.util.isUndefinedOrNull(accountId)) {
           $A.enqueueAction(handleComponentEvent);
        } else {
            helper.exeUpdateCreateAccountWithCIF(component, helper)
                .then(
                    $A.getCallback(function (result) {
                        $A.enqueueAction(handleComponentEvent);
                    }),
                    $A.getCallback(function (error) {
                        let toast = helper.getToast("Error", 'Something wrong with CIF', "error");
                        toast.fire();
                    })
                )
        }
    },
  
    //added for enquiry
    confirmSelectionLinkEnquiry: function(cmp, evt) {
        let selected = cmp.get("v.consentVal");
        cmp.set("v.disableCreateNewCaseButton", false);
        cmp.set("v.isConsentSelected", selected);
        cmp.set("v.isSelectionConfermed", true);
    },
    //Mohammed Junaid U Closure of Account W-010672 Starts
    accountClosureConfirmation: function(component, event, helper) {
        component.set("v.showAccountClosureConfirmation", false);
    },
    
    ficRefreshCreation : function(component, event, helper) {
        component.set("v.showAccountClosureConfirmation", false);
        helper.getExistingFICRefreshCase(component, event, helper);
    },
    
    proceedtoAccountClosure : function(component, event, helper) {
        var selectedJob = component.get("v.jobname");
        var accountId = component.get("v.accountSelected.Id");
        var accountRecord = component.get("v.accountSelected");
        var complianceStatus = component.get("v.complianceStatus");
        component.set("v.showAccountClosureConfirmation", false);
        helper.createCaseRecord(component,selectedJob,accountRecord,complianceStatus);
    },
    // W-010672 End -->
});