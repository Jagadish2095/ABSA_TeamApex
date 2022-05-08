({
	setFlowVariables: function (component, helper) {
		var selectedProcess = component.get("v.selectedProcess");
		if(selectedProcess){
		helper.setDefaultVariables(component);
		var processType = selectedProcess.ProcessType;
		switch (processType) {
			case "Sales":
				helper.setSalesVariables(component);
				break;
			case "Enquiry":
			case "maintenance":
				helper.setMaintenanceVariables(component);
				break;
			case "CustomerMaintenance":
				helper.setCustomerMaintenance(component, selectedProcess);
				break;
			default:
				helper.setSalesVariables(component);
		}
	}else{
		var recordId = component.get('v.recordId');
		var inputVariables = [{
								  name : 'recordId',
								  type : 'String',
								  value : recordId
								}];
		component.set("v.inputVariables", inputVariables);
	}
},

	setDefaultVariables: function (component) {
		var recordId = component.get("v.recordId");
		var customerVerificationData = component.get("v.customerVerificationData");
		var inputVariables = [];
		inputVariables = [
			{
				name: "recordId",
				type: "String",
				value: recordId
			},
			{
				name: "CustomerVerificationData",
				type: "String",
				value: customerVerificationData
			}
		];
		component.set("v.inputVariables", inputVariables);
	},

	setSalesVariables: function (component) {
		var applicationId = component.get("v.applicationId");
		var opportunityId = component.get("v.opportunityId");
		var inputVariables = component.get("v.inputVariables");
		inputVariables.push({
			name: "opportunityId",
			type: "String",
			value: opportunityId
		});

		inputVariables.push({
			name: "applicationId",
			type: "String",
			value: applicationId
		});
		component.set("v.inputVariables", inputVariables);
	},

	setMaintenanceVariables: function (component) {
		var inputVariables = component.get("v.inputVariables");
		var productAccountNumber = component.get("v.productAccountNumber");
		var caseId = component.get("v.caseId");
		inputVariables.push({
			name: "productAccountNumber",
			type: "String",
			value: productAccountNumber
		});
		inputVariables.push({
			name: "caseId",
			type: "String",
			value: caseId
		});
		component.set("v.inputVariables", inputVariables);
	},

	setCustomerMaintenance: function (component, selectedProcess) {
		var inputVariables = component.get("v.inputVariables");
		inputVariables.push({
			name: "caseId",
			type: "String",
			value: selectedProcess.caseId
		});
		inputVariables.push({
			name: "ChangeCategory",
			type: "String",
			value: selectedProcess.onboardingMode
		});
		component.set("v.inputVariables", inputVariables);
	},

	setChequeStandAloneVariables: function (component, helper) {
		helper.setDefaultVariables(component);
		var inputVariables = component.get("v.inputVariables");
		var opportunityId = component.get("v.opportunityId");
		var applicationId = component.get("v.applicationId");
		var documentScanningData = component.get("v.documentScanningData");
		var customerContractData = "";
		inputVariables.push({
			name: "opportunityId",
			type: "String",
			value: opportunityId
		});
		inputVariables.push({
			name: "applicationId",
			type: "String",
			value: applicationId
		});
		inputVariables.push({
			name: "CustomerContractData",
			type: "String",
			value: customerContractData
		});
		inputVariables.push({
			name: "DocumentScanningData",
			type: "String",
			value: documentScanningData
		});
		component.set("v.inputVariables", inputVariables);
	}
});