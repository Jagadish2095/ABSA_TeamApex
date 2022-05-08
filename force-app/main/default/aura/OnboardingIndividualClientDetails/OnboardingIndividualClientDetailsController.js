({
    doInit : function(component, event, helper) {
        
         //TdB: Foreign Ntional identifier
        var placeofResValue = component.get("v.placeofResValue");
        if(placeofResValue == 'Nambi/Les/Swazi' || placeofResValue == 'Non - Resident') {
            component.set("v.isForeignNational", true);
        } else {
            component.set("v.isForeignNational", false);
        }

        //TdB: Individual Minor Identifier
         var clientTypeVal = component.get("v.clientTypeValue");
        if(clientTypeVal == 'Individual - Minor') {
            component.set("v.isMinorIndiv", true);
        } else {
            component.set("v.isMinorIndiv", false);
        }

         //Anka: identifier : W-13541
        
         if(placeofResValue == 'South African Resident') {
            component.set("v.isSAResident", true);
        } else if(placeofResValue == 'Temp Resident') {
            component.set("v.isTempResident", true);
        }
        
        component.set('v.accountRecord.Place_of_Residence__c', placeofResValue);
        
        console.log('accRecordId : ' + component.get("v.accRecordId"));
        var accId = component.get("v.accRecordId");
        component.set("v.countryofresValue", 'South Africa');//Haritha for setting default country of residence
        
        helper.getloggedinUserProfileName(component, event, helper); //Added for SPM 
        
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        
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
                
        //Show Big Form if Client already exist in Salesforce, User have the option to call Golden Sources still
        if(!accId) {
            //Get logged in User details
            var action = component.get("c.getIndividualProspectRecordTypeId");
            
            // Add callback behavior for when response is received
            action.setCallback(this, function(response) {
                var message;
                
                var state = response.getState();
                
                if (component.isValid() && state === "SUCCESS") {
                    
                    var recordTypeIdVal = response.getReturnValue();
                    console.log('recordTypeIdVal : ' + recordTypeIdVal);
                    component.set("v.indvRecordTypeId", recordTypeIdVal);
                    
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
            
            
        } else {
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
			// Yongama Dayeni Lines 4 to 30 519 W-006517 and W-006516 
           /* var actionOccLevelAndEmpSec = component.get('c.getOccupationLevelAndEmployerSectorPicklist');
            
            var selectOccupationValue= '';
            var selectEmployerSectorValue= '';
            if(component.find('selectOccupationLevel')!=undefined){
                selectOccupationValue= component.find('selectOccupationLevel').get('v.value');
            }
            if(component.find('selectEmployerSector')!=undefined){
                selectEmployerSectorValue= component.find('selectEmployerSector').get('v.value');
            } 
            
            actionOccLevelAndEmpSec.setParams({
                objName : component.get('v.objName'),
                fldName : component.get('v.fldName')
            });
            actionOccLevelAndEmpSec.setCallback(this,function(result){
                var resultValue = result.getReturnValue();
                console.log('resultValue>>>'+resultValue);
                if(resultValue!=null){
                    component.set('v.occupationLevelList',resultValue);
                    component.set('v.employerSectorList',resultValue);
                    // alert('You have selected : '+resultValue[1]);  
                    if(selectOccupationValue == resultValue[7]){
                        console.log("Occupation Level Chosen ="+selectOccupationValue);
                        component.set("v.showOtherOccupation", true);
                    }
                    
                    if(selectEmployerSectorValue == resultValue[19]){
                        console.log("Employer Selector Chosen ="+selectOccupationValue);
                        component.set("v.showOtherEmployerSector", true);
                    }
                    
                    console.log("Employer Sector ="+selectValue);
                }
                
            });
            $A.enqueueAction(actionOccLevelAndEmpSec);*/
        }
        
        var clientTypeValue; 
        var clientGroupValue; 
        
        if(component.find("iClientType") != undefined) {
            if(component.find("iClientType").get("v.value") != undefined) {
                console.log('clientTypeValue 1st if: ' + clientTypeValue);
            	clientTypeValue = component.find("iClientType").get("v.value");
            }
        }
        
        if(component.find("iClientGroup") != undefined) {
            clientGroupValue = component.find("iClientGroup").get("v.value");
        }
        
        //Scenario for Lite Onboarding to Full Onboarding
        if(clientTypeValue == undefined || clientTypeValue == null || clientTypeValue == '') {
            console.log('clientTypeValue 2nd if: ' + clientTypeValue);
            clientTypeValue = component.get("v.clientTypeValue");
        }
        
        if(clientGroupValue == undefined || clientGroupValue == null || clientGroupValue == '') {
            clientGroupValue = component.get("v.clientGroupValue");
        }
                
        console.log('clientTypeValue : ' + clientTypeValue);
        console.log('clientGroupValue : ' + clientGroupValue);
        if(clientTypeValue == 'Sole Trader' || clientGroupValue == 'SOLE TRADER CLIENT' || component.get("v.isSoleTrader") == true){
            component.set("v.isSoleTrader", true);
        } else {
            component.set("v.isSoleTrader", false);
        }

        var relatedP = component.find('relatedPartiesCmp');
        if(relatedP != null) {
            relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
        }  

        //TdB - To Call Business Address Components
        var objCompB = component.find('mainComp');
        if(objCompB != null) {
            objCompB.getAccountId(component.get('v.accRecordId'));
            objCompB.getAccountClientType(clientTypeValue);
        }
        //TdB - To Call Trading as Name Components
        var tradingAsNameCmp = component.find('tradingAsNameComp');
        if(tradingAsNameCmp != null) {
            tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
        }
        
        //TdB - Set default sections open
        setTimeout($A.getCallback(function() {
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }));
        component.set('v.processNameP',component.get('v.processType'));
        
    },

    provideDetails: function (component, event, helper) {
        //var detailsForPreviouslyClosed= component.find("detailsForPreviouslyClosed");
        console.log(event.getSource().get("v.value"));
        if(event.getSource().get("v.value") == 'Yes'){
            
            component.set("v.showProvideDetails", true); 
        }else{    
            component.set("v.showProvideDetails", false); 
        }
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
    
    createIndividualAccount : function(component, event, helper){
        helper.showSpinner(component);
        var hanisObj = component.get('v.hanisResponse');
        var cpbObj = component.get('v.CPBResponse');
        var accountId = component.get('v.accRecordId');
        var processName = component.get("v.ProcessName"); // PJAIN: 20200318
        var processTypeValue = component.get('v.processType'); // TdB - New to Bank/Lite Onboarding
        var agreedToPolicy = component.get("v.isAgreedPrivacypolicy"); 
        var aggreedVerificationPolicy = component.get("v.isAgreedVerificationPolicy");
        var placeOfRes = component.get("v.placeofResValue");
        
        if(placeOfRes == null || placeOfRes == ' ') {
            placeOfRes = component.get("v.accountRecord.Place_of_Residence__c");
        }
        
        var action = component.get("c.CreateIndividualProspect");
        action.setParams({
            "hanisData" : JSON.stringify(hanisObj),
            "cpbData" : JSON.stringify(cpbObj),
            "accRecordId" : accountId,
            "clientType" : (processName == 'MerchantOnboarding' ? 'Sole Trader' : component.get("v.clientTypeValue")), // PJAIN: 20200318
			"processType" : processTypeValue,
            "placeOfResidence" : placeOfRes,
            "processName" : processName,
            "agreedPolicy" : agreedToPolicy,
            "aggreedVerificationPolicy": aggreedVerificationPolicy

        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var message = '';
            if (component.isValid() && state === "SUCCESS") {
                //alert('***************** '+JSON.stringify(response.getReturnValue()));
                component.set("v.accRecordId",response.getReturnValue());
                component.set("v.isConfirmationModalOpen", false);
                component.set("v.showRecordEditForm", true);
                //$A.util.removeClass(component.find("populateDiv"), "slds-hide");
                $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
                component.set("v.disableConsentCheckbox", true);
                helper.hideSpinner(component);

                //To Call Business Address Components
                var objCompB = component.find('mainComp');
                if(objCompB != null) {
                    objCompB.getAccountId(component.get('v.accRecordId'));
                }

                setTimeout($A.getCallback(function() {
                     //TdB - Set default sections open
                    setTimeout($A.getCallback(function() {
                        component.set("v.activeSections", component.get('v.defaultActiveSections'));
                    }));
                    
                    //TdB - TEMP: Set all to be Sole Trader
                    component.set("v.isSoleTrader", true);
                    //component.set("v.isSoleTrader", (processName == 'MerchantOnboarding')); // PJAIN: 20200319: Set isSoleTrader flag if in Merchant Onboarding flow.
                    
                    //TdB - To Call Trading as Name Components
                    var tradingAsNameCmp = component.find('tradingAsNameComp');
                    if(tradingAsNameCmp != null) {
                         tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
                    }

                    var clientTypeValue = component.find("iClientType").get("v.value");
                   
                    if(clientTypeValue == undefined) {
                        clientTypeValue = component.get("v.clientTypeValue");
                    }
                    if(clientTypeValue != 'Sole Trader') {
                        component.set("v.isSoleTrader", false);
                    }
                    //TdB - To Call Business Address Components
                    var objCompB = component.find('mainComp');
                    if(objCompB != null) {
                        objCompB.getAccountId(component.get('v.accRecordId'));
                    	objCompB.getAccountClientType(clientTypeValue);
                    }
                    
                    //alert('INN');
                    //Added by Rajesh for Adding Related party issue after refresh
                    //To Call Related Parties Components
                    var relatedP = component.find('relatedPartiesCmp');
                    if(relatedP != null) {
                        relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
                    }

                }));
                
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
        $A.enqueueAction(action);
    },
    
    closeAccountPreviewModal : function(component, event, helper){
        component.set("v.isConfirmationModalOpen",false);
    },
    
    populateDetails : function(component, event, helper){
        
        if(!$A.util.isEmpty(component.find("iIdNo").get("v.value"))){
            
            var cmpTarget = component.find('idNoError');
            $A.util.removeClass(cmpTarget, 'slds-has-error');
            
            //Hanis Service 
            helper.showSpinner(component);
            
            var actionHanisService = component.get("c.callHanisService");
            var idNumber = component.find("iIdNo").get("v.value");
            
            actionHanisService.setParams({
                "idNumber" : idNumber
            });
            
            actionHanisService.setCallback(this, function(response) {
                
                var state = response.getState();
                var message = '';
                
                if (component.isValid() && state === "SUCCESS") {
                    
                    var respObj = JSON.parse(response.getReturnValue());
                    
                    if(respObj.statusCode == 200 ){
                        console.log('HANIS SERVICE SUCCESS ; ' + respObj); 
                        component.set('v.hanisResponse',respObj);
                        
                        //Call CPB Service
                        helper.showSpinner(component);
                        
                        var actionCPBservice = component.get("c.callCPBService");
                        var idNumber = component.find("iIdNo").get("v.value");
                        var hanisResponseValues = component.get('v.hanisResponse');
                        
                        if(hanisResponseValues.surname != null && hanisResponseValues.surname != '') {
                            actionCPBservice.setParams({
                                "idNumber" : idNumber,
                                "lastName" : hanisResponseValues.surname
                            });
                            
                            actionCPBservice.setCallback(this, function(response) {
                                
                                var state = response.getState();
                                var message = '';
                                
                                if (component.isValid() && state === "SUCCESS") {
                                    
                                    var respObj = JSON.parse(response.getReturnValue());
                                    
                                    if(respObj.statusCode == 200){
                                        
                                        console.log('CPB SERVICE SUCCESS : ' + JSON.stringify(respObj));       
                                        component.set('v.CPBResponse',respObj);
                                        
                                        if(respObj.Person != null) {
                                            var residentialAddressObj = respObj.Person.AddressInformation.ResidentialAddress;
                                            var postalAddressObj = respObj.Person.AddressInformation.PostalAddress;
                                            
                                            component.set("v.residentialAddressDetails", residentialAddressObj);
                                            component.set("v.postalAddressDetails", postalAddressObj);
                                            component.set("v.isConfirmationModalOpen",true); 
                                        } else {
                                            console.log('CPB SERVICE ERROR OCCURRED');  
                                            var message = 'CPB Service Error';
                                            
                                            if(respObj.responseStatusDescription != null) {
                                                message = respObj.responseStatusDescription;
                                            } else if (respObj.errorDescription != null) {
                                                message = respObj.errorDescription;
                                            }
                                            
                                            var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                                            toastEvent.fire();
                                            
                                            //Enqueue action to Create Client and show RecordEditForm
                                            var a = component.get('c.createIndividualAccount');
                                            $A.enqueueAction(a);
                                            helper.hideSpinner(component);
                                        }
                                        
                                    }  else if(respObj.statusCode==404){
                                        console.log('CPB SERVICE ERROR OCCURRED');  
                                        var message = respObj.message;
                                        var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                                        toastEvent.fire();
                                        
                                        //Enqueue action to Create Client and show RecordEditForm
                                        var a = component.get('c.createIndividualAccount');
                                        $A.enqueueAction(a);
                                        helper.hideSpinner(component);
                                    } else{
                                        console.log('CPB SERVICE ERROR OCCURRED');  
                                        var message = "We cannot complete the request now, please try again if error persist contact administrator."
                                        var toastEvent = helper.getToast("CPB Service Error!", message, "error");
                                        toastEvent.fire();
                                        
                                        //Enqueue action to Create Client and show RecordEditForm
                                        var a = component.get('c.createIndividualAccount');
                                        $A.enqueueAction(a);
                                        helper.hideSpinner(component);
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
                                    
                                    var toast = helper.getToast("Error", message, "error");
                                    
                                    toast.fire();
                                    
                                    //Enqueue action to Create Client and show RecordEditForm
                                    var a = component.get('c.createIndividualAccount');
                                    $A.enqueueAction(a);
                                    helper.hideSpinner(component);
                                } else {
                                    var errors = response.getError();
                                    
                                    var toast = helper.getToast("Error", message, "error");
                                    
                                    toast.fire();
                                    
                                    //Enqueue action to Create Client and show RecordEditForm
                                    var a = component.get('c.createIndividualAccount');
                                    $A.enqueueAction(a);
                                    helper.hideSpinner(component);
                                }
                                
                            });
                            $A.enqueueAction(actionCPBservice);
                            
                        } else {
                            var toast = helper.getToast("Integration Service Error","No Last Name returned from Hanis" , "error");
                            
                            toast.fire();
                            
                            //Enqueue action to Create Client and show RecordEditForm
                            var a = component.get('c.createIndividualAccount');
                            $A.enqueueAction(a);
                            helper.hideSpinner(component);
                        }
                        
                    }  else if(respObj.statusCode==404){
                        console.log('HANIS SERVICE ERROR OCCURRED');  
                        var message = respObj.message;
                        var toastEvent = helper.getToast("Hanis Service Error!", message, "error");
                        toastEvent.fire();
                        
                        //Enqueue action to Create Client and show RecordEditForm
                        var a = component.get('c.createIndividualAccount');
                        $A.enqueueAction(a);
                        helper.hideSpinner(component);
                    } else{
                        console.log('HANIS SERVICE ERROR OCCURRED');  
                        var message = "We cannot complete the request now, please try again if error persist contact administrator."
                        var toastEvent = helper.getToast("Hanis Service Error!", message, "error");
                        toastEvent.fire();
                        
                        //Enqueue action to Create Client and show RecordEditForm
                        var a = component.get('c.createIndividualAccount');
                        $A.enqueueAction(a);
                        helper.hideSpinner(component);
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
                    
                    var toast = helper.getToast("Error", message, "error");
                    
                    toast.fire();
                    
                    //Enqueue action to Create Client and show RecordEditForm
                    var a = component.get('c.createIndividualAccount');
                    $A.enqueueAction(a);
                    helper.hideSpinner(component);
                } else {  
                    var errors = response.getError();
                    
                    var toast = helper.getToast("Error", message, "error");
                    
                    toast.fire(); 
                    
                    //Enqueue action to Create Client and show RecordEditForm
                    var a = component.get('c.createIndividualAccount');
                    $A.enqueueAction(a); 
                    helper.hideSpinner(component);
                }
            });
            $A.enqueueAction(actionHanisService);
        } else{
            var cmpTarget = component.find('idNoError');
            $A.util.addClass(cmpTarget, 'slds-has-error');
        }
        
    },
    
    //Function to submit RecordEditForm
    handleOnSubmit : function(component, event, helper) {
        event.preventDefault(); 
        //alert('INN handle submit');
        
        if(component.get("v.showSave") == true) {
            var eventFields = event.getParam("fields");
            console.log('-------SAVING FORM---------');
            eventFields.Valid_Update_Bypass__c = true;
            component.find('recordViewForm22').submit(eventFields);
            component.set("v.disableNextBtn",false);
        } else {
            
            var isManagerRoleAvailable = false;
            var isCountryOfCitizenShipBlank = false;
            var processType = component.get('v.processType'); // TdB - New to Bank/Lite Onboarding
            
            //TdB - Onboard New to Bank vs Lite Onboarding validation on Big Form
            if(processType != 'Lite Onboarding' && processType != 'SIC Code Change') {
                var managerOtherThanSoleTrader;
                
                if(component.find("mangrSoleTrader") != null) {
                    managerOtherThanSoleTrader = component.find("mangrSoleTrader").get("v.value");
                }
                
                if(managerOtherThanSoleTrader){
                    var relatedPartCmp = component.find("relatedPartiesCmp");
                    if(relatedPartCmp != null &&  relatedPartCmp != undefined){
                        var relatedPartyData = relatedPartCmp.get("v.data");
                        
                        if(relatedPartyData != undefined && relatedPartyData != null){
                            for(var i in relatedPartyData){
                                console.log('relatedPartyData[i].Roles '+relatedPartyData[i].Roles);
                                if(relatedPartyData[i].Roles != null && relatedPartyData[i].Roles != undefined && relatedPartyData[i].Roles != ''){
                                    var roles = relatedPartyData[i].Roles;
                                    console.log('roles '+roles);
                                    if(roles.includes('Manager')){
                                        console.log('IN Manager Role');
                                        isManagerRoleAvailable = true;
                                    }
                                }
                                if(relatedPartyData[i].CountryOfCitizenship == '' ||  relatedPartyData[i].CountryOfCitizenship == undefined || relatedPartyData[i].CountryOfCitizenship == null){
                                    isCountryOfCitizenShipBlank = true;
                                }
                            } 
                        }
                    }
                    //alert(isManagerRoleAvailable);
                    console.log('relatedPartCmp '+JSON.stringify(relatedPartyData));
                    if(!isManagerRoleAvailable){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "Error",
                            "message": "Please provide Manager from relationships."
                        });
                        toastEvent.fire();
                        return;
                    }
                }else{
                    var relatedPartCmp = component.find("relatedPartiesCmp");
                    if(relatedPartCmp != null &&  relatedPartCmp != undefined){
                        var relatedPartyData = relatedPartCmp.get("v.data");
                        
                        if(relatedPartyData != undefined && relatedPartyData != null){
                            for(var i in relatedPartyData){
                                if(relatedPartyData[i].CountryOfCitizenship == '' ||  relatedPartyData[i].CountryOfCitizenship == undefined || relatedPartyData[i].CountryOfCitizenship == null){
                                    isCountryOfCitizenShipBlank = true;
                                }
                            }
                        }
                    }
                }
            }
            
            if(isCountryOfCitizenShipBlank){
                var toastEvent = helper.getToast("Error", "Please provide Country of Citizenship from Relationships.", "error");
                toastEvent.fire();
                return;
            }
            var isError = helper.showValidations(component, event, helper);
            
            
            var eventFields = event.getParam("fields");
            
            if (!isError) { 
                console.log('-------SAVING FORM---------');
                component.find('recordViewForm22').submit(eventFields);
                component.set("v.disableNextBtn",false);
            }
        }
    },
    
    handleOnSuccess : function(component, event, helper) {
        console.log('----------------INSIDE handleOnSuccess');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success",
            "message": "The record has been updated successfully."
        });
        toastEvent.fire();
    },
    
    handleOnError : function(component, event, helper) {
        var errordetails = event.getParam('detail');
        console.log("errordetails", JSON.stringify(errordetails));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: 'error',
            mode: 'pester',
            message: JSON.stringify(errordetails)
        });
        toastEvent.fire();
    },
    
    //Validation for VAT Registration Number
    checkVatValidity : function(component, event, helper){
        var pattern = new RegExp('^(4)([0-9]{9})$');
        var vatNumber = component.find("vatNumber").get("v.value");
        if(vatNumber !== null && !vatNumber.toString().match(pattern)){
            helper.showErrorOnField(component, "vatNumber", "errvatNumber");
        }else{
            helper.hideErrorOnField(component, "vatNumber", "errvatNumber");
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
    
    createOpportunity : function(component, event, helper){
        helper.showSpinner(component);
        
        // PJAIN: 20200330: For Merchant Onboarding
        var processName = component.get("v.ProcessName");
        var processTypeValue = component.get('v.processType'); // TdB: To determine if its a New to Bank/Lite Onboarding
        
        if (processName === "MerchantOnboarding") {
            var opportunityCreationAction = component.get("c.createMerchantOnboardingOpportunity");
        } 
        //TdB - Credit Onboarding Opportunity
        else if (processName === "NewCreditProduct") {
            var opportunityCreationAction = component.get("c.CreateCreditOnboardingOpportunity");
        }
        else if (processName === "CPFOnboarding") {
            var opportunityCreationAction = component.get("c.CreateCPFOnboardingOpportunity");
        }
        else if (processName === "CAFNewToProduct" || processName === "CAFNewToBank") {
                            var opportunityCreationAction = component.get("c.CreateCAFOnboardingOpportunity");
                            opportunityCreationAction.setParams({
                            "accountId" : component.get("v.accRecordId")
                        });

                        } 
        else {
            var opportunityCreationAction = component.get("c.CreateOnboardingOpportunity");
        }
        
        console.log('accountId : ' + component.get("v.accRecordId"));
        
        opportunityCreationAction.setParams({
            "accountId" : component.get("v.accRecordId"),
            "processType" : processTypeValue
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
    },
    //Yongama Lines 674 to set occupation status W-006515
    setOccupationFields : function(component, event, helper){
        var occupationStatusValue = component.find("iOccupationStatus").get("v.value");
     //   var employerSectorValue = component.find("iEmployerSector").get("v.value");
        if(occupationStatusValue == 'Full Time Employed' || occupationStatusValue == 'Part Time Employed' || occupationStatusValue == 'Self Employed Professional' || occupationStatusValue == 'Self Employed-Non-Professional' || occupationStatusValue == 'Temporary Employed') {
            component.set("v.isEmployed", true);
            component.set("v.OtherOccupation", false);
      
          }    
            
           else if(occupationStatusValue == 'Other')
        {
            component.set("v.OtherOccupation", true);
            component.set("v.isEmployed", false);
        }
        else {
            component.set("v.isEmployed", false);
            component.set("v.OtherOccupation", false);
        }
        
        console.log("Occupation Status = "+occupationStatusValue);
    },
    
       setSectionsToRender : function(component, event, helper){
        //Show Sole Trader sections
        var clientTypeValue = component.find("iClientType").get("v.value");
        var clientGroupValue = component.find("iClientGroup").get("v.value");
        console.log('compo ' + component.get('v.accRecordId'));
        if(clientTypeValue == 'Sole Trader' || clientGroupValue == 'SOLE TRADER CLIENT') {
            component.set("v.isSoleTrader", true);
            //To Call Related Parties Components
            var relatedP = component.find('relatedPartiesCmp');
            if(relatedP != null) {
                relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
            }
        } else {
            component.set("v.isSoleTrader", false);
        }
        
        //TdB - To Call Trading as Name Components
        var tradingAsNameCmp = component.find('tradingAsNameComp');
           if(tradingAsNameCmp != null) {
               tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
           }
        
    },
    
    renderAgriFields: function (component, event, helper) {
        //Get High Risk Idenstry selected value
        var sicCategory = component.find("iSicCategory").get("v.value");
        console.log('sicCategory : ' + sicCategory)
        component.set("v.sicCategoryValue", sicCategory);
        
        //TdB - Set default sections open
        setTimeout($A.getCallback(function() {
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }));
        
    },
    renderCountryofRes: function (component, event, helper) {
        //Get Country Of residence selected value
        var countryofres = component.find("iCountryOfResidence").get("v.value");
        console.log('countryofres : ' + countryofres)
        component.set("v.countryofresValue", countryofres);
        
    },
    navigateToRelatedAccount : function(component, event, helper){
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.accRecordId"),
            "slideDevName": "related"
        });
        navEvt.fire();
    },
    
    renderHighRiskFields: function (component, event, helper) {
        //Get High Risk Idenstry selected value
        var highRiskInd = component.find("clientInvolved").get("v.value");
        console.log('highRiskInd : ' + highRiskInd)
        component.set("v.highIndustryValue", highRiskInd);
        
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
        
        var str1 = descriptionString.replace("(1)",component.find("industryforNOB").get("v.value") );
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
    
    showBigForm : function(component, event, helper){
        
        helper.createProspectBasedOnPopup(component);
        
        component.set("v.showRecordEditForm", true);
        $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
        
        //TdB - Set default sections open
        setTimeout($A.getCallback(function() {
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
        }));
        
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
    
    //display Country For Foreign Tax
    //Edit by Masechaba Maseli 250620
    showCountryForeignTax : function(component, event, helper){
        var countryForeignTax= component.find("registeredForeignTax");
        if(event.getSource().get("v.checked") == true){
            component.set("v.showCountryForeignTax", true); 
        }else{    
            component.set("v.showCountryForeignTax", false); 
        }
        
    },
    //display Temporary Resident details
    //Edit by Haritha 210920
    showTempresidentDetails : function(component, event, helper){
        var changeValue = event.getParam("value");
        var optionGiven = component.get("v.optionGiven") 
        if(changeValue=='Y'){
            component.set("v.optionGiven", 'Y');
            component.set("v.showTempResidentDetails", 'Yes');
        }else if(changeValue=='N'){    
            component.set("v.optionGiven", 'N');
            component.set("v.showTempResidentDetails",'No');
        }
    },
    //display Asylum details
    //Edit by Haritha 210920
    showasylumDetailssection : function(component, event, helper){
        
        var changeasylumValue = event.getParam("value");
        
        var asylumoptionGiven = component.get("v.asylumoptionGiven") 
        if(changeasylumValue=='Y'){
            component.set("v.asylumoptionGiven", 'Y');
            component.set("v.showAsylumDetails", 'Yes');
        }else if(changeasylumValue=='N'){    
            component.set("v.asylumoptionGiven", 'N');
            component.set("v.showAsylumDetails",'No');
        }
        
    },
    //display agreed consent details
    //Edit by Haritha 210920
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
            console.log("Verification ---->" , component.get("v.isAgreedVerificationPolicy"));
            component.get("v.isAgreedVerificationPolicy");
        }
    },
    
    openLimitedAccDetailsModal : function(component, event, helper){
        component.set("v.accountRecord.ID_Number__pc", component.get("v.IdentityNumber"));
        component.set('v.accountRecord.Client_Group__c',component.get('v.clientGroupValue'));
        component.set('v.accountRecord.Client_Type__c',component.get('v.clientTypeValue'));
        component.set('v.accountRecord.Place_of_Residence__c',component.get('v.placeofResValue'));
        component.set("v.showLimitedAccountInfoModal",true); 
    },
    
    closeLimitedAccDetailsModal : function(component, event, helper){
        component.set("v.showLimitedAccountInfoModal",false);
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
            var toastEvent = helper.getToast("Error", "Please complete all required fields", "error");
            toastEvent.fire();
        } else {
            helper.createProspectBasedOnPopup(component);        
            
            component.set("v.showRecordEditForm", true);
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            setTimeout($A.getCallback(function() {
                component.set("v.activeSections", component.get('v.defaultActiveSections'));
            }));
            component.set("v.activeSections", component.get('v.defaultActiveSections'));
            component.set("v.showLimitedAccountInfoModal",false);
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
    
    //Diksha - Create new SPM Opprotunity for Individuals
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
    
    
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpenforPM", false);
    },
    
    submitDetails: function(component, event, helper) {
        
        helper.creatingSPMOpp(component, event, helper);
        component.set("v.isModalOpenforPM", false);
    },
    //Yongama lines 976 to 977 for Occupation Level W-006516
    setLevelFields : function(component, event, helper){
        var levelValue = component.find("iOccupationLevel").get("v.value");
        
        if(levelValue  == 'Other') {
            component.set("v.isOtherLevel", true);
    
        } 
         
   else {
            component.set("v.isOtherLevel", false);
        }
        
        console.log("Occupation Level Value : " + levelValue );
    },
     //Yongama lines 979 to 992 for Employer Sector  W-006517
     setEmployerFields : function(component, event, helper){
        var employerSectorValue = component.find("iEmployerSector").get("v.value");
        
        if(employerSectorValue == 'Other') {
            component.set("v.isOtherEmployer", true);
    
        } 
         
   else {
            component.set("v.isOtherEmployer", false);
        }
        
        console.log("Employer Sector Value : " + employerSectorValue);
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
    

submitAccountDetailsCIF : function(component,event,helper){
    var action = component.get("c.clientdetails");
   var AccId = component.get("v.accRecordId");
   console.log("The Account from helper***" + AccId);
   action.setParams({"clientAccountId" : AccId});
       action.setCallback(this, function(response) {
           
          var state = response.getState();
           if(state === "SUCCESS"){
               
           var opportunityRecordId = component.get("v.opportunityRecordId");
            console.log('opportunityRecordId : ' + opportunityRecordId);
               
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            "type": "success",
            "title": "Success",
            "message": "The record has been updated successfully in CIF."   
            });
           toastEvent.fire();
               
            helper.closeFocusedTabAndOpenNewTab(component, opportunityRecordId);    
               
               
               
           }
           
           else{
               
           var returnVal = response.getReturnValue();                
               
           }
           
           var state = response.getState();
           console.log('state'+state);
           var returnVal = response.getReturnValue();
           console.log('returnVal'+returnVal);
          // var toastEvent = $A.get("e.force:showToast");
           //if(response.getReturnValue().toUpperCase().includes('"RETCODE') == 0 ){
               
           //}
       });
       $A.enqueueAction(action);
   console.log("DONE with helper to Call Service!!!!!!!!!!!!!!!!!!!!!!!!");
},
  
    
    //added to update Account info so that they can continue onboarding from account for W-010629
    onSave : function(component, event, helper){
        event.preventDefault();       // stop the form from submitting
        var fields = event.getParam('fields');
        component.find('recordViewForm22').submit(fields);
    },
     //Anka - W-013541 - Temporary Resident Section
     temporaryResidentSection: function (component, event, helper) {
        if(event.getSource().get("v.value") == true){
            component.set("v.showTemporaryResidentSection", true);
        }else{    
            component.set("v.showTemporaryResidentSection", false); 
        }
    },
    
})