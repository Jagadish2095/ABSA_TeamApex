({
    caseCurrentCaseHelper: function (component, event, helper) {
        var action = component.get("c.caseClose");
        action.setParams({ caseId: component.get("v.recordId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var caseResponse = response.getReturnValue();
                if (caseResponse.isSuccess == "true") {
                    this.fireToast("Success!", "Case successfully closed!", "success");
                    $A.get("e.force:refreshView").fire();
                } else {
                    this.fireToast("Error!", caseResponse.errorMessage, "error");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                this.fireToast("Error!", "RewardsEstimatorHelper.caseCurrentCaseHelper: Apex error: [" + JSON.stringify(errors) + "]." , "error");
            }
        });

        $A.enqueueAction(action);
    },

    //Lightning toastie
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
});