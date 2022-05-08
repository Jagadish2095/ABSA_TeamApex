({
    annualIncreasesOptions: [
        {'label': 'Yes', 'value': 'Y'},
        {'label': 'No', 'value': 'N'}
    ],

    noticeDeliveryOptions: [
        {'label': 'By registered mail to my last postal address provided to you', 'value': '1'},
        {'label': 'To an adult person at my last physical address provided to you', 'value': '2'}
    ],

    getAnnualIncreasesOptions: function(component) {
        return this.annualIncreasesOptions;
    },

    getNoticeDeliveryOptions: function() {
        return this.noticeDeliveryOptions;
    },

    increaseCount: function(component) {
        var currentCount = component.get('v.currentCount');
        var calculationLimit = component.get('v.calculationLimit');
        currentCount += 1;
        component.set('v.currentCount', currentCount);
        if (currentCount == calculationLimit) {
            component.set('v.isLimitReached', true);
        }
    },

    confirmInfo: function(component) {
        var returnValue = true;
        this.removeValidation(component, 'NoticeDelivery');
        this.removeValidation(component, 'AnnualIncreases');
        var noticeDeliveryValue = component.get('v.noticeDeliveryValue');
        var annualIncreasesValue = component.get('v.annualIncreasesValue');
        if ($A.util.isUndefinedOrNull(noticeDeliveryValue)) {
            this.addValidation(component, 'NoticeDelivery', 'Please select an option.');
            returnValue = false;
        }
        if ($A.util.isUndefinedOrNull(annualIncreasesValue)) {
            this.addValidation(component, 'AnnualIncreases', 'Please select an option.');
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

    getProductValues: function(component) {
        var productInfoResult = '';
        var cardProductDescription = '';
        var minimumCreditLimit = '';
        var maximumCreditLimit = '';
        var creditLimitApproved = '';
        var wkFiid = '';
        var wkAcctProd = '';
        var wkAcctType = '';
        if (!component.get('v.isReferred')) {
            productInfoResult = JSON.parse(component.get('v.scoringResult'));
            if (productInfoResult.applyResponse.z_return.application.productInformation[0]) {
                cardProductDescription = productInfoResult.applyResponse.z_return.application.productInformation[0].cardProductDescription;
                minimumCreditLimit = productInfoResult.applyResponse.z_return.application.productInformation[0].minimumCreditLimit;
                maximumCreditLimit = productInfoResult.applyResponse.z_return.application.productInformation[0].maximumCreditLimit;
                creditLimitApproved = productInfoResult.applyResponse.z_return.application.creditLimitApproved;
                wkFiid = productInfoResult.applyResponse.z_return.application.productInformation[0].sourceId;
                wkAcctProd = productInfoResult.applyResponse.z_return.application.productInformation[0].productId;
                wkAcctType = productInfoResult.applyResponse.z_return.application.productInformation[0].accountType;
            } else {
                alert('No product Information was returned with service result');
            }
        } else {
            productInfoResult = JSON.parse(component.get('v.applicationInfoResponse'));
            if (productInfoResult.getApplicationInformationResponse.z_return.application.productInformation) {
                cardProductDescription = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.cardProductDescription;
                minimumCreditLimit = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.minimumCreditLimit;
                maximumCreditLimit = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.maximumCreditLimit;
                creditLimitApproved = productInfoResult.getApplicationInformationResponse.z_return.application.creditLimitApproved;
                wkFiid = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.sourceId;
                wkAcctProd = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.productId;
                wkAcctType = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.accountType;
            } else {
                alert('No product Information was returned with service result');
            }
        }
        var wkFiidSplit = wkFiid.split("+");
        var wkFiid = wkFiidSplit[1];
        var creditCardSectionLabel = '';
        var chequeCardSectionLabel = '';
        switch (cardProductDescription) {
            case 'GOLD PACKAGE':
                creditCardSectionLabel = 'Gold Credit Card';
                chequeCardSectionLabel = 'Gold Cheque';
                break;
            case 'VISA PREMIUM PACKAGE':
                creditCardSectionLabel = 'Premium Credit Card';
                chequeCardSectionLabel = 'Premium Cheque';
                break;
        }
        if (component.get('v.referredWithCheque')) {
            creditCardSectionLabel = creditCardSectionLabel + ' (Package)';
            chequeCardSectionLabel = chequeCardSectionLabel + ' (Package)';
        }
        component.set('v.creditCardSectionLabel', creditCardSectionLabel);
        component.set('v.chequeCardSectionLabel', chequeCardSectionLabel);
        component.set('v.minimumCreditLimit', minimumCreditLimit);
        component.set('v.maximumCreditLimit', creditLimitApproved);
        component.set('v.creditLimitApproved', creditLimitApproved);
        component.set('v.updateCreditLimit', creditLimitApproved);
        component.set('v.wkFiid', wkFiid);
        component.set('v.wkAcctProd', wkAcctProd);
        component.set('v.wkAcctType', wkAcctType);
    },

    getValues: function(component) {
        var promise = this.executeReCalculate(component, this)
        .then(
            $A.getCallback(function(result) {
                component.set('v.creditLimitApproved', result.CAS096O.can096oOutPutArea.wkTotalCredit);
                component.set('v.creditLimitInterestRate', result.CAS096O.can096oOutPutArea.wkCrlIntRate);
                component.set('v.creditLimitInstalAmount', result.CAS096O.can096oOutPutArea.wkCrlInstal);
                component.set('v.monthlyAccountFee', result.CAS096O.can096oOutPutArea.wkAccountFee);
                component.set('v.monthlyFacilityFee', result.CAS096O.can096oOutPutArea.wkMonthlyServiceFee);
                component.set('v.initiationFee', result.CAS096O.can096oOutPutArea.wkInitFee);
                component.set('v.updatingLimit', false);
            }),
            $A.getCallback(function(error) {
                component.set('v.updatingLimit', false);
                component.find('branchFlowFooter').set('v.heading', 'Error: executeReCalculate');
                component.find('branchFlowFooter').set('v.message', JSON.stringify(error));
                component.find('branchFlowFooter').set('v.showDialog', true);
            })
        )
    },

    executeReCalculate : function(component, helper) {
        return new Promise(function(resolve, reject) {
            let action = component.get('c.callActionQuotation');
            var recordId = component.get('v.recordId');
            var newCreditLimit = component.get('v.updateCreditLimit');
            var wkFiid = component.get('v.wkFiid')
            var wkAcctProd = component.get('v.wkAcctProd')
            var wkAcctType = component.get('v.wkAcctType')
            action.setParams({
                'accountID': recordId,
                'newCreditLimit': newCreditLimit,
                'wkFiid': wkFiid,
                'wkAcctProd': wkAcctProd,
                'wkAcctType': wkAcctType
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
					var quotationResult = response.getReturnValue();
                    component.set('v.quotationResult', quotationResult);
                    var respObjLimitCalc = JSON.parse(quotationResult);
                    if (respObjLimitCalc.statusCode == 200 && respObjLimitCalc.CAS096O != null && respObjLimitCalc.CAS096O.can096oOutPutArea != null) {
                        resolve(respObjLimitCalc);
                    } else {
                        reject(respObjLimitCalc);
                    }
                } else {
                    var message = '';
                    var errors = response.getError();
                    if (errors) {
                        for (var i = 0; i < errors.length; i++) {
                            for (
                                var j = 0;
                                errors[i].pageErrors && j < errors[i].pageErrors.length;
                                j++
                            ) {
                                message +=
                                    (message.length > 0 ? '\n' : '') +
                                    errors[i].pageErrors[j].message;
                            }
                            if (errors[i].fieldErrors) {
                                for (var fieldError in errors[i].fieldErrors) {
                                    var thisFieldError = errors[i].fieldErrors[fieldError];
                                    for (var j = 0; j < thisFieldError.length; j++) {
                                        message +=
                                            (message.length > 0 ? '\n' : '') +
                                            thisFieldError[j].message;
                                    }
                                }
                            }
                            if (errors[i].message) {
                                message += (message.length > 0 ? '\n' : '') + errors[i].message;
                            }
                        }
                    } else {
                        message += (message.length > 0 ? '\n' : '') + 'Unknown error';
                    }
                    reject(message);
                }
            });
            $A.enqueueAction(action);
        })
    }
})