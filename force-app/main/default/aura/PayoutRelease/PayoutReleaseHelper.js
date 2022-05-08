({
    loadHistoryRecords : function(component) {
        var action = component.get("c.getHistory");
        action.setParams({"caseId" : component.get('v.recordId')});
        
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            var result = JSON.stringify(response.getReturnValue());
            // alert(result);
            if (component.isValid() && state === "SUCCESS"){
                component.set("v.decisionHistoryList", response.getReturnValue()); 
            }            
        });   
        $A.enqueueAction(action);
    },
    fetchReasonForPicklistValues : function(component, event, helper) {
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            objectType: 'Case',
            selectedField: 'Reason_for_more_information__c'
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.ReasonForMoreInfoList", list);
        })
        $A.enqueueAction(action);
    },
    fetchnformationSourceForPicklistValues : function(component, event, helper) {
        var action = component.get("c.getPickListValuesIntoList");
        action.setParams({
            objectType: 'Case',
            selectedField: 'Information_Source__c'
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.ReasonInformationSourceInfoList", list);
        })
        $A.enqueueAction(action);
    },
    showSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },     
    hideSpinner: function (component, event, helper) {
        var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    fetchExistingCaseData: function (component, event, helper) {
        var action = component.get("c.getCase");
        action.setParams({
            caseId: component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var caseInfo = response.getReturnValue();
            component.set("v.oldCaseOwnerId",caseInfo.OwnerId);
            component.set("v.PaymentMethodisLoadedasE", caseInfo.PR_Payment_method_is_loaded_as_E_EFT__c);
            component.set("v.InvoiceInformationCorresponds", caseInfo.PR_Invoice_information_corresp_with_SAP__c);
            component.set("v.PaymentMadeCorrectDealer", caseInfo.PR_Payment_is_made_to_the_correct_dealer__c);
            component.set("v.TheAmountofTheInvoiceCorresponds", caseInfo.PR_The_amount_of_the_invoice_corresponds__c);
            component.set("v.ServiceFeeHasBeenLoadedCorrectly", caseInfo.PR_Service_fee_has_been_loaded_correctly__c);
            component.set("v.DocumentationFeeLoaded", caseInfo.PR_Documentation_fee_has_been_loaded__c);
            component.set("v.DealerNameInvoiceCorrespons", caseInfo.PR_Dealer_name_of_invoice_corresponds__c);
            component.set("v.PaymentDetailsOfDealerDealerApproval", caseInfo.PR_Payment_detail_of_dealer_is_loaded__c);
            component.set("v.ProofOfDepositfromtheInvoice", caseInfo.PR_Proof_of_Deposit_is_on_file_Deposit__c);
        })
        $A.enqueueAction(action);
    },
    getSendTO : function(component,event,caseId){	
        var action = component.get("c.fetchSendToFromCase");	
        action.setParams({ "caseId" : caseId});	
        action.setCallback(this,function(response) {	
            var state = response.getState();	
            if (state === "SUCCESS") {	
                var sendToVal = response.getReturnValue();	
                console.log(' DATAMAP 74 '+JSON.stringify(sendToVal));	
                if(sendToVal != null && sendToVal != undefined){	
                    if(sendToVal.ISSAMEOWNER == 'TRUE'){	
                        if(sendToVal.COMPNAME == 'Payout Release'){	
                            component.set("v.isCompReadOnly",false);	
                        }else{	
                            component.set("v.isCompReadOnly",true);	
                            var activeSections = ['PRFC','PRFD','DecisionHistory'];	
                            component.set("v.activeSections",activeSections);	
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
            if (state === "SUCCESS") {	
                var sendToVal = response.getReturnValue();	
                //alert(sendToVal);	
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