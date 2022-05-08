({
	init: function (component, event, helper) {
		var ListOfCalls = [];
		var isCasaScreening = component.get("v.isCasaScreeningIncluded");
		if (isCasaScreening) {
			ListOfCalls.push("Screening");
		}
		var isRiskProfiling = component.get("v.isRiskProfilingIncluded");
		if (isRiskProfiling) {
			ListOfCalls.push("RiskProfiling");
		}
		var isGenerateDocuments = component.get("v.isGenerateDocumentsIncluded");
		if (isGenerateDocuments) {
			ListOfCalls.push("GenerateDocuments");
		}
		var isCVS = component.get("v.isCVSCreateUpdateIncluded");
		if (isCVS) {
			ListOfCalls.push("CVS");
		}
		ListOfCalls.push("allCallsCompleted");
		component.set("v.listOfCalls", ListOfCalls);
		helper.setNextCmp(component, event, helper);
	},

	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		component.set("v.updating", true);
		component.set("v.actionClicked", actionClicked);
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				component.set("v.hasProcessStopped", false);
				helper.handleCurrentTask(component, component.get("v.currentCall"));
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	},

	nextCmp: function (component, event, helper) {
		if (component.get("v.isStepComplete")) {
			helper.setNextCmp(component, event, helper);
		}
	},

	handleProcessStop: function (component, event, helper) {
		if (component.get("v.hasProcessStopped")) {
			component.set("v.isNextDisabled", false);
			component.set("v.isPausedDisabled", false);
		}
	},

	handlePauseEnable: function (component, event, helper) {
		if (component.get("v.enablePause")) {
			component.set("v.isPausedDisabled", false);
		}
	},

	showMessageDialog: function (component, event, helper) {
		if (component.get("v.showDialog")) {
			component.set("v.showMessageDialog", true);
		}
		component.set("v.showDialog", false);
	}
});