({
    init: function(component, event, helper) {
        helper.fetchValues(component, 'v.debitAuthenticationTypeOptions', 'Payment_Plan__c', 'Debit_authentication_Type__c');
    },

    accountActivationChange: function (component, event, helper) {
        var globalId = component.getGlobalId();
        var accountActivation = document.getElementById( globalId + '_AccountActivation' );
        component.set(' v.accountActivationChecked ', accountActivation.checked );
    },

    alternatePaymentChange: function (component, event, helper) {
        var globalId = component.getGlobalId();
        var alternatePayment = document.getElementById( globalId + '_AlternatePaymentArrangements' );
        component.set(' v.alternatePaymentChecked ', alternatePayment.checked );
    },

    insuficientFundsChange: function (component, event, helper) {
        var globalId = component.getGlobalId();
        var insuficientFunds = document.getElementById( globalId + '_InsuficientFundsCharges' );
        component.set(' v.insuficientFundsChecked ', insuficientFunds.checked );
    },

    dataLoaded: function(component, event, helper) {
        if (component.get('v.recordDataLoaded') == true) {
            if (component.get('v.reference') == '') {
                if (component.get('v.instantAccountResult') != '') {
                    helper.loadResultValues(component);
                    component.set('v.updating', false);
                } else {
                    var promise = helper.applyInstantAccountOpening(component, helper)
                    .then(
                        $A.getCallback(function(result) {
                            helper.loadResultValues(component);
                            component.set('v.updating', false);
                        }),
                        $A.getCallback(function(error) {
                            component.find('branchFlowFooter').set('v.heading', 'Error InstantAccountOpening');
                            component.find('branchFlowFooter').set('v.message', JSON.stringify(error));
                            component.find('branchFlowFooter').set('v.showDialog', true);
                            component.set('v.updating', false);
                        })
                    )
                    }
            }
        }
    },

    recordLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var debitAuthenticationType = payload.record.fields['Debit_authentication_Type__c'].value;
        var creditorShortName = payload.record.fields['Creditor_Short_Name__c'].value;
        var reference = payload.record.fields['Reference__c'].value;
        var amount = payload.record.fields['Amount__c'].value;
        var debitOrderCommencementDay = payload.record.fields['Debit_Order_Commencement_Date__c'].value;
        var collectionDay = payload.record.fields['Collection_Day__c'].value;
        var accountNumber = payload.record.fields['Account_Number__c'].value;
        var debitValueType = payload.record.fields['Debit_Value_Type__c'].value;
        var adjustableDebitDate = payload.record.fields['Adjustable_Debit_Date__c'].value;
        var accountActivation = payload.record.fields['Account_Activation__c'].value;
        var alternatePaymentArrangements = payload.record.fields['Alternate_Payment_Arrangements__c'].value;
        var insuficientFundsCharges = payload.record.fields['Insuficient_Funds_Charges__c'].value;
        if (reference == null) {
            reference = '';
        }
        if (debitOrderCommencementDay != null) {
            debitOrderCommencementDay = $A.localizationService.formatDate(debitOrderCommencementDay, "dd MMMM yyyy");
        }
        if (amount != null) {
            component.set('v.amountValue', amount);
            amount = $A.localizationService.formatCurrency(amount);
        }
        var adjustableDebitDateValue = 'No';
        if(adjustableDebitDate){
            adjustableDebitDateValue = 'Yes';
        }
        component.set('v.debitAuthenticationType', debitAuthenticationType);
        component.set('v.creditorShortName', creditorShortName);
        component.set('v.reference', reference);
        component.set('v.amount', amount);
        component.set('v.collectionStartDate', debitOrderCommencementDay);
        component.set('v.collectionDay', collectionDay);
        component.set('v.accountNumber', accountNumber);
        component.set('v.debitValueType', debitValueType);
        component.set('v.adjustableDebitDate', adjustableDebitDateValue);
        component.set('v.accountActivationChecked', accountActivation);
        component.set('v.alternatePaymentChecked', alternatePaymentArrangements);
        component.set('v.insuficientFundsChecked', insuficientFundsCharges);
        component.set('v.recordDataLoaded', true);
    },

    recordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var debitAuthenticationType = component.get('v.debitAuthenticationType');
        var creditorShortName = component.get('v.creditorShortName');
        var reference = component.get('v.reference');
        var amount = component.get('v.amountValue');
        var debitOrderCommencementDay = component.get('v.debitOrderCommencementDay');
        debitOrderCommencementDay = $A.localizationService.formatDate(debitOrderCommencementDay, "YYYY-MM-DD");
        var debitOrderDay = component.get('v.debitOrderDay');
        var accountNumber = component.get('v.accountNumber');
        //var debitValueType = component.get('v.debitValueType');
        var debitValueTypeValue = 'Usage'; //Only Value in SF
        var adjustableDebitDate = component.get('v.adjustableDebitDate');
        var adjustableDebitDateValue = false;
        if (adjustableDebitDate != 'No') {
            adjustableDebitDateValue = true;
        }
        var accountActivation = component.get('v.accountActivationChecked');
        var alternatePayment = component.get('v.alternatePaymentChecked');
        var insuficientFunds = component.get('v.insuficientFundsChecked');
        var macCode = component.get('v.macCode');
        eventFields['Debit_authentication_Type__c'] = debitAuthenticationType;
        eventFields['Creditor_Short_Name__c'] = creditorShortName;
        eventFields['Reference__c'] = reference;
        eventFields['Amount__c'] = amount;
        eventFields['Debit_Order_Commencement_Date__c'] = debitOrderCommencementDay;
        eventFields['Debit_Order_Debit_Day__c'] = debitOrderDay;
        eventFields['Account_Number__c'] = accountNumber;
        eventFields['Debit_Value_Type__c'] = debitValueTypeValue;
        eventFields['Adjustable_Debit_Date__c'] = adjustableDebitDateValue;
        eventFields['Account_Activation__c'] = accountActivation;
        eventFields['Alternate_Payment_Arrangements__c'] = alternatePayment;
        eventFields['Insuficient_Funds_Charges__c'] = insuficientFunds;
        eventFields['MAC_Code__c'] = macCode;
        component.find('DebitOrderInitiation').submit(eventFields);
    },

    recordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
        component.set('v.updating', false);
    },

    recordSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');

        if ((actionClicked == 'NEXT') || (actionClicked == 'FINISH' )) {
            if ((!component.get('v.pinpadComplete')) && (component.get('v.debitAuthenticationType') == 'Card and pin')) {
                component.set('v.doPinpad', true);
            } else {
                var promise = helper.applyInitiateDebiCheck(component, helper)
                .then(
                    $A.getCallback(function(result) {
                        component.set('v.updating', false);
                        navigate(actionClicked);
                    }),
                    $A.getCallback(function(error) {
                        component.find('branchFlowFooter').set('v.heading', 'Error InitiateDebiCheck');
                        component.find('branchFlowFooter').set('v.message', JSON.stringify(error));
                        component.find('branchFlowFooter').set('v.showDialog', true);
                        component.set('v.updating', false);
                    })
                )
                }
        } else {
            component.set('v.updating', false);
            navigate(actionClicked);
        }
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        var globalId = component.getGlobalId();
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);

        switch(actionClicked)
        {
            case 'NEXT':
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    component.set('v.pinpadComplete', false);
                    document.getElementById(globalId + '_debitOrder_submit').click();
                } else {
                    component.set('v.updating', false);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_debitOrder_submit').click();
                } else {
                    component.set('v.updating', false);
                    var ignoreValidity = confirm('Validation failed! Continue without saving?');
                    if (ignoreValidity) {
                        navigate(actionClicked);
                    }
                }
                break;
        }
    },

    pinpadComplete: function(component, event, helper) {
        component.set('v.doPinpad', false);
        var globalId = component.getGlobalId();
        var pinPadResponse = JSON.parse(component.get('v.pinPadResponse'));
        if (pinPadResponse.IsSuccessful && pinPadResponse.Message != null) {
            component.set('v.macCode', pinPadResponse.Message);
            component.set('v.pinpadComplete', true);
            document.getElementById(globalId + '_debitOrder_submit').click();
        } else {
            component.find('branchFlowFooter').set('v.heading', 'Error pinPadResponse');
            component.find('branchFlowFooter').set('v.message', JSON.stringify(pinPadResponse));
            component.find('branchFlowFooter').set('v.showDialog', true);
            component.set('v.updating', false);
        }
    },

    closePinPad: function(component, event, helper) {
        component.set('v.doPinpad',false);
    }
})