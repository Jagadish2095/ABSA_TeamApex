({
	submitForApproval : function(component, event, helper){
        var comments = component.get("v.comments");
        var action = component.get("c.submitToDisputedQA");
        action.setParams({
            "opp": component.get("v.opportunityRecord"),
            "comments" : comments
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.showSpinner", false);
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"success",
                    "title": "Success!",
                    "message": "Approval Request Submitted Succesfully"
                });
                toastEvent.fire();
            }
            else {
                var errors = response.getError();
                if (errors.length > 0) {
                    var message = errors[0].message;
                    component.set("v.recordError", "No Approval Process Found/ Approval Process is in Progress");
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})