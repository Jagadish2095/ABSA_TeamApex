({
	setFieldsHelper: function (component, event) {
		var dueDaysList = [];
		for (var i = 1; i <= 31; i++) {
			dueDaysList.push({ label: i, value: i });
		}
		component.set("v.dueDaysList", dueDaysList);
	},

	getAccountDataHelper: function (component, event) {
		this.showSpinner(component);
		var accountNumber = component.get("v.accountNumberFromFlow");
		if (accountNumber == null || accountNumber == undefined) {
			this.hideSpinner(component);
			this.getToast("Validation", "Please select an account", "warning");
			component.set("v.errorMessage", "Please select an account");
			return;
		}

		var action = component.get("c.getAccountData");
		action.setParams({
			accountNumber: accountNumber
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					var outputArea = respObj.MLB854O.MLB854O_OUTPUT_AREA;
					if (respObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_RETURN_CODE == 0 && respObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_PRIME_ACCT_ID != "") {
						//success
						//Set fields
						component.set("v.contactName", outputArea.MLB854O_CLIENT_NAME);
						component.set("v.interestRate", outputArea.MLB854O_PRIME_ACCT_INT_RATE);
						component.set("v.interestRateType", outputArea.interestRateTypeTranslated);
						component.set("v.nameOfScheme", outputArea.schemaCodeTranslated);
						component.set("v.remainingTerm", outputArea.MLB854O_PRIME_ACCT_REM_TERM);
						component.set("v.repaymentDueDay", outputArea.MLB854O_CUR_DUE_DAY);
						component.set("v.serviceFee", outputArea.MLB854O_CUR_SERVICE_FEE);
						component.set("v.advanceAmount", outputArea.MLB854O_FLEXI_AVAIL_AMT);
						component.set("v.totalRepayment", outputArea.MLB854O_PRIME_ACCT_PAYMENT);
						component.set("v.outstandingBalance", outputArea.MLB854O_OUTS_BAL);
						component.set("v.primaryAccountNumber", outputArea.MLB854O_SEC_ACCT_NUMBER);
						component.set("v.schemaCode", outputArea.MLB854O_SCHM_CODE);
						component.set("v.refNumber", outputArea.MLB854O_REF_NUMBER);
						component.set("v.primaryAccountId", outputArea.MLB854O_PRIME_ACCT_ID);

						outputArea.MLB854O_FLEXI_CODE == 0
							? component.set("v.flexiReserveFacility", "No Reserve")
							: component.set("v.flexiReserveFacility", outputArea.MLB854O_FLEXI_CODE);

						//filter Secondary Accounts
						var secondaryAccountList = outputArea.MLB854O_SECONDARY_ACCTS;
						var filterSecondaryAccounts = [];
						for (var i = 0; i < secondaryAccountList.length; i++) {
							if (secondaryAccountList[i].MLB854O_SEC_ACCT_ID != "") {
								filterSecondaryAccounts.push(secondaryAccountList[i]);
							}
						}

						//component.set("v.getAccountDataFromSF", true);
						component.set("v.secondaryAccountList", filterSecondaryAccounts);
						component.set("v.showForm", true);
					} else {
						//Error no primary account found
						this.getToast("Error", "Error While fetching data for Account: " + accountNumber, "error");
						var message = "Error while fetching data for Account: " + accountNumber;
						if (respObj.MLB854O.MLB854O_OUTPUT_AREA.MLB854O_PRIME_ACCT_ID == "") {
							message += ", no Primary account found,";
						}
						component.set("v.errorMessage", message + " Return Code: " + JSON.stringify(respObj.MLB854O.MLB854O_OUTPUT_AREA.returnCodeTranslated));
					}
				} else {
					//Fire Error Toast
					this.getToast("Error", "Error while fetching data for account: " + accountNumber, "error");
					component.set(
						"v.errorMessage",
						"Apex error HLDueDateChangeController.getAccountData: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error HLDueDateChangeController.getAccountData: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	updateDueDateHelper: function (component, event) {
		this.showSpinner(component);
		var selectedDay = component.get("v.selectedDay");
		var accountNumber = component.get("v.accountNumberFromFlow");
		var primaryAccountId = component.get("v.primaryAccountId");
		var refNumber = component.get("v.refNumber");
		var schemaCode = component.get("v.schemaCode");
		var submitButton = component.find("submitButton");
		component.set("v.showSuccessMessage", false); //Use the toast

		//Disable the submit button
		submitButton.set("v.disabled", true);

		component.set("v.errorMessage", null);

		if (!selectedDay) {
			this.hideSpinner(component);
			this.getToast("Validation", "Please select New Repayment Due Day", "warning");
			return;
		}

		var action = component.get("c.updateDueDate");
		action.setParams({
			accountNumber: accountNumber,
			primaryAccountId: primaryAccountId,
			newDueDay: selectedDay,
			refNumber: refNumber,
			schemaCode: schemaCode
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			var respObjString = JSON.stringify(respObj);
			console.log("SMath state***" + state);
			console.log("SMath respObj stringified before***" + JSON.stringify(respObj));
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					if(!respObjString.startsWith('{"errorMessage"')){
						if (respObj.MLB855O.MLB855O_OUTPUT_AREA.MLB855O_RETURN_CODE == 0) {
							//success
							this.getToast("Success", "Due Day Updated", "success");
							component.set("v.showSuccessMessage", true);
							component.set("v.sendConfirmationEmail", true);
							component.set("v.repaymentDueDay", component.get("v.selectedDay"));
						} else {
							//Show an error toast
							this.getToast("Error", "Due Day not updated", "Error");
							submitButton.set("v.disabled", false);
							component.set(
								"v.errorMessage",
								"An error occurred while updating Due Day: " +
									"Return Code: " +
									JSON.stringify(respObj.MLB855O.MLB855O_OUTPUT_AREA.returnCodeTranslated)
							);
						}
					} else if(respObjString.startsWith('{"errorMessage"')){
						//Show an error toast
						this.getToast("Error", "Due Day not updated", "Error");
						submitButton.set("v.disabled", false);
						component.set(
							"v.errorMessage",
							"An error occurred while updating Due Day: " +
								"Return Code: " +
								JSON.stringify(respObj.errorMessage)
						);
					}
					
				} else {
					//Fire Error Toast
					this.getToast("Error", "A service error occurred while updating Due Day: " + accountNumber, "error");
					submitButton.set("v.disabled", false);
					component.set(
						"v.errorMessage",
						"Apex error HLDueDateChangeController.updateDueDate: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				this.getToast("Error", "Due Day not updated", "Error");
				submitButton.set("v.disabled", false);
				component.set("v.errorMessage", "Apex error HLDueDateChangeController.updateDueDate: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
				this.getToast("Error", "Due Day not updated", "Error");
				submitButton.set("v.disabled", false);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	setEmailAddressField: function (component, event) {
		//Set Email Fields
		if (component.get("v.isBusinessAccountFromFlow") == "true") {
			//Business account
			component.set("v.clientEmailAddress", component.get("v.accountRecord.Active_Email__c"));
		} else {
			//Non business account
			component.set("v.clientEmailAddress", component.get("v.accountRecord.PersonEmail"));
		}
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