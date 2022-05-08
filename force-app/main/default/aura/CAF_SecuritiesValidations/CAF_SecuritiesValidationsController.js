({
    init: function (component,evt,helper) {
        console.log('recordId##' + component.get("v.recordId"));
        var selection = [
            { label: "Yes", value: "Yes" },
            { label: "No", value: "No" },
            { label: "Not Applicable", value: "Not Applicable" }
        ];
        component.set("v.selectOptions", selection);
        helper.getSendTO(component, event, component.get("v.recordId"));
        helper.refreshData(component, event, helper,'','','',false,'');
        helper.setValuesFromRecord(component, event, helper);    
        
    },
    
   handleExchangeRegulation : function(component, event, helper) {  
    var exchangeRegulation = component.find("exchangeRegulationGroup").get("v.value");
    console.log('exchangeRegulation##'+exchangeRegulation);
    component.find("exchangeRegulationValue").set("v.value",exchangeRegulation);

     if(exchangeRegulation == "YES"){
      component.set("v.isExchangeRegulation", true);  
       }else{
       component.set("v.isExchangeRegulation", false);}
       
   },
    
   handleReserveBankApproval : function(component, event, helper) {  
    var reserveBankApproval = component.find("reserveBankApprovalGroup").get("v.value");
    console.log('reserveBankApproval##'+reserveBankApproval);
     component.find("reserveBankApprovalValue").set("v.value",reserveBankApproval);
   },
     
      handleStatusCapturedOnCIF : function(component, event, helper) {  
    var statusCapturedOnCIF = component.find("statusCapturedOnCIFGroup").get("v.value");
    console.log('statusCapturedOnCIF##'+statusCapturedOnCIF);
     component.find("statusCapturedOnCIFValue").set("v.value",statusCapturedOnCIF);
  
   },
      handleMonthlyPOA : function(component, event, helper) {  
    var monthlyPOA = component.find("monthlyPOAGroup").get("v.value");
    console.log('monthlyPOA##'+monthlyPOA);
     component.find("monthlyPOAValue").set("v.value",monthlyPOA);
  
   },
      handleAnnualPOA : function(component, event, helper) {  
    var annualPOA = component.find("annualPOAGroup").get("v.value");
    console.log('annualPOA##'+annualPOA);
     component.find("annualPOAValue").set("v.value",annualPOA);
  
   },
      handleMuniBills : function(component, event, helper) {  
    var muniBills = component.find("muniBillsGroup").get("v.value");
    console.log('muniBills##'+muniBills);
     component.find("muniBillsValue").set("v.value",muniBills);
  
   },
      handleVerificationDocsValidatedIDDoc : function(component, event, helper) {  
    var verificationDocsValidatedIDDoc = component.find("verificationDocsValidatedIDDocGroup").get("v.value");
    console.log('verificationDocsValidatedIDDoc##'+verificationDocsValidatedIDDoc);
     component.find("verificationDocsValidatedIDDocValue").set("v.value",verificationDocsValidatedIDDoc);
  
   },
      handleSOARecByEmail : function(component, event, helper) {  
    var sOARecByEmail = component.find("sOARecByEmailGroup").get("v.value");
    console.log('sOARecByEmail##'+sOARecByEmail);
     component.find("sOARecByEmailValue").set("v.value",sOARecByEmail);
  
   },
    
    handleSOARecByPOBOX : function(component, event, helper) {  
    var sOARecByPOBOX = component.find("sOARecByPOBOXGroup").get("v.value");
    console.log('sOARecByPOBOX##'+sOARecByPOBOX);
     component.find("sOARecByPOBOXValue").set("v.value",sOARecByPOBOX);
  
   },
    handlePOIValidatedAndSigned : function(component, event, helper) {  
    var pOIValidatedAndSigned = component.find("pOIValidatedAndSignedGroup").get("v.value");
    console.log('pOIValidatedAndSigned##'+pOIValidatedAndSigned);
     component.find("pOIValidatedAndSignedValue").set("v.value",pOIValidatedAndSigned);
  
   },
    handlePOIDealershipFICertifying : function(component, event, helper) {  
    var pOIDealershipFICertifying = component.find("pOIDealershipFICertifyingGroup").get("v.value");
    console.log('pOIDealershipFICertifying##'+pOIDealershipFICertifying);
     component.find("pOIDealershipFICertifyingValue").set("v.value",pOIDealershipFICertifying);
  
   },
    handlePOIVerificationDate : function(component, event, helper) {  
    var pOIVerificationDate = component.find("pOIVerificationDateGroup").get("v.value");
    console.log('pOIVerificationDate##'+pOIVerificationDate);
     component.find("pOIVerificationDateValue").set("v.value",pOIVerificationDate);
  
   },
    handlePOICopiesClearLegible : function(component, event, helper) {  
    var pOICopiesClearLegible = component.find("pOICopiesClearLegibleGroup").get("v.value");
    console.log('pOICopiesClearLegible##'+pOICopiesClearLegible);
     component.find("pOICopiesClearLegibleValue").set("v.value",pOICopiesClearLegible);
  
   },
    handlePOINamesMatchIDDocument : function(component, event, helper) {  
    var pOINamesMatchIDDocument = component.find("pOINamesMatchIDDocumentGroup").get("v.value");
    console.log('pOINamesMatchIDDocument##'+pOINamesMatchIDDocument);
     component.find("pOINamesMatchIDDocumentValue").set("v.value",pOINamesMatchIDDocument);
  
   },
    handlePOICertifiedCopies : function(component, event, helper) {  
    var pOICertifiedCopies = component.find("pOICertifiedCopiesGroup").get("v.value");
    console.log('pOICertifiedCopies##'+pOICertifiedCopies);
     component.find("pOICertifiedCopiesValue").set("v.value",pOICertifiedCopies);
  
   },
    handleIDNumberAllRelatedPartiesChecked : function(component, event, helper) {  
    var iDNumberAllRelatedPartiesChecked = component.find("iDNumberAllRelatedPartiesCheckedGroup").get("v.value");
    console.log('iDNumberAllRelatedPartiesChecked##'+iDNumberAllRelatedPartiesChecked);
     component.find("iDNumberAllRelatedPartiesCheckedValue").set("v.value",iDNumberAllRelatedPartiesChecked);
  
   },
    handlePrimaryCustomerScreeningComplete : function(component, event, helper) {  
    var primaryCustomerScreeningComplete = component.find("primaryCustomerScreeningCompleteGroup").get("v.value");
    console.log('primaryCustomerScreeningComplete##'+primaryCustomerScreeningComplete);
     component.find("primaryCustomerScreeningCompleteValue").set("v.value",primaryCustomerScreeningComplete);
  
   },
    handleSecondTier : function(component, event, helper) {  
    var secondTier = component.find("secondTierGroup").get("v.value");
    console.log('secondTier##'+secondTier);
     component.find("secondTierValue").set("v.value",secondTier);
  
   },
    handleQA : function(component, event, helper) {  
    var qA = component.find("qAGroup").get("v.value");
    console.log('qA##'+qA);
     component.find("qAValue").set("v.value",qA);
  
   },
    handleProofOfAddress : function(component, event, helper) {  
    var proofOfAddress = component.find("proofOfAddressGroup").get("v.value");
    console.log('proofOfAddress##'+proofOfAddress);
     component.find("proofOfAddressValue").set("v.value",proofOfAddress);
  
   },
    handleRelatedPartiesScreeningCompleted : function(component, event, helper) {  
    var relatedPartiesScreeningCompleted = component.find("relatedPartiesScreeningCompletedGroup").get("v.value");
    console.log('relatedPartiesScreeningCompleted##'+relatedPartiesScreeningCompleted);
     component.find("relatedPartiesScreeningCompletedValue").set("v.value",relatedPartiesScreeningCompleted);
  
   },
    handleIndependentCIPRODocumentObtained : function(component, event, helper) {  
    var independentCIPRODocumentObtained = component.find("independentCIPRODocumentObtainedGroup").get("v.value");
    console.log('independentCIPRODocumentObtained##'+independentCIPRODocumentObtained);
     component.find("independentCIPRODocumentObtainedValue").set("v.value",independentCIPRODocumentObtained);
  
   },
    handleCIFValCIF07 : function(component, event, helper) {  
    var cIFValCIF07 = component.find("cIFValCIF07Group").get("v.value");
    console.log('cIFValCIF07##'+cIFValCIF07);
     component.find("cIFValCIF07Value").set("v.value",cIFValCIF07);
  
   },
    handleCIFAddressValidated : function(component, event, helper) {  
    var cIFAddressValidated = component.find("cIFAddressValidatedGroup").get("v.value");
    console.log('cIFAddressValidated##'+cIFAddressValidated);
     component.find("cIFAddressValidatedValue").set("v.value",cIFAddressValidated);
  
   },
    handleCreditAGMTNameRegistrationCIF : function(component, event, helper) {  
    var creditAGMTNameRegistrationCIF = component.find("creditAGMTNameRegistrationCIFGroup").get("v.value");
    console.log('creditAGMTNameRegistrationCIF##'+creditAGMTNameRegistrationCIF);
     component.find("creditAGMTNameRegistrationCIFValue").set("v.value",creditAGMTNameRegistrationCIF);
  
   },
    handleSignedMandatedSanctioner : function(component, event, helper) {  
    var signedMandatedSanctioner = component.find("signedMandatedSanctionerGroup").get("v.value");
    console.log('signedMandatedSanctioner##'+signedMandatedSanctioner);
     component.find("signedMandatedSanctionerValue").set("v.value",signedMandatedSanctioner);
  
   },
    handleIsValidHasNotExpired : function(component, event, helper) {  
    var isValidHasNotExpired = component.find("isValidHasNotExpiredGroup").get("v.value");
    console.log('isValidHasNotExpired##'+isValidHasNotExpired);
     component.find("isValidHasNotExpiredValue").set("v.value",isValidHasNotExpired);
  
   },
    handleSMSSecuritiesApprovalConditions : function(component, event, helper) {  
    var sMSSecuritiesApprovalConditions = component.find("sMSSecuritiesApprovalConditionsGroup").get("v.value");
    console.log('sMSSecuritiesApprovalConditions##'+sMSSecuritiesApprovalConditions);
     component.find("sMSSecuritiesApprovalConditionsValue").set("v.value",sMSSecuritiesApprovalConditions);
  
   },
    handleDraftedByBusinessBank : function(component, event, helper) {  
    var draftedByBusinessBank = component.find("draftedByBusinessBankGroup").get("v.value");
    console.log('draftedByBusinessBank##'+draftedByBusinessBank);
     component.find("draftedByBusinessBankValue").set("v.value",draftedByBusinessBank);
  
   },
    handleDraftedByCAFPC: function(component, event, helper) {  
    var draftedByCAFPC = component.find("draftedByCAFPCGroup").get("v.value");
    console.log('draftedByCAFPC##'+draftedByCAFPC);
     component.find("draftedByCAFPCValue").set("v.value",draftedByCAFPC);
  
   },
    handleSuretyshipLegallyCorrect : function(component, event, helper) {  
    var suretyshipLegallyCorrect = component.find("suretyshipLegallyCorrectGroup").get("v.value");
    console.log('suretyshipLegallyCorrect##'+suretyshipLegallyCorrect);
     component.find("suretyshipLegallyCorrectValue").set("v.value",suretyshipLegallyCorrect);
  
   },
    handleCorrectSuretyDocuments : function(component, event, helper) {  
    var correctSuretyDocuments = component.find("correctSuretyDocumentsGroup").get("v.value");
    console.log('correctSuretyDocuments##'+correctSuretyDocuments);
     component.find("correctSuretyDocumentsValue").set("v.value",correctSuretyDocuments);
  
   },
    handleOtherSecurityDocumentation : function(component, event, helper) {  
    var otherSecurityDocumentation = component.find("otherSecurityDocumentationGroup").get("v.value");
    console.log('otherSecurityDocumentation##'+otherSecurityDocumentation);
     component.find("otherSecurityDocumentationValue").set("v.value",otherSecurityDocumentation);
  
   },
    handleTransactionResolution : function(component, event, helper) {  
    var transactionResolution = component.find("transactionResolutionGroup").get("v.value");
    console.log('transactionResolution##'+transactionResolution);
     component.find("transactionResolutionValue").set("v.value",transactionResolution);
  
   },
    handleSecurityResolution : function(component, event, helper) {  
    var securityResolution = component.find("securityResolutionGroup").get("v.value");
    console.log('securityResolution##'+securityResolution);
     component.find("securityResolutionValue").set("v.value",securityResolution);
  
   },
    handleSection45Letter : function(component, event, helper) {  
    var section45Letter = component.find("section45LetterGroup").get("v.value");
    console.log('section45Letter##'+section45Letter);
     component.find("section45LetterValue").set("v.value",section45Letter);
  
   },
    onGrantButtonClick : function(component, event, helper) { 
     component.set("v.approvalStatus", "Approved");
     console.log('approvalStatus##' + component.get("v.approvalStatus"));   
      
   },
    onComment : function(component, event, helper) { 
      var commentTextArea = component.find("commentTextAreaId").get("v.value");
      component.set('v.commentTextArea', commentTextArea); 
      console.log('approvalComment## '+commentTextArea);
      console.log('commentTextArea## '+component.get("v.commentTextArea"));  
   }, 
     onAttestDecision : function(component, event, helper) { 
     var attestDecision = component.find("attestDecision").get("v.checked");
    console.log('attestDecision##' + attestDecision);
    if (attestDecision == true) {
        component.set("v.isSubmitDecision", "true");
    } else {
        component.set("v.isSubmitDecision", "false");
    }  
   }, 
    submitDecision : function(component, event, helper) { 
        helper.updateDecisionData(component, event, helper,'Security Validation',component.get("v.recordId"));
        if( component.get("v.approvalStatus") == "Approved" && 
           (component.get('v.cIFAddressValidated') == undefined ||
            component.get('v.secondTier') == undefined ||
            component.get('v.annualPOA') == undefined ||
            /*component.get('v.correctSuretyDocuments') == undefined ||
            component.get('v.creditAGMTNameRegistrationCIF') == undefined ||
            component.get('v.draftedByBusinessBank') == undefined ||
            component.get('v.draftedByCAFPC') == undefined ||
            component.get('v.exchangeRegulation') == undefined ||
            component.get('v.cIFValCIF07') == undefined ||
            component.get('v.iDNumberAllRelatedPartiesChecked') == undefined ||
            component.get('v.independentCIPRODocumentObtained') == undefined ||
            component.get('v.isValidHasNotExpired') == undefined ||
            component.get('v.monthlyPOA') == undefined ||
            component.get('v.muniBills') == undefined ||
            component.get('v.otherSecurityDocumentation') == undefined ||
            component.get('v.pOICertifiedCopies') == undefined ||
            component.get('v.pOICopiesClearLegible') == undefined ||
            component.get('v.pOIDealershipFICertifying') == undefined ||
            component.get('v.pOINamesMatchIDDocument') == undefined ||
            component.get('v.pOIValidatedAndSigned') == undefined ||
            component.get('v.pOIVerificationDate') == undefined ||
            component.get('v.primaryCustomerScreeningComplete') == undefined ||
            component.get('v.proofOfAddress') == undefined ||
            component.get('v.qA') == undefined ||
            component.get('v.relatedPartiesScreeningCompleted') == undefined ||
            component.get('v.section45Letter') == undefined ||
           component.get('v.securityResolution') == undefined ||*/
            component.get('v.signedMandatedSanctioner') == undefined ||
            component.get('v.sMSSecuritiesApprovalConditions') == undefined ||
            component.get('v.sOARecByEmail') == undefined ||
            component.get('v.sOARecByPOBOX') == undefined ||
            component.get('v.suretyshipLegallyCorrect') == undefined ||
            component.get('v.transactionResolution') == undefined || 
            component.get('v.verificationDocsValidatedIDDoc') == undefined
           ))
        {
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "Please complete the whole checklist before approving."
            });
            toastEvent.fire();   
        }else{ 
   var queueName = 'Validate Payout';
   var caseStatus = 'Validate Payout';
   var decision = component.get("v.approvalStatus");
   var details ;
        if(decision == 'Approved'){
         details = 'Approved As Is';}
        else if(decision == 'Requested More Information'){
         details = 'More Info Requested'; }
   var comments = component.get("v.commentTextArea");
   var isInsert = true;  
   var infoSource;
         if(decision == 'Approved'){
         infoSource = '';}
        else if(decision == 'Requested More Information'){
         infoSource = component.find("informationSource").get("v.value");}
         console.log('decision@@@ '+decision);
        console.log('infoSource@@@ '+infoSource);
        
   helper.refreshData(component, event, helper, decision,details,comments,isInsert,infoSource);
        } 
   }, 
   onRequestMoreInfoClick : function(component, event, helper) { 
      component.set("v.approvalStatus", "Requested More Information");
     console.log('approvalStatus##' + component.get("v.approvalStatus")); 
   }, 
   reasonForMoreInfoChange : function(component, event, helper) {
       
    },
    infoSourceChange : function(component, event, helper) {
      
    },  
    
onCommentChange : function(component, event, helper) {
        var approvalDecisionComment = component.find("decisionComments").get("v.value");
        var commentTextArea = component.find("decisionComments").get("v.value");
        component.set('v.commentTextArea', commentTextArea);
        component.set('v.approvalDecisionComment', approvalDecisionComment);
        console.log ('Comment : ' + approvalDecisionComment);
    },  
   
})