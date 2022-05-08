({
    // function automatic called by aura:doneWaiting event 
    changeOwner : function(component,event,helper,queueName,caseStatus,infoSource){ 
        var caseId = component.get("v.recordId");
        console.log('caseId@@@ '+caseId);
        console.log('queueName@@@ '+queueName);
        console.log('caseStatus@@@ '+caseStatus);
        console.log('infoSource@@@ '+infoSource);
        var approvalStatus = component.get("v.approvalStatus");
        if(approvalStatus == 'Requested More Information'){
            queueName = 'Sales Support Consultants';
        }
        var action = component.get("c.changeOwner");
        action.setParams({"caseId" : caseId,
                          "processName" : queueName,
                          "caseStatus" : caseStatus,
                          "infoSource" : infoSource});
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
                
            }else 
            {
                console.log ('error');
            }
            this.hideSpinner(component);
            $A.get('e.force:refreshView').fire();
        });
        
        $A.enqueueAction(action);
    },
    
    refreshData: function(component, event, helper, decision, details, comments, isInsert, infoSource) {
        
        
        this.showSpinner(component); 
        var caseId = component.get("v.recordId");
        var queueName = 'Validate Payout';
        var caseStatus = 'Validate Payout';
        var decision = decision;
        var details = details;
        var comments = comments;
        var isInsert = isInsert; 
        var processName = 'Security Validator';
        var infoSource = infoSource;
        var action = component.get("c.createDecisionHistory");
        action.setParams({"caseId" : caseId,
                          "decision" : decision,
                          "details" : details,
                          "comments" : comments,
                          "processName" : processName,
                          "isInsert" : isInsert,
                          "infoSource" : infoSource});
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state == "SUCCESS")
            {                   
                var data = response.getReturnValue();
                component.set('v.gridData',  data);     
                console.log('data@@@'+data);
                console.log('grid data@@@'+component.get("v.gridData"));
            }else 
            {
                console.log ('error');
            }
            
            var columns = [
                {
                    type: 'text',
                    fieldName: 'outcome',
                    label: 'Outcome'
                },
                {
                    type: 'text',
                    fieldName: 'processType',
                    label: 'Process'
                },
                {
                    type: 'text',
                    fieldName: 'decision',
                    label: 'Decision'
                },
                {
                    type: 'text',
                    fieldName: 'details',
                    label: 'Detail'
                },
                
                {
                    type: 'text',
                    fieldName: 'comments',
                    label: 'Comments'
                },
                {
                    type: 'text',
                    fieldName: 'sanctioner',
                    label: 'Sanctioner'
                },
                {
                    type: 'text',
                    fieldName: 'decisionDate',
                    label: 'Date'
                }
            ];
            
            component.set('v.gridColumns', columns);
            this.changeOwner(component, event, helper, queueName,caseStatus,infoSource);   
            
        });
        
        $A.enqueueAction(action);
        
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
    
    // function automatic called by aura:doneWaiting event 
    setValuesFromRecord : function(component,event,helper){
        this.showSpinner(component);  
        var action = component.get("c.getCaseDetails");
        action.setParams({ caseId : component.get("v.recordId")});
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var caseDetails = response.getReturnValue();
                if(caseDetails != null){
                    component.set("v.oldCaseOwnerId",caseDetails.OwnerId);
                    component.set('v.cIFAddressValidated',caseDetails.SV_Existing_Client_CIF_Address_Validated__c);
                    component.set('v.secondTier',caseDetails.SV_2nd_Tier__c);
                    component.set('v.annualPOA',caseDetails.SV_Annual_POA_1_Year__c);
                    component.set('v.correctSuretyDocuments',caseDetails.SV_Correct_Surety_Documents_NCA__c);
                    component.set('v.creditAGMTNameRegistrationCIF',caseDetails.SV_Credit_AGMT_Name_Registration_CIF__c);
                    component.set('v.draftedByBusinessBank',caseDetails.SV_Drafted_By_Business_Bank_Not_On_SMS__c);
                    component.set('v.draftedByCAFPC',caseDetails.SV_Drafted_By_CAF_PC_Capture_On_SMS__c);
                    component.set('v.exchangeRegulation',caseDetails.SV_Exchange_Regulation_3_1__c);
                    component.set('v.cIFValCIF07',caseDetails.SV_Existing_Client_CIF_Val_CIF07__c);
                    component.set('v.iDNumberAllRelatedPartiesChecked',caseDetails.SV_ID_Number_All_Related_Parties_Checked__c);
                    component.set('v.independentCIPRODocumentObtained',caseDetails.SV_Independent_CIPRO_Document_Obtained__c);
                    component.set('v.isValidHasNotExpired',caseDetails.SV_Is_Valid_Has_Not_Expired__c);
                    component.set('v.monthlyPOA',caseDetails.SV_Monthly_POA_3_Months__c);
                    component.set('v.muniBills',caseDetails.SV_Muni_Bills_Sent_Address_Email__c);
                    component.set('v.otherSecurityDocumentation',caseDetails.SV_Other_Security_Documentation_In_Order__c);
                    component.set('v.pOICertifiedCopies',caseDetails.SV_POI_Certified_Copies__c);
                    component.set('v.pOICopiesClearLegible',caseDetails.SV_POI_Copies_Must_Be_Clear_And_Legible__c);
                    component.set('v.pOIDealershipFICertifying',caseDetails.SV_POI_Dealership_And_FI_Certifying__c);
                    component.set('v.pOINamesMatchIDDocument',caseDetails.SV_POI_Names_Match_ID_Document__c);
                    component.set('v.pOIValidatedAndSigned',caseDetails.SV_POI_Validated_And_Signed_True_Copy__c);
                    component.set('v.pOIVerificationDate',caseDetails.SV_POI_Verification_Date__c);
                    component.set('v.primaryCustomerScreeningComplete',caseDetails.SV_Primary_Customer_Screening_Complete__c);
                    component.set('v.proofOfAddress',caseDetails.SV_Proof_Of_Address__c);
                    component.set('v.qA',caseDetails.SV_QA__c);
                    component.set('v.relatedPartiesScreeningCompleted',caseDetails.SV_Related_Parties_Screening_Completed__c);
                    component.set('v.reserveBankApproval',caseDetails.SV_Reserve_Bank_Approval_Received__c);
                    component.set('v.section45Letter',caseDetails.SV_Section_45_Letters_Obtained__c);
                    component.set('v.securityResolution',caseDetails.SV_Security_Resolution_S_Is_Are_In_Order__c);
                    component.set('v.signedMandatedSanctioner',caseDetails.SV_Signed_By_Mandated_Sanctioner__c);
                    component.set('v.sMSSecuritiesApprovalConditions',caseDetails.SV_SMS_Securities_Approval_Conditions__c);
                    component.set('v.sOARecByEmail',caseDetails.SV_SOA_Rec_By_Email_With_Copy_NCA_Reg__c);
                    component.set('v.sOARecByPOBOX',caseDetails.SV_SOA_Rec_By_POBOX_Private_Bag_Name__c);
                    component.set('v.statusCapturedOnCIF',caseDetails.SV_Status_Captured_On_CIF__c);
                    component.set('v.suretyshipLegallyCorrect',caseDetails.SV_Suretyship_Legally_Correct_All_Sigs__c);
                    component.set('v.transactionResolution',caseDetails.SV_Transaction_Resolution_Obtained__c);
                    component.set('v.verificationDocsValidatedIDDoc',caseDetails.SV_Verification_Docs_Validated_As_ID_Doc__c);
                    var exchangeRegulation = component.get("v.exchangeRegulation");
                    console.log('exchangeRegulation##'+exchangeRegulation);
                    if(exchangeRegulation == "YES"){
                        component.set("v.isExchangeRegulation", true);  
                    }else{
                        component.set("v.isExchangeRegulation", false);}
                    console.log('exchange reg @@@#'+component.get("v.exchangeRegulation"));  
                }
                console.log('Case Id loaded'+caseDetails.Id);
                this.hideSpinner(component);
            }
            
            else if (state === "INCOMPLETE") {
                this.hideSpinner(component);
            }
                else if (state === "ERROR") {
                    this.hideSpinner(component);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }else{
                        console.log("Unknown error in Load Product");
                    }
                }
            
        });
        $A.enqueueAction(action);
        
        
        
    },
    getSendTO : function(component,event,caseId){	
        var action = component.get("c.fetchSendToFromCase");	
        action.setParams({ "caseId" : caseId});	
        action.setCallback(this,function(response) {	
            var state = response.getState();	
            if (state === "SUCCESS") {	
                var sendToVal = response.getReturnValue();	
                console.log(' DATAMAP 250 '+JSON.stringify(sendToVal));	
                if(sendToVal != null && sendToVal != undefined){	
                    if(sendToVal.ISSAMEOWNER == 'TRUE'){	
                        if(sendToVal.COMPNAME == 'Security Validation'){	
                            component.set("v.isCompReadOnly",false);	
                        }else{	
                            component.set("v.isCompReadOnly",true);	
                            component.set("v.activeSections",'SecurityValidator');	
                            var activeSection = ['SecurityValidatorDecision','decisionHistory'];	
                            component.set("v.activeSections2",activeSection);	
                        }	
                    }	
                }	
            }	
            else if (state === "INCOMPLETE") {	
            }	
                else if (state === "ERROR") {	
                    this.hideSpinner(component);	
                    var errors = response.getError();	
                    if (errors) {	
                        if (errors[0] && errors[0].message) {	
                            console.log("Error message: " +errors[0].message);	
                        }	
                    }else{	
                        console.log("Unknown error in Load Product");	
                    }	
                }	
        });	
        $A.enqueueAction(action);	
    },	
    updateDecisionData : function(component, event, helper,componentName,caseId){	
        var action = component.get("c.updateDecisionDataToCase");	
        action.setParams({ "caseId" : caseId,	
                          "componentName":componentName,	
                          "ownerId":component.get("v.oldCaseOwnerId")});	
        action.setCallback(this,function(response) {	
            var state = response.getState();	
            //alert(state);	
            if (state === "SUCCESS") {	
                var sendToVal = response.getReturnValue();	
            }	
            else if (state === "INCOMPLETE") {	
            }	
                else if (state === "ERROR") {	
                    this.hideSpinner(component);	
                    var errors = response.getError();	
                    if (errors) {	
                        if (errors[0] && errors[0].message) {	
                            console.log("Error message: " +errors[0].message);	
                        }	
                    }else{	
                        console.log("Unknown error in Load Product");	
                    }	
                }	
        });	
        $A.enqueueAction(action);	
    }
})