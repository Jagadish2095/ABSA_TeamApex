({

    handleClick: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            url: $A.get("$Label.c.RewardEstimatorLink")
        });
        urlEvent.fire();
    },

    caseCloseController: function (component, event, helper) {
        helper.caseCurrentCaseHelper(component, event, helper);
    }
});