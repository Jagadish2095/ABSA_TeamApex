({
	sendAVAFCopyNatisHelper: function (component, event, helper) {
		let button = event.getSource();
		button.set("v.disabled", true);
		component.set("v.showSpinner", true);
		var action = component.get("c.sendCopyNatisLetter");
		action.setParams({
			accountId: component.get("v.caseAccountId"),
			accountNumber: parseInt(component.get("v.SelectedAccNumberFromFlow")),
			email: component.find("email").get("v.value")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var returnResponse = response.getReturnValue();
				if (returnResponse == "success") {
					helper.showToast("Success!", "success", "AVAF Copy Natis letter emailed successfully!");
					component.set("v.isCaseCloseShow", true);
					component.set("v.isSendEmail", false);
				} else {
					component.set("v.errorMessage", "Error AVAF Copy Natis letter email. Service Response: " + returnResponse);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error in sendAVAFCopyNatisHelper method. Error message: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in sendAVAFCopyNatisHelper method. State: " + state);
			}

			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	showToast: function (title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			type: type,
			message: message
		});
		toastEvent.fire();
	},

	allFieldsValid: function (component) {
		component.set("v.showSpinner", true);
		var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
		var arrayFields = [];

		for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
			var inputCmp = component.find(arrayAuraIdsToBeValidated[i]);
			if (inputCmp) {
				Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
			}
		}

		// Show error messages if required fields are blank
		var allValid = arrayFields.reduce(function (validFields, inputCmp) {
			var inputCmpValue = inputCmp.get("v.value");
			var inputCmpRequired = inputCmp.get("v.required");
			var inputCmpValid = true;

			if (inputCmpRequired && $A.util.isEmpty(inputCmpValue)) {
				inputCmpValid = false;
			}

			return validFields && inputCmpValid;
		}, true);

		component.set("v.showSpinner", false);
		return allValid;
	}
});