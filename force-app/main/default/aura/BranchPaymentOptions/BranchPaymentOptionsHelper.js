({
    accountOptions: [
        {'label': 'Absa in Package Cheque account', 'value': 'PackageAccount'},
        {'label': 'Another account', 'value': 'AnotherAccount'}
    ],

    fetchAccountOptions: function(component) {
        component.set('v.accountOptions', this.accountOptions);
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

    fetchSalaryData: function(component) {
        var SalaryAccoutAction = component.get('c.getSalaryAccoutDetails');
        var recordId = component.get('v.recordId');
        SalaryAccoutAction.setParams({
            'applicationId' : recordId
        });
        SalaryAccoutAction.setCallback(this, function(response) {
            var salaryAccoutDetails = response.getReturnValue();
            component.set('v.salaryAccountHolderName', salaryAccoutDetails['Account_Holder_Name__c']);
            component.set('v.salaryAccountNumber', salaryAccoutDetails['Account_Number__c']);
            component.set('v.salaryAccountType', salaryAccoutDetails['Account_Type__c']);
            component.set('v.salaryBankName', salaryAccoutDetails['Institution_Name__c']);
        });
        $A.enqueueAction(SalaryAccoutAction);
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
        if (!component.find('DebitOrderDebitDay').get('v.validity').valid) {
            component.find('DebitOrderDebitDay').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (component.get('v.accountValue') != 'PackageAccount') {
            component.set('v.usePackageAccount', false);
            if (!component.find('AccountHolderName').get('v.validity').valid) {
                component.find('AccountHolderName').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
            if (!component.find('AccountNumber').get('v.validity').valid) {
                component.find('AccountNumber').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
            if (!component.find('AccountType').get('v.validity').valid) {
                component.find('AccountType').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
            if (!component.find('BankName').get('v.validity').valid) {
                component.find('BankName').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
        } else {
            component.set('v.usePackageAccount', true);
        }
        return returnValue;
    }
})