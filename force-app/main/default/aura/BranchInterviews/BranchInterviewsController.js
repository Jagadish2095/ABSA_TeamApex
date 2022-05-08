({
    init : function(component, event, helper) {
        helper.checkPaused(component, event, helper);
        //Set Tab Label and Icon
        var workspaceAPI = component.find('workspace');
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: 'Product Onboarding'
            });
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: 'action:new_person_account',
                iconAlt: 'Product Onboarding'
            });
        })
    },

    handleMenuSelect: function(component, event, helper) {
        var interviewAction = event.getParam('value').split('~');
        if(interviewAction.includes('resume')) {
            helper.handleResume(component, interviewAction[0]);
        } else if(interviewAction.includes('restart')) {
            helper.handleRestart(component, interviewAction[0], interviewAction[1]);
        }
    },

    handleflowEvent: function(component, event, helper) {
        var startNewFlow = false;
        var flowStatus = event.getParam('flowStatus');
        var referralSelection = event.getParam('referralSelection');
        var flowName = event.getParam('flowName');
        var opportunityId = event.getParam('opportunityId');
        var applicationId = event.getParam('applicationId');
        var customerContractData = event.getParam('customerContractData');
        var customerVerificationData = event.getParam('customerVerificationData');
        var documentScanningData = event.getParam('documentScanningData');
        if (flowStatus == 'FINISH') {
            component.set('v.showFlow', false);
        } else {
            switch(referralSelection) {
                case 'Pause':
                    component.set('v.showFlow', false);
                    break;
                case 'PauseContinue':
                    component.set('v.showFlow', false);
                    component.set('v.flowName', flowName);
                    component.set('v.opportunityId', opportunityId);
                    component.set('v.applicationId', applicationId);
                    component.set('v.customerContractData', customerContractData);
                    component.set('v.customerVerificationData', customerVerificationData);
                    component.set('v.documentScanningData', documentScanningData);
                    startNewFlow = true;
                    break;
            }
        }
        component.set('v.startNewFlow', startNewFlow);
    },

    startNewFlow: function(component) {
        if (component.get('v.startNewFlow')) {
            component.set('v.flowId', '');
            component.set('v.flowResume', false);
            component.set('v.showFlow', true);
        }
    },

    testingStuff: function(component) {
        component.set('v.flowName', 'Test_Referral');
        component.set('v.flowId', '');
        component.set('v.flowResume', false);
        component.set('v.showFlow', true);
    }
})