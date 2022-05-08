({
	setNextCmp: function (component, event, helper) {
		var listOfCalls = component.get("v.listOfCalls");
		var currentTask = component.get("v.currentCall");
		for (var i = 0; i < listOfCalls.length; i++) {
			if (currentTask == listOfCalls[i]) {
				currentTask = listOfCalls[i + 1];
				component.set("v.currentCall", currentTask);
				break;
			}
		}
		if (currentTask == "") {
			currentTask = listOfCalls[0];
			component.set("v.currentCall", currentTask);
		}
		this.handleCurrentTask(component,currentTask);
	},

	handleCurrentTask: function (component,currentTask) {
		component.set("v.isNextDisabled", true);
		component.set("v.isPausedDisabled", true);
		if (currentTask == "allCallsCompleted") {
			var navigate = component.get("v.navigateFlow");
			navigate("NEXT");
		}
		if (currentTask == "Screening") {
			component.set("v.callCasaScreening", false);
			component.set("v.callCasaScreening", true);
		}
		if (currentTask == "RiskProfiling") {
			component.set("v.callRiskProfiling", false);
			component.set("v.callRiskProfiling", true);
		}
		if (currentTask == "GenerateDocuments") {
			component.set("v.callGenerateDocuments", false);
			component.set("v.callGenerateDocuments", true);
		}
		if (currentTask == "CVS") {
			component.set("v.callCVS", false);
			component.set("v.callCVS", true);
		}
		component.set("v.isStepComplete", false);
	},
});