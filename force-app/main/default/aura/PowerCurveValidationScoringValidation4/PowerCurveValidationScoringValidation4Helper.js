({    getResponse6Data: function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.getPCO6Data");
        var oppId = component.get("v.recordId");

        action.setParams({
            "oppID": oppId,
            "stageId": '6'
        });
        action.setCallback(this, function (response) {
            this.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.record", result);
                console.log("v.record " + result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error PowerCurveValidationScoringController.getData: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, PowerCurveValidationScoringController.getData state returned: " + state);
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
})