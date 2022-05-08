({
	rewardDebitedFromOptions: [
		{ label: "Cheque account", value: "Cheque" },
		{ label: "Credit Card account", value: "Credit Card" }
	],
	rewardDebitedFromOptionsChequeOnly: [{ label: "Cheque account", value: "Cheque" }],
	rewardDateDebitedOptions: [
		{ label: "01", value: "01" },
		{ label: "02", value: "02" },
		{ label: "03", value: "03" },
		{ label: "04", value: "04" },
		{ label: "05", value: "05" },
		{ label: "06", value: "06" },
		{ label: "07", value: "07" },
		{ label: "08", value: "08" },
		{ label: "09", value: "09" },
		{ label: "10", value: "10" },
		{ label: "11", value: "11" },
		{ label: "12", value: "12" },
		{ label: "13", value: "13" },
		{ label: "14", value: "14" },
		{ label: "15", value: "15" },
		{ label: "16", value: "16" },
		{ label: "17", value: "17" },
		{ label: "18", value: "18" },
		{ label: "19", value: "19" },
		{ label: "20", value: "20" },
		{ label: "21", value: "21" },
		{ label: "22", value: "22" },
		{ label: "23", value: "23" },
		{ label: "24", value: "24" },
		{ label: "25", value: "25" },
		{ label: "26", value: "26" },
		{ label: "27", value: "27" },
		{ label: "28", value: "28" },
		{ label: "29", value: "29" },
		{ label: "30", value: "30" },
		{ label: "31", value: "31" }
	],
	fetchMonthtlyFee: function (component) {
		var self = this;
		var action = component.get("c.getRewardsMonthlyFee");

		action.setCallback(component, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var monthlyFeeResult = response.getReturnValue();
				component.set("v.monthlyRewardFee", monthlyFeeResult);
			} else if (state == "ERROR") {
				component.set("v.showSpinner", false);
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.ServiceResponse", "Something went wrong getting Absa Rewards monthly fee. \n" + errors[0].message);
					}
				} else {
					component.set("v.ServiceResponse", "Something went wrong getting Absa Rewards monthly fee.");
				}
				component.set("v.ShowServiceResponse", true);
				self.showResponseInRed(component, true);
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getRewardDebitedFromOptions: function (component) {
		var CCApplicationNumber = component.get("v.CCApplicationNumber");
		if (CCApplicationNumber != null) {
			return this.rewardDebitedFromOptions;
		} else {
			return this.rewardDebitedFromOptionsChequeOnly;
		}
	},
	getRewardDateDebitedOptions: function (component) {
		return this.rewardDateDebitedOptions;
	},
	checkReward: function (component) {
		var returnValue = true;
		this.removeValidation(component, "RewardDebitedFrom");
		this.removeValidation(component, "RewardDateDebited");
		this.removeValidation(component, "RewardTsAndCsDiv");
		if (component.get(" v.rewardSelected")) {
			var rewardDebitedFromValue = component.get(" v.rewardDebitedFromValue");
			var rewardDateDebitedValue = component.get(" v.rewardDateDebitedValue");
			var rewardTsAndCsChecked = component.get(" v.rewardTsAndCsChecked");
			if ($A.util.isUndefinedOrNull(rewardDebitedFromValue)) {
				this.addValidation(component, "RewardDebitedFrom", "Please select an option.");
				returnValue = false;
			}
			if ($A.util.isUndefinedOrNull(rewardDateDebitedValue)) {
				this.addValidation(component, "RewardDateDebited", "Please select a value.");
				returnValue = false;
			}
			if (!rewardTsAndCsChecked) {
				this.addValidation(component, "RewardTsAndCsDiv", "Please accept terms and conditions.");
				returnValue = false;
			}
		}
		return returnValue;
	},
	addValidation: function (component, componentAuraId, errorMsg) {
		var styleClass = "slds-form-element__help validationCss";
		var errorComponent = component.find(componentAuraId);
		$A.util.addClass(errorComponent, "slds-has-error");
		var globalId = component.getGlobalId();
		var elementId = globalId + "_" + componentAuraId;
		var validationElementId = elementId + "_Error";
		var errorElement = document.getElementById(elementId);
		var validationElement = document.createElement("div");
		validationElement.setAttribute("id", validationElementId);
		validationElement.setAttribute("class", styleClass);
		validationElement.textContent = errorMsg;
		errorElement.appendChild(validationElement);
	},
	removeValidation: function (component, componentAuraId) {
		var globalId = component.getGlobalId();
		var validationElementId = globalId + "_" + componentAuraId + "_Error";

		var errorComponent = component.find(componentAuraId);
		$A.util.removeClass(errorComponent, "slds-has-error");

		if (document.getElementById(validationElementId)) {
			var errorElement = document.getElementById(validationElementId);
			errorElement.parentNode.removeChild(errorElement);
		}
	},
	executeApply: function (component) {
		component.set("v.showSpinner", true);
		component.set("v.isDisabled", true);
		component.set("v.isLoading", true);
		var self = this;
		var compEvent = component.getEvent("vasFulfilmentEvent");
		let action = component.get("c.ApplyReward");
		var oppId = component.get("v.opportunityId");
		var recordId = component.get("v.recordId");
		var CCApplicationNumber = component.get("v.CCApplicationNumber");
		var rewardDebitedFromValue = component.get("v.rewardDebitedFromValue");
		var rewardDateDebitedValue = component.get("v.rewardDateDebitedValue");
		var monthlyRewardsFeeValue = component.get("v.monthlyRewardFee");

		var vro = {
			oppId: oppId,
			accountID: recordId,
			CCApplicationNumber: CCApplicationNumber,
			rewardDebitedFromValue: rewardDebitedFromValue,
			rewardDateDebitedValue: rewardDateDebitedValue,
			monthlyRewardsFeeValue: monthlyRewardsFeeValue
		};

		action.setParams({
			vro: JSON.stringify(vro)
		});
		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (state === "SUCCESS") {
				var rewardResponse = JSON.parse(response.getReturnValue());

				if (rewardResponse.statusCode == 200) {
					var registrationResult = rewardResponse.NewMemberRegistrationResponse.NewMemberRegistrationResult;
					var membershipNumber = registrationResult.MembershipNumber;
					if (membershipNumber == null && registrationResult.MethodResponse.ErrorCode == "E0007") {
						membershipNumber = registrationResult.MethodResponse.DetailedError;
						//Inform parent component
						compEvent.setParams({
							rewardsInd: "N"
						});
						compEvent.fire();
						component.set("v.rewardIconName", "utility:clear");
						self.showResponseInRed(component, true);
						component.set("v.isLoading", false);
					} else {
						//Inform parent component
						compEvent.setParams({
							rewardsInd: "Y"
						});
						compEvent.fire();
						component.set("v.rewardIconName", "utility:success");
						self.showResponseInRed(component, false);
						membershipNumber = "Customer successfully registered for Rewards";
					}
					component.set("v.ShowServiceResponse", true);
					component.set("v.ServiceResponse", membershipNumber);
				} else if (rewardResponse.statusCode == 500) {
					component.set("v.ShowServiceResponse", true);
					component.set("v.ServiceResponse", "ErrorStatus: " + rewardResponse.status + "\n See Console for full response");
					console.log(" ErrorMessage: " + rewardResponse.message);
					component.set("v.rewardIconName", "utility:clear");
					self.showResponseInRed(component, true);
					component.set("v.isLoading", false);
				} else {
					var methodResponse = rewardResponse.NewMemberRegistrationResponse.NewMemberRegistrationResult.MethodResponse;
					var errorCode = methodResponse.ErrorCode;
					var errorMessage = methodResponse.ErrorMessage;
					component.set("v.ShowServiceResponse", true);
					component.set("v.ServiceResponse", "ErrorCode: " + errorCode + " ErrorMessage: " + errorMessage);
					component.set("v.rewardIconName", "utility:clear");
					self.showResponseInRed(component, true);
					component.set("v.isLoading", false);
				}
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}
				component.set("v.ShowServiceResponse", true);
				component.set("v.ServiceResponse", "ErrorCode: " + message);
				component.set("v.rewardIconName", "utility:clear");
				self.showResponseInRed(component, true);
				component.set("v.isLoading", false);
			}
		});
		$A.enqueueAction(action);
	},
	executeDummy: function (component) {
		return new Promise(function (resolve, reject) {
			resolve("Reward not selected.");
		});
	},
	showResponseInRed: function (component, showAsRed) {
		var responseText = component.find("responseText");
		if (showAsRed) {
			$A.util.addClass(responseText, "error-color");
			$A.util.removeClass(responseText, "success-color");
		} else {
			$A.util.addClass(responseText, "success-color");
			$A.util.removeClass(responseText, "error-color");
		}
	}
});