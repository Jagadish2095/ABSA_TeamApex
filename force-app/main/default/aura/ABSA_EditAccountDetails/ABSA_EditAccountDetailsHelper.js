({
    //Function to Call Experian Service 
    callExperianService : function(component, event, helper){
        this.showSpinner(component);
        var action = component.get("c.callExperianHandler");
        var regNumber = component.find("regNumberC").get("v.value");
        action.setParams({"registrationNumber" : regNumber});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if(respObj.statusCode==200){
                    console.log('EXPERIAN SERVICE SUCCESS');       
                    console.log('=========>'+JSON.stringify(respObj.companyDownload.results.kreditSearchFile.companyDetails));
                    component.set('v.experianResponse',respObj);
                    var CompanyDetailsObj = respObj.companyDownload.results.kreditSearchFile.companyDetails;
                    component.set('v.companyDetails',CompanyDetailsObj);
                    component.set("v.isExperianModalOpen",true);  
                    
                    //Added by Diksha for W-4484 complex onboarding
                    console.log('=========>'+JSON.stringify(CompanyDetailsObj.status));
                    if(CompanyDetailsObj!=undefined && CompanyDetailsObj!='' && CompanyDetailsObj!=null ){
                    if($A.get("$Label.c.Entity_Type_Status_To_Proceed").includes(CompanyDetailsObj.status)){

                    }
                    else{
                      let button =component.find('correctInfo');  
                      button.set('v.disabled',true);
                    }
                    }

                    
                } else if(respObj.statusCode > 399 || respObj.statusCode < 500){
                    console.log('EXPERIAN SERVICE ERROR OCCURRED');  
                    var message = respObj.message;
                    var toastEvent = helper.getToast("Error", message, "error");
                	toastEvent.fire();
                } else{
                    console.log('EXPERIAN SERVICE ERROR OCCURRED');  
                    var message = "We cannot complete the request now, please try again if error persist contact administrator."
                    var toastEvent = helper.getToast("Error", message, "error");
                	toastEvent.fire();
                }
                this.hideSpinner(component);
            } else if(state === "ERROR"){
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
    
    submitAccountDetailsCIF: function(component,event,helper){
    var action = component.get("c.clientdetails");
    var AccId = component.get("v.recordId");
    console.log("The Account from helper***" + AccId);
    action.setParams({"clientAccountId" : AccId});
        action.setCallback(this, function(response) {
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
       
   getEntityType : function(component,event,helper){
    var action = component.get("c.getEntityType");
    var OppId = component.get("v.recordId");
    
    console.log("The Account from helper***" + OppId);
    action.setParams({"recordId" : OppId});
       action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
           if (state == "SUCCESS") {
                component.set('v.clientType',response.getReturnValue());
   
}     
        });
        $A.enqueueAction(action);

},
    
    //Function to Create Business Prospect Account
    CreateBusinessAccount : function(component, event, helper){
        this.showSpinner(component);
        var experianObj = component.get('v.experianResponse');
        var action = component.get("c.CreateBusinessProspect");
        var accountId = component.get('v.accRecordId');
        action.setParams({
            "experianData2" : JSON.stringify(experianObj),
            "accRecordId" : accountId // PJAIN: 20200331
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            var message = '';
            if (state == "SUCCESS") {
                console.log('==BUSS==accRecord====>'+response.getReturnValue());
                var accountRec = response.getReturnValue();
                //START W-003571 - 2020-03-18
                component.set('v.accRecordId',accountRec.Id);
                component.set('v.clientType',accountRec.Client_Type__c);
                if(component.find("clientType") != undefined){
                    component.find("clientType").set("v.value",accountRec.Client_Type__c);
                }
                component.set('v.highIndustryValue',accountRec.The_Client_is_involved_in_High_Risk_Indu__c);                
                //END W-003571
                
                component.set("v.isExperianModalOpen",false);
                component.set("v.showRecordEditForm", true);
               // $A.util.removeClass(component.find("populateDiv"), "slds-hide");
                component.set("v.goldenSourceConsentGiven", true);
                $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
                 component.set("v.disableConsentCheckbox", true);
                this.hideSpinner(component);
                
                //Newly added by Rajesh for Financial Year End
                component.find("finYearEnd").set("v.value",accountRec.Financial_Year_End__c);
                
                //To Call Related Parties Components
                var relatedP = component.find('relatedPartiesCmp');
                relatedP.getOnboardingAccountId(component.get('v.accRecordId'));
                relatedP.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));//Added by chandra against W-004746
                
                //To Call Business Address Components
                var objCompB = component.find('mainComp');
                objCompB.getAccountId(component.get('v.recordId'));
                objCompB.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));
                
                //TdB - To Call Trading as Name Components
                var tradingAsNameCmp = component.find('tradingAsNameComp');
                tradingAsNameCmp.getAccountId(component.get('v.recordId'));
                
                //Added by Masechaba Maseli to call UBO List View
                var uboStructure = component.find('uboListViewCmp');
                uboStructure.getOnboardingUBOAccountId(component.get('v.recordId'));
                uboStructure.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));//Added by chandra against W-004746
                
                setTimeout($A.getCallback(function() {
                    component.set("v.activeSections", component.get('v.defaultActiveSections'));
                }));
                
            } else if(state === "ERROR"){
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
    
    //To show validations on Client Form
    showValidations : function(component) {  
        var incomeTax = this.validateIncomeTaxNumber(component);
        var vatNumber = this.validateVatNumber(component);
        var foreignTax = this.validateForeignTax(component);
        var countryOfForeingTax = this.validateCountryOfForeignTax(component);
        var language = this.validateLanguage(component);
        

        console.log ('showValidations values === incomeTax: [' + incomeTax + '];vatNumber: [' + vatNumber + '];foreignTax: [' + foreignTax + '];countryOfForeingTax: [' + countryOfForeingTax + '];language: [' + language + '];');

        return !incomeTax && !vatNumber && !foreignTax && !countryOfForeingTax && !language;
        
    },

    validateIncomeTaxNumber: function(component){
        //var incomeTaxNumber = component.find("itNumber").get("v.value");
        var iTaxCMP = component.find("itNumber");
        console.log("iTaxCMP>>");
        console.log(iTaxCMP);
        var incomeTaxNumber;
        if(iTaxCMP!==null && iTaxCMP!=='undefined' && iTaxCMP!==undefined){
            incomeTaxNumber = iTaxCMP.get("v.value");
            console.log("incomeTaxNumber");
            console.log(incomeTaxNumber);
        }
        if(component.find("registeredTax").get("v.checked")===true && $A.util.isEmpty(incomeTaxNumber)){
            console.log("incomeTaxNumber>>"+incomeTaxNumber);
            return this.showError(component, "itNumber");
        } else{
            if(component.find("registeredTax").get("v.checked")===false && !$A.util.isEmpty(incomeTaxNumber)){
                component.find("registeredTax").set("v.checked", true);
            }
            return this.hideError(component, "itNumber");
        }
    },

    validateVatNumber: function(component){
        var vatNumber = component.find("vatNumber").get("v.value");
        if(component.find("registeredVAT").get("v.checked")===true && $A.util.isEmpty(vatNumber)){
            return this.showError(component, "vatNumber"); 
        } else{
            var pattern = new RegExp('^(4)([0-9]{9})$');
            if (vatNumber !== null && vatNumber !== "" && !vatNumber.toString().match(pattern)){
                return this.showError(component, "vatNumber");
            }
            if(component.find("registeredVAT").get("v.checked")===false && !$A.util.isEmpty(vatNumber)){
                component.find("registeredVAT").set("v.checked", true);
            }
            return this.hideError(component, "vatNumber");
        }
    },

    validateForeignTax: function(component){
       var foreignTax = component.find("foreignTax").get("v.value");
        if(component.find("registeredForeignTax").get("v.checked")===true && $A.util.isEmpty(foreignTax)){
            return this.showError(component,"foreignTax");
        } else{
            if(component.find("registeredForeignTax").get("v.checked")===false && !$A.util.isEmpty(foreignTax)){
                component.find("registeredForeignTax").set("v.checked", true);
            }
            return this.hideError(component, "foreignTax");
        }
    },

    validateCountryOfForeignTax: function(component){
        if(component.find("registeredForeignTax").get("v.checked")===true && $A.util.isEmpty(component.find("countryForeignTax").get("v.value"))){
            return this.showError(component, "countryForeignTax");
        } else{
            return this.hideError(component, "countryForeignTax");
        }
    },

    //no longer applicable
    validateLanguage : function(component){
        if(component.find("language").get("v.value")=='Other' && $A.util.isEmpty(component.find("specifyLanguage").get("v.value"))){
            return this.showError(component,"specifyLanguage");
        } else{
            return this.hideError(component, "specifyLanguage");
        }
    },

    hideError: function(component, fieldName) {
        $A.util.removeClass(component.find(fieldName), 'slds-has-error');
        var error = component.find("err" + fieldName);
        $A.util.removeClass(error,"slds-form-element__help");
        $A.util.addClass(error,'slds-hide');
        return false;
    },

    showError: function(component, fieldName) {
        $A.util.addClass(component.find(fieldName), 'slds-has-error');
        var error = component.find("err" + fieldName);
        $A.util.removeClass(error,'slds-hide');
        $A.util.addClass(error,'slds-form-element__help');
        return true;
    },
   /** 
    fetchPickListVal: function(component, fieldName, elementId) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.account"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
  
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                
                if(elementId == 'countriesTraded'){
                    component.set("v.countriesTradedOptions", opts); 
                }
            }
        });
        $A.enqueueAction(action);
    },
    **/
    // PJAIN: 20200327
    populateBusinessProspectRecordTypeId: function(component) {
        var action = component.get("c.getAccountRecordTypeId");
        action.setParams({
            "recordTypeName": "Prospect"
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set('v.businessProspectRecordTypeId',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    //TdB - Method to create Client
    createProspectBasedOnPopup: function(component) {
        var action = component.get("c.createBusinessProspectLimitedData");
        action.setParams({
            "accRecord": component.get("v.accountRecord") 
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.accRecordId",response.getReturnValue());
                console.log('re : ' + response.getReturnValue());
                
                //TdB - To Call Related Parties Components
                var relatedP = component.find('relatedPartiesCmp');
                relatedP.getOnboardingAccountId(component.get('v.recordId'));
                relatedP.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));//Added by chandra against W-004746
                
                //Chandra - To Call UBO List View
            	var relatedubo = component.find('uboListViewCmp');
            	relatedubo.getOnboardingUBOAccountId(component.get('v.accRecordId'));
                relatedubo.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));//Added by chandra against W-004746
                
                //TdB - To Call Business Address Components
                var objCompB = component.find('mainComp');
                objCompB.getAccountId(component.get('v.recordId'));
                objCompB.getAccountClientType(component.get('v.accountRecord.Client_Type__c'));
                
                //TdB - To Call Trading as Name Components
                var tradingAsNameCmp = component.find('tradingAsNameComp');
                tradingAsNameCmp.getAccountId(component.get('v.recordId'));
            }
        });
        $A.enqueueAction(action);
    },
    
    //W-004493 - Manoj 07142020 - Getting Mapping of Entity Types and Golden Sources
    goldenSourceMapping : function(component, event, helper){
        var action = component.get("c.getEntitiesMapping");
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set("v.goldenSourceMappings",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    //W-004493 - Manoj 07142020 - Getting Mapping of Entity Types and Golden Sources
    showPrivateCompanyValidation : function(component, event, helper){
        var message = "You are only allowed to Onboard Pty Ltd";
        var toastEvent = helper.getToast("Error", message, "error");
        toastEvent.fire();
    },
    showBigForm : function(component, event, helper){
        
        var accRecordDetails = component.get('v.recordId');
        var isTrust = false;
        var clientTypeVal = component.find("idClientType").get("v.value");
      
       // var idTypeVal = component.find("idIdType") != undefined ? component.find("idIdType").get("v.value") : '';
      // console.log('clientTypeVal : ' + clientTypeVal);
       
            
            console.log('clientGroup : ' + accRecordDetails.Client_Group__c);
            
        //    component.set("v.clientGroup", accRecordDetails.Client_Group__c);
       //     component.set("v.clientType", component.find("idClientType").get("v.value"));
        //    component.set("v.clientType2", component.find("idClientType").get("v.value"));
        //    component.set("v.placeOfResidence", component.find("placeOfResidence2").get("v.value"));//accRecordDetails.Place_of_Residence__c);
        //    component.set("v.showRecordEditForm", true);
            
           // helper.createProspectBasedOnPopup(component);  
            $A.util.removeClass(component.find("goldenSourceDocs"), "slds-hide");
            
            setTimeout($A.getCallback(function() {
                component.set("v.activeSections", component.get('v.defaultActiveSections'));
            }));
            
            component.set("v.showLimitedAccountInfoModal",true);
        
        
    },
    ShowAll: function (component, event) {
       
            component.set("v.activeSections",["Account",
                "IDV",
                "commmunication",
                "BusinessInfo",
                "Financial",
                "BusinessAdd",
                "Regulatory",
                "tradingAsName",
                "Relationships"]);
 
    }
})