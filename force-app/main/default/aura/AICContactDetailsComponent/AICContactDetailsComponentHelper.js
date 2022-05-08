({
	getAICContactDetailsHelper : function(component, event, helper) {
		var action = component.get("c.getAICContactDetails");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results= response.getReturnValue();
                component.set("v.aicContactDetailsData", results);
            }
        });
        $A.enqueueAction(action);
	}
})