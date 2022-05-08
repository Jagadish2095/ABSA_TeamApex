({
    doInit : function(component, event, helper) { 
        
        var actions = [{ label: 'Download', name: 'download' }];
        
        component.set('v.columnsAudit', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'User', fieldName: 'ownerName', type: 'text'},
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} },
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
        
        helper.fetchAuditData(component);
        helper.fetchPickListVal(component);
        component.set('v.showRefundDetails',true);
        component.set('v.showNextButton',true);
        component.set('v.SeletedAccountNumber',component.get("v.selectedAccountNumberToFlow"));
        component.set('v.product',component.get("v.selectedProductValue"));
       
        
    },
    
             /**
    * @description download function to download file from ECM.
    **/
    download: function(cmp, event, helper) {
        var row = event.getParam('row');
        var actionName = event.getParam('action').name;
        helper.download(cmp, row);
    }, 
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'download':
                helper.download(component, row);
                break
        }
    },
    
    onNext : function(component, event, helper) {
        
  
        var domicileBranch = component.get("v.domicileBranch");
        var subLedger = component.get("v.subLedger");
        var journalMode = component.get("v.journalMode");
        var refundDescription = component.get("v.refundDescription");
        var refundMotivation = component.get("v.refundMotivation"); 
        var requestLogDate = component.get("v.requestLogDate");
        var effectiveJournalDate = component.get("v.effectiveJournalDate");
        var refundRangeDateTo = component.get("v.refundRangeDateTo");
        var refundRangeDateFrom = component.get("v.refundRangeDateFrom");
        var itemReference = component.get("v.itemReference");
        var SeletedAccountNumber = component.get("v.SeletedAccountNumber");
        var product = component.get("v.product");
        var transactionType = component.get("v.transactionType");
        var refundReason = component.get("v.refundReason"); 
        var amount = component.get("v.amount");
        var refundProductType = component.get("v.refundProductType"); 

        
        if(SeletedAccountNumber =='' || SeletedAccountNumber == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Account Number cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
            
        }else if(product =='' || product == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Product cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();

        } else if(requestLogDate =='' || requestLogDate == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Request log date cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(refundProductType =='' || refundProductType == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund Product type cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
            
        } else if(transactionType =='' || transactionType == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Transaction type cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(refundReason =='' || refundReason == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund reason cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        } else if(amount =='' || amount == null  ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Amount cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        } else if(refundRangeDateFrom =='' || refundRangeDateFrom == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund Range Date - From cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        
        }else if(refundRangeDateTo =='' || refundRangeDateTo == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund Range Date - To  cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        } else if(itemReference =='' || itemReference == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Item Reference cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        } else if(refundDescription =='' || refundDescription == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund Description cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        } else if(refundMotivation =='' || refundMotivation == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Refund motivation cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(domicileBranch =='' || domicileBranch == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Client Domicile Branch cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(subLedger =='' || subLedger == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Sub Ledger cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(journalMode =='' || journalMode == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Journal Mode cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else if(effectiveJournalDate =='' || effectiveJournalDate == null){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Effective Date for Journal cannot be blank.",
                "type":"error"
            });
            toastEvent.fire();
        }  else {
        	helper.displayRequiredDocs(component);
            helper.updateCase(component);
            component.set('v.showRefundDetails',false);
            component.set('v.showNextButton',false);
            component.set('v.showUploadDetails',true);
            component.set('v.showValidateButton',true);
        }
         
        
    },
    onRefundTypeChange :function(component, event, helper){   
        var refundProductType = component.get('v.refundProductType');
        var respObj = component.get('v.responseList');
        
        var productType ;
        for(var key in respObj){
            if(respObj[key].Name == refundProductType){
                 productType = respObj[key].Id;
            }
        }
        component.set('v.productTypeId',productType); 

    },
    

    
    handleRefundTransactionEvent:function(component, event, helper){       
		console.log('start');
        var selectedGLAccountNumberFromEvent = event.getParam("glAccountNumber"); 
        var recordTransactionTypeEvent = event.getParam("recordTransactionTypeEvent"); 
        var internalProductEvent = event.getParam("internalProduct"); 
        var typeGroup = event.getParam("typeGroup"); 
        var vatableEvent = event.getParam("vatable"); 
        var statementNarrativeEvent = event.getParam("statementNarrative"); 
        var transactionTypeIdEvent = event.getParam("transactionTypeId");
        
       	component.set("v.glAccountNumber" , selectedGLAccountNumberFromEvent);  
        component.set("v.typeGroupClass" , typeGroup); 
        component.set("v.internalProduct" , internalProductEvent);       
        component.set("v.transactionTypeId" , transactionTypeIdEvent);  
        component.set("v.statementNarrative" , statementNarrativeEvent);  
        console.log('internalProductEvent ' + internalProductEvent);
        console.log('glAccountNumber ' + selectedGLAccountNumberFromEvent);
        
        if(vatableEvent== true){
            
            component.set("v.vatable" ,'Yes'); 
            
        } else {
            
            component.set("v.vatable" , 'No'); 
        }
        
        
    },  
    
    handleRefundReason:function(component, event, helper){  
        console.log('here');
        var refundCategoryEvent = event.getParam("categoryEvent");
        var recordReasonGroupEvent = event.getParam("recordReasonGroupEvent");
        var recordRefundId = event.getParam("refundReasonIdEvent");
        component.set("v.category" , refundCategoryEvent);  
        component.set("v.refundReasonId" , recordRefundId);  
        component.set("v.reasonGroup" , recordReasonGroupEvent);  
         
     },
    
       requestLogDate:function(component, event, helper) {
            
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        
        if(component.get("v.requestLogDate") != '' && component.get("v.requestLogDate") < todayFormattedDate){
            component.set("v.requestLogDateError" , true);
            console.log('Inside true mydate'+component.get("v.requestLogDate"));
            
        }else{
            
            component.set("v.requestLogDateError" , false);
           
        }  
    },
    
    /*call dateUpdate function on onchange event on date field*/ 
    onEffectiveJournalDate : function(component, event, helper) {
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.effectiveJournalDate") != '' && component.get("v.effectiveJournalDate") < todayFormattedDate){
            component.set("v.effectiveJournalDateError" , true);
            console.log('Inside true mydate'+component.get("v.effectiveJournalDate"));
        }else{
            component.set("v.effectiveJournalDateError" , false);
            console.log('Inside false mydate'+component.get("v.effectiveJournalDate"));
        }
        
    },
    
    onRefundRangeDateTo : function(component, event, helper) {
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.refundRangeDateTo") != '' && component.get("v.refundRangeDateTo") < todayFormattedDate){
            component.set("v.refundRangeDateToError" , true);
            
        }else{
            component.set("v.refundRangeDateToError" , false);
            
        }
        
    },
    
    refundRangeDateFromUpdate : function(component, event, helper) {
        
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
        // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(component.get("v.refundRangeDateFrom") != '' && component.get("v.refundRangeDateFrom") < todayFormattedDate){
            component.set("v.refundRangeDateFromError" , true);
        }else{
            component.set("v.refundRangeDateFromError" , false);
        }
        console.log('refundRangeDateFrom' + component.get("v.refundRangeDateFrom"));
        
    },
    refreshDocuments : function(component, event, helper) {
        console.log('here');
        helper.fetchAuditData(component);
        helper.checkStage(component);
        
    },
    
    
    validate : function(component, event, helper) {
        var respObj = component.get('v.dataAudit');
        var operationalRiskEventForm = component.get('v.operationalRiskEventForm');
        var proofBankingAccount = component.get('v.proofBankingAccount');
        //var rootCauseAnalysisFormDoc = component.get('v.rootCauseAnalysisFormDoc');
        var feeChargedBankStatement = component.get('v.feeChargedBankStatement');
        var interestChargedBankStatement = component.get('v.interestChargedBankStatement');
        var interestCalculationPDFDocument = component.get('v.interestCalculationPDFDocument');
        var validatedFeeCalculations = component.get('v.validatedFeeCalculations');
        var incidentNumber = component.get('v.incidentNumber');
        var riskEventNumber = component.get('v.riskEventNumber');
        var fraudForm = component.get('v.fraudForm');
        var legalCollectionsForm = component.get('v.legalCollectionsForm');
        var supportedApprovals = component.get('v.supportedApprovals');
        var motivationClientInterest = component.get('v.motivationClientInterest');
        var rootCauseAnalysisForm = component.get('v.rootCauseAnalysisForm');
        var bankingFacilityLetter = component.get('v.bankingFacilityLetter');
        
        var amount = component.get("v.amount"); 
        var category = component.get("v.category"); 
        var typeGroupClass = component.get("v.typeGroupClass"); 
        var internalProduct = component.get("v.internalProduct"); 
        console.log('motivationClientInterest ' + motivationClientInterest);
        console.log('proofBankingAccount ' + proofBankingAccount);
        
        if(motivationClientInterest != 'Motivation: Client Interest / Cost Reimbursement Request.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach motivation: client interest / cost reimbursement request' ,
                "type":"Error"
            });
            toastEvent.fire();
            
        } else if(proofBankingAccount != 'Proof of banking account.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Proof of banking account document' ,
                "type":"Error"
            });
            toastEvent.fire();
            
        } else if(amount >= 10000 && category != 'Management Discretion' && rootCauseAnalysisForm != 'Root Cause Analysis Form.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach root cause analysis form' ,
                "type":"Error"
            });
            toastEvent.fire();
        }  else if(typeGroupClass == 'Fees'  && feeChargedBankStatement != 'Bank Statement(s) showing erroneous fee charges.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Bank Statement(s) showing erroneous fee charges' ,
                "type":"Error"
            });
            toastEvent.fire();
            
        }else if(typeGroupClass == 'Interest'  && interestChargedBankStatement != 'Bank Statement(s) showing erroneous interest charges.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Bank Statement(s) showing erroneous interest charges' ,
                "type":"Error"
            });
            toastEvent.fire(); 
            
        } else if(typeGroupClass == 'Interest' && interestCalculationPDFDocument != 'Interest Calculation PDF Document.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Interest Calculation PDF Document' ,
                "type":"Error"
            });
            toastEvent.fire(); 
            
        } else if(typeGroupClass == 'Fees' && internalProduct == 'Cheques Fees' && validatedFeeCalculations != 'Validated Fee Calculations.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach validated fee calculations' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        
        } else if(internalProduct == 'Overnights/Term/AgriLoans Interest' || 
                  internalProduct == 'Overnights/Term/AgriLoans  Fees' ||
                  internalProduct == 'Commercial Property Finance Interest' || 
                  internalProduct == 'Commercial Property Finance Fees' || 
                  internalProduct == 'Guarantees Fees' || 
                  internalProduct == 'Cheques Overdrafts/CAF/Revolving Interest' ||
                  internalProduct == 'Cheques Overdrafts/CAF/Revolving Fees' 
                  && bankingFacilityLetter != 'Banking Facility Letter or other agreed price contract.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach banking facility letter or other agreed price contract' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        }  else if(amount >= 10000 && category != 'Management Discretion' && operationalRiskEventForm != 'Operational Risk Event Form.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Operational risk event form' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        }  else if(amount >= 10000 && category != 'Management Discretion' && riskEventNumber != 'Risk Event Number.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach risk Event Number' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        } else if(category == 'System Failure' && incidentNumber != 'IT incident Number.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach IT incident Number' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        } else if(category == 'Fraud' && fraudForm != 'Fraud Form.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Fraud Form' ,
                "type":"Error"
            });
            toastEvent.fire(); 
        } else if( category == 'Management Discretion'
                  && legalCollectionsForm != 'Legal Collections Form/Agreement.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach legal collections Form/Agreement' ,
                "type":"Error"
            });
            toastEvent.fire(); 
           
        } else if( category == 'Management Discretion'
                  && supportedApprovals != 'Supported Approvals.pdf'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": 'Please attach Supported Approvals' ,
                "type":"Error"
            });
            toastEvent.fire(); 
          }
            else{
				 component.set("v.showValidateButton", false);
                 // var submitButton = component.find("submitButtonNext");
                //submitButton.set("v.disabled", false); 
            }
            
            
                
        
    }
    
    
    
    
    
})