({
	fetchPolicyData: function (component) {
		//set the collection date to be three days from today
		var currDate = new Date();
		var collectionDate = $A.localizationService.formatDate(currDate.setDate(currDate.getDate() + 3), "YYYYMMDD");
		component.set("v.collectionDate", collectionDate);

		//picklist values for Exergy
		let accountTypes = [{ label: "Savings" }, { label: "Current" }, { label: "Transmission" }, { label: "Bond" }, { label: "Credit Card" }];
		component.set("v.accountTypeList", accountTypes);

		var action = component.get("c.fetchPolicyDetails");
		//setting params
		action.setParams({
			policyNumber: component.get("v.selectedAccountFromFlow")
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
					component.set("v.policyContract", JSON.parse(responseData));
					//set the premium amount to the current balance
					var premiumBal = component.get("v.policyContract.PremiumBalance");
					if (premiumBal >= 0) {
						component.find("bSubmit").set("v.disabled", true);
						component.find("bEdit").set("v.disabled", true);
						component.set("v.isAccountUpToDate", true);
					}
					component.set("v.premiumAmount", component.get("v.policyContract.AdjustedPremium"));
					component.set("v.accountType", component.get("v.policyContract.BankContract.AccountTypeID"));
					component.set("v.bankName", component.get("v.policyContract.BankContract.BankName"));
					component.set("v.exergyBankName", component.get("v.policyContract.BankContract.BankName"));
					component.set("v.exergyBankId", component.get("v.policyContract.BankContract.BankID"));
					component.set("v.exergyBranchId", component.get("v.policyContract.BankContract.BankBranchID"));

					var branchName = component.get("v.policyContract.BankContract.BankBranchName");
					if (branchName != null) {
						if (branchName.includes("###")) {
							var branchSplit = branchName.split("###");
							component.set("v.branchCode", branchSplit[0]);
							component.set("v.branchName", branchSplit[1]);
						} else {
							component.set("v.branchName", branchName);
						}
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}

			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	scheduleAdhocDebitOrder: function (component) {
		var exergyBankId = component.get("v.exergyBankId");
		var exergyBranchId = component.get("v.exergyBranchId");
		var exergyBankName = component.get("v.exergyBankName");
		var policyContract = component.get("v.policyContract");

		var accountName = component.find("fAccountName").get("v.value");
		var accountNumber = component.find("fAccountNumber").get("v.value");
		var bank = component.find("fBank").get("v.value");
		var branch = component.find("fBranchCode").get("v.value");
		var accountType = component.find("fBankAccountType").get("v.value");

		var collectionDate = component.find("fCollectionDate").get("v.value");
		var formatCollectionDate = $A.localizationService.formatDate(collectionDate, "yyyyMMdd");

		var bankDetailsChanged = exergyBankName != bank ? true : false;

		let debitOrderParamsMap = new Map();
		debitOrderParamsMap["policyNumber"] = component.get("v.selectedAccountFromFlow");
		debitOrderParamsMap["collectionDate"] = formatCollectionDate;
		debitOrderParamsMap["accountName"] = accountName;
		debitOrderParamsMap["accountNo"] = accountNumber;
		debitOrderParamsMap["accountType"] = accountType;
		debitOrderParamsMap["branchCode"] = branch;
		debitOrderParamsMap["bankName"] = bank;
		debitOrderParamsMap["externalBranchID"] = exergyBranchId;
		debitOrderParamsMap["externalBankID"] = exergyBankId;
		debitOrderParamsMap["bankDetailsChanged"] = bankDetailsChanged;

		var action = component.get("c.createAdhocDebitOrder");

		//setting params
		action.setParams({
			debitOrderParamsMap: debitOrderParamsMap
		});

		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					this.fireToastEvent("Error!", "Adhoc payment scheduling was unsuccessful", "error");
					component.set("v.errorMessage", responseData);
				} else {
					this.fireToastEvent("Success!", "Adhoc payment scheduled successfully", "Success");
					component.set("v.isPaymentScheduledToFlow", true);
					component.find("bSubmit").set("v.disabled", true);
					component.find("bEdit").set("v.disabled", true);
					component.find("fCollectionDate").set("v.disabled", true);
					component.find("fAccountName").set("v.disabled", true);
					component.find("fBranchCode").set("v.disabled", true);
					component.find("fAccountNumber").set("v.disabled", true);
					component.find("fBankAccountType").set("v.disabled", true);
					component.find("fBank").set("v.disabled", true);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AdhocPaymentController.createAdhocDebitOrder: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			component.set("v.showConfirmSubmission", false);
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	handleFormValidations: function (component) {
		var currDate = new Date();
		var validDate = $A.localizationService.formatDate(currDate.setDate(currDate.getDate() + 3), "YYYY-MM-DD");
		var collectionDate = component.find("fCollectionDate").get("v.value");
		var accountName = component.find("fAccountName").get("v.value");
		var accountNumber = component.find("fAccountNumber").get("v.value");
		var branch = component.find("fBranchCode").get("v.value");

		//Validation on collection date empty
		if ($A.util.isEmpty(collectionDate)) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide collection date", "warning");
			return;
		}

		//Validation on collection date not more that 3 days
		if (collectionDate < validDate) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Collection date cannot be less than 3 days from today", "warning");
			return;
		}

		//account name must not be blank
		if (accountName == "" || accountName == null) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide account holders name", "warning");
			return;
		}

		//account number must not be blank
		if (accountNumber == "" || accountNumber == null) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide account number", "warning");
			return;
		}

		//branch must not be blank
		if (branch == "" || branch == null) {
			this.hideSpinner(component);
			this.fireToastEvent("Validation Warning", "Please provide full banking details", "warning");
			return;
		}

		component.set("v.showConfirmSubmission", true);
	},

	/**
	 * @description transactional history story helper method to fetch the data from Apex method
	 * @param component
	 * @param event
	 * @param helper
	 * @author Bhanumurty Rayala
	 */
	handleTransactionalHistoryHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getTransactionalHistory");
		//setting params
		action.setParams({
			policyNumber: component.get("v.selectedAccountFromFlow")
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
					component.set("v.transactionalHistoryData", JSON.parse(responseData));
					component.set("v.transactionalHistoryDataTable", JSON.parse(responseData));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/**
	 * @description to run the filter logic for the story
	 * @param component
	 * @param Event
	 * @param helper
	 * @author Bhanumurty Rayala
	 */
	filterDateRangeHelper: function (component, event, helper) {
		var startDate = component.find("startDate").get("v.value");
		var endDate = component.find("endDate").get("v.value");
		var transactionalHistoryData = component.get("v.transactionalHistoryData");
		var filterData = [];
		if ($A.util.isEmpty(startDate) || $A.util.isEmpty(endDate)) {
			helper.fireToastEvent("Validation Warning", "Missing start/end date", "warning");
		} else if (endDate < startDate) {
			helper.fireToastEvent("Validation Warning", "End date cannot be in past", "warning");
		} else {
			for (var i = 0; i < transactionalHistoryData.length; i++) {
				if (startDate <= transactionalHistoryData[i].CreatedDate && endDate >= transactionalHistoryData[i].CreatedDate) {
					filterData.push(transactionalHistoryData[i]);
				}
			}
			component.set("v.transactionalHistoryDataTable", filterData);
		}
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