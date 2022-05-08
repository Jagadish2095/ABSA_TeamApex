({
    doInit: function(component, event, helper) {
        helper.getStaticResource(component, event, helper);

    },

    handleCaseLoad: function(component, event, helper) {
        if (component.find("serviceGroupField").get("v.value") === 'Everyday Banking -Awaiting Request Refunds') {
                helper.getAccountDetail(component, event, helper);
            component.set("v.showSpinner",true);
            component.set("v.isReadOnly", true)
            component.set("v.isManuallyChecked", true)
            component.set("v.showSummaryButtom", false)
            let jsonFromCase = JSON.parse(component.find("extendedRequestData").get("v.value"));
            component.set("v.debitFrom", jsonFromCase.debitFrom)
            component.set("v.amountValue", jsonFromCase.amount)
            component.set("v.product", jsonFromCase.product)
            component.set("v.selectedAccountNumberFromFlow", jsonFromCase.selectedAccountNumberFromFlow)
            component.set("v.accountNumberFromFlow", jsonFromCase.accountNumberFromFlow)

             component.set("v.showSpinner",false);
        }
           if (component.find("serviceGroupField").get("v.value") === 'Request Refund Escalations') {
                    component.set("v.isFailedQueue", true)
                   let jsonFromCase = JSON.parse(component.find("extendedRequestData").get("v.value"));
                    component.set("v.debitFrom", jsonFromCase.debitFrom)
                    component.set("v.amountValue", jsonFromCase.amount)
                    component.set("v.textForSummaryDebit", jsonFromCase.productInfoFromAccount)
                    component.set("v.textForSummaryCredit", jsonFromCase.productInfoToAccount)
                    component.set("v.bankName", jsonFromCase.bankNameFrom)
                    component.set("v.bankNameFrom", jsonFromCase.bankNameTo)
                    component.set("v.refundTypeValue", jsonFromCase.refundType)
                    component.set("v.reasonForDebitValue", jsonFromCase.reason)
                    component.set("v.effectiveDate", jsonFromCase.date)
                    component.set("v.product", jsonFromCase.product)
                    component.set("v.debitFrom", jsonFromCase.debitFrom)
                    component.set("v.selectedAccountNumberFromFlow", jsonFromCase.selectedAccountNumberFromFlow)
                    component.set("v.accountNumberForSummary", jsonFromCase.accountNumberForSummary)
                     component.set("v.textForSummaryDebit", component.get("v.product") + '\n' + component.get("v.debitFrom"));
                      component.set("v.textForSummaryCredit", component.get("v.product") + '\n' + component.get("v.accountNumberForSummary"));
                }else{
                        helper.getAccountDetail(component, event, helper);
                }
        helper.setValuesForSummary(component, event)
    },

        handleSourceBalanceChange: function(component, event, helper) {
            let valueFromSourceBalance = component.find("sourceBalance").get("v.value");
            if (valueFromSourceBalance === '--Other--') {
                 component.set("v.accountNumberForSummary",'');
                component.set("v.showVerificationSector", true);
                component.set("v.showBankSector", false);
                component.set("v.showSummaryButtom", false);

            } else {

                     component.set("v.targetAccountType", helper.getAccountType(component, valueFromSourceBalance));
                    let accRecord = component.get("v.sourceAccType");

                  if((accRecord != null) && ((accRecord.productType !='CA' && accRecord.status != 'OPEN') || (accRecord.productType !='CHQ' && accRecord.status != 'CURRENT'))){
                      component.set("v.caseIsOnHold", true);
                      component.set("v.showSummaryButtom", false);
                    helper.fireToastEvent("Error", 'Transaction cannot be performed on this account', "Error");

                  }else{
                      component.set("v.caseIsOnHold", false);
                     component.set("v.showSummaryButtom", true);
                  }
                component.set("v.showVerificationSector", false);
                component.set("v.isReadOnly", false);
                component.set("v.showBankSector", true);
            }
        },

    showSummary: function(component, event, helper) {
        if((component.get("v.showOtherReason") && (component.get("v.accountType")==='--None--')) ||
        (component.find("serviceGroupField").get("v.value") === 'Everyday Banking -Awaiting Request Refunds' && component.get("v.accountType")==='--None--')){
                helper.fireToastEvent("Error", 'Please select account type', "Error");
        }
        else{component.set("v.showRefundsSummary", true)
        helper.setValuesForSummary(component, event, helper)

}
    },
    goPrevious: function(component, event, helper) {
       var navigate = component.get("v.navigateFlow");
       navigate("BACK");
    },
    changeAccountType: function(component, event, helper) {
     helper.changeAccountTypeOnChange(component, event, helper)
    },
    onChange: function (component, event, helper) {
                component.set("v.sourceAccType", helper.getAccountType(component, component.get("v.accountFromFlow")));
        },
    showPauseOrClose: function(component, event, helper) {
        component.set("v.showPauseOrClose", true)
    },
    closeCaseOnHold: function(component, event, helper) {
        component.set("v.caseIsOnHold", false)
    },
    handleBankChange: function (component, event, helper) {
    		component.set("v.branchCode", "");
    		component.set("v.branchName", "");
    	},
    		handleBranchCodeEvent: function (component, event, helper) {
        		var selectedBranchCode = event.getParam("recordBranchCodeEvent");
        		component.set("v.branchCode", selectedBranchCode);
        	},
    handleManuallyVerifyAccount: function(component, event, helper) {
        component.set("v.showProofOfbanking", true)
        component.set("v.isManuallyChecked", true)
    },
    refreshView: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    pauseCase: function(component, event, helper) {
        helper.saveJson(component, event);
        helper.transferCase(component, event, helper);
    },
    handleError: function(component, error, helper) {
        var description = error.getParams().description;

    },
    manuallyVerifyAccount: function(component, event, helper) {
        component.set("v.wasSuccessfullVerified", true);
        component.set("v.showProofOfbanking", false);
    },
    onCheckProofOfBanking: function(component, event, helper) {
        var checkCmp = component.find("checkbox").get("v.value");
        if (checkCmp === true) {
            component.set("v.proofOfbankingChecked", true);
        } else {
            component.set("v.proofOfbankingChecked", false);
        }
    },
    closeCase: function(component, event, helper) {
        component.find("statusField").set("v.value", "Closed");
        component.find("caseCloseEditForm").submit();
    },

    closeSummary: function(component, event, helper) {
        component.set("v.showRefundsSummary", false)
    },
  closePauseCase: function(component, event, helper) {
        component.set("v.showPauseOrClose", false)
    },

    handleVerifyAccount: function(component, event, helper) {
        helper.verifyAccount(component, event, helper);
    },

    checkIfOther: function(component, event, helper) {
        var selPickListValue = event.getSource().get("v.value");
        if (selPickListValue === 'Other') {
            component.set("v.showOtherReason", true);
            component.set("v.showVerificationAccountButton", true);
        } else {

            component.set("v.showOtherReason", false);
        }
    },

    createTransactionRecord: function(component, event, helper) {
        component.get("v.showSpinner", true);
     let rec;
        component.find("accountRecordCreator").getNewRecord(
            "Case_Transaction__c", // sObject type (objectApiName)
            null, // recordTypeId
            false, // skip cache?
      $A.getCallback(function() {
                rec = component.get("v.caseTransaction");
                var error = component.get("v.newCaseTransactionError");
                if (error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                  let jsonFromCase = JSON.parse(component.find("extendedRequestData").get("v.value"));
                component.set("v.newCaseTransactionFields.Transaction_Date__c", component.get("v.effectiveDate"));
                component.set("v.newCaseTransactionFields.Amount__c", component.get("v.amountValue"));
                component.set("v.newCaseTransactionFields.Source_Account__c", component.get("v.debitFrom"));
                component.set("v.newCaseTransactionFields.Status__c", 'New');
                component.set("v.newCaseTransactionFields.Target_Account__c", component.get("v.accountNumberForSummary"));
                component.set("v.newCaseTransactionFields.Case__c", component.get("v.caseIdFromFlow"));
                component.set("v.newCaseTransactionFields.jobType__c", 'Request Refund');
                component.set("v.newCaseTransactionFields.Service_Group__c", 'Everyday Banking - Collections');
                component.set("v.newCaseTransactionFields.Reason__c", component.get("v.reasonForDebitValue"));
                component.set("v.newCaseTransactionFields.Reference__c", component.get("v.selectedAccountNumberFromFlow"));
                component.set("v.newCaseTransactionFields.Collection_Phase__c",  jsonFromCase.collPhase);
                component.set("v.newCaseTransactionFields.Source_Account_Type__c", jsonFromCase.product);
                component.set("v.newCaseTransactionFields.Target_Account_Type__c",  jsonFromCase.targetAccountType);
                console.log("v.newCaseTransactionFields")
                component.find("accountRecordCreator").saveRecord($A.getCallback(function(saveResult) {
                    if (saveResult.state === "SUCCESS") {
                       helper.replaceValuesInJson(component, event)
                        helper.callApprovalProcess(component, event);
                    } else if (saveResult.state === "INCOMPLETE") {
                       console.log('INCOMPLETE ' + JSON.stringify(saveResult.error))
                    } else if (saveResult.state === "ERROR") {
                         console.log('ERROR ' +JSON.stringify(saveResult.error))
                    } else {
                        console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
                    }
                }));
            })
        );
    },

})