({
    
    doInit : function(component, event, helper) {
        
        console.log('OnboardingClientDetails - processType : ' + component.get("v.processType"));
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        var accId = component.get("v.accRecordId");
        //alert(accId);
        workspaceAPI.getFocusedTabInfo().then(function(response) {
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
        })
        
        helper.fetchPickListVal(component, 'Countries_Traded_With__c', 'countriesTraded');
        
        //W-004493 - Manoj 07022020 New Design Business Prospect - Selecting Client Group, Client Type
        helper.goldenSourceMapping(component);
        
        component.set("v.activeSections", component.get('v.defaultActiveSections'));
        
        //Show Big Form if Client already exist in Salesforce, User have the option to call Golden Sources still
        if(!accId) {
            helper.populateBusinessProspectRecordTypeId(component); // PJAIN: 20200327
        } else {
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            //TdB - To Call Related Parties Components
            var relatedP = component.find('relatedPartiesCmp');
            if(relatedP != null) {
                 relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
            }

            //TdB - To Call Business Address Components
            var objCompB = component.find('mainComp');
            if(objCompB != null) {
                objCompB.getAccountId(component.get('v.accRecordId'));
            	objCompB.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));
            }

            //TdB - To Call Trading as Name Components
            var tradingAsNameCmp = component.find('tradingAsNameComp');
            if(tradingAsNameCmp != null) {
                 tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
            }
            
            //Added by Masechaba Maseli to call UBO List View
            var uboStructure = component.find('uboListViewCmp');
            if(uboStructure != null) {
                uboStructure.getOnboardingUBOAccountId(component.get('v.accRecordId'));
            }

        }
        console.log('Process Name : ' + component.get('v.ProcessName'));
        console.log('Process Type : ' + component.get('v.processType'));
        console.log('Selected Entity : ' + component.get('v.clientType2'));		//W-005563- Manoj- 0914202
        console.log('Selected Client Group: ' + component.get('v.clientGroup'));	//W-005563- Manoj- 0914202
        console.log('Selected Place of Residence: ' + component.get('v.placeOfResidence'));	//W-005563- Manoj- 0914202
        component.set('v.processNameP',component.get('v.processType'));
        
        if(component.get('v.processType')=='LiteToFullOnboarding'){
            component.set('v.showConsentSection',false);
            component.set('v.showRecordEditForm',true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            //component.set('v.accRecordId','0010E00000xKgzmQAC');
        }
        
        var processTypeVal = component.get('v.processType');
         //Surety Onboarding - Prepopulate Nature of Business
        if(processTypeVal == 'Surety Onboarding') {
            if(component.find("NatureOfClient") != undefined) {
                component.find("NatureOfClient").set("v.value", $A.get("$Label.c.NatureOfBusinessTemplate_Surety"));
            }
        }
        
        helper.getloggedinUserProfileName(component, event, helper);
        
        /*
        //Get logged in User details
        var action = component.get("c.getLoggedInUserDetails");
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var message;
            
            var state = response.getState();
            
            if (component.isValid() && state === "SUCCESS") {
                
                var userDetails = response.getReturnValue();
                console.log('Employee : ' + userDetails.EmployeeNumber);
                component.find("iIdentifiedByEmployeeNumber").set("v.value",  userDetails.EmployeeNumber)
                //var today = $A.localizationService.formatDate(new Date(), "DD-MMM-YYYY");
                //component.find("iIdentifiedByEmployeeNumber").set("v.value",  userDetails.EmployeeNumber)
                
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
        */
    },
    
    
    setClientTypeValue: function(component, event, helper) {
        
        component.set('v.clientType', component.find('clientType').get('v.value')) 
        component.set('v.clientType2', component.find('clientType').get('v.value')); 
        
        console.log('clientType : ' + component.get('v.clientType'));
        //TdB - To Call Business Address Components
        var objCompB = component.find('mainComp');
        if(objCompB != null) {
            objCompB.getAccountClientType(component.get('v.clientType'));
        }

        //Added by chandra against W-004746
        var relatedP = component.find('relatedPartiesCmp');
        if(relatedP != null) {
            relatedP.getAccountClientType(component.get("v.clientType"));
        }
        
        //Added by chandra against W-004746
        var uboStructure = component.find('uboListViewCmp');
        if(uboStructure != null) {
            uboStructure.getAccountClientType(component.get("v.clientType"));
        }
        
        setTimeout($A.getCallback(function() {
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }));
        
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
        component.set("v.accountRecord.Registration_Number__c",  component.find("regNumberC").get("v.value"));
        component.set("v.showLimitedAccountInfoModal",true);
        
        //Populating details from ClientFinder Entity Selection W-005633 - Manoj 09152020 
        component.set('v.accountRecord.Client_Group__c',component.get('v.clientGroup'));
        component.set('v.accountRecord.Client_Type__c',component.get('v.clientType2'));
        component.set('v.accountRecord.Place_of_Residence__c',component.get('v.placeOfResidence'));
        
    },
    
    closeLimitedAccDetailsModal : function(component, event, helper){
        component.set("v.showLimitedAccountInfoModal",false);
    },
    
    showBigForm : function(component, event, helper){
        
        var accRecordDetails = component.get('v.accountRecord');
        var isTrust = false;
        var isClub = false;
        var clientTypeVal = component.find("idClientType").get("v.value");
        if(clientTypeVal == 'Trusts'){
            accRecordDetails.Registration_Number__c = accRecordDetails.Trust_Number__c;
            isTrust = true;
            component.get('v.accountRecord',accRecordDetails);
        }

        if(clientTypeVal == 'Clubs/Societies/Associations/Other Informal Bodies' || clientTypeVal == 'Central Bank or Regulator' 
           || clientTypeVal == 'Non Profit Organizations (NGO)'
           || clientTypeVal == 'Schools' || clientTypeVal == 'Foreign Trust' || clientTypeVal == 'Central Bank or Regulator'){
            var accNameTemp = accRecordDetails.Name;
        	var regNoTemp = accRecordDetails.Registration_Number__c;
            accRecordDetails.Name = regNoTemp;
            accRecordDetails.Registration_Number__c = accNameTemp;
            isClub = true;
            component.get('v.accountRecord',accRecordDetails);
        }
        var idTypeVal = component.find("idIdType") != undefined ? component.find("idIdType").get("v.value") : '';
        console.log('clientTypeVal : ' + clientTypeVal);
        if(!accRecordDetails.Name || !accRecordDetails.Client_Group__c || clientTypeVal == ''|| (!isTrust && idTypeVal == '') || (isTrust && (accRecordDetails.Trust_Number_New_format__c == '' || accRecordDetails.Trust_Number__c == '') )){
            var toastEvent = helper.getToast("Error", "Please complete all required fields", "error");
            toastEvent.fire();
        } else {
            
            console.log('clientGroup : ' + accRecordDetails.Client_Group__c);
            
            
            component.set("v.clientGroup", accRecordDetails.Client_Group__c);
            component.set("v.clientType", component.find("idClientType").get("v.value"));
            component.set("v.clientType2", component.find("idClientType").get("v.value"));
            component.set("v.placeOfResidence", component.find("placeOfResidence2").get("v.value"));//accRecordDetails.Place_of_Residence__c);
            component.set("v.showRecordEditForm", true);
            
            helper.createProspectBasedOnPopup(component);  
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            setTimeout($A.getCallback(function() {
                component.set("v.activeSections", component.get('v.defaultActiveSections'));
            }));
            
            component.set("v.showLimitedAccountInfoModal",false);
        }
        
        var processTypeVal = component.get('v.processType');
         //Surety Onboarding - Prepopulate Nature of Business
        if(processTypeVal == 'Surety Onboarding') {
            if(component.find("NatureOfClient") != undefined) {
                component.find("NatureOfClient").set("v.value", $A.get("$Label.c.NatureOfBusinessTemplate_Surety"));
            }
        }
        
    },
    
    
    populateDetails : function(component, event, helper){
        if(!$A.util.isEmpty(component.find("regNumberC").get("v.value"))){
            var cmpTarget = component.find('regNumberError');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
            
            var regNumber = component.find("regNumberC").get("v.value");
            var regNumberValue = regNumber.trim();
            
            component.set("v.clientGroup",component.get('v.clientGroup'));
            component.set("v.clientType", component.get('v.clientType2'));
            component.set("v.placeOfResidence", component.get('v.placeOfResidence'));
            var clientTyp = component.get('v.clientType2');
            
            if(clientTyp != 'Private Company' && clientTyp != 'Close Corporation'&& clientTyp != 'Incorporated Company' && clientTyp != 'Public Listed Company' && clientTyp != 'Co-operative'){
                helper.showPrivateCompanyValidation(component, event, helper);
            } else{
                
                if(regNumberValue != null && (clientTyp =='Private Company' && regNumberValue.endsWith("07")) || (clientTyp =='Close Corporation' && regNumberValue.endsWith("23"))|| (clientTyp =='Incorporated Company' && regNumberValue.endsWith("21")) || (clientTyp =='Public Listed Company' && regNumberValue.endsWith("06"))) {   
                    helper.callExperianService(component, event, helper);
                    
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
        
        var processTypeVal = component.get('v.processType');
         //Surety Onboarding - Prepopulate Nature of Business
        if(processTypeVal == 'Surety Onboarding') {
            if(component.find("NatureOfClient") != undefined) {
                component.find("NatureOfClient").set("v.value", $A.get("$Label.c.NatureOfBusinessTemplate_Surety"));
            }
        }
    },
    
    //Function to submit RecordEditForm
    handleOnSubmit : function(component, event, helper) {
        console.log('INN');
        event.preventDefault();
        //Newly added by Rajesh to validate Share Percentage
        var relatedPartiesCmp  = component.find("relatedPartiesCmp");
        var uboListViewCmp = component.find("uboListViewCmp");
        var sharePercentage = 0;
        var isCountryOfCitizenShipBlank = false;
        var relatedPartiesRoles = []; //Added by chandra against W-004746
        var selectedRoles; //Added by chandra against W-004746
        var processType = component.get('v.processType'); // TdB - New to Bank/Lite Onboarding
        var childSharePercentage = 0;
        var clientType = component.get("v.clientType2");//component.find("clientType2").get("v.value");
        var placeOfRes = component.get("v.placeOfResidence");
        var isComplexEntity = false;
        var isRelatedPartyComplexEntity = false;
        
        if(uboListViewCmp != null && uboListViewCmp != undefined){
            var uboListViewCmpData = component.find("uboListViewCmp").get("v.gridData");
            for(var i in uboListViewCmpData){
                var children = uboListViewCmpData[i]._children;
                for(var j in children){
                    if(children[j].accType == 'AccountAccount'){
                        childSharePercentage += Number(children[j].ParentShareholding);
                    }

                    if(children[j].idType == 'Registration Number' || children[j].idType == 'Non-Registered Entity' || children[j].idType == 'Passport') {
                        console.log('# children[j].idType ' + children[j].idType);
                        isRelatedPartyComplexEntity = true;
                    }
                }
            }
        } 
        if(relatedPartiesCmp != null && relatedPartiesCmp != undefined){
            var  relatedPartiesCmpData = component.find("relatedPartiesCmp").get("v.data");
            for(var i in relatedPartiesCmpData){
                console.log("COC "+relatedPartiesCmpData[i].CountryOfCitizenship);
                sharePercentage += Number(relatedPartiesCmpData[i].SharePercentage);
                if(relatedPartiesCmpData[i].isIndividual == 'true' && (relatedPartiesCmpData[i].CountryOfCitizenship == '' ||  relatedPartiesCmpData[i].CountryOfCitizenship == undefined || relatedPartiesCmpData[i].CountryOfCitizenship == null)){
                    isCountryOfCitizenShipBlank = true;
                }
                if(relatedPartiesCmpData[i].Roles != undefined) {
                    var roles = relatedPartiesCmpData[i].Roles.split(";");//Added by chandra against W-004746
                    relatedPartiesRoles.push(roles);//Added by chandra against W-004746      
            	}

                //TdB - Flag entity as Complex
                if(relatedPartiesCmpData[i].ID_Type__c == 'Registration Number' || relatedPartiesCmpData[i].ID_Type__c == 'Non-Registered Entity' || relatedPartiesCmpData[i].ID_Type__c == 'Passport') {
                    console.log('# relatedPartiesCmpData[i].ID_Type__c ' + relatedPartiesCmpData[i].ID_Type__c);
                   isRelatedPartyComplexEntity = true;
               } 
               
           }
       }
       
       if(isRelatedPartyComplexEntity == true) {
           
           //TdB - Flag entity as Complex
           if(((clientType == 'Private Company') ||
               (clientType == 'Close Corporation') ||
               (clientType == 'Incorporated Company') ||
               (clientType == 'Non Profit Companies') ||
               (clientType == 'Sole Trader')) || ((clientType == 'Private Individual' || clientType != 'Individual - Minor') && (placeOfRes == 'South African Resident'))) {
               console.log('# clientType ' + clientType);
               isComplexEntity = true;
            }
        }
        
        if(processType != 'Surety Onboarding') {
            if(isCountryOfCitizenShipBlank){
                var toastEvent = helper.getToast("Error", "Please provide Country of Citizenship from Relationships.", "error");
                toastEvent.fire();
                return;
            }
        }
        
        //Added by chandra to validate relatedParties Roles for Close Corporation against W-004746
        selectedRoles = relatedPartiesRoles.toString();
        
        if(processType != 'Surety Onboarding') {
            if(clientType == 'Close Corporation' && (!selectedRoles.includes("Members/Controllers") 
                                                     || !selectedRoles.includes("Manager") 
                                                     || !selectedRoles.includes("Individual with Authority to Act")
                                                     || !selectedRoles.includes("Contact Person"))){
                var toastEvent = helper.getToast("Error", "Required to select Members/Controllers, Manager, Individual with Authority to Act, and Contact Person in Related Parties roles for Close Corporation", "error");
                toastEvent.fire();
                return;
            }
            
            if(clientType == 'Trusts' && (!selectedRoles.includes("Donors/Founders") 
                                          || !selectedRoles.includes("Trustees") 
                                          || !selectedRoles.includes("Individual with Authority to Act")
                                          || !selectedRoles.includes("Contact Person"))
              ){
                var toastEvent = helper.getToast("Error", "Required to select Donors/Founders, Trustees, and Individual with Authority to Act,Contact Person in Related Parties roles for Trusts", "error");
                toastEvent.fire();
                return;
            }
            //End of changes by chandra
            
            //Start - Manoj - Mandatory Roles - W-006645 - 12/14/202
            if(clientType == 'Co-operative' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                || !selectedRoles.includes("Director") 
                                                || !selectedRoles.includes("Shareholder/Controller")
                                                || !selectedRoles.includes("Contact Person")
                                                || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Directors,Shareholder/Controller,Contact Person and Manager in Related Parties roles", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Foreign Company' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                   || !selectedRoles.includes("Director") 
                                                   || !selectedRoles.includes("Shareholder/Controller")
                                                   || !selectedRoles.includes("Contact Person")
                                                   || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Directors,Shareholder/Controller,Contact Person and Manager in Related Parties roles", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Foreign Listed Company' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                          || !selectedRoles.includes("Director") 
                                                          || !selectedRoles.includes("Shareholder/Controller")
                                                          || !selectedRoles.includes("Contact Person")
                                                          || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Directors,Shareholder/Controller,Contact Person and Manager in Related Parties roles", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Foreign Trust' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                 || !selectedRoles.includes("Contact Person") 
                                                 || !selectedRoles.includes("Donors/Founders")
                                                 || !selectedRoles.includes("Trustees")
                                                 || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Contact Person,Donors/Founders,Trustees and Manager in Related Parties roles", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Public Listed Company' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                         || !selectedRoles.includes("Director") 
                                                         || !selectedRoles.includes("Shareholder/Controller")
                                                         || !selectedRoles.includes("Contact Person")
                                                         || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Directors,Shareholder/Controller,Contact Person and Manager in Related Parties roles", "error");
                toastEvent.fire();
                return;
            }
            //End - Manoj -Mandatory Roles - W-006645 - 12/14/202
            
            
            //TdB - Add validation for additional Roles - W-8006
            if(clientType == 'Clubs/Societies/Associations/Other Informal Bodies' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                                                      || !selectedRoles.includes("Members/Controllers") 
                                                                                      || !selectedRoles.includes("Contact Person")
                                                                                      || !selectedRoles.includes("Manager"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Members/Controllers,Contact Person and Manager in Related Parties roles for Clubs/Societies/Associations/Other Informal Bodies", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Incorporated Company' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                        || !selectedRoles.includes("Manager") 
                                                        || !selectedRoles.includes("Shareholder/Controller")
                                                        || !selectedRoles.includes("Contact Person"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Manager,Shareholder/Controller,Contact Person in Related Parties roles forIncorporated Company", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Non Profit Companies' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                            || !selectedRoles.includes("Manager") 
                                                            || !selectedRoles.includes("Director")
                                                            || !selectedRoles.includes("Contact Person")
                                                            || !selectedRoles.includes("Shareholder/Controller"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Manager,Directors,Shareholder/Controller,Contact Person in Related Parties roles for Non Profit Companies", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Non Profit Organizations (NGO)' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                                      || !selectedRoles.includes("Manager") 
                                                                      || !selectedRoles.includes("Contact Person")
                                                                      || !selectedRoles.includes("Members/Controllers"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Manager,Members/Controllers,Contact Person in Related Parties roles for Non Profit Organizations (NGO)", "error");
                toastEvent.fire();
                return;
            }
            if(clientType == 'Schools' && (!selectedRoles.includes("Individual with Authority to Act") 
                                                                      || !selectedRoles.includes("Shareholder/Controller") 
																	  || !selectedRoles.includes("Key Controllers") 
																	  || !selectedRoles.includes("Operators on primary accounts") 
																	  || !selectedRoles.includes("Sureties") 
                                                                      || !selectedRoles.includes("Contact Person")
                                                                      || !selectedRoles.includes("Members/Controllers"))){
                var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Shareholder/Controller,Key Controllers,Operators on primary accounts,Sureties,Contact Person,Members/Controllersin Related Parties roles for Schools", "error");
                toastEvent.fire();
                return;
            }
            
            //TdB - Central Bank and Regulator
            if(clientType == 'Central Bank or Regulator' && (!selectedRoles.includes("Individual with Authority to Act") 
            || !selectedRoles.includes("Director")
            || !selectedRoles.includes("Contact Person")
            || !selectedRoles.includes("Shareholder/Controller"))){
var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Directors,Shareholder/Controller,Contact Person in Related Parties roles for Central Bank or Regulator", "error");
toastEvent.fire();
return;
}

//TdB - Regulated Credit Entities and Financial Institutions
if(clientType == 'Regulated Credit Entities and Financial Institutions' && (!selectedRoles.includes("Individual with Authority to Act") 
|| !selectedRoles.includes("Regulated Director")
|| !selectedRoles.includes("Manager")
|| !selectedRoles.includes("Contact Person")
|| !selectedRoles.includes("Shareholder/Controller"))){
var toastEvent = helper.getToast("Error", "Required to select Individual with Authority to Act,Regulated Director,Manager, Shareholder/Controller,Contact Person in Related Parties roles for Regulated Credit Entities and Financial Institutions", "error");
toastEvent.fire();
return;
}

            sharePercentage = Number(sharePercentage) + Number(childSharePercentage);
            //alert(sharePercentage);
            
             //TdB - Flag as Complex entity
            if(((clientType == 'Trusts') ||
                (clientType == 'Co-operative') ||
                (clientType == 'Public Listed Company') ||
                (clientType == 'Foreign Company') ||
                (clientType == 'Foreign Listed Company') ||
                (clientType == 'Foreign Trust') ||
                (clientType == 'Clubs/Societies/Associations/Other Informal Bodies') ||
                (clientType == 'Non Profit Organizations (NGO)') ||
                (clientType == 'Schools' ) ||
                (clientType == 'Stokvel') ||
                (clientType == 'Partnership') ||
                (clientType == 'Organs of State and Institutions of Higher Learning') ||
                (clientType == 'Central Bank or Regulator') ||
                (clientType == 'Joint Ventures') ||
                (clientType == 'Deceased Estate') ||
                (clientType == 'Joint & Several')) || ((clientType == 'Individual - Minor' || 
                clientType == 'Private Individual' || clientType == 'Sole Trader') || 
                (clientType != 'Regulated Credit Entities and Financial Institutions')
                && placeOfRes != 'South African Resident'))
                {
                    isComplexEntity = true;
                }
            
            //Tdb - Do not fire validaion on Complex enities
            if(isComplexEntity == false){
                if(sharePercentage > 100 || sharePercentage < 100){
                    var toastEvent = helper.getToast("Error", "Share percantage must be 100%", "error");
                    toastEvent.fire();
                    return;
                } 
            }    
            //Added by Mbuyiseni Mbhokane
            if(event.getSource().get("v.value") == true && component.find("fspName") != undefined && ($A.util.isEmpty(component.find("fspName").get("v.value")))){
                var toastEvent = helper.getToast("Error", "Please Enter Name of FSP", "error");
                toastEvent.fire();
                
            }else if(event.getSource().get("v.value") == true && component.find("fspNumber") != undefined && ($A.util.isEmpty(component.find("fspNumber").get("v.value")))){
                var toastEvent = helper.getToast("Error", "Please Enter FSP number", "error");
                toastEvent.fire();
            }
            
            //Added by Himani to validate CountriesTradedWith and CountryOfOperation
            if(component.find("CountriesTradedWith") != undefined && component.find("CountriesTradedWith") != null
               && component.find("CountryOfOperation") != undefined && component.find("CountryOfOperation") != null){
                var CountriesTradedWith=component.find("CountriesTradedWith").get("v.value");
                var CountryOfOperation=component.find("CountryOfOperation").get("v.value");
                
                if(CountriesTradedWith.split(";").length >3 || CountryOfOperation.split(";").length >3)
                {
                    
                    console.log("ct"+CountriesTradedWith.split(";").length);
                    console.log("co"+CountryOfOperation.split(";").length);
                    var toastEvent = helper.getToast("Error", "CountriesTradedWith and  CountryOfOperation can have only 10 values", "error");
                    toastEvent.fire();
                    
                    return;
                }
            }  
        } else {
            if(!selectedRoles.includes("Contact Person")){
                var toastEvent = helper.getToast("Error", "Required to select Contact Person in Related Parties", "error");
                toastEvent.fire();
                return;
            }
        }
            
            var eventFields = event.getParam("fields");
            console.log('=INSIDE handleOnSubmit==>'+JSON.stringify(eventFields));
            
            var validationSucceeded = helper.showValidations(component);      
            if (validationSucceeded) {
                console.log('-------SAVING FORM---------');
                component.find('recordViewForm22').submit(eventFields);
                component.set("v.proceedToOpp",true);
                helper.hideSpinner(component);
            } else {
                helper.hideSpinner(component);
                var toastEvent = helper.getToast("Error", "Please ensure that all fields are completed correctly.", "error");
                toastEvent.fire();
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
        
        //TdB - Check if placeOfRes is visible
        if(component.find("placeOfRes") != null) {
            var placeOfRes = component.find("placeOfRes").get("v.value");
            //alert('placeOfRes '+placeOfRes);
            if(placeOfRes != null && placeOfRes != undefined && placeOfRes !=''){
                component.set("v.placeOfResidence",placeOfRes);
            }
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
        component.find("industryforNOB").set("v.value",component.find("industryBackgroud").get("v.value")); 
        component.find("sicCategoryforNOB").set("v.value",component.find("iSicCategory").get("v.value")); 
    },
    
    //Close Nature of Business Modal
    closeNatureOfBusinessModal: function(component, event, helper) {
        component.set("v.showNatureOfBusinessModal", false); 
    },
    
    //Generate Nature of Business data
    generateNatureOfBusiness: function(component, event, helper) {
        //load the static template
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
        component.find("NatureOfClient").set("v.value", str9.toUpperCase());
        component.set("v.showNatureOfBusinessModal", false); 
    },
    
    createOpportunity: function (component, event, helper) {
        var accId = component.get("v.accRecordId");
        var action = component.get("c.validateRelatedParties");
        var processNameValue = component.get('v.ProcessName'); // PJAIN: 20200330
        var processTypeValue = component.get('v.processType'); // TdB: To determine if its a New to Bank/Lite Onboarding
        
        console.log('processName in createOpp : ' + processNameValue);
        console.log('processType in createOpp : ' + processTypeValue);
        var clientType = component.find("clientType").get("v.value");
        console.log('clientType : ' + clientType);        
        
        action.setParams({
            "accountId": accId,
            "processType": processTypeValue,
            "clientTypeP":clientType
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
                        if (processNameValue === "MerchantOnboarding") {
                            var opportunityCreationAction = component.get("c.createMerchantOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId")
                        });
                        } //TdB - Credit Onboarding Opportunity
                        else if (processNameValue === "NewCreditProduct") {
                            var opportunityCreationAction = component.get("c.CreateCreditOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId"),
                            "processType" : processTypeValue
                        });
                        } 
                        else if (processNameValue === "CPFOnboarding") {
                            var opportunityCreationAction = component.get("c.CreateCPFOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId"),
                            "processType" : processTypeValue
                        });

                        }   
                        
                         else if (processNameValue === "CAFNewToProduct" || processNameValue === "CAFNewToBank") {
                            var opportunityCreationAction = component.get("c.CreateCAFOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId")
                        });

                        }    


                       else {
                            var opportunityCreationAction = component.get("c.CreateOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId"),
                            "processType" : processTypeValue
                        });
                        }
                        console.log('accountId : ' + component.get("v.accRecordId"));
                        
                        
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
    
    //6097 - Trigger Full Client On-boarding Prior Fulfilment
    updateOpportunity : function(component, event, helper){
        console.log('Inside updateOpportunity--');
        console.log('liteOpportunityId>>>'+component.get('v.liteOpportunityId'));
        
        var processNameVal = component.get('v.ProcessName');
        
        if(processNameVal == 'LiteToFullOnboarding') {        
            var action = component.get("c.updateLiteOpportunity");
            action.setParams({recordId : component.get('v.liteOpportunityId')});
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == 'SUCCESS'){
                    console.log('updateOpportunity Response'+response.getReturnValue());
                    /*$A.get('e.force:refreshView').fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                  "recordId": component.get('v.liteOpportunityId')
                });
                navEvt.fire();*/
                
                var workspaceAPI = component.find("workspace");
                var onboardingClientDetailsTabId;
                workspaceAPI.getFocusedTabInfo().then(function(response) {
                    onboardingClientDetailsTabId = response.tabId;
                });
                workspaceAPI.closeTab({
                    tabId: onboardingClientDetailsTabId
                });
                
                
            } else{
                var toast = this.getToast("Error",'Something went wrong. Please contact Administrator', "error");
                toast.fire();
            }            
        });
            $A.enqueueAction(action);
            
        } else {
            
             //TdB - Update Document Placeholders
            var oppRecId = component.get('v.opportunityRecordId');
            var actionUpdateOpp = component.get("c.updateDocumentPlaceholders");
            actionUpdateOpp.setParams({
                accountId: component.get("v.accRecordId"),
                oppId : oppRecId
            });
            
            actionUpdateOpp.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {
                    var resultVal = response.getReturnValue();

                    if(resultVal == 'SUCCESS') {
            var workspaceAPI = component.find("workspace");
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                console.log(focusedTabId);
                
                //Opening New Tab
                workspaceAPI.openTab({
                    url: '#/sObject/' + oppRecId + '/view'
                }).then(function(response) {
                    workspaceAPI.focusTab({tabId : response});
                })
                .catch(function(error) {
                    console.log(error);
                });
                
                //Closing old one
                workspaceAPI.closeTab({tabId: focusedTabId});
            })
            .catch(function(error) {
                console.log(error);
            });

        } else {
            var toast = helper.getToast("Error", 'An error occured: ' + resultVal, "error");
            toast.fire();
        }
        helper.hideSpinner(component);
    } else {
        var errors = response.getError();
        var toast = helper.getToast("Error", response, "error");
        toast.fire();
    }
});
$A.enqueueAction(actionUpdateOpp);
        }
        
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
        var sicCategory = component.find("iSicCategory").get("v.value");
        console.log('sicCategory : ' + sicCategory)
        component.set("v.sicCategoryValue", sicCategory);
        
        setTimeout($A.getCallback(function() {
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }));
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
            //component.set("v.disableConsentCheckbox", false);
        } else{
            //component.set("v.disableConsentCheckbox", true);
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

    provideDetails: function (component, event, helper) {
        //var detailsForPreviouslyClosed= component.find("detailsForPreviouslyClosed");
        if(event.getSource().get("v.value") == 'Yes'){
            component.set("v.showProvideDetails", true); 
        }else{    
            component.set("v.showProvideDetails", false); 
        }
    },
    //Haritha - W-005858 - consent Aggreement 
    savecheckedaccount: function(component, event, helper) {
        
        if (component.find('AgreePrivacyPolicy').get('v.checked')==false) {
            component.set("v.isAgreedPrivacypolicy", false);
            component.get("v.isAgreedPrivacypolicy")
        }
        else if (component.find('AgreePrivacyPolicy').get('v.checked')==true) {
            
            component.set("v.isAgreedPrivacypolicy", true);
            component.get("v.isAgreedPrivacypolicy")
        }
    },
    
    savecheckedAccountConsent : function(component, event, helper) {
        if (component.find('AgreeVerificatonPolicy').get('v.checked')==false) {
            component.set("v.isAgreedVerificationPolicy", false);
            component.get("v.isAgreedVerificationPolicy");
        }
        else if (component.find('AgreeVerificatonPolicy').get('v.checked')==true) {
            component.set("v.isAgreedVerificationPolicy", true);
            component.get("v.isAgreedVerificationPolicy");
        }
    },
    //Added By Mbuyiseni Mbhokane
    handleCheckboxChange: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showFsp", true); 
        }else{    
            component.set("v.showFsp", false); 
        }
    },
    
    //Added By Mbuyiseni Mbhokane
    handlePicklistChange: function (component, event, helper) {
        if(event.getSource().get("v.value") == 'Yes'){
            component.set("v.showCondition", true); 
        }else{    
            component.set("v.showCondition", false); 
        }
    },
    
    //Added By Mbuyiseni Mbhokane
    handleConditionChange: function (component, event, helper) {
        if(event.getSource().get("v.value") == 'Yes'){
            component.set("v.showNamedCondition", true); 
        }else{    
            component.set("v.showNamedCondition", false); 
        }
    },
    
    
    //Added by Diksha for SPM to select PM on opp creation  
    
    createSPMOpportunity: function(component, event, helper) {
        var accId = component.get("v.accRecordId");
        var action = component.get("c.validateRelatedParties");
        var processNameValue = component.get('v.ProcessName'); // PJAIN: 20200330
        var processTypeValue = component.get('v.processType'); // TdB: To determine if its a New to Bank/Lite Onboarding
        var clientType = component.find("clientType").get("v.value");
        console.log('processName in createOpp : ' + processNameValue);
        action.setParams({
            "accountId": accId,
            "processType": processTypeValue,
            "clientTypeP":clientType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var error = response.getReturnValue();
                console.log( "error onboardingclientdetails" + JSON.stringify(error));
                if (error != '') {
                    var toast = helper.getToast("Error", error, "error");
                    toast.fire();
                }
                else {
                    var proceedToOppFlag = component.get("v.proceedToOpp");
                    console.log('------proceedToOppFlag---------'+proceedToOppFlag);
                    if(proceedToOppFlag){
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
                    }
                }
            }
        });
        $A.enqueueAction(action);
        
        
    },
    
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpenforPM", false);
    },
    
    submitDetails: function(component, event, helper) {
        
        helper.creatingSPMOpp(component, event, helper);
        component.set("v.isModalOpenforPM", false);
    },
    
    // Added by Masechaba Maseli to validate PTY roles when CIF update
     validatePTY: function(component,event,helper){
    var accId = component.get("v.accRecordId");
        var action = component.get("c.validateRelatedParties");
        var processNameValue = component.get('v.ProcessName'); // PJAIN: 20200330
        var processTypeValue = component.get('v.processType'); // TdB: To determine if its a New to Bank/Lite Onboarding
        
        console.log('processName in createOpp : ' + processNameValue);
        var clientType = component.find("clientType").get("v.value");
        console.log('clientType : ' + clientType);        
        
        if(clientType == 'Private Company'){
        action.setParams({
            "accountId": accId,
            "processType": processTypeValue,
            "clientTypeP":clientType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var error = response.getReturnValue();
                console.log('error##@@@'+error);
                if (error != '') {
                    console.log('In error##@@@');
                    var toast = helper.getToast("Error", error, "error");
                    toast.fire();
                }
                else {
                 console.log('In else##@@@');   
                 helper.submitAccountDetailsCIF(component,event,helper);  
                }}
            
 }); 
        
    }
        
        else{
            helper.submitAccountDetailsCIF(component,event,helper); 
        }
       $A.enqueueAction(action);  
    },
    
   //added to update Account info so that they can continue onboarding from account for W-010629
    onSave : function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        //fields.Place_of_Residence__c =  component.get("v.placeOfResidence");
        component.find('recordViewForm22').submit(fields);
    }
})