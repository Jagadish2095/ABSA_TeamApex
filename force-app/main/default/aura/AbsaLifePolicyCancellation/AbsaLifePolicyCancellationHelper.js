({
	getPolicyReasons: function (component, event, helper, reasonValueType) {
		var action = component.get("c.getReasons");
		//passing parameters
		action.setParams({
			reasonValueType: reasonValueType
		});

		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.reasonOptions", response.getReturnValue());
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getPolicyReasons unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getPolicyData: function (component, event, helper) {
		var action = component.get("c.fetchPolicyDetails");
		action.setParams({
			policyNumber: component.get("v.policyNumberFromFlow")
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
					var policyResults = JSON.parse(responseData);

					if (!policyResults.Clients) {
						component.set("v.errorMessage", "Clients not found for selected policy");
						this.hideSpinner(component);
						return;
					}

					if (!policyResults.Contracts) {
						component.set("v.errorMessage", "Contracts not found for selected policy");
						this.hideSpinner(component);
						return;
					}

					var contractsObj = policyResults.Contracts.V3_DC2Contract;
					var listOfComponents = contractsObj.Components.V3_DC2Component;
					var contractNextDueDate = contractsObj.DateNextDue;

					component.set("v.contractGID", contractsObj.GID);
					component.set("v.policyName", contractsObj.ContractTypeDescription);
					component.set("v.policyNumber", policyResults.RefNo);
					component.set("v.nextDebitOrderDate", $A.localizationService.formatDate(contractNextDueDate, "yyyy/MM/dd"));
					component.set("v.numberOfMembers", listOfComponents.length);
					component.set("v.policyStatus", contractsObj.StatusDescription);
					component.set("v.contractNextDueDate", contractNextDueDate);

					var policyStartDate = $A.localizationService.formatDate(contractsObj.CommenceDate, "yyyy-MM-dd");
					component.set("v.policyStartDate", policyStartDate);

					var todayDate = new Date();

					var diffTime = Math.abs(todayDate - new Date(policyStartDate));
					var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

					if (diffDays <= 30) {
						//var timezone = $A.get("$Locale.timezone");
						/*$A.localizationService.getToday(timezone, function (today) {
							component.set("v.cancellationRMovementDate", today);
						});*/
						//var cancelDate = new Date(policyStartDate);
						component.set("v.cancellationRMovementDate", policyStartDate);
						component.set("v.contractWithin30Days", true);
						component.set("v.reasonLabel", "Cancellation reason");
						component.set("v.dateLabel", "Effective cancellation date");
						this.getPolicyReasons(component, event, helper, "Cancel Reason");
						//parameter cancellation reason
					} else {
						component.set("v.reasonLabel", "Lapsed reason");
						component.set("v.dateLabel", "Movement date");
						component.set("v.cancellationRMovementDate", contractNextDueDate);
						this.getPolicyReasons(component, event, helper, "Lapse Reason");
						//lapse if false condition. parameter lapse reason
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getPolicyData error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getPolicyData unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	cancelRLapsePolicyHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action;
		var contractID = component.get("v.contractGID");
		var cancellationRMovementDate = component.get("v.cancellationRMovementDate");
		var cancellationRLapseReason = component.get("v.cancellationRLapseReason");
		var contractNextDueDate = component.get("v.contractNextDueDate");
		var reasonNote = component.get("v.reasonNote");

		if (component.get("v.contractWithin30Days")) {
			action = component.get("c.contractCancelPolicy");
			action.setParams({
				contractGid: contractID,
				cancelRequestDate: cancellationRMovementDate.replace(/-/g, ""),
				decisionReason: cancellationRLapseReason,
				decisionNote: reasonNote
			});
		} else {
			action = component.get("c.contractLapsePolicy");
			action.setParams({
				contractGid: contractID,
				movementDate: contractNextDueDate,
				reasonDesc: cancellationRLapseReason,
				note: reasonNote
			});
		}

		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					this.fireToastEvent("Error", "Failed to submit policy cancellation/lapse request.", "error");
					component.set("v.errorMessage", responseData);
					component.set("v.confirmCancelPolicy", false);
				} else {
					this.fireToastEvent("Success!", "The requested policy cancellation/lapse has been submitted successfully.", "Success");
					component.set("v.confirmCancelPolicy", false);
					component.set("v.errorMessage", "");
					component.find("btnSubmit").set("v.disabled", false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "cancel/lapse Policy error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "cancel/lapse Policy unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	validateRequiredInputs: function (component, event, helper) {
		var cancellationRLapseReason = component.get("v.cancellationRLapseReason");
		var cancellationRMovementDate = component.get("v.cancellationRMovementDate");
		var currentDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");

		if (!cancellationRMovementDate || cancellationRMovementDate < currentDate) {
			helper.hideSpinner(component);
			helper.fireToastEvent("Validation Warning", "Please provide valid effective cancellation date", "warning");
			return;
		}

		if (!cancellationRLapseReason) {
			helper.hideSpinner(component);
			helper.fireToastEvent("Validation Warning", "Please provide valid reason", "warning");
			return;
		}
		if (component.get("v.reasonLabel") === "Cancellation reason") {
			component.set("v.confirmCancelPolicy", true);
		} else {
			helper.cancelRLapsePolicyHelper(component, event, helper);
		}
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	fireToastEvent: function (title, msg, type, mode) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
			mode: mode
		});
		toastEvent.fire();
	}
});