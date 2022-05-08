({
    loadHistoryRecords : function(cmp) {
        
        cmp.set('v.decisionHistorycolumns', [
            {label: 'Outcome', fieldName: 'Outcome__c', type: 'text', readonly:true },
            {label: 'Process', fieldName: 'Process_Name__c', type: 'text', readonly:true },
            {label: 'Decision', fieldName: 'Decision__c', type: 'text', readonly:true },
            {label: 'Detail', fieldName: 'Details__c', type: 'text', readonly:true },
            {label: 'Comments', fieldName: 'Comments__c', type: 'text', readonly:true },
            {label: 'Decision By', fieldName: 'Decision_By__c', type: 'text', readonly:true },
            {label: 'Date', fieldName: 'CreatedDate', type: 'text', readonly:true }          
        ]);
        
        var dhList = cmp.get("c.getHistory");
        dhList.setParams({"caseId" : cmp.get('v.recordId')});
        
        dhList.setCallback(this, function(response) {
            var state = response.getState(); 
            var result = JSON.stringify(response.getReturnValue());
            
            if (cmp.isValid() && state === "SUCCESS"){
                cmp.set("v.decisionHistoryList", response.getReturnValue()); 
                //alert ('Decision History records :: ' + result); 
            }            
        });   
        $A.enqueueAction(dhList);
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
    
    setRadioButtonValues : function(cmp,event,helper){
        
        var action = cmp.get("c.getCase");
        action.setParams({ caseId : cmp.get("v.recordId")});
        
        action.setCallback(this,function(response) {           
            var state = response.getState();
            if (state === "SUCCESS") {
                var caseRecord = response.getReturnValue();
                
                if(caseRecord != null){
                    cmp.set("v.oldCaseOwnerId",caseRecord.OwnerId);
                    cmp.set('v.landlordAddressVal',caseRecord.pv_Names_of_address_of_landlord_received__c);  
                    cmp.set('v.form25CompleteVal',caseRecord.pv_Form_25_completed_in_full_and_signed__c);
                    cmp.set('v.pricingDocReceivedVal',caseRecord.pv_Pricing_document_received__c);
                    cmp.set('v.docFeeVal',caseRecord.pv_Doc_fee_as_per_credit_approval__c);
                    cmp.set('v.amountFinVal',caseRecord.pv_Amount_financed_not_credit_approval__c);
                    cmp.set('v.debitOrderVal',caseRecord.pv_Debit_order_not_R500000_p_a__c);
                    cmp.set('v.signedDOVal',caseRecord.pv_Signed_Debit_Order__c);
                    cmp.set('v.signedAgreeVal',caseRecord.pv_Original_signed_agreement_and_t_c__c);
                    cmp.set('v.creditAgreeTermVal',caseRecord.pv_Term_on_Credit_agrees_with_credit_app__c);
                    cmp.set('v.creditAgreeTypeVal',caseRecord.pv_Type_of_agreement_as_per_credit_approval__c);  
                    cmp.set('v.articleFinanceVal',caseRecord.pv_Article_financed_per_credit_approval__c);
                    cmp.set('v.nonVATGroupVal',caseRecord.pv_Non_VAT_registered_VAT_264_form__c);
                    cmp.set('v.vatRegGroupVal',caseRecord.pv_VAT_registered_valid_tax_invoice__c);
                    cmp.set('v.invSignedVal',caseRecord.pv_Invoice_signed_by_client__c);
                    cmp.set('v.invAmountVal',caseRecord.pv_Invoice_correspond_with_contract__c);
                    cmp.set('v.confirmFromSalesVal',caseRecord.pv_Confirm_from_sales_of_dealer_banking__c);
                    cmp.set('v.descriptionOfGoodsVal',caseRecord.pv_Year_model_and_description_of_goods__c);
                    cmp.set('v.bankInterestVal',caseRecord.pv_Bank_interest_with_insurance_company__c);
                    cmp.set('v.freedomOfChoiceVal',caseRecord.pv_Freedom_of_choice_form_completed__c);  
                    cmp.set('v.formSignedVal',caseRecord.Form_23_completed_in_full_and_signed__c);
                    cmp.set('v.faisDocVal',caseRecord.pv_FAIS_documents_completed_clause_1_5__c);
                    cmp.set('v.dicPaidVal',caseRecord.pv_DIC_to_be_paid_in_dealer__c);
                    cmp.set('v.dealerCheckVal',caseRecord.pv_Dealer_correspond_Credit_Approval__c);
                    cmp.set('v.signedByManVal',caseRecord.pv_Signed_by_mandate_holder__c);
                    cmp.set('v.inspectReportVal',caseRecord.pv_Inspection_Report_completed_in_full__c);
                    cmp.set('v.goodsPaidVal',caseRecord.pv_Proof_that_goods_are_paid_in_full__c);
                    cmp.set('v.depMatchVal',caseRecord.pv_Deposit_correspond_credit_approval__c);
                    cmp.set('v.signConsentVal',caseRecord.pv_Signed_customer_communication__c);  
                    cmp.set('v.casaRefNoVal',caseRecord.pv_CASA_Reference_number_on_header__c);
                    cmp.set('v.engChassNoVal',caseRecord.pv_Engine_Chassis_number_corresponds__c);
                    cmp.set('v.clientNameCheckVal',caseRecord.pv_Client_name_correspond_with_agreement__c);
                    cmp.set('v.screenInfoMatchVal',caseRecord.pv_CIF07_Screen_Information_Corresponds__c);
                    cmp.set('v.ficaInfoVal',caseRecord.pv_New_FICA_information_has_been_loaded__c);
                    cmp.set('v.signedAckVal',caseRecord.pv_Signed_acknowledgement_of_receipts__c);
                    cmp.set('v.infoSignContrVal',caseRecord.pv_All_info_on_Signed_Credit_Agreement__c);
                    cmp.set('v.debitOrderInfoVal',caseRecord.pv_Debit_order_information_SAP__c);  
                    cmp.set('v.monthDebitOrderVal',caseRecord.pv_Monthly_debit_order_does_not_exceed__c);
                    cmp.set('v.InsureInfoVal',caseRecord.pv_Insurance_info_is_updated_on_SAP__c);
                    cmp.set('v.customerLoadedVal',caseRecord.pv_Correct_customer_group_loaded_on_SAP__c);
                    cmp.set('v.affordInfoVal',caseRecord.pv_Affordability_information_loaded__c);
                    cmp.set('v.serviceFeeVal',caseRecord.pv_Service_fee_has_been_loaded_correctly__c);  
                    cmp.set('v.docFeeLoadedVal',caseRecord.pv_Doc_fee_has_been_loaded_correctly__c);
                    cmp.set('v.dicPayVal',caseRecord.pv_DIC_payable_and_reflects_in_condition__c);
                    cmp.set('v.noDicPayVal',caseRecord.pv_No_DIC_is_payable_and_it_was_deleted__c);
                    cmp.set('v.clientInfoUpdVal',caseRecord.pv_Client_communication_info_is_updated__c);
                    cmp.set('v.vapsLoadedVal',caseRecord.pv_VAPS_loaded_on_SAP_have_signed_docs__c);
                    cmp.set('v.vapsCancelVal',caseRecord.pv_Cancelled_VAPS_policy_docs_deleted__c);   
                }    
                else if (state === "ERROR") {
                    this.hideSpinner(component);
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +errors[0].message);
                        }
                    }
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
                //alert(sendToVal);	
                console.log(' DATAMAP 140 '+JSON.stringify(sendToVal));	
                if(sendToVal != null && sendToVal != undefined){	
                    if(sendToVal.ISSAMEOWNER == 'TRUE'){	
                        if(sendToVal.COMPNAME == 'Payout Validation'){	
                            component.set("v.isCompReadOnly",false);	
                        }else{	
                            component.set("v.isCompReadOnly",true);	
                            var activeSection = ['checkList','decision','history'];	
                            component.set("v.activeSections",activeSection);	
                        }	
                    }	
                }	
                /*if(sendToVal != null && sendToVal != '' && sendToVal != undefined){	
component.set("v.sendToVal",sendToVal);	
if(sendToVal != 'Payout Validator'){	
var activeSection = ['checkList','decision','history'];	
component.set("v.activeSections",activeSection);	
}	
}*/	
}	
    else if (state === "INCOMPLETE") {	
    }	
        else if (state === "ERROR") {	
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