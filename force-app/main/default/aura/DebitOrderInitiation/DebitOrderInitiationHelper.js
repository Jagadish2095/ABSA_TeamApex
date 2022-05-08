({
    fetchValues: function(component, listName, objName, objField) {
        var action = component.get("c.getPickListValues");
        var objObject = {'sobjectType': objName};
        var objField = objField
        action.setParams({
            "objObject": objObject,
            "objField": objField
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                component.set(listName, response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    loadResultValues: function(component) {
        var instantAccountResult = JSON.parse(component.get('v.instantAccountResult'));

        var creditorShortNameValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.creditorDetails.mandUltCredShortName;
        component.set('v.creditorShortName', creditorShortNameValue);
        var referenceValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.mandateDetails.contractRef;
        component.set('v.reference', referenceValue);
        var amountValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.paymentDetails.mandMaxAmount;
        component.set('v.amountValue', amountValue);
        var amount = $A.localizationService.formatCurrency(amountValue);
        component.set('v.amount', amount);
        var debitOrderCommencementDayValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.paymentDetails.RMSCollStDate;
        if (debitOrderCommencementDayValue != null) {
            debitOrderCommencementDayValue = $A.localizationService.formatDate(debitOrderCommencementDayValue, "dd MMMM yyyy");
        }
        component.set('v.debitOrderCommencementDay', debitOrderCommencementDayValue);
        component.set('v.collectionStartDate', debitOrderCommencementDayValue);
        var debitOrderDayValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.paymentDay;
        if (debitOrderDayValue.length == 1) {
            debitOrderDayValue = '0' + debitOrderDayValue;
        }
        component.set('v.debitOrderDay', debitOrderDayValue);
        //var accountNumberValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.accountNumber;
        //component.set('v.accountNumber', accountNumberValue);

        var debitValueTypeValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.paymentDetails.supplDtValueTyp;
        component.set('v.debitValueType', 'Usage');//Only value in SF

        var adjustableDebitDateValue = instantAccountResult.applyResponse.z_return.application.debitOrderDetails.paymentDetails.supplDteAdjRuleInd;
        var adjustableDebitDate = 'No';
        if (adjustableDebitDateValue != 'N') {
            adjustableDebitDateValue = 'Yes';
        }
        component.set('v.adjustableDebitDate ', adjustableDebitDate);
    },

    applyInstantAccountOpening: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let action = component.get('c.applyInstantAccountOpening');
            var applicationId = component.get('v.applicationId');
            var lockVersionId = component.get('v.lockVersionId');
            var ccApplicationNumber = component.get('v.ccApplicationNumber');
            action.setParams({
                'applicationId' : applicationId,
                'applicationNumber' :  ccApplicationNumber,
                'lockVersionId' : lockVersionId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.instantAccountResult', response.getReturnValue());
                    var instantAccountResult = JSON.parse(response.getReturnValue());
                    if (instantAccountResult.statusCode == 200) {
                       if ((instantAccountResult.applyResponse.z_return.responseCommons != null) &&
                            (instantAccountResult.applyResponse.z_return.responseCommons.responseMessages != null) &&
                            (instantAccountResult.applyResponse.z_return.responseCommons.responseMessages.length > 0)) {
                            var resultError = '';
                            for (var i = 0; i < instantAccountResult.applyResponse.z_return.responseCommons.responseMessages.length; i++) {
                                console.log(instantAccountResult.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                resultError = resultError + instantAccountResult.applyResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                                resultError = resultError.replace('&lt;', '<');
                                resultError = resultError.replace('&gt;', '>');
                            }
    						reject(resultError);
                        } else {
                            lockVersionId = instantAccountResult.applyResponse.z_return.application.lockVersionId;
                            component.set('v.lockVersionId', lockVersionId);
							resolve(instantAccountResult);
                        }
                    } else {
                        reject(instantAccountResult);
                    }
                } else {
                    reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    },

    applyInitiateDebiCheck: function(component, helper) {
        return new Promise(function(resolve, reject) {
            let action = component.get('c.applyInitiateDebiCheck');
            var applicationId = component.get('v.applicationId');
            var lockVersionId = component.get('v.lockVersionId');
            var ccApplicationNumber = component.get('v.ccApplicationNumber');
            action.setParams({
                'applicationId' : applicationId,
                'applicationNumber' :  ccApplicationNumber,
                'lockVersionId' : lockVersionId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.initiateDebiCheckResult', response.getReturnValue());
                    var initiateDebiCheckResult = JSON.parse(response.getReturnValue());
                    if (initiateDebiCheckResult.statusCode == 200) {
                       if ((initiateDebiCheckResult.applyResponse.z_return.responseCommons != null) &&
                            (initiateDebiCheckResult.applyResponse.z_return.responseCommons.responseMessages != null) &&
                            (initiateDebiCheckResult.applyResponse.z_return.responseCommons.responseMessages.length > 0)) {
                            var resultError = '';
                            for (var i = 0; i < initiateDebiCheckResult.applyResponse.z_return.responseCommons.responseMessages.length; i++) {
                                console.log(initiateDebiCheckResult.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                resultError = resultError + initiateDebiCheckResult.applyResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                                resultError = resultError.replace('&lt;', '<');
                                resultError = resultError.replace('&gt;', '>');
                            }
    						reject(resultError);
                        } else {
                            lockVersionId = initiateDebiCheckResult.applyResponse.z_return.application.lockVersionId;
                            component.set('v.lockVersionId', lockVersionId);
							resolve(initiateDebiCheckResult);
                        }
                    } else {
                        reject(initiateDebiCheckResult);
                    }
                } else {
                    reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    },

    checkValidity: function(component, helper) {
        var returnValue = 'pass';
        this.removeValidation(component, 'AccountActivationDiv');
        this.removeValidation(component, 'AlternatePaymentArrangementsDiv');
        this.removeValidation(component, 'InsuficientFundsChargesDiv');

        if (!component.find('DebitAuthenticationType').get('v.validity').valid) {
            component.find('DebitAuthenticationType').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.get('v.accountActivationChecked')) {
            this.addValidation(component, 'AccountActivationDiv', 'Please select to confirm.');
            returnValue = 'fail';
        }
        if (!component.get('v.alternatePaymentChecked')) {
            this.addValidation(component, 'AlternatePaymentArrangementsDiv', 'Please select to confirm.');
            returnValue = 'fail';
        }
        if (!component.get('v.insuficientFundsChecked')) {
            this.addValidation(component, 'InsuficientFundsChargesDiv', 'Please select to confirm.');
            returnValue = 'fail';
        }
        return returnValue;
    },

    addValidation: function(component, componentAuraId, errorMsg) {
        var styleClass= 'slds-form-element__help validationCss';
        var errorComponent = component.find(componentAuraId);
        $A.util.addClass(errorComponent, 'slds-has-error');
        var globalId = component.getGlobalId();
        var elementId = (globalId + '_' + componentAuraId);
        var validationElementId = (elementId + '_Error');
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement('div');
        validationElement.setAttribute('id', validationElementId);
        validationElement.setAttribute('class', styleClass);
        validationElement.textContent = errorMsg;
        errorElement.appendChild(validationElement);
    },

    removeValidation: function(component, componentAuraId) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + '_' + componentAuraId + '_Error');
        var errorComponent = component.find(componentAuraId);
        $A.util.removeClass(errorComponent, 'slds-has-error');
        if(document.getElementById(validationElementId)) {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        }
    }
})