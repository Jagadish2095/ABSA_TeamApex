({
    init: function(component, event, helper) {
        component.set("v.showSpinner", true);
        component.set('v.rewardDebitedFromOptions', helper.getRewardDebitedFromOptions(component));
        component.set('v.rewardDateDebitedOptions', helper.getRewardDateDebitedOptions());
        helper.fetchMonthtlyFee(component);
    },
    rewardButtonIcon: function (component, event) {
        if (component.get('v.rewardSelected')) {
            component.set('v.rewardSelected', false);
            component.set('v.rewardIconName', 'utility:add');
        } else {
            component.set('v.rewardSelected', true);
            component.set('v.rewardIconName', 'utility:success');
        }
    },
    rewardTsAndCsChange: function (component, event, helper) {
        var globalId = component.getGlobalId();
        var rewardTsAndCs = document.getElementById(globalId + '_RewardTsAndCs');
        component.set('v.rewardTsAndCsChecked', rewardTsAndCs.checked);
    },
    validateComponent: function (component, event, helper) {
        return helper.checkReward(component);
    },
    applyReward: function (component, event, helper) {
        if (helper.checkReward(component)) {
            if (component.get('v.rewardSelected')) {
                return helper.executeApply(component);
            } else {
                return helper.executeDummy(component);
            }
        }
    }
})