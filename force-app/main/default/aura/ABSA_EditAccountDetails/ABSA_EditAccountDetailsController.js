({
    
    doInit : function(component, event, helper) {
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        var accId = component.get("v.accRecordId");
        //alert(accId);
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Edit Client Details" 
            });
            
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:flow", 
                iconAlt: "Edit Client Details"
            });
        })
        
      //  helper.fetchPickListVal(component, 'Countries_Traded_With__c', 'countriesTraded');
        helper.ShowAll(component,event);
        
      //  component.set('v.clientType',component.get("v.accountRecord2.Client_Type__c"));
        helper.getEntityType(component,event,helper);
  
        
        component.set("v.accountRecord.Client_Type__c",'--None--');		//W-005999 - To set default Client Type on Big form
        //Show Big Form if Client already exist in Salesforce, User have the option to call Golden Sources still
        if(!accId) {
           // helper.populateBusinessProspectRecordTypeId(component); // PJAIN: 20200327
        } else {
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            
        }
        
        
        
    },
    saveRecord : function(component, event, helper){
 
      component.find("recordNewAccount").submit();
	 // component.find('recordViewForm22').submit(eventFields);
    
    },
        saveRecord1 : function(component, event, helper){
    
      component.find("recordViewForm22").submit();
           
        
    },
     updateCIF : function(component, event, helper){
        //this.showSpinner(component);
        console.log("###########start the Service Call and Submit###########");
     //   component.find("recordNewAccount").submit();
        var AccId = component.get("v.recordId");
         console.log("AccountID : " + AccId);
       	helper.submitAccountDetailsCIF(component,event,helper);
       // this.hideSpinner(component);
       console.log("##########DONE CIF###########");
    },
     //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
        setSectionsToRender : function(component, event, helper){
        //Show Sole Trader sections
        var clientTypeValue = component.find("iClientType").get("v.value");
        var clientGroupValue = component.find("iClientGroup").get("v.value");
        console.log('clientTypeValue: ' + clientTypeValue);
        if(clientTypeValue == 'Sole Trader' || clientGroupValue == 'SOLE TRADER CLIENT') {
            component.set("v.isSoleTrader", true);
            //To Call Related Parties Components
           console.log("accRecordId2---->"+component.get('v.accRecordId'));
            var relatedP = component.find('relatedPartiesCmp');
            relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
        } else {
            component.set("v.isSoleTrader", false);
        }
        
        //TdB - To Call Trading as Name Components
        var tradingAsNameCmp = component.find('tradingAsNameComp');
        if(tradingAsNameCmp != null) {
            tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
        }
        
    },
    
    
    setClientTypeValue: function(component, event, helper) {
        
        component.set('v.clientType', component.find('clientType').get('v.value')); 
        component.set('v.clientType2', component.find('clientType').get('v.value')); 
        console.log('clientType : ' + component.get('v.clientType'));
        //TdB - To Call Business Address Components
        var objCompB = component.find('mainComp');
        objCompB.getAccountClientType(component.get('v.clientType'));
        
        //Added by chandra against W-004746
        var relatedP = component.find('relatedPartiesCmp');
        relatedP.getAccountClientType(component.get("v.clientType"));
        
        //Added by chandra against W-004746
        var uboStructure = component.find('uboListViewCmp');
        uboStructure.getAccountClientType(component.get("v.clientType"));
    },
    
    //Toggle Populate button
    showPopulateDetailsButton : function(component, event, helper){
        if (component.find('agreed').get('v.checked')) {
            component.set("v.goldenSourceConsentGiven", false);
            //$A.util.removeClass(component.find("populateDiv"), "slds-hide");
        }
        else {
            component.set("v.goldenSourceConsentGiven", true);
            //$A.util.addClass(component.find("populateDiv"), "slds-hide");
        }
    },
    
    //Button method to create Business Prospect Account
    proceedExperian : function(component, event, helper){
        helper.CreateBusinessAccount(component, event, helper);
    },
    
    closeExperianModal : function(component, event, helper){
        component.set("v.isExperianModalOpen",false);
    },
    
    openLimitedAccDetailsModal : function(component, event, helper){
      //  component.set("v.accountRecord.Registration_Number__c",  component.find("regNumberC").get("v.value"));
        component.set("v.showLimitedAccountInfoModal",true);
    },
    
   onChange: function(component, event) {
        
        var checkCmp = component.find("checkbox").get("v.value");
        console.log(JSON.stringify(checkCmp));
        component.set("v.accountRecord.share_information_to_third_party__c",  checkCmp);
        
    },
    
    closeLimitedAccDetailsModal : function(component, event, helper){
        component.set("v.showLimitedAccountInfoModal",false);
    },
    
    
    populateDetails : function(component, event, helper){ 
        if(!$A.util.isEmpty(component.find("regNumberC").get("v.value"))){
            //alert('INN');
            var cmpTarget = component.find('regNumberError');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
            
            var regNumber = component.find("regNumberC").get("v.value");
            var regNumberValue = regNumber.trim();
            var clientGrp = component.find("clientGroup2") != undefined ? component.find("clientGroup2").get("v.value") : '';
            component.set("v.clientGroup",clientGrp );
            //alert('2');
            component.set("v.clientType", component.find("idClientType2").get("v.value"));
            //alert('3');
            var placeOfRed = component.find("placeOfResidence") != null && component.find("placeOfResidence") != undefined ? component.find("placeOfResidence").get("v.value") : null;
            component.set("v.placeOfResidence", placeOfRed);
            
            //alert('4');
            var clientTyp = component.find("idClientType2").get("v.value");
            //alert('5');
            if(clientTyp != 'Private Company' && clientTyp != 'Close Corporation'){
                helper.showPrivateCompanyValidation(component, event, helper);
            } else{
                if(regNumberValue != null && (clientTyp =='Private Company' && regNumberValue.endsWith("07")) || (clientTyp =='Close Corporation' && regNumberValue.endsWith("23"))) {
                    if(placeOfRed!=''){
                        helper.callExperianService(component, event, helper);    
                    } else{
                        var toastEvent = helper.getToast("Onboarding Exception", "Please fill all required fields", "error");
                        toastEvent.fire();
                    }
                    
                    
                    //$A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
                    component.set('v.columns',[
                        {label: 'Document Type', fieldName: 'documentType', type: 'text'},
                        {label: 'Required', fieldName: 'required', type: 'text'},
                        {label: 'Status', fieldName: 'status', type: 'text'},
                        {label: 'Version', fieldName: 'version', type: 'text'},
                        {label: 'Last Updated', fieldName: 'lastUpdated', type: 'text'},
                        {label: 'Updated By', fieldName: 'updatedBy', type: 'text'}
                    ]);
                    
                }
                else {
                    if(clientTyp =='Private Company'){
                        var toastEvent = helper.getToast("Onboarding Exception", "You are only allowed to Onboard Pty Ltd", "error");
                        toastEvent.fire();
                    }else{
                        var toastEvent = helper.getToast("Onboarding Exception", "You are only allowed to Onboard Close Corporations", "error");
                        toastEvent.fire();   
                    }
                }
            }
            
        } else {
            var cmpTarget = component.find('regNumberError');
            $A.util.addClass(cmpTarget, 'slds-has-error');
            //component.find("agreed").set("v.checked", false);
        }
    },
    
    //Function to submit RecordEditForm
    handleOnSubmit : function(component, event, helper) {
        console.log('INN');
        event.preventDefault();
        //Newly added by Rajesh to validate Share Percentage
        var relatedPartiesCmp  = component.find("relatedPartiesCmp").get("v.data");
        var uboListViewCmp = component.find("uboListViewCmp").get("v.gridData");
        console.log('uboListViewCmp '+JSON.stringify(uboListViewCmp));
        var sharePercentage = 0;
        var isCountryOfCitizenShipBlank = false;
        var relatedPartiesRoles = []; //Added by chandra against W-004746
        var selectedRoles; //Added by chandra against W-004746
        
        var childSharePercentage = 0;
        for(var i in uboListViewCmp){
            var children = uboListViewCmp[i]._children;
            for(var j in children){
                if(children[j].accType == 'AccountAccount'){
                    childSharePercentage += Number(children[j].ParentShareholding);
                }
            }
        }
        if(relatedPartiesCmp != null && relatedPartiesCmp != undefined){
            for(var i in relatedPartiesCmp){
                sharePercentage += Number(relatedPartiesCmp[i].SharePercentage);
                if(relatedPartiesCmp[i].CountryOfCitizenship == '' ||  relatedPartiesCmp[i].CountryOfCitizenship == undefined || relatedPartiesCmp[i].CountryOfCitizenship == null){
                    isCountryOfCitizenShipBlank = true;
                }
                var roles = relatedPartiesCmp[i].Roles.split(";");//Added by chandra against W-004746
                relatedPartiesRoles.push(roles);//Added by chandra against W-004746
            }
        }
        if(isCountryOfCitizenShipBlank){
            var toastEvent = helper.getToast("Error", "Please provide Country of Citizenship from Relationships.", "error");
            toastEvent.fire();
            return;
        }
        
        var clientType = component.find("clientType").get("v.value");
        /* if(clientType == 'Trusts'){
            var trustNumBigForm = component.find("trustNumBigForm").get("v.value");
            var trustNumFormatBigForm = component.find("trustNumFormatBigForm").get("v.value");
            if((trustNumBigForm == null || trustNumBigForm == undefined || trustNumBigForm == '') && (trustNumFormatBigForm == null || trustNumFormatBigForm == undefined || trustNumFormatBigForm == '')){
                var toastEvent = helper.getToast("Error", "Please fill Trust Number or Trust Number New format", "error");
                toastEvent.fire();
                return;
            }
        } */
        
        //Added by chandra to validate relatedParties Roles for Close Corporation against W-004746
        selectedRoles = relatedPartiesRoles.toString();
        
        if(clientType == 'Close Corporation' && (!selectedRoles.includes("Members/Controllers") 
                                                 || !selectedRoles.includes("Managing Director/Chief Executive Officer") 
                                                 || !selectedRoles.includes("Individual with Authority to Act")
                                                 || !selectedRoles.includes("Contact Person"))){
            var toastEvent = helper.getToast("Error", "Required to select Members/Controllers, Managing Director/Chief Executive Officer, Individual with Authority to Act, and Contact Person in Related Parties roles for Close Corporation", "error");
            toastEvent.fire();
            return;
        }
        
        if(clientType == 'Primary Company' && (!selectedRoles.includes("Shareholder/Controllers") 
                                                 || !selectedRoles.includes("Managing Director/Chief Executive Officer") 
                                                 || !selectedRoles.includes("Individual with Authority to Act")
                                                 || !selectedRoles.includes("Contact Person"))){
            var toastEvent = helper.getToast("Error", "Required to select Shareholder/Controllers, Managing Director/Chief Executive Officer, Individual with Authority to Act, and Contact Person in Related Parties roles for Close Corporation", "error");
            toastEvent.fire();
            return;
        }
        

        //End of changes by chandra
        
        
        
        console.log('sharePercentage '+sharePercentage);
        sharePercentage = Number(sharePercentage) + Number(childSharePercentage);
        console.log('childSharePercentage '+childSharePercentage);
        console.log('FINAL  '+sharePercentage);
        //alert(sharePercentage);
        if(sharePercentage > 100 || sharePercentage < 100){
            var toastEvent = helper.getToast("Error", "Share percantage must be 100%", "error");
            toastEvent.fire();
            return;
        }
        
        
        //Added by Himani to validate CountriesTradedWith and CountryOfOperation
        var CountriesTradedWith=component.find("CountriesTradedWith").get("v.value");
        var CountryOfOperation=component.find("CountryOfOperation").get("v.value");
        
        if(CountriesTradedWith.split(";").length >3 || CountryOfOperation.split(";").length >3)
        {
            
            console.log("ct"+CountriesTradedWith.split(";").length);
            console.log("co"+CountryOfOperation.split(";").length);
            var toastEvent = helper.getToast("Error", "CountriesTradedWith and  CountryOfOperation can have only 10 values", "error");
            toastEvent.fire();
        }
        
        
        else{
            console.log('=INSIDE relatedPartiesCmp==>'+JSON.stringify(relatedPartiesCmp));
            
            var eventFields = event.getParam("fields");
            console.log('=INSIDE handleOnSubmit==>'+JSON.stringify(eventFields));
            
            var validationSucceeded = helper.showValidations(component);      
            if (validationSucceeded) {
                console.log('-------SAVING FORM---------');
                component.find('recordViewForm22').submit(eventFields);
                component.set("v.proceedToOpp",true);
                //Updating CIF -- START
                var AccId = component.get("v.recordId");
         		console.log("AccountID : " + AccId);
       			helper.submitAccountDetailsCIF(component,event,helper);
                //Updating CIF -- END
                helper.hideSpinner(component);
                //Show Success Message
                var toastEvent1 = $A.get("e.force:showToast");
                toastEvent1.setParams({
                    "type": "success",
                    "title": "Success",
                    "message": "The record has been updated successfully in CIF."
                });
                toastEvent1.fire();
            } else {
                helper.hideSpinner(component);
                var toastEvent = helper.getToast("Error", "Please ensure that all fields are completed correctly.", "error");
                toastEvent.fire();
            }
        }
    },
    
    handleOnSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
         var AccId = component.get("v.recordId");
         console.log("AccountID : " + AccId);
       	helper.submitAccountDetailsCIF(component,event,helper);
        var toastEvent1 = $A.get("e.force:showToast");
        toastEvent1.setParams({
            "type": "success",
            "title": "Success",
            "message": "The record has been updated successfully in CIF."
        });
        toastEvent1.fire();
    },
    
    handleOnError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error",
            "message": "Something went wrong Please contact Administrator."
        });
        toastEvent.fire();
    },
    handleOnLoad : function(component, event, helper) {
        var clientType = component.find("clientType").get("v.value");
        component.set("v.clientType2",clientType);
        var placeOfRes = component.find("placeOfRes").get("v.value");
        //alert('placeOfRes '+placeOfRes);
        if(placeOfRes != null && placeOfRes != undefined && placeOfRes !=''){
            component.set("v.placeOfResidence",placeOfRes);
        }
    },
    
    navigateToRelatedAccount : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.accRecordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    //Function to create Opportunity
    createOpportunity_old : function(component, event, helper){
        var proceedToOppFlag = component.get("v.proceedToOpp");
        console.log('------proceedToOppFlag---------'+proceedToOppFlag);
        if(proceedToOppFlag){
            helper.showSpinner(component);
            var opportunityCreationAction = component.get("c.CreateOnboardingOpportunity");
            console.log('accountId : ' + component.get("v.accRecordId"));
            opportunityCreationAction.setParams({
                "accountId" : component.get("v.accRecordId")
            });
            
            // Add callback behavior for when response is received
            opportunityCreationAction.setCallback(this, function(response) {
                var state = response.getState();
                var message = '';
                if (component.isValid() && state === "SUCCESS") {
                    var opportunityRecordId = response.getReturnValue();
                    console.log('opportunityRecordId : ' + opportunityRecordId);
                    helper.closeFocusedTabAndOpenNewTab(component, opportunityRecordId);
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
            $A.enqueueAction(opportunityCreationAction);
        } else{
            var toastEvent = helper.getToast("Error", "Please fill out all fields", "error");
            toastEvent.fire();
        }
        
    },
    
    multiPicklistCountriesTradedChange: function(component, event, helper) {
        component.set("v.account.Countries_Traded_With__c", event.getSource().get("v.value"));
    },
    
    //Show Modal for Nature of Business 
    openNatureOfBusinessModal : function(component, event, helper) {
        component.set("v.showNatureOfBusinessModal", true); 
        // prepopulate industry on Nature of business based on selection on big form
      
   
        
        var clientType = component.get('v.clientType');
        if(clientType == 'Sole Trader'){
        console.log(component.find("industryBackgroud").get("v.value"));
        console.log(component.find("iSicCategory").get("v.value"));
            
        component.find("industryforNOB").set("v.value",component.find("industryBackgroud").get("v.value")); 
        component.find("sicCategoryforNOB").set("v.value",component.find("iSicCategory").get("v.value")); 
        }else if(clientType != 'Sole Trader'){
            var industryBackgroud1 = component.find("industryBackgroud1").get("v.value");
            console.log('industryBackgroud1' + industryBackgroud1);
            
            var iSicCategory1 = component.find("iSicCategory1").get("v.value");
            console.log('iSicCategory1' + iSicCategory1);
            
            component.find("industryforNOB").set("v.value",industryBackgroud1); 
            component.find("sicCategoryforNOB").set("v.value",iSicCategory1); 
        }
        
    },
    
    
    //Close Nature of Business Modal
    closeNatureOfBusinessModal: function(component, event, helper) {
        component.set("v.showNatureOfBusinessModal", false); 
    },
    
    //Generate Nature of Business data
    generateNatureOfBusiness: function(component, event, helper) {
        //load the static template
         var clientType = component.get('v.clientType');
        var descriptionString = $A.get("$Label.c.NatureOfBusinessTemplate");
        
        var str1 = descriptionString.replace("(1)",component.find("industryBackgroud").get("v.value") );
        var str2 = str1.replace("(2)",component.find("productServicesOffered").get("v.value") );
        var str3 = str2.replace("(3)",component.find("wholesaleRetail").get("v.value") );
        var str4 = str3.replace("(4)",component.find("numberofOpLocation").get("v.value") );
        var str5 = str4.replace("(5)",component.find("locationOfOpArea").get("v.value") );
        var str6 = str5.replace("(6)",component.find("numberOfClients").get("v.value") );
        var str7 = str6.replace("(7)",component.find("locationOfCusClients").get("v.value") );
        
        //check for export checkbox
        if (component.find("customerImports").get("v.value") == true){
            var importText = 'THE CLIENT IMPORTS SOURCE MATERIALS FROM: '+component.find("countriesImp").get("v.value");
            var str8 = str7.replace("(11)",importText );
            console.log('value of imports'+component.find("customerImports").get("v.value"));}
        else {
            var str8 = str7.replace("(11)","THE CLIENT IS NOT INVOLVED IN ANY IMPORTS. ."); 
        }
        
        //check for import checkbox
        if (component.find("customerExports").get("v.value") == true){
            var exportText = 'THE CLIENT EXPORTS TO THE FOLLOWING LOCATIONS: '+component.find("countriesExp").get("v.value");
            var str9 = str8.replace("(10)",exportText );
            console.log('value of export'+component.find("customerImports").get("v.value"));}
        else {
            var str9 = str8.replace("(10)","THE CLIENT IS NOT INVOLVED IN ANY EXPORTS. ."); 
        }
        //SET THE CALCULATED VALUE TO FIELD
        //
         if (clientType == 'Sole Trader'){
        component.find("NatureOfClient").set("v.value", str9.toUpperCase());
             component.set("v.showNatureOfBusinessModal", false); }
        
        else {component.find("NatureOfClient1").set("v.value", str9.toUpperCase());
             component.set("v.showNatureOfBusinessModal", false); }   
            
        
    },
    
    createOpportunity: function (component, event, helper) {
        var accId = component.get("v.accRecordId");
        var action = component.get("c.validateRelatedParties");
        var processName = component.get("v.ProcessName"); // PJAIN: 20200330
        
        action.setParams({
            "accountId": accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var error = response.getReturnValue();
                if (error != '') {
                    var toast = helper.getToast("Error", error, "error");
                    toast.fire();
                }
                else {
                    var proceedToOppFlag = component.get("v.proceedToOpp");
                    console.log('------proceedToOppFlag---------'+proceedToOppFlag);
                    if(proceedToOppFlag){
                        helper.showSpinner(component);
                        // PJAIN: 20200330: For Merchant Onboarding
                        if (processName === "MerchantOnboarding") {
                            var opportunityCreationAction = component.get("c.createMerchantOnboardingOpportunity");
                        }
                        // Haritha && Diksha : For SPM Onboarding
                        else if (ProcessName === "SPMOnboarding") {
                            var opportunityCreationAction = component.get("c.createSPMOnboardingOpportunity");
                        }
                            else {
                                var opportunityCreationAction = component.get("c.CreateOnboardingOpportunity");
                            }
                        console.log('accountId : ' + component.get("v.accRecordId"));
                        opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId")
                        });
                        
                        // Add callback behavior for when response is received
                        opportunityCreationAction.setCallback(this, function(response) {
                            var state = response.getState();
                            var message = '';
                            if (component.isValid() && state === "SUCCESS") {
                                var opportunityRecordId = response.getReturnValue();
                                console.log('opportunityRecordId : ' + opportunityRecordId);
                                helper.closeFocusedTabAndOpenNewTab(component, opportunityRecordId);
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
                        $A.enqueueAction(opportunityCreationAction);
                    } else{
                        var toastEvent = helper.getToast("Error", "Please fill out all fields", "error");
                        toastEvent.fire();
                    }
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    
    //display Reason for not providing SA TAX Number
    showReasonForTaxNA : function(component, event, helper){
        var reasonForTaxNA= component.find("reasonForTaxNA");
        if(event.getSource().get("v.checked") == false){
            component.set("v.showNoTaxReason", true); 
        }else{    
            component.set("v.showNoTaxReason", false); 
        }
        
    },
    
    renderHighRiskFields: function (component, event, helper) {
        //Get High Risk Idenstry selected value
        var highRiskInd = component.find("clientInvolved").get("v.value");
        console.log('highRiskInd : ' + highRiskInd)
        component.set("v.highIndustryValue", highRiskInd);
        
    },
    
    renderAgriFields: function (component, event, helper) {
        //Get High Risk Idenstry selected value
        var clientType = component.get('v.clientType');
        if(clientType == 'Sole Trader'){
            var sicCategory = component.find("iSicCategory").get("v.value");
            console.log('sicCategory : ' + sicCategory)
            component.set("v.sicCategoryValue", sicCategory);
        }
        else if(clientType != 'Sole Trader'){
        var sicCategory = component.find("iSicCategory1").get("v.value");
        console.log('sicCategory : ' + sicCategory)
        component.set("v.sicCategoryValue", sicCategory);
        }
        
    },
    
    //W-004493 - Manoj 07022020 New Design Business Prospect - Selecting Client Group, Client Type
    handleConsent: function (component, event, helper) {
        component.find("agreed").set("v.checked", false);
        var entityType = event.getSource().get('v.value');
        var goldenSourcesList = component.get("v.goldenSourceMappings");
        var entityMap;
        
        for(var ent in goldenSourcesList){
            if(entityType == goldenSourcesList[ent].Entity_Name__c )
                entityMap = goldenSourcesList[ent];
        }
        
        if(entityMap!=undefined && entityMap.Call_Golden_Source__c){
            component.set("v.disableConsentCheckbox", false);
        } else{
            component.set("v.disableConsentCheckbox", true);
        }
        
    },
    
    //TdB - W-004831 - Regulary Subsection for Q1
    regulatoryQ1SubSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ1SubSection", true); 
        }else{    
            component.set("v.showRegulatoryQ1SubSection", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q1
    regulatoryQ2SubSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ2SubSection", true); 
        }else{    
            component.set("v.showRegulatoryQ2SubSection", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q1
    regulatoryQ3SubSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ3SubSection", true); 
        }else{    
            component.set("v.showRegulatoryQ3SubSection", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q1
    regulatoryQ4SubSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ4SubSection", true); 
        }else{    
            component.set("v.showRegulatoryQ4SubSection", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q1a
    regulatoryQ1SubSection2: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ1SubSection2", true); 
        }else{    
            component.set("v.showRegulatoryQ1SubSection2", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q2b
    regulatoryQ2SubSection2: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ2SubSection2", true); 
        }else{    
            component.set("v.showRegulatoryQ2SubSection2", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q3c
    regulatoryQ3SubSection2: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ3SubSection2", true); 
        }else{    
            component.set("v.showRegulatoryQ3SubSection2", false); 
        }
    },
    
    //TdB - W-004831 - Regulary Subsection for Q4d
    regulatoryQ4SubSection2: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showRegulatoryQ4SubSection2", true); 
        }else{    
            component.set("v.showRegulatoryQ4SubSection2", false); 
        }
    },
    showBigForm : function(component, event, helper){
  		var accRecordDetails = component.get('v.accountRecord');
        var clientTypeVal = component.find("idClientType").get("v.value");
        
        console.log(accRecordDetails.FirstName);
        console.log(accRecordDetails.LastName);
        console.log(accRecordDetails.Client_Group__c);
        console.log(accRecordDetails.ID_Number__pc);
        console.log(clientTypeVal);
        console.log(accRecordDetails.Client_Type__c);
        
        if(!accRecordDetails.FirstName || !accRecordDetails.LastName || !accRecordDetails.Client_Group__c || !accRecordDetails.ID_Number__pc || !accRecordDetails.ID_Type__c || clientTypeVal == ''){
           // var toastEvent = helper.getToast("Error", "Please complete all required fields", "error");
           // toastEvent.fire();
        } else {
            helper.createProspectBasedOnPopup(component);        
            
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            setTimeout($A.getCallback(function() {
                component.set("v.activeSections", component.get('v.defaultActiveSections'));
            }));
            
            component.set("v.showLimitedAccountInfoModal",false);
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }
        
        
    }
})