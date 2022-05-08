({
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
    
    showValidations : function(component, event, helper) {
        
        var processType = component.get('v.processType');
        
        var isError = false; 
        
        //TdB - Onboard New to Bank vs Lite Onboarding validation on Big Form
        if(processType != 'Lite Onboarding' && processType != 'SIC Code Change') {
            //Validate Contact details for Next of Kin
            if(component.find("iNextofKinCellphoneNumber") != undefined && $A.util.isEmpty(component.find("iNextofKinCellphoneNumber").get("v.value")) && component.find("iNextofKinTelephoneNumber") != undefined && $A.util.isEmpty(component.find("iNextofKinTelephoneNumber").get("v.value")) && component.find("iNextofKinEmailAddress") != undefined &&  $A.util.isEmpty(component.find("iNextofKinEmailAddress").get("v.value"))) {
                var toastie = this.getToast('Next of Kin Validation', 'At least one Contact detail required for Next of Kin', 'error');
                toastie.fire();
                isError = true;
            }
            
            //Validate Contactd details
            if($A.util.isEmpty(component.find("iEmail").get("v.value")) && $A.util.isEmpty(component.find("iPersonMobilePhone").get("v.value")) && $A.util.isEmpty(component.find("iPersonHomePhone").get("v.value"))) {
                var toastie = this.getToast('Contact Details Validation', 'At least one Contact detail required for Client', 'error');
                toastie.fire();
                isError = true;
            }
            
            //INCOME TAX NUMBER
            /*if(component.find("registeredTax").get("v.checked")===true && $A.util.isEmpty(component.find("itNumber").get("v.value"))){
            isError = true;
            helper.showErrorOnField(component, "itNumber", "erritNumber");
        } else{
            helper.hideErrorOnField(component, "itNumber", "erritNumber");
        }
        
        //VAT REGISTATION NUMBER
        var pattern = new RegExp('^(4)([0-9]{9})$');
        var vatNumber = component.find("vatNumber").get("v.value");
        if((component.find("registeredVAT").get("v.checked")===true && $A.util.isEmpty(component.find("vatNumber").get("v.value"))) || 
           (vatNumber !== null && !vatNumber.toString().match(pattern))){
            isError = true;
            helper.showErrorOnField(component, "vatNumber", "errvatNumber");
        }else{
            helper.hideErrorOnField(component, "vatNumber", "errvatNumber");
        }
        
        //MARKETING CONSENT EMAIL
        if(component.find("marConEmailCheck").get("v.checked")===true && $A.util.isEmpty(component.find("marConInfo").get("v.value"))){
            isError = true;
            helper.showErrorOnField(component, "marConInfo", "errmarConEmail");
        } else{
            helper.hideErrorOnField(component, "marConInfo", "errmarConEmail");
        } 
        
        //MARKETING CONSENT PHONE
        if(component.find("marConPhoneCheck").get("v.checked")===true && $A.util.isEmpty(component.find("marConPhone").get("v.value"))){
            isError = true;
            helper.showErrorOnField(component, "marConPhone", "errmarConPhone");
        } else{
            helper.hideErrorOnField(component, "marConPhone", "errmarConPhone");
        } 
        
        //MARKETING CONSENT SMS
        if(component.find("marConSMSCheck").get("v.checked")===true && $A.util.isEmpty(component.find("marConSMS").get("v.value"))){
            isError = true;
            helper.showErrorOnField(component, "marConSMS", "errmarConSMS");
        } else{
            helper.hideErrorOnField(component, "marConSMS", "errmarConSMS");
        } 
        
        //Foreign Tax
        if(component.find("registeredForeignTax").get("v.checked")===true && $A.util.isEmpty(component.find("foreignTax").get("v.value"))){
            isError = true;
            helper.showErrorOnField(component, "foreignTax", "errforeignTax");
        } else{
            helper.hideErrorOnField(component, "foreignTax", "errforeignTax");
        }*/
            
            //Validate Address Details
            var isPhysicalAddAvailable = false;
            var isPostalAvailable = false;
            var isBusinessAddAvailable = false;
            var isEmployerAvailable = false;
            
            var errmsg;
            var addressData =  component.find("mainComp").get("v.addList");
            // W-005527
            var clientTypeValue = component.find("iClientType").get("v.value");
            var clientGroupValue = component.find("iClientGroup").get("v.value");
            var occupationStatusValue = component.find("iOccupationStatus").get("v.value");
            for(var i in addressData){
                if(addressData[i].Address_Type__c == 'Physical Address'){
                    
                    isPhysicalAddAvailable = true;
                }
                if(addressData[i].Address_Type__c == 'Postal'){
                    isPostalAvailable = true;
                }
                if(addressData[i].Address_Type__c == 'Business Address'){
                    isBusinessAddAvailable = true;
                }
                if(addressData[i].Address_Type__c == 'Employers'){
                    isEmployerAvailable = true;
                }
            }
            
            
            if( clientGroupValue == 'SOLE TRADER CLIENT' && (!isPhysicalAddAvailable || !isPostalAvailable || !isBusinessAddAvailable)){
                // alert("show error");
                var toastie = this.getToast('Address Details Validation', 'Add Postal,Physical and Business types of address detail required for Client', 'error');
                toastie.fire();
                isError = true;
            }
            
            /*if( clientGroupValue == 'Individual' && occupationStatusValue == 'Full Time Employed' && (!isPhysicalAddAvailable || !isPostalAvailable || !isEmployerAvailable)){
                // alert("show error");
                var toastie = this.getToast('Address Details Validation', 'Add Postal,Physical and Employer types of address detail required for Client', 'error');
                toastie.fire();
                isError = true;
            }else if( clientGroupValue == 'Individual' && occupationStatusValue != 'Full Time Employed' && (!isPhysicalAddAvailable || !isPostalAvailable )){
                // alert("show error");
                var toastie = this.getToast('Address Details Validation', 'Add Postal and Physical types of address detail required for Client', 'error');
                toastie.fire();
                isError = true;
            }*/
            
            //W-007575 Defect- Anka Ganta- 2020-11-09
            if( clientTypeValue == 'Individual' && occupationStatusValue == 'Full Time Employed'){
                if(!isPhysicalAddAvailable && !isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical,Postal and Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && !isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal and Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && !isPostalAvailable && isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical and Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && isPostalAvailable && isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && !isPostalAvailable && isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical and Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && isPostalAvailable && !isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Employer types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && isPostalAvailable && isEmployerAvailable){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }
             }else if( clientTypeValue == 'Individual' && occupationStatusValue != 'Full Time Employed' && (!isPhysicalAddAvailable || !isPostalAvailable )){
                if((!isPhysicalAddAvailable && !isPostalAvailable )){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal and Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && !isPostalAvailable ){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && isPostalAvailable ){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }
            }else if( clientGroupValue == 'Individual' && occupationStatusValue != 'Full Time Employed' && (!isPhysicalAddAvailable || !isPostalAvailable )){
                if((!isPhysicalAddAvailable && !isPostalAvailable )){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal and Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(isPhysicalAddAvailable && !isPostalAvailable ){
                    var toastie = this.getToast('Address Details Validation', 'Add Postal types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }else if(!isPhysicalAddAvailable && isPostalAvailable ){
                    var toastie = this.getToast('Address Details Validation', 'Add Physical types of address detail required for Client', 'error');
                    toastie.fire();
                    isError = true;
                }
            }
        }
     
     return isError; 
 },
    
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
    
    //Function to close focus tab and open a new tab
    closeFocusedTabAndOpenNewTab : function( component, recordId ) {
        
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
            
            console.log(focusedTabId);
            
            //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/' + recordId + '/view'
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
    
    // PJAIN: 20200331
    showErrorOnField: function(component, componentId, errorComponentId) {
        $A.util.addClass(component.find(componentId), 'slds-has-error');
        var error = component.find(errorComponentId);
        $A.util.removeClass(error,'slds-hide');
        $A.util.addClass(error,'slds-form-element__help');
    },
    
    // PJAIN: 20200331
    hideErrorOnField: function(component, componentId, errorComponentId) {
        $A.util.removeClass(component.find(componentId), 'slds-has-error');
        var error = component.find(errorComponentId);
        $A.util.removeClass(error,"slds-form-element__help");
        $A.util.addClass(error,'slds-hide');
    },
    
    //TdB - Method to create Client
    createProspectBasedOnPopup: function(component) {
        var processTypeValue = component.get('v.processType'); // TdB - New to Bank/Lite Onboarding
        var action = component.get("c.createIndividualProspectLimitedData");
        action.setParams({
            "accRecord": component.get("v.accountRecord"),
            "agreedPolicy" :component.get("v.isAgreedPrivacypolicy"),// Haritha - New to SPM onboarding consent
            "processType" : processTypeValue,
            "aggreedVerificationPolicy":component.get("v.isAgreedVerificationPolicy")// Muvhuso - New to SPM onboarding consent
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.accRecordId",response.getReturnValue());
                console.log('re : ' + response.getReturnValue());
                
                //Show Sole Trader sections
                var clientTypeValue = component.get('v.accountRecord.Client_Type__c'); 
                var clientGroupValue = component.get('v.accountRecord.Client_Group__c'); 
                
                if(clientTypeValue == 'Sole Trader' || clientGroupValue == 'SOLE TRADER CLIENT') {
                    component.set("v.isSoleTrader", true);
                    
                    //TdB - To Call Trading as Name Components
                    var tradingAsNameCmp = component.find('tradingAsNameComp');
                    if(tradingAsNameCmp != null) {
                        tradingAsNameCmp.getAccountId(component.get('v.accRecordId'));
                    }
                    
                } else {
                    component.set("v.isSoleTrader", false);
                }
                
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
            }
        });
        $A.enqueueAction(action);
    },
    
    //Added by Diksha for SPM 
    showPmuserlist : function(component, event, helper) {
        var action = component.get("c.getPortfolioManagerlist");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var ttt = response.getReturnValue();
                
                component.set('v.pmList',response.getReturnValue());
                var portManger = component.get("v.pmList");
                var selScheme = component.get("v.selectedPm");
                component.set("v.selectedPm", selScheme);
                // this.creatingSPMOpp(component, event, helper);
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    getloggedinUserProfileName : function(component, event, helper) {
        var action = component.get("c.getloggedinUserProfileName");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var loggedinProfile = response.getReturnValue();
                
                component.set('v.loggedinUserProfile',response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });
        
        $A.enqueueAction(action);
    },
    
    creatingSPMOpp : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedPm ;
        var userId = $A.get("$SObjectType.CurrentUser.Name");
        if(component.get("v.selectedPm") == undefined){
            selectedPm=userId;
        }else{
            selectedPm = component.get("v.selectedPm");
        }
        
        
        //Get logged in User details
        var action = component.get("c.createNewSPMOpportunity");
        
        action.setParams({
            "accountId" : component.get("v.accRecordId"),
            "selectedPm": selectedPm
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
                    var toast = helper.getToast("Error", 'SPM Opportunity could not be created. Please contact your Salesforce Admin', "error");
                    
                    toast.fire();
                }
                
                helper.hideSpinner(component);
                
            }else if(state === "ERROR"){
                
                var toast = helper.getToast("Error", 'SPM Opportunity could not be created. Please contact your Salesforce Admin', "error");
                
                toast.fire();
                
                helper.hideSpinner(component);
            }
            
        });
        
        
        $A.enqueueAction(action);
    },
    
})