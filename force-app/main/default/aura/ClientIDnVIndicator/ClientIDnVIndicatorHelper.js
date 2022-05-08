({
    //check if the current user is linked to IDnV Service groups
	checkIDnVPollingUser: function (component) {
		var action = component.get("c.checkIDnVPollingUserServiceGroups");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseVal = response.getReturnValue();
				if (responseVal) {
					this.reinitializeChildPolling(component);
				}
				component.set("v.doAutoRefresh", responseVal);
                component.set("v.pollingUser", responseVal);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "checkIDnVUser Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "checkIDnVUser Error State: " + state);
			}
		});
		$A.enqueueAction(action);
	},

    // ClientIDnVPolling component stops polling when there is no active call.
	// So the child is reinitialized to continue polling.
	reinitializeChildPolling: function (component) {
		var intervalPollingTime = 5000;
		//execute callApexIDnVPollingMethod again after 5 second intervals
		var intervalId = window.setInterval(
			$A.getCallback(function () {
				var cmpValid = component.isValid();
				if (cmpValid == true) {
					var cifCode = component.get("v.cifCode");
					var authenticated = component.get("v.authenticated");
					if (cifCode && !authenticated) {
						component.set("v.reinitializeChild", true);
					}
				}
			}),
			intervalPollingTime
		);
		component.set("v.intervalId", intervalId);
	},

	//Check ID & V Status
	checkIDnVStatus: function (component) {
		var cacheObject = component.get("v.clientIDnVObjectParent");
        console.log("**cacheObject***", cacheObject);
        if(cacheObject){
            if (cacheObject.identified == true && cacheObject.verified == true && cacheObject.matched == true) {
                component.set("v.authenticated", true);
                var authTypes = cacheObject.authenticationType;
                component.set("v.authTypes", authTypes.join(", "));
            } else {
                component.set("v.authenticated", false);
                if(cacheObject.methodLastUsed){
                    component.set("v.methodLastUsed", " " + cacheObject.methodLastUsed);
                }
                if (cacheObject.identified == false) {
                    component.set("v.unauthenticatedReason", " - Not Identified");
                } else if (cacheObject.matched == false) {
                    component.set("v.unauthenticatedReason", " - CIF Mismatch");
                    component.set("v.methodLastUsed", "");
                } else if (cacheObject.verified == false) {
                    component.set("v.unauthenticatedReason", " - Not Verified");
                } else {
                    component.set("v.unauthenticatedReason", "");
                }
            }
        }else{
            component.set("v.unauthenticatedReason", " - No Active Connections");
            component.set("v.methodLastUsed", "");
        }
	}
});