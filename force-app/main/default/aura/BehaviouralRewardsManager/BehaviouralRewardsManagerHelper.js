({
    //JQUEV 2020/10/27
    transferCase: function (component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.transferCase");
        action.setParams({  serviceGroupName: $A.get("$Label.c.Behavioural_Rewards_Benefits_Team_Call_Centre"),
                            serviceTypeName: $A.get("$Label.c.Behavioural_Rewards"),
                            caseId: component.get("v.caseIdFromFlow") });
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

    // J QUEV 2020-11-03
    // Method to validate all fields
    // This version of the method validates lightning:inputField
    allFieldsValid: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var arrayFields = [];

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
            var inputCmp = component.find(arrayAuraIdsToBeValidated[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }

        // Show error messages if required fields are blank
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {

            var inputCmpValue = inputCmp.get("v.value");
            var inputCmpRequired = inputCmp.get("v.required");
            var inputCmpValid = true;

            if(inputCmpRequired && $A.util.isEmpty(inputCmpValue)){
                inputCmpValid = false;
            }

            return validFields && inputCmpValid;
        }, true);

        return allValid;
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