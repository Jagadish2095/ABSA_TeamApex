({
    init: function(component, event, helper) {
        component.set(' v.annualIncreasesOptions', helper.getAnnualIncreasesOptions());
        component.set(' v.noticeDeliveryOptions', helper.getNoticeDeliveryOptions());
        helper.getProductValues(component);
        if (component.get('v.wkAcctProd') != '') {
            helper.getValues(component);
        }
    },

    updateLimit: function(component, event, helper) {
        if ((parseInt(component.get('v.updateCreditLimit')) <= parseInt(component.get('v.maximumCreditLimit'))) && (parseInt(component.get('v.updateCreditLimit')) >= parseInt(component.get('v.minimumCreditLimit')))) {
            component.set("v.updatingLimit", true);
            var promise = helper.executeReCalculate(component, helper)
            .then(
                $A.getCallback(function(result) {
                    component.set('v.creditLimitApproved', result.CAS096O.can096oOutPutArea.wkTotalCredit);
                    component.set('v.creditLimitInterestRate', result.CAS096O.can096oOutPutArea.wkCrlIntRate);
                    component.set('v.creditLimitInstalAmount', result.CAS096O.can096oOutPutArea.wkCrlInstal);
                    component.set('v.monthlyAccountFee', result.CAS096O.can096oOutPutArea.wkAccountFee);
                    component.set('v.monthlyFacilityFee', result.CAS096O.can096oOutPutArea.wkMonthlyServiceFee);
                    component.set('v.initiationFee', result.CAS096O.can096oOutPutArea.wkInitFee);
                    helper.increaseCount(component);
                    component.set("v.updatingLimit", false);
                }),
                $A.getCallback(function(error) {
                    component.set("v.updatingLimit", false);
                    component.find('branchFlowFooter').set('v.heading', 'Error: executeReCalculate');
                    component.find('branchFlowFooter').set('v.message', JSON.stringify(error));
                    component.find('branchFlowFooter').set('v.showDialog', true);
                })
            )
        } else {
            var message = 'Minimum credit limit: ' + component.get('v.minimumCreditLimit') + ' Maximum credit limit: ' + component.get('v.maximumCreditLimit');
            component.find('branchFlowFooter').set('v.heading', 'Credit limit exceeded');
            component.find('branchFlowFooter').set('v.message', message);
            component.find('branchFlowFooter').set('v.showDialog', true);
        }
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        component.set('v.updating', true);
        switch(actionClicked) {
            case 'NEXT':
            case 'FINISH':
                var confirmed = helper.confirmInfo(component);
                component.set('v.updating', false);
                if (confirmed) {
                    navigate(actionClicked);
                }
                break;
            case 'BACK':
            case 'PAUSE':
                component.set('v.updating', false);
                navigate(actionClicked);
                break;
        }
    }
})