({
    //JQUEV 2020/10/27
    transferCase: function (component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.transferCase");
        action.setParams({
            serviceGroupName: $A.get("$Label.c.Behavioural_Rewards_Benefits_Team_Call_Centre"),
            serviceTypeName: $A.get("$Label.c.Behavioural_Rewards"),
            caseId: component.get("v.caseIdFromFlow")
        });
        action.setCallback(this, function (response) {
            helper.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.fireToast("Success!", "Case Escalated to Outbound Consultant", "success");
                component.set("v.isFormReadOnly", true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error BehaviouralRewardsManagerController.transferCase: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred BehaviouralRewardsManagerController.transferCase, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Show Spinner
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },

    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.isSpinner", false);
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
});