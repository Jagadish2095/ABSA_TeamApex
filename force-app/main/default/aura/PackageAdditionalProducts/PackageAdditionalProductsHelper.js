({
    checkAdditionalProducts: function(component) {
        var returnValue = false;
        var creditLifeComponent = component.find('branchCreditLife');
        var checkCreditLife = creditLifeComponent.ValidateComponent();
        if (checkCreditLife) {
            returnValue = true;
        }
        return returnValue;
    },

    getProductValues: function(component) {
        var productInfoResult = '';
        var cardProductDescription = '';
        if (!component.get('v.isReferred')) {
            productInfoResult = JSON.parse(component.get('v.scoringResult'));
            cardProductDescription = productInfoResult.applyResponse.z_return.application.productInformation[0].cardProductDescription;
        } else {
            productInfoResult = JSON.parse(component.get('v.applicationInfoResponse'));
            cardProductDescription = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.cardProductDescription;
        }
        switch (cardProductDescription) {
            case 'GOLD PACKAGE':
                component.set('v.creditCardSectionLabel', 'Gold Package');
                component.set('v.creditCardDescriptionLabel', 'Gold Cheque and Gold Credit Card with a credit limit of ');
                component.set('v.creditLimitInstalAmount', '164');
                break;
            case 'VISA PREMIUM PACKAGE':
                component.set('v.creditCardSectionLabel', 'Premium Package');
                component.set('v.creditCardDescriptionLabel', 'Premium Cheque and Premium Credit Card with a credit limit of ');
                component.set('v.creditLimitInstalAmount', '282');
                break;
        }
    },

    getQuotationValues: function(component) {
        var quotationResult = JSON.parse(component.get('v.quotationResult'));
        var approvedCreditLimit = quotationResult.CAS096O.can096oOutPutArea.wkTotalCredit;
        var creditLimitInstalAmount = quotationResult.CAS096O.can096oOutPutArea.wkCrlInstal;
        var creditLimitInterestRate = quotationResult.CAS096O.can096oOutPutArea.wkCrlIntRate;
        var monthlyCreditLifeFee = quotationResult.CAS096O.can096oOutPutArea.wkClpAmt;
        component.set('v.approvedCreditLimit', approvedCreditLimit);
        component.set('v.creditLimitInstalAmount', creditLimitInstalAmount);
        component.set('v.creditLimitInterestRate', creditLimitInterestRate);
        component.set('v.monthlyCreditLifeFee', monthlyCreditLifeFee);
    },

    executeCompleteOne : function(component, helper) {
        var productInfoResult = '';
        var creditLifeComponent = component.find('branchCreditLife');
        var applicationId = component.get('v.applicationId');
        var applicationNumber = '';
        var lockVersionId = component.get('v.lockVersionId');
        var creditLifeRequired = 'N';
        var cardProdSubProdGroupId = '';
        var creditLimitApproved = '';
        var creditLimitSelected = component.get('v.approvedCreditLimit');
        var noticeDelivery = component.get('v.noticeDeliveryValue');
        var annualCreditLimitIncreases = component.get('v.annualIncreasesValue');
        if (!component.get('v.isReferred')) {
            productInfoResult = JSON.parse(component.get('v.scoringResult'));
            applicationNumber = productInfoResult.applyResponse.z_return.application.applicationNumber;
            cardProdSubProdGroupId = productInfoResult.applyResponse.z_return.application.productInformation[0].cardProdSubProdGroupId;
            creditLimitApproved = productInfoResult.applyResponse.z_return.application.creditLimitApproved;
        } else {
            productInfoResult = JSON.parse(component.get('v.applicationInfoResponse'));
            applicationNumber = productInfoResult.getApplicationInformationResponse.z_return.application.applicationNumber;
            cardProdSubProdGroupId = productInfoResult.getApplicationInformationResponse.z_return.application.productInformation.cardProdSubProdGroupId;
            creditLimitApproved = productInfoResult.getApplicationInformationResponse.z_return.application.creditLimitApproved;
        }
        if (creditLifeComponent.get('v.creditLifeSelected')) {
            creditLifeRequired = 'Y';
        }
        return new Promise(function(resolve, reject) {
            let action = component.get('c.callCompleteOne');
            action.setParams({
                'applicationId': applicationId,
                'applicationNumber': applicationNumber,
                'lockVersionId': lockVersionId,
                'creditLifeRequired': creditLifeRequired,
                'cardProdSubProdGroupId': cardProdSubProdGroupId,
                'creditLimitApproved': creditLimitApproved,
                'creditLimitSelected': creditLimitSelected,
                'noticeDelivery': noticeDelivery,
                'annualCreditLimitIncreases': annualCreditLimitIncreases
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.completeOneResult', response.getReturnValue());
                    var completeOneResult = JSON.parse(response.getReturnValue());
                    if (completeOneResult.statusCode == 200) {
                       if ((completeOneResult.applyResponse.z_return.responseCommons != null) &&
                            (completeOneResult.applyResponse.z_return.responseCommons.responseMessages != null) &&
                            (completeOneResult.applyResponse.z_return.responseCommons.responseMessages.length > 0)) {
                            var resultError = '';
                            for (var i = 0; i < completeOneResult.applyResponse.z_return.responseCommons.responseMessages.length; i++) {
                                console.log(completeOneResult.applyResponse.z_return.responseCommons.responseMessages[i].message);
                                resultError = resultError + completeOneResult.applyResponse.z_return.responseCommons.responseMessages[i].message + '\r\n';
                                resultError = resultError.replace('&lt;', '<');
                                resultError = resultError.replace('&gt;', '>');
                            }
    						reject(resultError);
                        } else {
                            lockVersionId = completeOneResult.applyResponse.z_return.application.lockVersionId;
                            component.set('v.lockVersionId', lockVersionId);
							resolve(completeOneResult);
                        }
                    } else {
                        reject(completeOneResult);
                    }
                } else {
                   reject(response.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        })
    }
})