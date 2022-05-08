({
    init: function(component, event, helper) {
        helper.fetchPaymentData(component);
        helper.fetchSalaryData(component);
        helper.fetchAccountOptions(component);
        helper.fetchBankValues(component);
        helper.fetchValues(component, 'v.debitDayOptions', 'Payment_Plan__c', 'Debit_Order_Debit_Day__c');
        helper.fetchValues(component, 'v.accountTypeOptions', 'Payment_Plan__c', 'Account_Type__c');
        if (!component.get('v.referredWithCheque')) {
            component.set('v.usePackageAccount', false);
            component.set('v.showButtons', false);
            component.set('v.accountValue', 'AnotherAccount');
        }
    },

    paymentRecordLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var bankName = payload.record.fields['Bank_Name__c'].value;
        var debitDay = payload.record.fields['Debit_Order_Debit_Day__c'].value;
        var accountName = payload.record.fields['Account_Holder_Name__c'].value;
        var accountNumber = payload.record.fields['Account_Number__c'].value;
        var accountType = payload.record.fields['Account_Type__c'].value;
        component.set('v.bankName', bankName);
        component.set('v.debitDay', debitDay);
        component.set('v.accountName', accountName);
        component.set('v.accountNumber', accountNumber);
        component.set('v.accountType', accountType);
        component.set('v.updating', false);
    },

    paymentRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var debitDay = component.get('v.debitDay');
        var bankName = '';
        var accountName = '';
        var accountNumber = '';
        var accountType = '';
        if (component.get('v.accountValue') != 'PackageAccount') {
            bankName = component.get('v.bankName');
            debitDay = component.get('v.debitDay');
            accountName = component.get('v.accountName');
            accountNumber = component.get('v.accountNumber');
            accountType = component.get('v.accountType');
        }
        eventFields['Bank_Name__c'] = bankName;
        eventFields['Debit_Order_Debit_Day__c'] = debitDay;
        eventFields['Account_Holder_Name__c'] = accountName;
        eventFields['Account_Number__c'] = accountNumber;
        eventFields['Account_Type__c'] = accountType;
        component.find('PaymentOptionsDetail').submit(eventFields);
    },

    paymentRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
		component.set('v.updating', false);
    },

    paymentRecordSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');
        component.set('v.updating', false);
        navigate(actionClicked);
    },

    useSalaryDetailsChange: function(component, event, helper) {
        var globalId = component.getGlobalId();
        var useSalaryDetails = document.getElementById( globalId + '_UseSalaryDetails' );

        if (useSalaryDetails.checked) {
            component.set('v.useSalaryAccount', true);
            component.set('v.paymentPlanAccountHolderName', component.get('v.accountName'));
            component.set('v.paymentPlanAccountNumber', component.get('v.accountNumber'));
            component.set('v.paymentPlanAccountType', component.get('v.accountType'));
            component.set('v.paymentPlanBankName', component.get('v.bankName'));
            component.set('v.accountName', component.get('v.salaryAccountHolderName'));
            component.set('v.accountNumber', component.get('v.salaryAccountNumber'));
            component.set('v.accountType', component.get('v.salaryAccountType'));
            component.set('v.bankName', component.get('v.salaryBankName'));
        } else {
            component.set('v.useSalaryAccount', false);
            component.set('v.accountName', component.get('v.paymentPlanAccountHolderName'));
            component.set('v.accountNumber', component.get('v.paymentPlanAccountNumber'));
            component.set('v.accountType', component.get('v.paymentPlanAccountType'));
            component.set('v.bankName', component.get('v.paymentPlanBankName'));
        }
    },

    setAccountValue: function(component, event, helper) {
        if (component.get('v.accountValue') == 'PackageAccount') {
            component.set('v.usePackageAccount', true);
        } else {
            component.set('v.usePackageAccount', false);
        }
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        var globalId = component.getGlobalId();
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);

        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_paymentPlan_submit').click();
                } else {
                    component.set('v.updating', false);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_paymentPlan_submit').click();
                } else {
                    component.set('v.updating', false);
                    var ignoreValidity = confirm('Validation failed! Continue without saving?');
                    if (ignoreValidity) {
                        navigate(actionClicked);
                    }
                }
                break;
        }
    }
})