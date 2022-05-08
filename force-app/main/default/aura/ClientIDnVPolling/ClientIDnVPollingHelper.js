({
	//DBooysen 2021-03-05
	//function to initiate the polling and set function polling intervals
	IDnVPollingHelper: function (component, event, helper) {
		//execute callApexIDnVPollingMethod for the first time
		helper.callApexIDnVPollingMethod(component, event, helper);

		var intervalPollingTime = 5000;
		//execute callApexIDnVPollingMethod again after 5 second intervals
		var intervalId = window.setInterval(
			$A.getCallback(function () {
				var cmpValid = component.isValid();
				if (cmpValid == true) {
					helper.callApexIDnVPollingMethod(component, event, helper);
				}
			}),
			intervalPollingTime
		);
		component.set("v.intervalId", intervalId);
	},

	//DBooysen 2021-03-05
	//function that polls apex to get the clients' ID&V status from the system cache
	callApexIDnVPollingMethod: function (component, event, helper) {
		var action = component.get("c.getSessionCacheValues");
		action.setParams({
			cifCode: component.get("v.cifCodeFromParentCmp")
		});
		action.setCallback(this, function (response) {
			var responseVal = response.getReturnValue();
			component.set("v.clientIDnVObject", responseVal);
            if (!responseVal){
				var intervalIdVal = component.get("v.intervalId");
				clearInterval(intervalIdVal);
                component.set("v.clientIDnVObject", null);
			}
		});
		$A.enqueueAction(action);
	}
});