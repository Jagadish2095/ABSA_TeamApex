({
	doInit: function (component, event, helper) {
		helper.doInit(component, event);
	},

	closeCase: function (component, event, helper) {
		if ($A.util.isEmpty(component.find("caseComments").get("v.value"))) {
			//Error required fields are missing
			helper.fireToast("Error!", "Please complete all the required fields. ", "error");
		} else {
			helper.CloseCaseHelper(component, event, helper);
			
		}
	},

	onError: function (component, event, helper) {
		helper.fireToast("Error!", "An Error occurred. ", "error");
	},

	requestApproval: function (component, event, helper) {
		helper.showSpinner(component);
		var approvedDeclinedValue = component.get("v.approvedDeclinedValue");
		component.find("reissueVoucherField").set("v.value", approvedDeclinedValue);
		component.find("statusField").set("v.value", 'Awaiting Internal');
		component.find("caseEditForm").submit();
		helper.hideSpinner(component);
		helper.fireToast("Success!", "Approval request submitted", "success");
		$A.get('e.force:refreshView').fire();
	},

	caseOnload: function (component, event, helper) {
		var approvalStatus = component.get("v.cse.Approval_Status__c");
		helper.getVoucher(component, event, helper);
		helper.setEscalatedFormView(component, event, helper);
		if (component.get("v.escalatedFromFlow")) {
			if (approvalStatus == "Approved") {
				helper.getTxnReferenceHelper(component, event);
			}
		}
	},

	handleScheduleVoucherReissue: function (component, event, helper) {
		var approvalStatus = component.get("v.cse.Approval_Status__c");
		if (approvalStatus == "Approved") {
			component.set("v.schedule", true);
			helper.getReissueTxnReference(component, event, helper);
		}
	},

	HandleCaseResolutionSelect: function (component, event, helper) {},

	handleSendVoucher: function (component, event, helper) {
		component.set("v.schedule", false);
		helper.getReissueTxnReference(component, event, helper);
	},

	handleScheduleRequest: function (component, event, helper) {
		helper.scheduleVoucherHelper(component, event, helper);
	},

	escalateCase: function (component, event, helper) {
		if ($A.util.isEmpty(component.find("caseComments").get("v.value"))) {
			helper.fireToast("Error!", "Please complete all the required fields. ", "error");
		} else {
			component.find("caseComments").set("v.value",component.find("caseComments").get("v.value"));
			component.find("caseEditForm").submit();
			helper.transferCase(component, event, helper);
		}
	}
});