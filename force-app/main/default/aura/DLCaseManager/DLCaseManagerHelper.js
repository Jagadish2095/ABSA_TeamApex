({
	getDataHelper: function (component, event, helper) {
		var action = component.get("c.getData");
		action.setParams({ serviceType: component.find("typeField").get("v.value"), caseId: component.get("v.caseIdFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (!$A.util.isEmpty(resp)) {
					//Success
					if (!$A.util.isEmpty(resp["voucherList"])) {
						component.set("v.data", JSON.parse(resp["voucherList"]));
					}
					if (!$A.util.isEmpty(resp["commentList"])) {
						component.set("v.existingCommentsList", JSON.parse(resp["commentList"]));
					}
					if (!$A.util.isEmpty(resp["picklistOptions"])) {
						component.set("v.dependentPicklistJSON", resp["picklistOptions"]);
					}
					helper.hideSpinner(component);
				} else {
					helper.displayError(
						component,
						helper,
						"retrieve Dependent Picklist Options.",
						"DLCaseManagerController.getPicklistOptions, Response was empty: " + JSON.stringify(resp)
					);
				}
			} else if (state === "ERROR") {
				helper.displayError(
					component,
					helper,
					"retrieve Dependent Picklist Options.",
					"DLCaseManagerController.getPicklistOptions: " + JSON.stringify(response.getError())
				);
			} else {
				helper.displayError(
					component,
					helper,
					"retrieve Dependent Picklist Options.",
					"DLCaseManagerController.getPicklistOptions, state returned: " + state
				);
			}
		});
		$A.enqueueAction(action);
	},

	transferCase: function (component, event, helper) {
		var action = component.get("c.transferCase");
		action.setParams({
			serviceGroupName: $A.get("$Label.c.Digital_Lifestyle_Rewards_Team_Call_Centre"),
			serviceTypeName: component.find("typeField").get("v.value"),
			caseId: component.get("v.caseIdFromFlow")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.fireToast("Success!", "Case Escalated to Rewards Team Call Centre queue. ", "success");
				var caseServiceType = component.find("typeField").get("v.value");
				if (caseServiceType == "Timeout Errors/Voucher not received" || caseServiceType == "Voucher Redemption") {
					//Send Email to Stellr
					helper.sendEmailHelper(component, event, helper);
				} else {
					component.set("v.isFormReadOnly", true);
					helper.hideSpinner(component);
				}
			} else if (state === "ERROR") {
				helper.displayError(component, helper, "Transfer this Case.", "DLCaseManagerController.transferCase: " + +JSON.stringify(response.getError()));
			} else {
				helper.displayError(component, helper, "Transfer this Case.", "DLCaseManagerController.transferCase, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	sendEmailHelper: function (component, event, helper) {
		var action = component.get("c.sendEmail");
		action.setParams({
			caseId: component.get("v.caseIdFromFlow"),
			emailAddress: component.get("v.escalationEmailAddressFromFlow"),
			emailTemplateName: $A.get("$Label.c.DL_Escalate_to_Stellr_Email_Template"),
			voucherListString: JSON.stringify(component.get("v.data")),
			caseCommentsString: JSON.stringify(component.get("v.existingCommentsList"))
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.includes("Error")) {
					helper.displayError(component, helper, "Send an Email to Stellr.", "DLCaseManagerController.sendEmail: " + resp);
				} else {
					//Success
					component.set("v.isFormReadOnly", true);
					helper.hideSpinner(component);
					helper.fireToast("Success!", resp + " to Stellr", "success");
				}
			} else if (state === "ERROR") {
				helper.displayError(component, helper, "Send an Email to Stellr.", "DLCaseManagerController.sendEmail: " + JSON.stringify(response.getError()));
			} else {
				helper.displayError(component, helper, "Send an Email to Stellr.", "DLCaseManagerController.sendEmail, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//Create and set Select Options
	createOptions: function (component, valueList, attributeName) {
		var noneOption = { class: "optionClass", label: "--None--", value: null };
		var otherOption = { class: "optionClass", label: "Other", value: "Other" };
		var opts = [];
		opts.push(noneOption);
		if (valueList != null) {
			for (var i = 0; i < valueList.length; i++) {
				opts.push({ class: "optionClass", label: valueList[i], value: valueList[i] });
			}
			opts.push(otherOption);
			component.set(attributeName, opts);
		}
	},

	//Toast, Display & Log Error Message
	displayError: function (component, helper, simpleMsg, complexMsg) {
		helper.hideSpinner(component);
		component.set("v.isFormReadOnly", false);
		helper.fireToast("Error!", "An error occurred while trying to " + simpleMsg, "error");
		component.set("v.errorMessage", "Unexpected error occurred " + complexMsg);
		console.log("Unexpected error occurred " + complexMsg);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});