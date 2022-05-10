({
	getApplicationData: function (component, event, helper) {
		helper.showSpinner(component, event, helper);
		var action = component.get("c.getApplicationApex");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				component.set("v.applicationRecord",respObj);
					
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error VoiceCancelCreditApplicationCTRL.getApplicationApex: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			helper.hideSpinner(component, event, helper);
		});
		$A.enqueueAction(action);
	},

	cancelApplicationHelper: function (component, event, helper) {
		helper.showSpinner(component, event, helper);
		var applicationRecord = component.get("v.applicationRecord");
		if(applicationRecord.Application_Number__c || applicationRecord.General_Notes__c){
			helper.hideSpinner(component, event, helper);
			helper.getToast("Validation", "There is no Application Number or application lockVersionId on the related Application", "warning");
			component.set("v.errorMessage", "There is no Application Number or application lockVersionId on the related Application");
			return
		}
		var action = component.get("c.cancelApplication");
		var generalNotesField = applicationRecord.General_Notes__c //component.find("generalNotesField").get("v.value");
		var lockVersionId;
		const lockVersionIdString = "applicationLockVersionId:";
		if (generalNotesField.includes("applicationLockVersionId:")) {
			lockVersionId = generalNotesField.substring(
				generalNotesField.indexOf(lockVersionIdString) + lockVersionIdString.length,
				generalNotesField.lastIndexOf(";")
			);
		} else {
			helper.hideSpinner(component);
			helper.getToast("Validation", "Application lockVersionId required", "warning");
			return;
		}
		action.setParams({
			applicationNumber: component.find("applicationNumberField").get("v.value"),
			lockVersionId: lockVersionId,
			cancelReasonId: component.get("v.selectedReasonId")
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					if (respObj.cancelApplicationResponse.Responsereturn.responseCommons.success == "TRUE") {
						helper.getToast("Application Cancelled", "Application was cancelled as per customers's request", "success");
						document.getElementById("submitButton").click();
					} else {
						var errorMessage = JSON.stringify(respObj.cancelApplicationResponse.Responsereturn.responseCommons.responseMessages);
						helper.getToast("Error", "Error while cancelling Application", "error");
						component.set("v.errorMessage", errorMessage);
					}
				} else {
					//Fire Error Toast
					helper.getToast("Service Error", "Service Error while cancelling Application ", "error");
					component.set(
						"v.errorMessage",
						"VoiceCancelCreditApplicationCTRL.cancelApplication: Service Error: " +
							"statusCode: " +
							JSON.stringify(respObj.statusCode) +
							", status: " +
							JSON.stringify(respObj.status) +
							", message: " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.getToast("Apex error", "An Apex error occurred while cancelling Application ", "error");
				var errorMessage = "VoiceCancelCreditApplicationCTRL.cancelApplication: Apex error: " + JSON.stringify(errors);
				component.set("v.errorMessage", errorMessage);
			} else {
				helper.getToast("Unexpected error", "Unexpected error occurred", "error");
				component.set("v.errorMessage", "Unexpected error occurred while cancelling Application");
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});