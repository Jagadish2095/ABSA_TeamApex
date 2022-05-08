({
    //Function for setting the table columns and setting the fields to be quried.
    getColumns : function(component) {        
        component.set('v.columnList', [
            {label: 'Effective Date', fieldName: 'EffectiveDate', type: 'date'},
            {label: 'Expiration Date', fieldName: 'ExpirationDate', type: 'date'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Policy Action', fieldName: 'Policy_Action__c', type: 'text'},
            {label: 'Debit Order Start Date', fieldName: 'Debit_Order_Start_Date__c', type: 'text'},
            {label: 'Premium Frequency', fieldName: 'PremiumFrequency', type: 'text'},
            {label: 'Payment Method', fieldName: 'Payment_Method__c', type: 'date'},
            {label: 'Account Type', fieldName: 'Account_Type__c', type: 'text'},
            {label: 'Branch Code', fieldName: 'Branch_Code__c', type: 'text'},
            {label: 'Account Number', fieldName: 'Account_Number__c', type: 'text'},
            {label: 'Account Holder Name', fieldName: 'Account_Holder_Name__c', type: 'text'},
            {label: 'Number of Rejections', fieldName:'Number_of_Rejections__c', type: 'text'},
            {label: 'Fixed Instruction Indicator', fieldName: 'Fixed_Instruction_Indicator__c', type: 'text'},
            {label: 'Fixed Instruction Date', fieldName: 'Fixed_Instruction_Date__c', type: 'date'},
            {label: 'Unpaid Reason Code', fieldName: 'Unpaid_Reason_Code__c', type: 'text'}

        ]);

    },
    
    //Function for getting the data from the Apex controller
    getDataHelper : function(component, event) {

        var action     = component.get("c.getPolicyRecord");

        action.setParams({
            insurancePolicyId  : component.get("v.policyRecordId")
        });
        action.setCallback(this,function(response){
            // store the response return value 
            var state = response.getState();
            if (state === "SUCCESS") {

                var resultData = response.getReturnValue();
                component.set("v.policyAccountData", resultData);
            
            }else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error InsurancePolicyPolicyAccountController.getPolicyRecord: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
            
        });
        $A.enqueueAction(action);
    },


})