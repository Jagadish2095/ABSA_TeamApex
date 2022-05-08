({
	fetchServiceProvidersData: function (component) {
		var action = component.get("c.getServiceProvidersData");
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
				} else {
					var serviceProvidersData = JSON.parse(responseData);
					component.set("v.serviceProvidersData", serviceProvidersData);
					var serviceProvidersList = [];
					for (var key in serviceProvidersData) {
						serviceProvidersList.push({ label: key, value: key });
					}
					component.set("v.serviceProviderOptions", serviceProvidersList);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "fetchServiceProvidersData error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "fetchServiceProvidersData unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	fetchMobileBeneficiaries: function (component) {
		var cifCode = component.get("v.cifCode");
		var action = component.get("c.getMobileBeneficiaries");
		//setting params
		action.setParams({
			cifKey: cifCode
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
					var beneficiaryList = JSON.parse(responseData);
					if (beneficiaryList.length > 0) {
						component.set("v.showBeneficiariesTable", true);
					} else {
						component.set("v.showBeneficiariesTable", false);
					}
					component.set("v.beneficiaryList", beneficiaryList);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "fetchMobileBeneficiaries error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "fetchMobileBeneficiaries unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	populateRechargeTypeValues: function (component, selectedValue) {
		var serviceProvidersData = component.get("v.serviceProvidersData");
		let rechargeTypeSet = new Set();
		var serviceProviderRechargeValues = [];
		var rechargeTypeList = [];

		for (var i = 0; i < serviceProvidersData[selectedValue].length; i++) {
			rechargeTypeSet.add(serviceProvidersData[selectedValue][i].voucherInstitutionCode);
			serviceProviderRechargeValues.push(serviceProvidersData[selectedValue][i]);
		}

		component.set("v.serviceProviderRechargeValues", serviceProviderRechargeValues);

		for (var rechargeTypeElement of rechargeTypeSet) {
			rechargeTypeList.push({ label: rechargeTypeElement, value: rechargeTypeElement });
		}

		component.set("v.serviceProviderID", "");
		component.set("v.ownAmount", "");
		component.set("v.purchaseAmount", "");
		component.set("v.rechargeAmountDetail", "");
		component.set("v.rechargeType", "");
		component.set("v.rechargeAmountOptions", []);
		component.set("v.isOwnAmount", false);
		component.set("v.rechargeTypeOptions", rechargeTypeList);
	},

	populateRechargeAmountValues: function (component, selectedValue) {
		var serviceProviderRechargeValues = component.get("v.serviceProviderRechargeValues");

		var rechargeVouchers = [];

		if (serviceProviderRechargeValues.length > 0) {
			for (var i = 0; i < serviceProviderRechargeValues.length; i++) {
				var serviceProviderID = serviceProviderRechargeValues[i].SPID;
				var voucherDesc = serviceProviderRechargeValues[i].voucherDesc;
				var voucherInstitutionCode = serviceProviderRechargeValues[i].voucherInstitutionCode;
				var amount = serviceProviderRechargeValues[i].amount;
				var durantionValue = serviceProviderRechargeValues[i].durantionValue;
				var durantionUnit = serviceProviderRechargeValues[i].durantionUnit;
				var selectLabel;
				var selectValue;

				if (voucherInstitutionCode == selectedValue) {
					if (amount == "Own") {
						selectLabel = "Own amount";
						selectValue = serviceProviderID + ";Own amount";
					} else {
						selectLabel = voucherDesc + " - R" + amount + " - " + durantionValue + " " + durantionUnit;
						selectValue = serviceProviderID + ";" + amount;
					}
					rechargeVouchers.push({ label: selectLabel, value: selectValue });
				}
			}
		}
		component.set("v.rechargeAmountOptions", rechargeVouchers);
	},

	validateRechargeValues: function (component) {
		var cellphoneNumber = component.get("v.cellphoneNumber");
		var serviceProvider = component.get("v.serviceProvider");
		var rechargeType = component.get("v.rechargeType");
		var rechargeAmountDetail = component.get("v.rechargeAmountDetail");
		var ownAmount = component.get("v.ownAmount");
		var purchaseAmount = component.get("v.purchaseAmount");
		var saveAsBeneficiary = component.get("v.saveAsBeneficiary");

		//Cellphone number must not be blank
		if (!cellphoneNumber || cellphoneNumber.length != 10 || isNaN(Number(cellphoneNumber))) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide valid cellphone number", "warning");
			return;
		}
		//Service provider must not be blank
		if (!serviceProvider) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please select service provider", "warning");
			return;
		}
		//Recharge type must not be blank
		if (!rechargeType) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please select recharge type", "warning");
			return;
		}
		//Recharge amount must not be blank
		if (!rechargeAmountDetail) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please select recharge amount", "warning");
			return;
		}
		//Amount must not be blank
		if (!purchaseAmount && (!ownAmount || Number(ownAmount <= 0) || isNaN(Number(ownAmount)))) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide valid amount", "warning");
			return;
		}

		component.set("v.showConfirmSubmission", true);
	},

	validateBeneficiaryDetails: function (component) {
		var benDescription = component.get("v.benDescription");
		var cellphoneNumber = component.get("v.cellphoneNumber");
		var serviceProvider = component.get("v.serviceProvider");

		//Beneficiary description must not be blank
		if (!benDescription) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide beneficiary description", "warning");
			return;
		}

		//Cellphone number must not be blank
		if (!cellphoneNumber || cellphoneNumber.length != 10 || isNaN(Number(cellphoneNumber))) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide valid beneficiary cellphone number", "warning");
			return;
		}
		//Service provider must not be blank
		if (!serviceProvider) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide beneficiary service provider", "warning");
			return;
		}

		component.set("v.allowBeneficiarySave", true);
	},

	submitRechargeValues: function (component) {
		var selectedAccountType = component.get("v.selectedAccountTypeFromFlow");
		var selectedAccountNumber = component.get("v.selectedAccountNumberFromFlow");
		var serviceProviderID = component.get("v.serviceProviderID");
		var cellphoneNumber = component.get("v.cellphoneNumber");
		var caseNumber = component.get("v.caseNumber");
		var ownAmount = component.get("v.ownAmount");
		var purchaseAmount = component.get("v.purchaseAmount");
		var finalAmount = purchaseAmount ? purchaseAmount : ownAmount;

		var accountNumber = this.addLeadingZeros(selectedAccountNumber, 19);

		let mobileTopUpParamsMap = new Map();
		mobileTopUpParamsMap["spid"] = serviceProviderID;
		mobileTopUpParamsMap["phoneNumber"] = cellphoneNumber;
		mobileTopUpParamsMap["accType"] = selectedAccountType;
		mobileTopUpParamsMap["accNumber"] = accountNumber;
		mobileTopUpParamsMap["amount"] = finalAmount;
		mobileTopUpParamsMap["retrievalRefNumber"] = caseNumber.replace("C-", "0000");

		var action = component.get("c.processMobileTopUp");
		//setting params
		action.setParams({
			mobileTopUpParamsMap: mobileTopUpParamsMap
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					this.fireToastEvent("Error!", "Mobile top up Unsuccessful", "error");
					component.set("v.errorMessage", responseData);
				} else {
					this.fireToastEvent("Success!", "Mobile top up Successful", "Success");
					//DBOOYSEN. W-008306
					//Create the charge log by calling aura method from child component "ChargeTransaction"
					var chargeComponent = component.find("chargeTransactionCmp");
					chargeComponent.createChargeLog("TC002"); //Mobile Recharge
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "MobileTopUpController.processMobileTopUp error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "MobileTopUpController.processMobileTopUp unexpected error occurred, state returned: " + state);
			}
			component.set("v.showConfirmSubmission", false);
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	createMobileBeneficiaries: function (component) {
		var cifCode = component.get("v.cifCode");
		var benDescription = component.get("v.benDescription");
		var serviceProvider = component.get("v.serviceProvider");
		var cellphoneNumber = component.get("v.cellphoneNumber");
		var beneficiaryList = component.get("v.beneficiaryList");
		var newIvrPaymentNumber = this.generateIvrPaymentNumber(beneficiaryList);

		var action = component.get("c.addMobileBeneficiaries");
		//setting params
		action.setParams({
			cifKey: cifCode,
			ivrPaymentNo: newIvrPaymentNumber,
			cellProvider: serviceProvider,
			cellNo: cellphoneNumber,
			description: benDescription
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
					this.fireToastEvent("Success!", "Mobile beneficiary successfully created", "Success");
					component.find("btnSaveBeneficiary").set("v.disabled", true);
					component.find("btnSubmit").set("v.disabled", false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "createMobileBeneficiaries error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "createMobileBeneficiaries unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	generateIvrPaymentNumber: function (array) {
		var ivrPaymentNo;
		if (array.length > 0) {
			var maxIvrPaymentNo = Math.max.apply(
				Math,
				array.map(function (o) {
					return o.ivrPaymentNo;
				})
			);
			ivrPaymentNo = maxIvrPaymentNo + 1;
		} else {
			ivrPaymentNo = 1;
		}
		return ivrPaymentNo;
	},

	addLeadingZeros: function (str, size) {
		while (str.length < size) str = "0" + str;
		return str;
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