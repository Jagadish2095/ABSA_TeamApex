({
	notifyBanker: function (component, event) {
		var action = component.get("c.sendEmail");
		var caseId = component.get("v.caseRecordId");
		var email = component.find("clientEmailAddress").get("v.value");
		var name = component.get("v.name");
		var bankerAddress = component.get("v.emailAddress");

		//hasBanker check added by chandra to apply Banker not found error dated 07/01/2021
		if ((name == null || name == "") && component.get("v.hasBanker")) {
			var toast = this.getToast("Error", "Banker not found!!", "Error");
			toast.fire();
		} else if (name != null && name != "") {
			action.setParams({
				emailAddress: email,
				caseRecordId: caseId,
				name: name,
				templateName: "Notify_Banker",
				bankerEmail: bankerAddress,
				balance: "",
				accountNumber: "",
				flowplstCardNumbers: "",
				jsonResponseString: "",
				templateAttrVal: ""
			});

			action.setCallback(
				this,
				$A.getCallback(function (response) {
					var state = response.getState();

					if (state === "SUCCESS") {
					} else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								var toast = this.getToast("Error", errors[0].message, "error");
								toast.fire();
							}
						}
					}
				})
			);
			$A.enqueueAction(action);
		}
	},

	getBanker: function (component, event) {
		var accountId = component.get("v.clientAccountIdFromFlow");
		var action = component.get("c.getBankerName");
		action.setParams({
			accountId: accountId
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var responseBean = JSON.parse(response.getReturnValue());

				if (responseBean != null) {
					if (responseBean.length > 0) {
						for (var i = 0; i < responseBean.length; i++) {
							if (responseBean[i].role == "Business Banker" && responseBean[i].name != "") {
								component.set("v.name", responseBean[i].name);
								component.set("v.emailAddress", responseBean[i].email);
							}
						}
					}
					//hasBanker check added by chandra dated 07/01/2021
					else if (component.get("v.hasBanker")) {
						var toast = this.getToast("error", "Something went wrong! CIF not linked to a banker", "Error");
						toast.fire();
					}
				} else {
					var toast = this.getToast("error", "Something went wrong! Service issue", "Error");
					toast.fire();
				}
			}
		});
		$A.enqueueAction(action);
	},

	doNotSendConfirmation: function (component, event) {
		var caseId = component.get("v.caseRecordId");
		var action = component.get("c.noEmail");
		action.setParams({
			caseRecordId: caseId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				this.hideSpinner(component);
				var toast = this.getToast("Success", "Case close successfully", "Success");
				toast.fire();
				$A.get("e.force:refreshView").fire();
			} else {
				this.hideSpinner(component);
				var toast = this.getToast("Error", "Something went wrong while updating the case", "Error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	},

	closeOpenAnotherJob: function (component, event) {
		var caseId = component.get("v.caseRecordId");
		var action = component.get("c.noEmail");
		action.setParams({
			caseRecordId: caseId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				this.hideSpinner(component);
				var toast = this.getToast("Success", "Case close successfully", "Success");
				toast.fire();
				$A.get("e.force:refreshView").fire();
			} else {
				this.hideSpinner(component);
				var toast = this.getToast("Error", "Something went wrong while updating the case", "Error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	},

	sendCustomerEmail: function (component) {
		var action = component.get("c.sendEmail");

		var caseId = component.get("v.caseRecordId");
		var email = component.find("clientEmailAddress").get("v.value");
		var name = component.get("v.name");
		var templateName = component.get("v.templateName");
		var bankerAddress = component.get("v.bankerEmailAddress");
		var balance = component.get("v.accBalanceFromFlow");
		var accountNumber = component.get("v.accNumberFromFlow");
		var flowplstCardNumbers = component.get("v.flowplstCardNumbers");
		//Added by chandra dated 29/01/2021
		var responseStringFromFlow = component.get("v.responseStringFromFlow");
		var idRegistrationNumber;
        //Added by Nagpalsing dated 09/07/2021
        var taxPeriod = component.get("v.taxPeriod");
        var replaceBodyMap;
		if (component.get("v.emailBodyMappingFromFlow")) {
			replaceBodyMap = JSON.parse(component.get("v.emailBodyMappingFromFlow"));
		}

		if (component.get("v.caseRecord.Account.ID_Number__pc") != null) {
			idRegistrationNumber = component.get("v.caseRecord.Account.ID_Number__pc");
		} else {
			idRegistrationNumber = component.get("v.caseRecord.Account.Registration_Number__c");
		}

		action.setParams({
			emailAddress: email,
			caseRecordId: caseId,
			name: "",
			templateName: templateName,
			bankerEmail: "",
			balance: balance != "" ? balance : "",
			accountNumber: accountNumber != "" ? accountNumber : "",
			flowplstCardNumbers: flowplstCardNumbers,
			jsonResponseString: responseStringFromFlow != "" ? responseStringFromFlow : "",
			templateAttrVal: idRegistrationNumber != null ? idRegistrationNumber : "",
			emailBodyMapping: replaceBodyMap,
            taxPeriod : taxPeriod
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					this.hideSpinner(component);
					var result = response.getReturnValue();

					if (result === "success") {
						var toast = this.getToast("Success", "Email sent successfully", "success");
					} else {
						var toast = this.getToast("Error", result, "error");
					}

					this.hideSpinner(component);

					toast.fire();

					$A.get("e.force:refreshView").fire();
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
							$A.get("e.force:refreshView").fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	sendCustomerSMS: function (component) {
		var messageText = component.get("v.smsMessageText");
		var integrationService = component.get("v.smsIntegrationAccount");

		if (messageText && integrationService) {
			var caseId = component.get("v.caseRecordId");
			var phoneNumber = component.find("mobile").get("v.value");

			var action = component.get("c.notifyClientBySMS");

			action.setParams({
				caseId: caseId,
				phoneNumber: phoneNumber,
				messageText: messageText,
				serviceAccount: integrationService
			});

			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var toast;
					var responseVal = response.getReturnValue();
					if (responseVal.startsWith("Error: ")) {
						component.set("v.errorMessage", responseVal);
						toast = this.getToast("Error", "Failed to send sms", "Error");
					} else {
						toast = this.getToast("Success", "SMS successfully sent", "Success");
					}
					toast.fire();
					$A.get("e.force:refreshView").fire();
				} else if (state === "ERROR") {
					var errors = response.getError();
					component.set("v.errorMessage", "notifyClientBySMS Error: " + JSON.stringify(errors));
				} else {
					component.set("v.errorMessage", "Error State: " + state);
				}
				this.hideSpinner(component);
			});
			$A.enqueueAction(action);
		} else {
			component.set("v.errorMessage", "SMS Message and/or SMS Integration Service Account not provided, SMS not sent");
			this.hideSpinner(component);
		}
	},

	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},

	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		return toastEvent;
	}
});