({
	myAction : function(component, event, helper) {
	},    
    
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'Method__c', 'PaymentMethod');    
        helper.fetchDraftingFees(component);
        helper.doInit(component);
    },
    
    onChange : function(component, event, helper) {
        component.set("v.paymentPreferenceType", event.getSource().get("v.value"));               
    },
    
    submitSave : function(component, event, helper) {
        helper.submitSave(component);
    },
    
    submitEdit : function(component, event, helper) {
        helper.submitEdit(component);
    },
    
    submitCancel : function(component, event, helper) {
        var a = component.get('c.doInit');
        $A.enqueueAction(a);
    },
    
    onDraftingFeeChange : function(component, event, helper) {
        helper.onDraftingFeeChange(component);
    },
    
    onPicklistPaymentMethodChange : function(component, event, helper) {
        helper.onPicklistPaymentMethodChange(component);
    },
    
    onPicklistAccTypeChange : function(component, event, helper) {
        helper.onPicklistAccTypeChange(component, event);
    },
    
    handleSubmitPaymentEvent : function(component, event, helper) {
        helper.submitPaymentPlan(component);
    },
    
    handleBrachCodeComponentEvent : function(component, event, helper) {
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