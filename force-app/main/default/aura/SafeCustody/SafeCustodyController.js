({
	myAction : function(component, event, helper) {
	},
    
    doInit : function(component, event, helper) {
        helper.fetchApplicationDetails(component, event, helper);
        helper.fetchDraftingFeePaymentOption(component, event, helper);
        helper.fetchDraftingFeePaymentMethod(component, event, helper);
        helper.checkIfPaymentPlanExists(component, event, helper);
        helper.checkPaymentPreferenceSetTypeonApplication(component, event, helper);
        helper.fetchPickListVal(component, 'Method__c', 'PaymentMethod');
        helper.fetchPickListVal(component, 'Account_Type__c', 'AccountType');
    },
    
    submitSave : function(component, event, helper) {
        var paymentPlanMethod = component.get("v.draftingFeePaymentPlanMethod");
        if (component.get("v.selectSCFPaymentRequired") != 'Yes' && component.get("v.selectSCFPaymentRequired") != 'No') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To submit please make Safe Custody Charge selection.",
                "type":"error"
            });
            toastEvent.fire();
        } else if (component.get("v.selectSCFPaymentRequired") == 'Yes' && component.get("v.selectSCFPaymentOption") != 'Yes' && component.get("v.selectSCFPaymentOption") != 'No') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To submit please make a Safe Custody payment selection.",
                "type":"error"
            });
            toastEvent.fire();
        } else if (component.get("v.draftingFeePaymentMethod") == 'Fees Waived' && component.get("v.selectSCFPaymentOption") == 'Yes') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": " Safe Custody payment details cannot be the same as the Drafting Fee payment details because the Drafting Fee has been waived.",
                "type":"error"
            });
            toastEvent.fire();
        } else if (component.get("v.draftingFeePaymentMethod") == 'Fees for Estate Provider Plan' && component.get("v.selectSCFPaymentOption") == 'Yes') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": " Safe Custody payment details cannot be the same as the Drafting Fee payment details because the Drafting Fee has been Estate Provider Plan.",
                "type":"error"
            });
            toastEvent.fire();	
        } else if (component.get("v.draftingFeePaymentMethod") == 'Fees for Staff' && component.get("v.selectSCFPaymentOption") == 'Yes') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": " Safe Custody payment details cannot be the same as the Drafting Fee payment details because the Drafting Fee has been set as Exempted Staff.",
                "type":"error"
            });
            toastEvent.fire();	
           
        } else if (component.get("v.draftingFeePaymentMethod") == 'Fees Paid' && component.get("v.selectSCFPaymentOption") == 'Yes' && paymentPlanMethod != 'Debit Instruction') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "Safe Custody payment details cannot be the same as Drafting Fee payment details because the Drafting Fee payment method is '" + paymentPlanMethod + "'.",
                "type":"error"
            });
            toastEvent.fire();
        } else {
            helper.submitPayment(component, event, helper);
        }
    },
    
    submitEdit: function(component, event, helper) {
        console.log('Safe_Custody_Is_Required__c: ' + component.get("v.applicationDetail.Safe_Custody_Is_Required__c"));
        helper.fetchPickListVal(component, 'Method__c', 'PaymentMethod');
        helper.fetchPickListVal(component, 'Account_Type__c', 'AccountType');
        component.set("v.selectedAccNumber", '');
        component.set("v.selectedBranchCode", '');
        component.set("v.selectedAccType", '');
        component.set("v.SCFTypeIsSet", false);
        component.set("v.showSafeCustodyRequired", true);
        component.set("v.showSafeCustody", true);
            component.set("v.disableRadioButtonGroup", false);
            component.set("v.disableAccountType", false);
            component.set("v.disableBankAccountNumber", false);
            component.set("v.showBankName", true);
            component.set("v.showBankNameReadOnly", false);
            component.set("v.showBranchName", true);
            component.set("v.showBranchNameReadOnly", false);
        if (component.get("v.applicationDetail.Safe_Custody_Is_Required__c") == 'No') {
        	component.set("v.selectSCFPaymentRequired", 'No');
        } else if (component.get("v.applicationDetail.Safe_Custody_Is_Required__c") == 'Yes') {
            component.set("v.selectSCFPaymentRequired", 'Yes');
        }
        component.set("v.showSCFRequired", false);
        component.set("v.showSaveButton", true);
        component.set("v.showEditButton", false);
        component.set("v.showCancelButton", true);
    },
    
    submitCancel: function(component, event, helper) {
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    
    onchangeRadioButtonGroup : function(component, event, helper) {
        var checkCmp = component.find("radioGrp");        
        if(checkCmp.get("v.value") == "No") {
            component.set("v.showPaymentDetails", true);
        }
        else if (checkCmp.get("v.value") == 'Yes') {
        	component.set("v.showPaymentDetails", false);
        }
    },
    
    onchangeRadioButtonGroup2 : function(component, event, helper) {
        var checkCmp = component.find("radioGrp2");        
        if(checkCmp.get("v.value") == "No") {
            component.set("v.showSafeCustody", false);
            component.set("v.showPaymentDetails", false);
        }
        else if (checkCmp.get("v.value") == 'Yes') {
        	component.set("v.showSafeCustody", true);
        }
    },
    
    onPicklistAccTypeChange: function(component, event, helper) {
        component.set("v.Account_Type__c", event.getSource().get("v.value"));
    },
    
    handleSubmitPaymentEvent: function(component, event, helper) {
        helper.submitPaymentPlan(component, event, helper);
    },
    
    handleBrachCodeComponentEvent: function(component, event, helper) {
        //Event handler to get branch code from child component
        var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.selectedBranchCode", pselectedBranchCodeGetFromEvent);
    },
    
    clearAllBankAttribute: function(component, event, helper) {
            var recordToBeclear = event.getParam("clearBranchName");
            component.set("v.selectedBankName", null);
            var bankname= component.get("v.selectedBankName");
            component.set("v.selectedBranchName", null);
            var branchname= component.get("v.selectedBranchName");
            component.set("v.selectedBranchCode", null);
            var branchcode= component.get("v.selectedBranchCode");
    }
})