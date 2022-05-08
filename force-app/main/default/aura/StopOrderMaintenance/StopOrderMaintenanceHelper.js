({
	getLoggedInUserDetails: function (component, event, helper) {
		component.set("v.isSpinner", true);
		//1. Get logged in User details
		var getUserDetailsAction = component.get("c.getLoggedInUserDetails");
		getUserDetailsAction.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();

				if (state === "SUCCESS") {
					var getUserDetailsResult = response.getReturnValue();

					component.set("v.userRecord", getUserDetailsResult);

					//2. Get Stop Order List based on Account Number
					var getBenListAction = component.get("c.getBeneficiaryList");

					getBenListAction.setParams({
						accId: component.get("v.recordId"),
						accNumber: component.get("v.accountNumber")
					});

					getBenListAction.setCallback(
						this,
						$A.getCallback(function (response) {
							var state = response.getState();

							if (state === "SUCCESS") {
								var result = response.getReturnValue();

								if (!result || result.length <= 0) {
									component.set("v.isErrorMessage", true);
									component.set(
										"v.errorMessage",
										"helper.getBeneficiaryList - no stop orders returned, please contact your administrator or try again later"
									);
								} else {
									component.set("v.mapValues", result);

									var arrayMapKeys = [];
									for (var key in result) {
										arrayMapKeys.push({ key: key, value: result[key] });
									}
									component.set("v.listValues", arrayMapKeys);
									component.set("v.isErrorMessage", false);
								}
							} else if (state === "ERROR") {
								var errors = response.getError();

								component.set("v.isErrorMessage", true);
								component.set(
									"v.errorMessage",
									"helper.getBeneficiaryList - no stop orders returned, please contact your administrator or try again later " +
										JSON.stringify(errors)
								);
							}
							component.set("v.isSpinner", false);
						})
					);

					$A.enqueueAction(getBenListAction);
				} else if (state === "ERROR") {
					var toast = helper.getToast("Error", "There was an error retrieving User details", "error");

					component.set("v.isSpinner", false);
					toast.fire();
				}
			})
		);

		$A.enqueueAction(getUserDetailsAction);
	},

	handleClickUpdate: function (component, event, helper, menuLabel, instrNo) {
		component.set("v.typeOfAction", "update");
		component.set("v.instrNo", instrNo);
		component.set("v.isEditBeneficiaryOpen", true);

		if (menuLabel === "Edit") {
			//Get beneficiary from Map
			var allBeneficiaries = component.get("v.mapValues");
			var selectedBeneficiary = allBeneficiaries[instrNo];

			if (selectedBeneficiary) {
				component.set("v.beneficiaryName", selectedBeneficiary.refName);
				component.set("v.bankName", selectedBeneficiary.targetBank);
				component.set("v.targetAccount", selectedBeneficiary.targetAccount);
				component.set("v.sourceRef", selectedBeneficiary.sourceRef);
				component.set("v.targetRef", selectedBeneficiary.targetRef);
				component.set("v.frequency", selectedBeneficiary.freq);
				component.set("v.amount", selectedBeneficiary.amount);
				component.set("v.branchCode", selectedBeneficiary.targetBranch);

				var endDate = selectedBeneficiary.PayEndDate;
				var year = endDate.substring(0, 4);
				var month = endDate.substring(4, 6);
				var day = endDate.substring(6, 8);

				var actionDate = selectedBeneficiary.actionDate;
				var actionDateYear = actionDate.substring(0, 4);
				var actionDateMonth = actionDate.substring(4, 6);
				var actionDay = actionDate.substring(6, 8);

				var formattedDate = actionDateYear + "-" + actionDateMonth + "-" + actionDay;
				var formattedEndDate = year + "-" + month + "-" + day;

				component.set("v.payEndDate", formattedEndDate);
				component.set("v.payDate", formattedDate);
			}
		}
		//Get Bank and Branch Record based on Branch Code returned from service
		var getBenListAction = component.get("c.getSelectedBranchRecordDetails");
		var bankNameVal = component.get("v.bankName");

		getBenListAction.setParams({
			branchCode: component.get("v.branchCode")
		});

		getBenListAction.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();

				if (state === "SUCCESS") {
					var result = response.getReturnValue();
					if (result != null) {
						//Set Bank Name and Branch
						component.set("v.selectedBankId", result.Bank__c);
						component.set("v.selectedBranchCodeId", result.Id);
						component.set("v.selectedBranchCodeName", result.Name);
					} else {
						//Set Bank Name and Branch
						component.set("v.selectedBankId", null);
						component.set("v.selectedBranchCodeId", null);
						component.set("v.selectedBranchCodeName", null);
					}
				} else if (state === "ERROR") {
					var toast = helper.getToast("Error", "There was an error retrieving the list of Bank Accounts", "error");
					toast.fire();
				}
			})
		);

		$A.enqueueAction(getBenListAction);
	},

	handleClickRemove: function (component, event, helper, instrNo) {
		component.set("v.instrNo", instrNo);

		//Get details of stop order to remove
		//Get beneficiary from Map
		var allBeneficiaries = component.get("v.mapValues");
		var selectedBeneficiary = allBeneficiaries[instrNo];
		component.set("v.beneficiaryName", selectedBeneficiary.refName);
		component.set("v.isRemoveBeneficiaryOpen", true);
	},

	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		return toastEvent;
	},

	//Fire Sticky Lightning toast
	fireStickyToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			mode: "sticky",
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	allFieldsValid: function (component) {
		var idsToValidate = component.get("v.idsToValidate");
		var arrayFields = [];
		for (var i = 0; i < idsToValidate.length; i++) {
			var inputCmp = component.find(idsToValidate[i]);
			if (inputCmp) {
				Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
			}
		}
		var allValid = arrayFields.reduce(function (validFields, inputCmp) {
			var inputCmpValue = inputCmp.get("v.value");
			var inputCmpRequired = inputCmp.get("v.required");
			var inputCmpValid = true;
			if (inputCmpRequired && $A.util.isEmpty(inputCmpValue)) {
				inputCmpValid = false;
			}
			return validFields && inputCmpValid;
		}, true);

		return allValid;
	},

	actionEditBeneficiary: function (component, event, helper) {
		var accountId = component.get("v.recordId");
		var instrNo = component.get("v.instrNo");
		var beneficiaryNameValue = component.get("v.beneficiaryName");
		var targetAccountValue = component.get("v.targetAccount");
		var targetAccType = component.find("iselectAccType").get("v.value");
		var sourceAccType = component.get("v.accountNumberType");
		var sourceBranch = component.get("v.accountNumberBranch");
		var sourceRefValue = component.get("v.sourceRef");
		var branchCodeId = component.get("v.selectedBranchCodeId");
		var targetRefValue = component.get("v.targetRef");
		var loggedInUser = component.get("v.userRecord");
		var accNo = component.get("v.accountNumber");
		var amountToPay = component.get("v.amount");
		var frequency = component.get("v.frequency");
		var payDate = component.get("v.payDate");
		var payEndDate = component.get("v.payEndDate");
		var payOnDay = component.get("v.payDay");
		if (!frequency) {
			frequency = "DAILY";
		}
		if (!payOnDay) {
			payOnDay = "1";
		}

		var typeOfAction = component.get("v.typeOfAction");

		var actionUpdateBeneficiary = component.get("c.updateBeneficiary");

		actionUpdateBeneficiary.setParams({
			accId: accountId,
			instrNo: instrNo,
			beneficiaryName: beneficiaryNameValue,
			trigDate: payDate,
			endDate: payEndDate,
			payDay: payOnDay,
			freq: frequency,
			amount: amountToPay,
			srcAccNumber: accNo,
			srcAccType: sourceAccType,
			srcBranchCode: sourceBranch,
			trgAccType: targetAccType,
			trgBranchCodeId: branchCodeId,
			trgAccNumber: targetAccountValue,
			srcRef: sourceRefValue,
			trgRef: targetRefValue,
			userRecord: loggedInUser,
			updateType: typeOfAction
		});

		// Add callback behavior for when response is received
		actionUpdateBeneficiary.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var reponseRemoveBeneficiary = response.getReturnValue();
				var toast = helper.getToast("Success", reponseRemoveBeneficiary, "Success");
				toast.fire();

				//Enqueue doInit again
				var a = component.get("c.doInit");
				$A.enqueueAction(a);

				component.set("v.isEditBeneficiaryOpen", false);
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

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			} else {
				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(actionUpdateBeneficiary);
	}
});