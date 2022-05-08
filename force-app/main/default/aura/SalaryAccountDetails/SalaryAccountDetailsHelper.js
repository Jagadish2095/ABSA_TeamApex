({
    fetchData: function(component) {
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
    },
    
    checkValidity: function(component, helper) {
        var returnValue = 'pass';
        if (!component.find('SalaryAccountHolderName').get('v.validity').valid) {
            component.find('SalaryAccountHolderName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }  
        if (!component.find('SalaryAccountNumber').get('v.validity').valid) {
            component.find('SalaryAccountNumber').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }  
        if (!component.find('SalaryBankName').get('v.validity').valid) {
            component.find('SalaryBankName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }  
        if (!component.find('SalaryAccountType').get('v.validity').valid) {
            component.find('SalaryAccountType').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }  
        return returnValue;
    }
})