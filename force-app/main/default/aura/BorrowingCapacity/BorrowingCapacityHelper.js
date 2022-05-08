({
	handleInit: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationScoringRecordId");
        action.setParams({
            opportunityId: component.get("v.opportunityId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var applicationScoringId = response.getReturnValue();
                if(applicationScoringId){
                    component.set("v.applicationScoringId", applicationScoringId);
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("Error!", "Borrowing Capacity: " + errors[0].message, "error");
                    }
                } else {
                    this.showToast("Error!", "Borrowing Capacity: unknown error", "error");
                }
            }
            
        	component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }, 
    
    showToast : function(title, message, type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title" : title,
            "message" : message,
            "type" : type
        });
        toastEvent.fire();
    }
})