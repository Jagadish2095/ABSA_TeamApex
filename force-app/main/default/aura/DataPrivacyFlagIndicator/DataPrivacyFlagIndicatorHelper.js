({
	//check if the current user is linked to IDnV Service groups
	checkIDnVPollingUser: function (component) {
		var action = component.get("c.getDataPrivacyFlagIndiatorVal");
        action.setParams({
            accountId : component.get("v.recordId")
        });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseVal = response.getReturnValue();
                component.set("v.isDataPrivacyFlagged", false);
				if (responseVal) {
					component.set("v.isDataPrivacyFlagged", true);
                    component.set("v.dataPrivacyTypes", responseVal);
                }
			} else if (state === "ERROR") {
				component.set("v.isDataPrivacyFlagged", false);
			} else {
				component.set("v.isDataPrivacyFlagged", false);
			}
		});
		$A.enqueueAction(action);
	}
});