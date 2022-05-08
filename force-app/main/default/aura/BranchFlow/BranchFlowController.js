({
	init: function (component, event, helper) {
		var flow = component.find("flowData");
		var flowId = component.get("v.flowId");
		if ($A.util.isUndefinedOrNull(flowId) || flowId == "") {
			var flowName = component.get("v.flowName");
			if ($A.util.isUndefinedOrNull(flowName)) {
				var selectedProcess = component.get("v.selectedProcess");
				flowName = selectedProcess.flow;
			}
			if (flowName == "BranchChequeStandAlone") {
				helper.setChequeStandAloneVariables(component,helper);
			} else {
				helper.setFlowVariables(component, helper);
			}
			flow.startFlow(flowName, component.get("v.inputVariables"));
		} else {
			component.set("v.flowResume", true);
			flow.resumeFlow(flowId);
		}
	},

	handleStatusChange: function (component, event, helper) {
		var branchFlowEvent = component.getEvent("branchFlowEvent");
		var flowTitle = event.getParam("flowTitle");
		var flowStatus = event.getParam("status");
		var referralSelection = "";
		var flowName = "";
		var opportunityId = "";
		var applicationId = "";
		var customerContractData = "";
		var customerVerificationData = "";
		var documentScanningData = "";
		var outputVariables = event.getParam("outputVariables");
		if (flowStatus == "WAITING") {
			for (var key in outputVariables) {
				var outputVar = outputVariables[key];
				if (outputVar.name == "referralSelection") {
					referralSelection = outputVar.value;
				}
				if (outputVar.name == "opportunityId") {
					opportunityId = outputVar.value;
				}
				if (outputVar.name == "applicationId") {
					applicationId = outputVar.value;
				}
				if (outputVar.name == "CustomerVerificationData") {
					customerVerificationData = outputVar.value;
				}
				if (outputVar.name == "DocumentScanningData") {
					documentScanningData = outputVar.value;
				}
			}
			// Credit Card Referral Process
			if (referralSelection != "") {
				if (referralSelection == "PauseContinue") {
					flowName = "BranchChequeStandAlone";
				}
				branchFlowEvent.setParams({
					flowStatus: flowStatus,
					referralSelection: referralSelection,
					flowName: flowName,
					opportunityId: opportunityId,
					applicationId: applicationId,
					customerContractData: customerContractData,
					customerVerificationData: customerVerificationData,
					documentScanningData: documentScanningData
				});
				branchFlowEvent.fire();
			} else {
				component.set("v.doneWithFlow", true);
			}
		} else if (flowStatus == "FINISHED") {
			for (var key in outputVariables) {
				var outputVar = outputVariables[key];
				if (outputVar.name == "caseId") {
					component.set("v.caseId", outputVar.value);
				}
			}
			component.set("v.doneWithFlow", true);
		}
	}
});