/****************@ Author: Chandra********************************
****************@ Date: 22/11/2019********************************
****************@ Description: Method to get user detail*********/
({
    
    /****************@ Author: Anka Ganta********************************
****************@ Date: 20/01/2020********************************
****************@ Description: Account and RelatedPartyDetails*********/
getParentAccountWrapper: function (component) {
    //Get ParentAccountWrapper
    var actionWrapper = component.get("c.getParentAccountWrapper");
    actionWrapper.setParams({
        "oppId" : component.get("v.recordId")
    });
    
    
    actionWrapper.setCallback(this, function(response) {
        var state = response.getState();
        if (state == "SUCCESS") {
            component.set("v.parentAccountWrapper", response.getReturnValue());
            console.log('actionWrapper ("v.parentAccountWrapper") : ' + component.get("v.parentAccountWrapper"));
            
        }else {
            console.log("Failed with state: " + state);
        }
    
    });
    $A.enqueueAction(actionWrapper);
},
getAccountDetails: function (component) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAccountData");
        action.setParams({
            "oppId": component.get("v.recordId")
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                
                //this.showSpinner(component);
                component.set("v.account", response.getReturnValue());
                component.set("v.accountRecord", response.getReturnValue());
                component.set("v.selectedIdType", component.get("v.account.ID_Type__pc"));
                component.set("v.selectedClientType", component.get("v.account.Client_Type__c"));
                component.set("v.selectedNationality", component.get("v.account.Nationality__pc"));
                component.set("v.selectedCountryResidence", component.get("v.account.Country_of_Residence__pc"));
                component.set("v.selectedCountryBirth", component.get("v.account.Country_of_Birth__pc"));
                component.set("v.selectedCountryRegistration", component.get("v.account.Country_of_Registration__c"));
                component.set("v.accountRecordType", component.get("v.account.RecordType.Name"));
                component.set("v.accRecordId", component.get("v.account.Id"));
                
                if(component.get("v.accountRecordType") == 'Business Client' || component.get("v.accountRecordType") == 'Business Prospect') {
                    component.set("v.accountName",component.get("v.account.Name"));
                } else {
                    component.set("v.accountName",component.get("v.account.FirstName") + ' ' + component.get("v.account.LastName"));
                }
                
                console.log('accountName in helper.Account: ' + component.get("v.accountName"));
                
                //Call to get Opportunity details
                //Get logged in User details
                var getOpportunityAction = component.get("c.getOpportunityData");
                
                getOpportunityAction.setParams({
                    "oppId": component.get("v.recordId")
                });
                
                // Add callback behavior for when response is received
                getOpportunityAction.setCallback(this, function(response) {
                    var message;
                    
                    var state = response.getState();
                    
                    if (component.isValid() && state === "SUCCESS") {
                        
                        var oppDetails = response.getReturnValue();
                        
                        //Set Opportunit Casa Fields
                        if(oppDetails != null) {
                            console.log('oppDetails : ' + oppDetails.CASA_Status__c);
                            console.log('oppDetails : ' + oppDetails.CASA_Reference_Number__c);
                            console.log('oppDetails : ' + oppDetails.CASA_Screening_Date__c);
                            console.log('oppDetails : ' + oppDetails.CASA_Screening_Status_Value__c);
                            console.log('oppDetails : ' + oppDetails.Risk_Rating_Date__c);
                            console.log('oppDetails : ' + oppDetails.Risk_Rating__c);
                            //console.log('oppDetails : ' + oppDetails.Case__c);
                            console.log('accountName : ' + component.get("v.accountName"));
                            component.set("v.opportunityRecord", oppDetails);
                            
                            //Show Casa results if any 
                            if(oppDetails.CASA_Reference_Number__c != null && oppDetails.CASA_Reference_Number__c != 0 && oppDetails.CASA_Reference_Number__c != '') {
                                component.set("v.showFinishedScreen", true);
                                component.set("v.activeCasaSections", 'casaScreeningResults'); 
                                console.log('activeCasaSections : ' + component.get("v.activeCasaSections"));
                            }
                            
                            
                            
                            //Show Risk fields if any
                            if (oppDetails.Risk_Rating__c != null) {
                                //Set Risk Data from Opportunity
                                var dataTable = [];
                                var riskRatingValues = {
                                    accName: component.get("v.accountName"),
                                    riskRating: oppDetails.Risk_Rating__c,
                                    screeningDate: $A.localizationService.formatDate(oppDetails.Risk_Rating_Date__c, "yyyy-MM-dd")}; 
                                
                                dataTable.push(riskRatingValues);
                                component.set("v.docList",dataTable);
                                
                                //Show Risk result Table
                                component.set("v.activeRiskSections", 'RiskRatingResults');
                                console.log('activeRiskSections : ' + component.get("v.activeRiskSections"));
                                var cmpTarget = component.find('resultsDiv');
                                $A.util.removeClass(cmpTarget, "slds-hide");
                                
                                component.set("v.showGenerateCIFButton", true);
                            }
                            
                            //Get Participant details
                            var action2 = component.get("c.getPartcicpantAccountData");
                            action2.setParams({
                                "oppId" : component.get("v.recordId"),
                                "parentAccWrapper" : component.get("v.parentAccountWrapper")
                            });
                            
                            
                            action2.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state == "SUCCESS") {
                                    console.log(' participantAccountList '+JSON.stringify(response.getReturnValue()));
                                    component.set("v.participantAccountList", response.getReturnValue());
                                    
                                }else {
                                    console.log("Failed with state: " + state);
                                }
                                
                            });
                            $A.enqueueAction(action2);
                        } 
                        
                    }else if(state === "ERROR")
                    {
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
                $A.enqueueAction(getOpportunityAction);
                
            }else {
                console.log("Failed with state: " + state);
                // this.hideSpinner(component);
            }
        });
        $A.enqueueAction(action);
    },    
    
     submitAccountDetails: function (component,event,helper) { 
         this.showSpinner(component);
          var action2 = component.get("c.callToCASAScreening");
                action2.setParams({
                    "oppId": component.get("v.recordId")
                });
                
                
         action2.setCallback(this, function(response) {
             var state = response.getState();
             var toastEvent = $A.get("e.force:showToast");
             if (state == "SUCCESS") {
                  //alert('testing++'+response.getReturnValue().toUpperCase());
                 if(response.getReturnValue().toUpperCase().includes('SUCCESS') == true ){
                     this.getAccountDetails(component,event,helper);
                     this.getTradingAsNameDetails(component,event,helper);
                     component.set("v.showFinishedScreen", true);
                     component.set("v.showRiskButton", true);
                     component.set("v.hideSubmitButton", true);
                     component.set("v.activeCasaSections", 'casaScreeningResults');
                    //W-005715 : Anka Ganta : 2020-08-18
                    this.CheckRelatedPartyCasaStatus(component,event,helper);
                     toastEvent.setParams({
                         "title": "Success!",
                         "type": "success",
                         "message": "CASA Screening has been Successfully Completed."
                     });
                 }else {
                     console.log("Failed with state: " + response.getReturnValue());
                     toastEvent.setParams({
                         "title": "Error!",
                         "type": "error",
                         "message": response.getReturnValue()
                     });
                 }
             }else {
                 console.log("Failed with state: " + state);
                 toastEvent.setParams({
                         "title": "Error!",
                         "type": "error",
                     "message": state
                 });
             }
             
             $A.get('e.force:refreshView').fire();
             
             toastEvent.fire();
                   this.hideSpinner(component);
                });
                $A.enqueueAction(action2);
  }, 
    
    refreshStatus: function (component,event,helper) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.refreshCasaStatus");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("response.getReturnValue()++"+response.getReturnValue());
                debugger;
                if(state === "SUCCESS"){
                   this.getAccountDetails(component,event,helper);
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "CASA Screening Status has been Successfully Refreshed.",
                        "type":"success"
                    });
                    toastEvent.fire();
                    component.set("v.showCasaScreen", false);
                    component.set("v.showFinishedScreen", true);
                    component.set("v.showGenerateCIFButton", false);
                    //W-005715 : Anka Ganta : 2020-08-18
                    this.CheckRelatedPartyCasaStatus(component,event,helper);
                   // var a = component.get('c.doInit');
                    
                    //$A.enqueueAction(a);
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while doing the screening process, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
			$A.get('e.force:refreshView').fire();   
            
            this.hideSpinner(component);
            
        });
        $A.enqueueAction(action);
    },
    
    /****************@ Author: Anka Ganta********************************
 	****************@ Date: 27/05/2020********************************
 	****************@ Description: getCasaAnalystComments****/
    getAnalystCommentsHelper : function (component,event,helper) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAnalystComments");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'success'){
                   this.getAccountDetails(component,event,helper);
                    this.getTradingAsNameDetails(component,event,helper);
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "CASA Analyst comments added.",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while doing the screening process, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
            
            this.hideSpinner(component);
            
        });
        $A.enqueueAction(action);
    },
    /****************@ Author: Anka Ganta********************************
 	****************@ Date: 24/06/2020********************************
 	****************@ Description: confirmDocumentReceipt****/
    confirmDocumentReceiptHelper : function (component,event,helper) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.confirmDocumentReceipt");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'success'){
                   this.getAccountDetails(component,event,helper);
                    this.getTradingAsNameDetails(component,event,helper);
                    
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Confirm Document Receipt has successfully done.",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while doing the screening process, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
            
            this.hideSpinner(component);
            
        });
        $A.enqueueAction(action);
    },
    
    /****************@ Author: Anka Ganta********************************
 	****************@ Date: 21/07/2020********************************
 	****************@ Description: getDocuments for CASA Tier 1, Tier 2, Tier 3 approval****/
    getDocumentsCasaTiersHelper : function (component,event,helper) {
        this.showSpinner(component);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getDocumentsCasaTiers");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() == 'success'){
                   this.getAccountDetails(component,event,helper);
                    this.getTradingAsNameDetails(component,event,helper);
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Get Documents Orchestration service has completed successfully.",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": response.getReturnValue(),
                        "duration":"15000",
                        "type":"error"
                    });
                    toastEvent.fire();
                } 
            }
            else {
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "An error occured while doing the screening process, please try again.",
                    "type":"error"
                });
                toastEvent.fire();
            }
            
            
            this.hideSpinner(component);
            
        });
        $A.enqueueAction(action);
    },
    
    getTradingAsNameDetails: function(component, event, helper){
        //Get Tradig as Details details
        var action2 = component.get("c.getTradingAsNameData");
        action2.setParams({
            "oppId" : component.get("v.recordId"),
            "businessRelatedParties" : component.get("v.businessParticipantAccountList"),
            "parentAccWrapper" : component.get("v.parentAccountWrapper")
        });
        
        
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                component.set("v.tradingAsNameList", response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + state);
            }
        
            
        });
        $A.enqueueAction(action2);
    },
   
    // function automatic called by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // remove slds-hide class from mySpinner
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // add slds-hide class from mySpinner    
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    eddProcessValidation: function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.getDocsByOppId");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                 component.set("v.documentTypes", response.getReturnValue());
                  var eddRequiredDocuments = component.get("v.documentTypes");
                  console.log("eddRequiredDocuments++"+eddRequiredDocuments);
                if(eddRequiredDocuments.length != 3){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type": "error",
                        "title": "",
                        "message": "Please upload EDD Documents:EDD level ll report,Management sign off,Proof of source of Income / funds"
                    });
                    toastEvent.fire();
                }
                else{
                    var caseRec = component.get("v.opportunityRecord.Case__c");
                    console.log("caseRec"+caseRec);
                    var caseStatus = component.get("v.opportunityRecord.Case__r.Status");
                    console.log("caseStatus::"+caseStatus);
                    var Resolvedlabel = $A.get("$Label.c.Resolved");
                    if($A.util.isUndefinedOrNull(caseRec) || caseStatus == Resolvedlabel){
                        this.createCIFHelper(component, event, helper);
                    }
                    else{
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type": "error",
                            "title": "",
                            "message": "Please Resolve below related case of Opportunity to proceed further"
                        });
                        toastEvent.fire();
                    }
                }
                 
            }
            else {
                console.log("Failed with state: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
      //Start changes for W-004683 By Himani 
      
    getEntitytype: function (component, event, helper) {
        
        var action = component.get("c.getentitytype");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var responsevalue1=response.getReturnValue();
                component.set("v.entitytype",responsevalue1);
                var entitytype=component.get("v.entitytype");
                console.log("entitytype"+entitytype);
                for(var i in entitytype)
                {
                 console.log("entityvalue"+entitytype[i].Entity_Type__c);
                 component.set("v.entitytypestring",entitytype[i].Entity_Type__c);
                }
                
                this.DocumentUpload(component);
               }
            else {
                console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
     DocumentUpload: function (component, event, helper) {
        
        var action = component.get("c.getDocs");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var responsevalue1=response.getReturnValue();
                component.set("v.documentsUploaded",responsevalue1);
                //this.getMandatoryDocs(component);
                this.getPrimayClientMandatoryDocs(component);
                this.getRelMandatoryDocs(component);
               }
            else {
                console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    
     
   
   getMandatoryDocs : function (component){
       var Entitytype = component.get("v.entitytypestring");
       var OppId = component.get("v.recordId");
       console.log("Entitytype"+Entitytype);
       var action = component.get("c.getAllMandatoryDocuments"); 
       action.setParams({
            "Entitytype": Entitytype
        });
       action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
            var responsevalue=response.getReturnValue();
            console.log("responsevalue"+responsevalue);
            component.set('v.Mandatorydocuments',responsevalue);
            var Mandatorydocuments=component.get("v.Mandatorydocuments");
            var documentsUploaded= component.get("v.documentsUploaded");
                
            console.log("v.Mandatorydocuments"+Mandatorydocuments);
            console.log("v.documentsUploaded"+documentsUploaded);
                var DocFlag;
                var checkFlag;
                var nonMandFlag='F';
                for(var i in Mandatorydocuments)
                {
                    
                    DocFlag='F';
                    for(var j in documentsUploaded) 
                    {
                        console.log("Mandatorydocuments[i].ECM_Type__c"+Mandatorydocuments[i].ECM_Type__c);
                        console.log("documentsUploaded[j]"+documentsUploaded[j]);
                        if(documentsUploaded[j]===Mandatorydocuments[i].ECM_Type__c)
                        { 
                            DocFlag='T';
                        }
                    }
                    if (DocFlag==='F')
                    {   
                        console.log("bb");
                        nonMandFlag='T'
                        //    this.setOpportunityVal(component, event, true);
                    } 
                }
                
                if (nonMandFlag==='T')
                {
                    console.log("no mand docs available");
                    this.setOpportunityVal(component, event, true);
                }
                else
                {  console.log("mand docs available");
                 this.setOpportunityVal(component, event, false);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }else{
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
        
   getRelMandatoryDocs : function (component){
      
       var Entitytype = component.get("v.entitytypestring");
       var OppId = component.get("v.recordId");
       var documentsUploaded=component.get("v.documentsUploaded");
       console.log("documentsUploaded"+documentsUploaded);
        console.log("Entitytype"+Entitytype);
        console.log("OppId"+OppId);
       
       var action = component.get("c.getAllRelatedMandatoryDocuments"); 
       action.setParams({
             "Entitytype": Entitytype,
             "OppId": OppId
        });
       action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
            var responsevalue = response.getReturnValue();
            console.log("responsevalue"+responsevalue);
                
                component.set("v.relatedPartyManDocs",responsevalue);
                
            console.log("relaPartyManDocs+++"+component.get("v.relatedPartyManDocs")); 
            }
           
           else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }}
           
        });
        $A.enqueueAction(action);
           
       
    },
  setOpportunityVal : function(component, event, checkFlag) {
        console.log("checkFlag++"+checkFlag);
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOpportunity");
        action.setParams({
            recordId: recordId,
    		docFlag: checkFlag
        });
        action.setCallback(this, function(data) {
         	var response = data.getReturnValue();
            
        });
        $A.enqueueAction(action); 
        
	},  
    
  //End changes for W-004683 By Himani
    // W-005715 : Anka Ganta : 2020-08-18
  // if Related party status is not 'Approved' Stop user to do Risk Profiling and make relPartyInvalidStatusFlag is true
  CheckRelatedPartyCasaStatus : function(component, event, helper) {
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.CheckRelatedPartyCasaStatus");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            //debugger;
            component.set("v.relPartyInvalidStatusFlag", response.getReturnValue());
            console.log("relPartyInvalidStatusFlag"+component.get("v.relPartyInvalidStatusFlag"));
            
        });
        $A.enqueueAction(action); 
        
	},  
    //W-005661 - Anka Ganta - 2020-09-19
     getPrimayClientMandatoryDocs : function (component){
      
       var Entitytype = component.get("v.entitytypestring");
       var OppId = component.get("v.recordId");
       var documentsUploaded=component.get("v.documentsUploaded");
       console.log("documentsUploaded"+documentsUploaded);
        console.log("Entitytype"+Entitytype);
        console.log("OppId"+OppId);
       
       var action = component.get("c.getPrimaryClientMandatoryDocuments"); 
       action.setParams({
             "Entitytype": Entitytype,
             "OppId": OppId
        });
       action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
            var responsevalue = response.getReturnValue();
            console.log("responsevalue"+responsevalue);
            component.set("v.PrimaryClientMandDocs",responsevalue);
            console.log("PrimaryClientMandDocs+++"+component.get("v.PrimaryClientMandDocs"));
            }
           
           else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +errors[0].message);
                    }
                }}
           
        });
        $A.enqueueAction(action);
           
       
    },

    //Tdb - Business Entities as Related Parties
    getBusinessAccountDetails: function (component) {        
        
        //Get Participant details
        var action2 = component.get("c.getPartcicpantBusinessAccountData");
        action2.setParams({
            "oppId" : component.get("v.recordId")
        });
                
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                console.log(' businessParticipantAccountList '+JSON.stringify(response.getReturnValue()));
                component.set("v.businessParticipantAccountList", response.getReturnValue());
                
            }else {
                console.log("Failed with state: " + state);
            }
            
        });
        
        $A.enqueueAction(action2);
    },
})