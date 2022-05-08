({
    init: function(component, event, helper) {
        helper.fetchData(component);
        helper.fetchBankValues(component);
        helper.fetchValues(component, 'v.accountOptions', 'Application_Financial_Account__c', 'Account_Type__c');
    },

    salaryRecordLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var bankName = payload.record.fields['Institution_Name__c'].value;
        var accountName = payload.record.fields['Account_Holder_Name__c'].value;
        var accountNumber = payload.record.fields['Account_Number__c'].value;
        var accountType = payload.record.fields['Account_Type__c'].value;
        component.set('v.bankName', bankName);
        component.set('v.accountName', accountName);
        component.set('v.accountNumber', accountNumber);
        component.set('v.accountType', accountType);
        component.set('v.updating', false);
    },
    
    salaryRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var bankName = component.get('v.bankName');
        var accountName = component.get('v.accountName');
        var accountNumber = component.get('v.accountNumber');
        var accountType = component.get('v.accountType');
		eventFields['Institution_Name__c'] = bankName;
        eventFields['Account_Holder_Name__c'] = accountName;
        eventFields['Account_Number__c'] = accountNumber;
        eventFields['Account_Type__c'] = accountType;
        component.find('SalaryAccountDetail').submit(eventFields);
    },
    
    salaryRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
		component.set('v.updating', false);
    },
    
    salaryRecordSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');
        component.set('v.updating', false);
        navigate(actionClicked); 
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
                    document.getElementById(globalId + '_financialAccount_submit').click();
                } else {
                    component.set('v.updating', false);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_financialAccount_submit').click();
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