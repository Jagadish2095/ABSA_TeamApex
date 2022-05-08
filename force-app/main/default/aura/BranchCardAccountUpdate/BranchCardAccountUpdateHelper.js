({
    fetchSalaryData: function(component) {
        var action = component.get('c.getApplicationFinancialAccountRecordId');
        var recordId = component.get('v.recordId');
        action.setParams({
            'applicationId' : recordId,
            'accountPurpose' : 'Salary'
        });
        action.setCallback(this, function(response) {
            var financialAccountRecordId = response.getReturnValue();
            component.set('v.financialAccountRecordId', financialAccountRecordId);
        });
        $A.enqueueAction(action);
    },

    fetchPaymentData: function(component) {
        var action = component.get('c.getPaymentPlanRecordId');
        var recordId = component.get('v.recordId');
        action.setParams({
            'applicationId' : recordId
        });
        action.setCallback(this, function(response) {
            var paymentPlanRecordId = response.getReturnValue();
            component.set('v.paymentPlanRecordId', paymentPlanRecordId);
        });
        $A.enqueueAction(action);
    },

    fetchBankValues: function(component) {
        var action = component.get("c.getBankInfo");
        action.setCallback(this, function(response) {
            var bankOptions = component.get("v.bankOptions");
            if (response.getState() == "SUCCESS") {
                var bankValues = response.getReturnValue();
                for (const bankValue of bankValues) {
                    bankOptions.push(bankValue);
                }
                component.set("v.bankOptions", bankOptions);
            }
        });
        $A.enqueueAction(action);
    },

    fetchValues: function(component, listName, objName, objField) {
        var action = component.get('c.getPickListValues');
        var objObject = { 'sobjectType': objName };
        action.setParams({
            'objObject': objObject,
            'objField': objField
        });
        action.setCallback(this, function(response) {
            component.set(listName, response.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})