({
	// W-019387 Hloni Matsoso 14/03/2022
	// Gets flow name according to Process Type, then executes that flow
	executeFlowByProcessTypeName : function(component, serviceType) {
		var action = component.get("c.getFlowNameByServiceType");
		console.log("serviceType : " + serviceType);

		action.setParams({
			serviceTypeName: serviceType
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log(`state: ${ state}`);
			console.log(`response: ${ response.getReturnValue()}`);

			if (state === "SUCCESS") {
				console.log(`returning : ${ response.getReturnValue()}`);
				this.executeFlow(component, response.getReturnValue());
				component.set("v.errorMessage", "");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getFlowName error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "getFlowName unexpected error occurred, state returned: " + state);
			}
		});

		$A.enqueueAction(action);
	},

	// W-019387 Hloni Matsoso 14/03/2022
	// Load flow
	executeFlow : function(component, flowName) {
		var flow = component.find("flowToBeRendered");
		var inputVariables = [{ name : "MainAccountID", type : "String", value: component.get("v.recordId")}];
		flow.startFlow(flowName,inputVariables);
	}
})