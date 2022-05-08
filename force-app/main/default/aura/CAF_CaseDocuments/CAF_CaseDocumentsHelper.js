({
    generateDocsForCaseHelper: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.errorMessage", null);
        var action = component.get("c.getDocumentsForCase");

        action.setParams({
            caseId: component.get("v.recordId")
            // "caseId" : '0d7b9d05-a783-4c2d-b7fc-36f2396dd040'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!",
                    type: "success",
                    message: "Documents Generated Successfully"
                });
                toastEvent.fire();
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in generateDocsForCaseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in generateDocsForCaseHelper method. State: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }
});