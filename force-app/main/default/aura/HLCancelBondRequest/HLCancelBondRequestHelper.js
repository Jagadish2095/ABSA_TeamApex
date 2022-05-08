({
	updateCaseAccountNumber: function (component) {
		var action = component.get("c.updateAccountNumberField");
		//setting params
		action.setParams({
			caseId: component.get("v.caseIdFromFlow"),
			accountNumber: component.get("v.selectedAccountNumberFromFlow")
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("*Account number updated!*");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "updateCaseAccountNumber error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "updateCaseAccountNumber unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getAccountInformationCancellation: function (component) {
		var action = component.get("c.getAccountInformation");
		//setting params
		action.setParams({
			accountNumber: component.get("v.selectedAccountNumberFromFlow")
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
					component.find("fCancelReasons").set("v.disabled", true);
					component.find("btnViewTerms").set("v.disabled", true);
				} else {
					var responseObj = JSON.parse(responseData);
					component.set("v.schemaCode", responseObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_SCHM_CODE);
					component.set("v.refNumber", responseObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_REF_NUMBER);
					component.set("v.primaryAccountId", responseObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_PRIME_ACCT_ID);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getAccountInformationNotice error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getAccountInformationNotice unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	updateAccountInformationCancellation: function (component) {
		var action = component.get("c.updateAccountInformation");
		//setting params
		action.setParams({
			accountNumber: component.get("v.selectedAccountNumberFromFlow"),
			primaryAccountId: component.get("v.primaryAccountId"),
			refNumber: component.get("v.refNumber"),
			schemaCode: component.get("v.schemaCode")
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
				} else {
					this.fireToastEvent("Success", "Cancellation request has been submitted", "Success");
					component.find("btnSubmit").set("v.disabled", true);
					this.createPropertyHubCase(component);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "updateAccountInformationCancellation error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "updateAccountInformationCancellation unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	createPropertyHubCase: function (component) {
		var thisCaseId = component.get("v.caseIdFromFlow");
		var accountId = component.get("v.accountIdFromFlow");
		var cancellationReason = component.get("v.selectedCancelReason");

		var action = component.get("c.createServiceRequestCase");
		//setting params
		action.setParams({
			parentId: thisCaseId,
			accountId: accountId,
			subject: "Retentions - " + cancellationReason,
			description: "Request to Cancel Bond",
			serviceGroup: "Propertyhub",
			queueName: "Propertyhub"
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				this.fireToastEvent("Success", "New case successfully sent to the property Hub Team", "Success");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "createPropertyHubCase error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "createPropertyHubCase unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	validateFieldValues: function (component) {
		var selectedCancelReason = component.get("v.selectedCancelReason");
		//Cancellation reason must not be blank
		if (!selectedCancelReason) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide cancellation reason", "warning");
			return;
		}

		component.set("v.showConfirmSubmission", true);
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});