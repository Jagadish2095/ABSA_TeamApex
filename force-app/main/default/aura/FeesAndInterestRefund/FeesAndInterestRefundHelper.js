({
    /**
    * @description function to show spinner.
    **/
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    /**
    * @description function to hide spinner.
    **/   
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
     
    fetchPickListVal : function(component, fieldName, elementId) {
        var action = component.get("c.getProduct");
        action.setParams({});

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var allValues = response.getReturnValue();
                 console.log('allValues '+JSON.stringify(allValues));
                component.set('v.responseList',allValues);
                 var prodList = [];
                var productId= [];
                for(var key in allValues){
                    if (!prodList.includes(allValues[key].Id)) {
                        prodList.push(allValues[key].Name);
                        productId.push(allValues[key].Name);
                        
                    }
                }
                 component.set('v.refundProductList',prodList)
 
            }

        });
        $A.enqueueAction(action);
    },
    
    updateRequiredDocument: function (component, event, helper) {
        var amount = component.get("v.amount");
        var internalProduct = component.get("v.internalProduct"); 
		var refundReason = component.get("v.refundReason"); 
        var category = component.get("v.category"); 
        
        switch (internalProduct) {
            case "Cheques Fees":                
                if (amount >= 10000 && category =='Management Discretion') {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": 'Please attach Root cause analysis orm document' ,
                        "type":"Error"
                    });
                    toastEvent.fire();
                } else {
                   // value = component.get("v.currentEmail");
                }
                break;
              
            default:
                //component.set("v.showAltSMS", "");
                //component.set("v.showAltEmail", "");
                break;              
        }        
        
    },
    
    updateCase: function (component, event, helper) {
         component.set("v.showSpinner", true);
        var caseId = component.get("v.recordId");
        var domicileBranch = component.get("v.domicileBranch");
        var subLedger = component.get("v.subLedger");
        var journalMode = component.get("v.journalMode");
		var refundDescription = component.get("v.refundDescription");
        var refundMotivation = component.get("v.refundMotivation"); 
        var effectiveJournalDate = component.get("v.effectiveJournalDate");
        var refundRangeDateTo = component.get("v.refundRangeDateTo");
        var refundRangeDateFrom = component.get("v.refundRangeDateFrom");
        var itemReference = component.get("v.itemReference");
        var amount = component.get("v.amount");
        var transactionTypeId = component.get("v.transactionTypeId");
        var SeletedAccountNumber = component.get("v.SeletedAccountNumber"); 
        var productTypeId = component.get("v.productTypeId");
        var refundReasonId = component.get("v.refundReasonId");
        
        console.log('productTypeId' + productTypeId);
        var action = component.get("c.updateCase");  
        action.setParams({caseRecordId:caseId,productId:productTypeId,refundTransactionId:transactionTypeId,refundReasonId:refundReasonId,amount:amount,clientDomicileBranch: domicileBranch,subLedger: subLedger,journalMode: journalMode,description:refundDescription,motivation:refundMotivation,itemReference:itemReference,refundRangeDateFrom:refundRangeDateFrom,refundRangeDateTo:refundRangeDateTo,effectiveJournalDate:effectiveJournalDate,seletedAccountNumber:SeletedAccountNumber}); 
        action.setCallback(this, function(response) {
            var resp =  response.getReturnValue();
            var state = response.getState();
            console.log('resp'+resp);
            
            if (state === "SUCCESS") {
                if(resp != null){
                    
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success", "message":resp,"type":"Success"
                    });
                    toastEvent.fire();

                } else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "ERROR", "message":resp,"type":"ERROR"
                    });
                    toastEvent.fire();
                    
                }
                
            } else if(state === "ERROR"){
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Please try again " + resp,
                    "type":"error"
                });
                
                toastEvent.fire();
            } else{
                
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
        
        
        
    },
    
    // retrieve all required documents for user to upload
    displayRequiredDocs: function (component, event, helper) {
        var rootCauseAnalysisForm  = component.get('v.rootCauseAnalysisForm');
		var amount  = component.get('v.amount');
        var category  = component.get('v.category');
        var typeGroupClass  = component.get('v.typeGroupClass');
        
        if(amount >= 10000 && category != 'Management Discretion'){
            
            component.set("v.showRootCauseAnalysis",true);

        } else {
            component.set("v.showRootCauseAnalysis",false); 
        } 
        
        if(typeGroupClass == 'Fees'){
            component.set("v.showRootFeeCharge",true); 
        }         
        if(typeGroupClass == 'Interest'){
            component.set("v.showRootInterestCharge",true); 
        }
        if(category == 'System Failure'){
            component.set("v.showITincidentNumber",true);
            
        } else if(category == 'Fraud'){
            component.set("v.showFraudForm",true); 
            
        }   else if(category == 'Management Discretion'){
            
            component.set("v.showLegal",true); 
        }
        
   
    },
    
    checkStage: function (component, event, helper) {
        
        var action = component.get("c.getDocs");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        console.log('Id ' + component.get("v.recordId"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var responsevalue1=response.getReturnValue();
                component.set("v.documentsUploaded",responsevalue1);
                this.getMandatoryDocs(component);
                console.log('responsevalue1 ' + responsevalue1);
                console.log('resJson ' + JSON.stringify(responsevalue1));
                
            }
            else {
                console.log("Failed with state: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },
    
    fetchAuditData: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocAuditHistoryEmail");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        console.log('recordId: ' + component.get("v.recordId"));
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log('data:' + data);
                console.log('allValues '+JSON.stringify(data));
                
                data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                });
                var motivationClientInterest;
                var proofBankingAccount;
                var rootCauseAnalysisForm ;
                var feeChargedBankStatement ;
                var interestChargedBankStatement ; 
                var validatedFeeCalculations ;
                var interestCalculationPDFDocument ;
                var bankingFacilityLetter;
                var operationalRiskEventForm ;
                var riskEventNumber;
                var incidentNumber;
                var fraudForm;
                var legalCollectionsForm;
                var supportedApprovals;
               var deedSettlement;

                //Motivation: Client Interest / Cost Reimbursement
                for(var key in data){ 
                    if(data[key].Name  == 'Motivation: Client Interest / Cost Reimbursement Request.pdf'){
                        motivationClientInterest = data[key].Name;
                        component.set("v.motivationClientInterest", motivationClientInterest);
                        console.log('motivationClientInterest  22 ' + motivationClientInterest);
                    
                    } else if(data[key].Name  == 'Root Cause Analysis Form.pdf'){
                        rootCauseAnalysisForm = data[key].Name; 
                        component.set("v.rootCauseAnalysisForm", rootCauseAnalysisForm);

                    } else if(data[key].Name  == 'Proof of banking account.pdf'){
                        proofBankingAccount = data[key].Name; 
                        component.set("v.proofBankingAccount", proofBankingAccount);
                        
                    } else if(data[key].Name  == 'Bank Statement(s) showing erroneous fee charges.pdf'){
                        feeChargedBankStatement = data[key].Name; 
                        component.set("v.feeChargedBankStatement", feeChargedBankStatement);
                        
                    } else if(data[key].Name  == 'Bank Statement(s) showing erroneous interest charges.pdf'){
                        interestChargedBankStatement = data[key].Name;  
                        component.set("v.interestChargedBankStatement", interestChargedBankStatement);

                   }  else if(data[key].Name  == 'Validated Fee Calculations.pdf'){
                       validatedFeeCalculations = data[key].Name;  
                       component.set("v.validatedFeeCalculations", validatedFeeCalculations);                                                                                                           

                   } else if(data[key].Name  == 'Interest Calculation PDF Document.pdf'){
                       interestCalculationPDFDocument = data[key].Name;  
                       component.set("v.interestCalculationPDFDocument", interestCalculationPDFDocument);                                                                                                           
                       
                   }else if(data[key].Name  == 'Banking Facility Letter or other agreed price contract.pdf'){
                       bankingFacilityLetter = data[key].Name; 
                       component.set("v.bankingFacilityLetter", bankingFacilityLetter);                                                                                                           
                       
                   } else if(data[key].Name  == 'Operational Risk Event Form.pdf'){
                       operationalRiskEventForm = data[key].Name; 
                       component.set("v.operationalRiskEventForm", operationalRiskEventForm);                                                                                                           
                   }  else if(data[key].Name  == 'Risk Event Number.pdf'){
                       riskEventNumber = data[key].Name; 
                       component.set("v.riskEventNumber", riskEventNumber);                                                                                                           
                   }  else if(data[key].Name  == 'IT incident Number.pdf'){
                       incidentNumber = data[key].Name; 
                       component.set("v.incidentNumber", incidentNumber);                                                                                                           
                   }  else if(data[key].Name  == 'Fraud Form.pdf'){
                       fraudForm = data[key].Name; 
                       component.set("v.fraudForm", fraudForm);     
                       
                   }  else if(data[key].Name  == 'Legal Collections Form/Agreement.pdf'){
                       
                       legalCollectionsForm = data[key].Name; 
                       component.set("v.legalCollectionsForm", legalCollectionsForm);
                       
                   }  else if(data[key].Name  == 'Supported Approvals.pdf'){
                       supportedApprovals = data[key].Name; 
                       component.set("v.supportedApprovals", supportedApprovals);                                                                                                           
                    
                   }else if(data[key].Name  == 'Supported Approvals.pdf'){
                       supportedApprovals = data[key].Name; 
                       component.set("v.supportedApprovals", supportedApprovals); 
                       
                   } else if(data[key].Name  == 'Deed of Settlement.pdf'){
                       deedSettlement = data[key].Name; 
                       component.set("v.deedSettlement", deedSettlement);                                                                                                           
                   }

                       else if(data[key].Name  == 'Other.pdf'){
                        other = data[key].Name; 
                        component.set("v.other", other);
                    }
                }
                
                component.set("v.dataAudit", data);
                
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getMandatoryDocs : function (component){
        var Entitytype = component.get("v.opportunityRecord.Entity_Type__c");
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
                var documentsUploaded=component.get("v.documentsUploaded");
                var DocFlag;
                var checkFlag;
                var nonMandFlag='F';
                for(var i in Mandatorydocuments)
                {
                    
                    DocFlag='F';
                    for(var j in documentsUploaded)
                    {
                        if(documentsUploaded[j]===Mandatorydocuments[i].ECM_Type__c)
                        {
                            console.log("Mandatorydocuments Mach 184 " + Mandatorydocuments[i].ECM_Type__c);
                            DocFlag='T';
                        }
                    }
                    if (DocFlag==='F')
                    { 
                        console.log("bb");
                        nonMandFlag='T'
                    } 
                }
                
                if (nonMandFlag==='T')
                {
                    console.log("non mand");
                    this.setRecValue(component, event, true);
                    
                }
                else
                {  
                    console.log("mand");
                    this.setRecValue(component, event, false);
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
    
    setRecValue : function(component, event, checkFlag) 
    {
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateRec");
        action.setParams({
            recordId: recordId,
            docFlag: checkFlag
        });
        action.setCallback(this, function(data) {
            var response = data.getReturnValue();
            console.log("Response 238 " + response);
        });
        $A.enqueueAction(action); 
        
    },
    
        /**
    * @description download function to download file from ECM.
    **/  
    download: function (cmp, row) {
        cmp.set('v.showSpinner', true);
        var action = cmp.get('c.getDocumentContent');
        action.setParams({
            "documentId": row.Id 
        });
        console.log('row Id ' + row.Id);
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', row.Name);
                element.style.display = 'none';
                document.body.appendChild(element);		
                element.click();		
                document.body.removeChild(element);
            } else {
                console.log("Download failed ...");
            }
            cmp.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },
})