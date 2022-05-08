({
    init: function(component, event, helper) {
        if (component.get('v.showSalaryAccount')) {
            helper.fetchSalaryData(component);
        }
        if (component.get('v.showPaymentAccount') || component.get('v.useSalaryAccount')) {
            helper.fetchPaymentData(component);
        }
        helper.fetchBankValues(component);
        helper.fetchValues(component, 'v.salaryAccountOptions', 'Application_Financial_Account__c', 'Account_Type__c');
        helper.fetchValues(component, 'v.paymentAccountOptions', 'Payment_Plan__c', 'Account_Type__c');
    },

    salaryRecordLoaded: function(component, event) {
        var payload = event.getParam('recordUi');
        var bankName = payload.record.fields['Institution_Name__c'].value;
        var accountName = payload.record.fields['Account_Holder_Name__c'].value;
        var accountNumber = payload.record.fields['Account_Number__c'].value;
        var accountType = payload.record.fields['Account_Type__c'].value;
        component.set('v.salaryBankName', bankName);
        component.set('v.salaryAccountName', accountName);
        component.set('v.salaryAccountNumber', accountNumber);
        component.set('v.salaryAccountType', accountType);
        component.set('v.salaryAccountLoaded', true);

        if (((!component.get('v.showPaymentAccount')) && (!component.get('v.useSalaryAccount'))) || (component.get('v.paymentAccountLoaded'))) {
            component.set('v.updating', false);
        }
    },

    salaryRecordSubmit: function(component, event) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var bankName = component.get('v.salaryBankName');
        var accountName = component.get('v.salaryAccountName');
        var accountNumber = component.get('v.salaryAccountNumber');
        var accountType = component.get('v.salaryAccountType');
		eventFields['Institution_Name__c'] = bankName;
        eventFields['Account_Holder_Name__c'] = accountName;
        eventFields['Account_Number__c'] = accountNumber;
        eventFields['Account_Type__c'] = accountType;
        component.find('SalaryAccountDetail').submit(eventFields);
    },

    salaryRecordError: function(component, event) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.set('v.heading', errorMessage);
        component.set('v.message', eventDetails);
        component.set('v.showDialog', true);
		component.set('v.updating', false);
    },

    salaryRecordSuccess: function(component) {
        var globalId = component.getGlobalId();
        if (component.get('v.showPaymentAccount') || component.get('v.useSalaryAccount')) {
            document.getElementById(globalId + '_paymentPlan_submit').click();
        } else {
            component.set('v.updating', false);
            component.set('v.showPopUp', false);
        }
    },

    paymentRecordLoaded: function(component, event) {
        var payload = event.getParam('recordUi');
        var bankName = payload.record.fields['Bank_Name__c'].value;
        var accountName = payload.record.fields['Account_Holder_Name__c'].value;
        var accountNumber = payload.record.fields['Account_Number__c'].value;
        var accountType = payload.record.fields['Account_Type__c'].value;
        component.set('v.paymentBankName', bankName);
        component.set('v.paymentAccountName', accountName);
        component.set('v.paymentAccountNumber', accountNumber);
        component.set('v.paymentAccountType', accountType);
        component.set('v.paymentAccountLoaded', true);
        if ((!component.get('v.showSalaryAccount')) || ((component.get('v.showSalaryAccount')) && (component.get('v.salaryAccountLoaded')))) {
            component.set('v.updating', false);
        }
    },

    paymentRecordSubmit: function(component, event) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var bankName = component.get('v.paymentBankName');
        var accountName = component.get('v.paymentAccountName');
        var accountNumber = component.get('v.paymentAccountNumber');
        var accountType = component.get('v.paymentAccountType');
		eventFields['Bank_Name__c'] = bankName;
        eventFields['Account_Holder_Name__c'] = accountName;
        eventFields['Account_Number__c'] = accountNumber;
        eventFields['Account_Type__c'] = accountType;
        component.find('PaymentOptionsDetail').submit(eventFields);
    },

    paymentRecordError : function(component, event) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.set('v.heading', errorMessage);
        component.set('v.message', eventDetails);
        component.set('v.showDialog', true);
		component.set('v.updating', false);
    },

    paymentRecordSuccess : function(component) {
        component.set('v.updating', false);
        component.set('v.showPopUp', false);
    },

    cancelClose: function(component) {
        component.set('v.showPopUp', false);
    },

    updateClose: function(component) {
        var globalId = component.getGlobalId();
        if (!component.get('v.showPaymentAccount') && component.get('v.useSalaryAccount')) {
            var bankName = component.get('v.salaryBankName');
            var accountName = component.get('v.salaryAccountName');
            var accountNumber = component.get('v.salaryAccountNumber').toString();
            var accountType = component.get('v.salaryAccountType');
            component.set('v.paymentBankName', bankName);
            component.set('v.paymentAccountName', accountName);
            component.set('v.paymentAccountNumber', accountNumber);
            component.set('v.paymentAccountType', accountType);
        }
        if (component.get('v.showSalaryAccount')) {
            document.getElementById(globalId + '_financialAccount_submit').click();
        } else if (component.get('v.showPaymentAccount')) {
            document.getElementById(globalId + '_paymentPlan_submit').click();
        }
    }
})