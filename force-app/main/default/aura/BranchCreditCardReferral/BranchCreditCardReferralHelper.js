({
    referralOptions: [
        {'label': 'Refer the Credit Card decision', 'value': 'Pause'},
        {'label': 'Refer the Credit Card decision and open stand-alone Cheque account', 'value': 'PauseContinue'},
        {'label': 'Discard application', 'value': 'Stop'}
    ],

    getReferralOptions: function() {
        return this.referralOptions;
    },

    getScoringValues: function(component) {
        var promise = this.executeApplicationInfo(component)
        .then(
            $A.getCallback(function(result) {
                component.set('v.updating', false);
                var creditStatusId = result.getApplicationInformationResponse.z_return.application.creditStatus.id;
                var creditStatus = result.getApplicationInformationResponse.z_return.application.creditStatus.description;
                var creditStatusGroup = result.getApplicationInformationResponse.z_return.application.statusGroup;
                var declineLetterDescription = declineLetterDescription = result.getApplicationInformationResponse.z_return.application.declineLetterDescription;
                if ($A.util.isUndefinedOrNull(declineLetterDescription)) {
                    var declineLetterDescription = '';
                }
                component.set('v.creditStatus', creditStatus);
                component.set('v.creditStatusId', creditStatusId);
                component.set('v.creditStatusGroup', creditStatusGroup);
                component.set('v.declineLetterDescription', declineLetterDescription);
                component.set('v.updating', false);
            }),
            $A.getCallback(function(error) {
                component.set('v.updating', false);
                alert(error);
            })
        )
    },

    getApplicationInfo: function(component) {
        var promise = this.executeApplicationInfo(component)
        .then(
            $A.getCallback(function(result) {
                component.set('v.updating', false);
                var creditStatusId = result.getApplicationInformationResponse.z_return.application.creditStatus.id;
                var creditStatus = result.getApplicationInformationResponse.z_return.application.creditStatus.description;
                var creditStatusGroup = result.getApplicationInformationResponse.z_return.application.statusGroup;
                var declineLetterDescription = declineLetterDescription = result.getApplicationInformationResponse.z_return.application.declineLetterDescription;
                if ($A.util.isUndefinedOrNull(declineLetterDescription)) {
                    var declineLetterDescription = '';
                }
                component.set('v.creditStatus', creditStatus);
                component.set('v.creditStatusId', creditStatusId);
                component.set('v.creditStatusGroup', creditStatusGroup);
                component.set('v.declineLetterDescription', declineLetterDescription);
                if ((creditStatusId == '03') && (creditStatusGroup == '1')) {
                    component.find('branchFlowFooter').set('v.nextDisabled', false);
                    component.find('branchFlowFooter').set('v.pauseDisabled', true);
                    component.set('v.declineLetterDescription', '');
                } else {
                    component.find('branchFlowFooter').set('v.nextDisabled', true);
                    component.find('branchFlowFooter').set('v.pauseDisabled', false);
                }
                component.set('v.updating', false);
            }),
            $A.getCallback(function(error) {
                component.set('v.updating', false);
                alert(error);
            })
        )
    },

    executeApplicationInfo : function(component) {
        return new Promise(function(resolve, reject) {
            let action = component.get('c.callApplicationInformation');
            var applicationNumber = component.get('v.ccApplicationNumber');
            action.setParams({
                'applicationNumber': applicationNumber
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.applicationInfoResponse', response.getReturnValue());
                    var applicationResult = JSON.parse(response.getReturnValue());
                    if ((applicationResult.getApplicationInformationResponse.z_return.responseCommons != null) &&
                        (applicationResult.getApplicationInformationResponse.z_return.responseCommons.responseMessages != null) &&
                        (applicationResult.getApplicationInformationResponse.z_return.responseCommons.responseMessages.length > 0)) {
                        var resultError = '';
                        for (var i = 0; i < applicationResult.getApplicationInformationResponse.z_return.responseCommons.responseMessages.length; i++) {
                            console.log(applicationResult.getApplicationInformationResponse.z_return.responseCommons.responseMessages[i].message);
                            resultError = resultError + applicationResult.getApplicationInformationResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                            resultError = resultError.replace('&lt;', '<');
                            resultError = resultError.replace('&gt;', '>');
                        }
                        reject(resultError);
                    } else {
                        resolve(applicationResult);
                    }
                } else {
                    reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    },

    confirmSelection: function(component) {
        var returnValue = true;
        this.removeValidation(component, 'ReferralOptions');
        var referralSelection = component.get('v.referralSelection');
        if ($A.util.isUndefinedOrNull(referralSelection)) {
            this.addValidation(component, 'ReferralOptions', 'Please select an option.');
            returnValue = false;
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
    },

    executeSelection: function(component) {
        var navigate = component.get('v.navigateFlow');

        switch(component.get('v.referralSelection')) {
            case 'Pause':
                component.set('v.updating', false);
                component.set('v.referredWithCheque', true);
                component.set('v.showKofax', true);
                break;
            case 'PauseContinue':
                component.set('v.updating', false);
                component.set('v.referredWithCheque', false);
                component.set('v.showKofax', true);
                break;
            case 'Stop':
                navigate('NEXT');
                break;
        }
    }
})