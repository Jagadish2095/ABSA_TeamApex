({
	//Handle Init event
	doInit: function (component, event) {
		var paymentOption = component.get("v.activeTabId");
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "Current/Cheque",
			value: "Cheque"
		});
		opts.push({
			class: "optionClass",
			label: "Savings",
			value: "Savings"
		});

		opts.push({
			class: "optionClass",
			label: "Credit Card",
			value: "Credit Card"
		});

		opts.push({
			class: "optionClass",
			label: "--None--",
			value: "--None--"
		});
		component.set("v.targetAccTypeOptions", opts);

		//get account details
		if (paymentOption == "payBeneficiary") {
			this.getAccountDetails(component, event);
		}
	},

	//Get Account Details by Calling a method on CIGetAccountLinkedToClientCodeCmp
	getAccountDetails: function (component, event) {
		var paymentOption = component.get("v.activeTabId");
		if (paymentOption == "payBeneficiary") {
			this.showSpinner(component);
			var getBenDetails = component.find("hiddenComp");
			getBenDetails.getAccountDetailsMethod(component, event);
		}
	},

	getAccountDetailsByAccNo: function (component) {
		this.showSpinner(component);
		var action = component.get("c.getAccountDetailsByAccNo");
		action.setParams({ accountNo: component.get("v.selectedLinkedAccount") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("Error: ")) {
					// error
					this.getToast("Error!", "Paymentshelper.getAccountDetailsByAccNo : " + responseValue, "Error");
				} else {
					// success
					component.find("linkedCombiId").set("v.disabled", false);
					var combiLinkedList = [];
					var respObj = JSON.parse(responseValue);

					for (var key in respObj) {
						if (respObj[key].productType == "CO" && respObj[key].status == "ACTIVE") {
							combiLinkedList.push(respObj[key].oaccntnbr.replace(/^0+/, ""));
						}
					}
					component.set("v.linkedCombiList", combiLinkedList);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.showPaymentStatusError", true);
						component.set("v.showPaymentStatusErrorMsg", "PaymentsHelper.getAccountDetailsByAccNo -" + JSON.stringify(errors));
					}
				} else {
					component.set("v.showPaymentStatusError", true);
					component.set("v.showPaymentStatusErrorMsg", "PaymentsHelper.getAccountDetailsByAccNo -" + state);
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getCombiLinkedAccounts: function (component) {
		this.showSpinner(component);
		var action = component.get("c.getAccountsLinkedToCombi");
		action.setParams({ selectedCombi: component.get("v.selectedPOACombiValue") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseBean = response.getReturnValue();
				if (responseBean.statusCode != 200) {
					// error

					this.getToast("Error!", "Payments.Helper.getCombiLinkedAccounts : " + JSON.stringify(responseBean.message), "Error");
				}

				if (responseBean === null || responseBean === undefined) {
					component.set("v.showPaymentStatusError", true);
					component.set(
						"v.showPaymentStatusErrorMsg",
						"PaymentsHelper.getAccountDetailsByAccNo - unexpected error, PaymentsHelper.getCombiLinkedAccounts - service returned null response"
					);
				}

				if (responseBean.CClistAccsLinkedToACombiCardV1Response.ccp308o.lnkAccntLst) {
					// success
					var combiLinkedList = [];

					var responseList = responseBean.CClistAccsLinkedToACombiCardV1Response.ccp308o.lnkAccntLst;

					for (var key in responseList) {
						combiLinkedList.push(responseList[key].accntNbr);
					}

					component.set("v.combiLinkedAccounts", combiLinkedList);

					component.find("linkedAccId").set("v.disabled", false);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.showPaymentStatusError", true);
				component.set("v.showPaymentStatusErrorMsg", "Apex error PaymentRequestController.getAccountDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.showPaymentStatusError", true);
				component.set("v.showPaymentStatusErrorMsg", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Payment Functions

	//Function for validating Absa Listed Payment screen fields
	ValidateAbsaListed: function (component, event) {
		//Payment Options
		var paymentOption = component.get("v.activeTabId");
		var paymentType = component.get("v.paymentTypeOptionValue");

		//Fields
		var selectedProductType = component.get("v.selectedProductValue");
		var selectedFromAccount = component.get("v.selectedAccountNumber");
		var beneficiaryName = component.get("v.recipientRefName");
		var toAccount = component.get("v.targetAccountNo");
		var recipientAccountType = component.get("v.selectedTargetAccType");
		var paymentAmount = component.get("v.amount");
		var bank = component.get("v.targetBankName");
		var futureDate = component.get("v.myDate");
		var branchCode = component.get("v.selectedBranchCode");
		var debitRefName = component.get("v.paymentRefName");
		var creditRefName = component.get("v.recipientReference");

		//required fields array
		var requiredFields = [
			selectedProductType,
			selectedFromAccount,
			beneficiaryName,
			toAccount,
			recipientAccountType,
			paymentAmount,
			branchCode,
			debitRefName,
			creditRefName
		];

		for (var i = 0; i < requiredFields.length; i++) {
			if (requiredFields[i] == "" || requiredFields[i] == null) {
				console.log("Field position: " + i + " value: " + requiredFields[i]);
				var title = "Validation";
				var message = "Please complete all required fields";
				this.getToast(title, message, "warning");
				return;
			}
		}

		if (paymentOption == "absaListed") {
			if (paymentType == "future") {
				if (futureDate == null) {
					getToast("Validation", "Future date cannot be blank", "warning");
					return;
				}
				this.FuturePayment(component, event);
			} else {
				this.AbsaListedOrOnceOffPayment(component, event);
			}
		}
	},

	ValidateOnceOffPayment: function (component, event) {
		//Payment Options
		var paymentOption = component.get("v.activeTabId");
		var paymentType = component.get("v.paymentTypeOptionValue");
		var futureDate = component.get("v.myDate");

		//Fields
		var selectedProductType = component.get("v.selectedProductValue");
		var selectedFromAccount = component.get("v.selectedAccountNumber");
		var bank = component.get("v.targetBankName");
		var branchCode = component.get("v.selectedBranchCode");
		var beneficiaryName = component.get("v.recipientRefName");
		var toAccount = component.get("v.targetAccountNo");
		var recipientAccountType = component.get("v.selectedTargetAccType");
		var paymentAmount = component.get("v.amount");
		var debitRefName = component.get("v.paymentRefName");
		var creditRefName = component.get("v.recipientReference");

		//required fields array
		var requiredFields = [
			selectedProductType,
			selectedFromAccount,
			bank,
			branchCode,
			beneficiaryName,
			toAccount,
			recipientAccountType,
			paymentAmount,
			debitRefName,
			creditRefName
		];

		//Validate fields
		for (var i = 0; i < requiredFields.length; i++) {
			if (requiredFields[i] == "" || requiredFields[i] == null) {
				console.log("Field position: " + i + " value: " + requiredFields[i]);
				var title = "Validation";
				var message = "Please complete all required fields";
				this.getToast(title, message, "warning");
				return;
			}
		}

		if (paymentOption == "onceOffPayment") {
			if (paymentType == "future") {
				if (futureDate == null) {
					getToast("Validation", "Future date cannot be blank", "warning");
					return;
				}
				this.FuturePayment(component, event);
			} else {
				this.AbsaListedOrOnceOffPayment(component, event);
			}
		}
	},

	//Validate Fields before paying the beneficiary
	ValidatePayBeneficiary: function (component, event) {
		//Payment Options
		var paymentOption = component.get("v.activeTabId");
		var paymentType = component.get("v.paymentTypeOptionValue");
		var futureDate = component.get("v.myDate");

		//Fields
		var selectedProductType = component.get("v.selectedProductValue");
		var selectedFromAccount = component.get("v.selectedAccountNumber");

		//Fields
		var selectedProductType = component.get("v.selectedProductValue");
		var selectedFromAccount = component.get("v.selectedAccountNumber");
		var bank = component.get("v.targetBankName");
		var branchCode = component.get("v.selectedBranchCode");
		var beneficiaryName = component.get("v.recipientRefName");
		var toAccount = component.get("v.targetAccountNo");
		var recipientAccountType = component.get("v.selectedTargetAccType");
		var paymentAmount = component.get("v.amount");
		var debitRefName = component.get("v.paymentRefName");
		var creditRefName = component.get("v.recipientReference");
		var ivrCode = component.get("v.ivrNominate");

		//required fields array
		var requiredFields = [
			selectedProductType,
			selectedFromAccount,
			beneficiaryName,
			bank,
			branchCode,
			toAccount,
			recipientAccountType,
			ivrCode,
			debitRefName,
			paymentAmount,
			creditRefName
		];

		//Validate fields
		for (var i = 0; i < requiredFields.length; i++) {
			if (requiredFields[i] == "" || requiredFields[i] == null) {
				console.log("Field position: " + i + " value: " + requiredFields[i]);
				var title = "Validation";
				var message = "Please complete all required fields";
				this.getToast(title, message, "warning");
				return;
			}
		}

		if (paymentOption == "payBeneficiary") {
			if (paymentType == "future") {
				if (futureDate == null) {
					this.getToast("Validation", "Future date cannot be blank", "warning");
					return;
				}
				this.FuturePayment(component, event);
			} else {
				this.PayBeneficiary(component, event);
			}
		}
	},

	AbsaListedOrOnceOffPayment: function (component, event) {
		this.showSpinner(component);
		var paymentOption = component.get("v.activeTabId");
		var paymentType = component.get("v.paymentTypeOptionValue");
		var paymIipInd;

		if (paymentType === "immediate") {
			paymIipInd = "D";
		} else {
			paymIipInd = "";
		}
        var action = component.get("c.initiatePayment");

		let initiatePaymentParamsMap = new Map();
		initiatePaymentParamsMap["amount"] = component.get("v.amount");
		initiatePaymentParamsMap["srcAcc"] = component.get("v.selectedAccountNumber");
		initiatePaymentParamsMap["srcAccType"] = component.get("v.selectedProductValue");
		initiatePaymentParamsMap["srcStmtRef"] = component.get("v.paymentRefName");
		initiatePaymentParamsMap["trgAcc"] = component.get("v.targetAccountNo");
		initiatePaymentParamsMap["trgClrCode"] = component.get("v.selectedBranchCode"),
		initiatePaymentParamsMap["trgAccType"] = component.get("v.selectedTargetAccType");
		initiatePaymentParamsMap["trgStmtRef"] = component.get("v.recipientReference");
		initiatePaymentParamsMap["paymIipInd"] = paymIipInd;
		initiatePaymentParamsMap["instrRefName"] = component.get("v.recipientRefName");
		initiatePaymentParamsMap["instrType"] = 'OOP';
		initiatePaymentParamsMap["tieb"] = '0';
		initiatePaymentParamsMap["instrNo"] = '0';
		initiatePaymentParamsMap["accessAcc"] = '';
		initiatePaymentParamsMap["cifKey"] = '';

		action.setParams({
			initiatePaymentParamsMap: initiatePaymentParamsMap
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				console.log("responseData**", responseData);
				if (responseData.startsWith("Error: ")) {
					this.fireStickyToast("Error!", "Payment Unsuccessful", "error");
					component.set("v.errorMessage", responseData);
					component.set("v.disableSubmitButton", false);
				} else {
					var jsonResponseData = JSON.parse(responseData);
					console.log("jsonResponseData**", jsonResponseData);
					this.getToast("Success!", "Payment Successful", "Success");
					component.set("v.errorMessage", '');
					if(paymIipInd != "D"){
						component.set("v.showPaymentStatusSuccess", true);
						component.set("v.showMakeAnotherPaymentButton", true);
						component.set("v.disablePaymentTypeSelection", true);
						component.set("v.disableChangeBenButton", true);

						//Disable Submit button
						component.set("v.disableSubmitButton", true);

						//Navigate to next screen
						this.navigateToNextScreen(component, event);
					}else if(paymIipInd == "D"){
						var uniqueEFT = jsonResponseData.mbn301o.uniqueEft;

						//Complete Immediate Payment Action
				        this.showSpinner(component);
						var actionComp = component.get("c.completePayment");
						actionComp.setParams({
							uniqueEft: uniqueEFT
						});

						actionComp.setCallback(this, function (response) {
							var stateResp = response.getState();
							if (stateResp === "SUCCESS") {
								var results = response.getReturnValue();
								if (results === "SUCCESSFUL PROCESS") {
									component.set("v.showPaymentStatusSuccess", true);
									component.set("v.disablePaymentTypeSelection", true);

									component.set("v.showMakeAnotherPaymentButton", true);
									this.getToast("Success!", "Payment Successfully Completed", "Success");

									//Disable button
									component.set("v.disableSubmitButton", true);

									//Navigate to next screen
									this.navigateToNextScreen(component, event);
								} else {
									this.getToast("Error!", "Payment Unsuccessful", "Error");
									component.set("v.errorMessage", results);
									component.set("v.disableSubmitButton", true);
								}
							} else if (stateResp === "ERROR") {
								this.getToast("Error!", "Payment Unsuccessful..  Please try again..", "Error");
								var errors = response.getError();
								component.set("v.errorMessage", "PaymentsController.completePayment error: " + JSON.stringify(errors[0].messages));
							}
							this.hideSpinner(component);
						});
						$A.enqueueAction(actionComp);
					}

					//DBOOYSEN. W-008306:Create the charge log by calling aura method from child component "ChargeTransaction"
					var chargeComponent = component.find("chargeTransactionCmp");
					if (paymentType === "immediate") {
						chargeComponent.createChargeLog("TC004"); //Immediate Interbank Payment
					} else {
						chargeComponent.createChargeLog("TC003"); //Normal Payment
					}

					if (paymentOption == "onceOffPayment") {
						component.set("v.showAddBenBtn", true);
						this.setAddBeneficiaryFields(component, event);
					}
					//added by Danie Booysen 08/02/2021
					this.setProofOfPaymentAttributes(component, responseData);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "PaymentsController.initiatePayment error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "PaymentsController.initiatePayment unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	PayBeneficiary: function (component, event, helper) {
		this.showSpinner(component);
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		var paymentType = component.get("v.paymentTypeOptionValue");
		var paymIipInd;
        var tieb = component.get("v.selectedBenTIEBVal");//Added by chandra dated 12/01/2022

		if (paymentType === "immediate") {
			paymIipInd = "D";
		} else {
			paymIipInd = "";
		}

		var action = component.get("c.initiateBeneficiaryPayment");

		let initiatePaymentParamsMap = new Map();
		initiatePaymentParamsMap["accountId"] = clientAccountId;
		initiatePaymentParamsMap["amount"] = component.get("v.amount");
		initiatePaymentParamsMap["srcAcc"] = component.get("v.selectedAccountNumber");
		initiatePaymentParamsMap["srcAccType"] = component.get("v.selectedProductValue");
		initiatePaymentParamsMap["srcStmtRef"] = component.get("v.paymentRefName");
		initiatePaymentParamsMap["trgAcc"] = component.get("v.targetAccountNo");
		initiatePaymentParamsMap["trgClrCode"] = component.get("v.selectedBranchCode"),
		initiatePaymentParamsMap["trgAccType"] = component.get("v.selectedTargetAccType");
		initiatePaymentParamsMap["trgStmtRef"] = component.get("v.recipientReference");
		initiatePaymentParamsMap["paymIipInd"] = paymIipInd;
		initiatePaymentParamsMap["instrRefName"] = component.get("v.recipientRefName");
		initiatePaymentParamsMap["instrType"] = 'VP';
		initiatePaymentParamsMap["tieb"] = tieb;
		initiatePaymentParamsMap["accessAcc"] = component.get("v.accessAcc");
		initiatePaymentParamsMap["instrNo"] = component.get("v.instructionNumber");
		initiatePaymentParamsMap["cifKey"] = '';

		action.setParams({
			initiatePaymentParamsMap: initiatePaymentParamsMap
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				console.log("responseData**", responseData);
				if (responseData.startsWith("Error: ")) {
					this.fireStickyToast("Error!", "Payment Unsuccessful", "error");
					component.set("v.errorMessage", responseData);
					component.set("v.disableSubmitButton", false);
				} else {
					var jsonResponseData = JSON.parse(responseData);
					console.log("jsonResponseData**", jsonResponseData);
					this.getToast("Success!", "Payment Successful", "Success");
					component.set("v.errorMessage", '');
					if(paymIipInd != "D"){
						component.set("v.showPaymentStatusSuccess", true);
						component.set("v.showMakeAnotherPaymentButton", true);
						component.set("v.disablePaymentTypeSelection", true);
						component.set("v.disableChangeBenButton", true);

						//Disable Submit button
						component.set("v.disableSubmitButton", true);

						//Navigate to next screen
						this.navigateToNextScreen(component, event);
					}else if(paymIipInd == "D"){
						var uniqueEFT = jsonResponseData.mbn301o.uniqueEft;
						var paymNo = jsonResponseData.mbn301o.paymNo;

						//Complete Immediate Payment Action
				        this.showSpinner(component);
						var actionComp = component.get("c.completePayment");
						actionComp.setParams({
							uniqueEft: uniqueEFT,
							paymNo: paymNo
						});

						actionComp.setCallback(this, function (response) {
							var stateResp = response.getState();
							if (stateResp === "SUCCESS") {
								var results = response.getReturnValue();
								if (results === "SUCCESSFUL PROCESS") {
									component.set("v.showPaymentStatusSuccess", true);
									component.set("v.disablePaymentTypeSelection", true);

									component.set("v.showMakeAnotherPaymentButton", true);
									this.getToast("Success!", "Payment Successfully Completed", "Success");

									//Disable button
									component.set("v.disableSubmitButton", true);

									//Navigate to next screen
									this.navigateToNextScreen(component, event);
								} else {
									this.getToast("Error!", "Payment Unsuccessful", "Error");
									component.set("v.errorMessage", results);
									component.set("v.disableSubmitButton", true);
								}
							} else if (stateResp === "ERROR") {
								this.getToast("Error!", "Payment Unsuccessful..  Please try again..", "Error");
								var errors = response.getError();
								component.set("v.errorMessage", "PaymentsController.completeBeneficiaryPayment error: " + JSON.stringify(errors[0].messages));
							}
							this.hideSpinner(component);
						});
						$A.enqueueAction(actionComp);
					}

					//DBOOYSEN. W-008306:Create the charge log by calling aura method from child component "ChargeTransaction"
					var chargeComponent = component.find("chargeTransactionCmp");
					if (paymentType === "immediate") {
						chargeComponent.createChargeLog("TC004"); //Immediate Interbank Payment
					} else {
						chargeComponent.createChargeLog("TC003"); //Normal Payment
					}

					//added by Danie Booysen 08/02/2021
					this.setProofOfPaymentAttributes(component, responseData);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "PaymentsController.PayBeneficiary error: " + JSON.stringify(errors[0].messages));
			} else {
				component.set("v.errorMessage", "PaymentsController.PayBeneficiary unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	// Future Dated Payment
	FuturePayment: function (component, event) {
		this.showSpinner(component);
        var selectedAccountNumber = component.get("v.selectedAccountNumber");
		var selectedProductValue = component.get("v.selectedProductValue");
		var amount = component.get("v.amount");
		var targetAccNumber = component.get("v.targetAccountNo");
		var selectedBranchCode = component.get("v.selectedBranchCode");
		var recipientReference = component.get("v.recipientReference");
		var selectedTargetAccType = component.get("v.selectedTargetAccType");
		var myDate = component.get("v.myDate");
		var paymentRefName = component.get("v.paymentRefName");
		var accessAccount = component.get("v.accessAcc");

        var action = component.get("c.initiateFuturePayment");
		action.setParams({
			srcAccountNumber: selectedAccountNumber,
			srcAccountType: selectedProductValue,
			amount: amount,
			trgAccNumberP: targetAccNumber,
			trgBranchCodeP: selectedBranchCode,
			trgAccReferenceP: recipientReference,
			trgAccTypeP: selectedTargetAccType,
			futureDateP: myDate,
			futureSourceRef: paymentRefName,
			accessAcc: accessAccount
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var serviceResponse = response.getReturnValue();

				if (serviceResponse == "SUCCESSFUL PROCESS") {
					this.getToast("Success!", JSON.stringify(serviceResponse), "Success");
					component.set("v.showPaymentStatusSuccess", true);
					component.set("v.disableSubmitButton", true);
					component.set("v.showMakeAnotherPaymentButton", true);
					component.set("v.disablePaymentTypeSelection", true);
					component.set("v.disableChangeBenButton", true);

					//Navigate to next screen
					this.navigateToNextScreen(component, event);
				} else {
					this.getToast("Error!", "Payment Unsuccessful..  Please try again.." + serviceResponse, "Error");
					console.log(JSON.stringify(serviceResponse));
					component.set("v.disableSubmitButton", false);
					component.set("v.errorMessage", serviceResponse);
				}
			} else if (state === "ERROR") {
				this.getToast("Error!", "Service Issue .... Please try again later", "Error");
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Payment functions End

	//Navigate to the next screen
	navigateToNextScreen: function (component, event) {
		// Figure out which action was called
		var actionClicked = event.getSource().getLocalId();
		// Fire that action
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	setAddBeneficiaryFields: function (component, event) {
		var addBenFields = {
			selectedProductTypeFromFlow: component.get("v.selectedProductValue"),
			selectedAccountNumberToFlow: component.get("v.selectedAccountNumber"),
			beneficiaryName: component.get("v.recipientRefName"),
			accountNumber: component.get("v.targetAccountNo"),
			selectedBankName: component.get("v.targetBankName"),
			branchCode: component.get("v.selectedBranchCode"),
			selectedTargetAccType: component.get("v.selectedTargetAccType"),
			beneficiaryReference: component.get("v.recipientReference"),
			ownReference: component.get("v.paymentRefName"),
			respFromCIGetAccLink: component.get("v.responseToFlow")
		};

		component.set("v.addBenFieldsToFlow", JSON.stringify(addBenFields));
	},

	// Clear Fields
	clearFields: function (component, event) {
		component.set("v.showPaymentStatusError", false);
		component.set("v.myDate", null);
		component.set("v.selectedProductValue");
		component.set("v.selectedAccountNumber", null);
		component.set("v.paymentTypeOptionValue", null);
		component.set("v.selectedBranchCode", null);
		component.set("v.paymentRefName", null);
		component.set("v.targetAccNumber", null);
		component.set("v.targetAccountNo", null);
		component.set("v.paymentRefName", null);
		component.set("v.recipientReference", null);
		component.set("v.recipientRefName", null);
		//component.set("v.selectedTargetAccType",null);
		component.set("v.targetBankName", null);
		component.set("v.sendProofOfPaymentToFlow", false);
		component.set("v.showMakeAnotherPaymentButton", false);
		component.set("v.paymentTypeOptionValue", null);
		component.set("v.selectedCombiValue", null);
		component.set("v.selectedAccountBalance", null);
		component.set("v.selectedAccountDailyLimit", null);
		component.set("v.showPaymentStatusErrorMsg", null);
		component.set("v.showPaymentStatusSuccess", false);
		component.set("v.showAddBenBtn", false);
		component.set("v.disableSubmitButton", false);
		component.set("v.disablePaymentTypeSelection", false);
		component.set("v.disableChangeBenButton", false);
		component.set("v.amount", null);
	},

	submitRequest: function (component, event, helper) {
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		var selectedAccountValue = component.get("v.selectedAccountNumber");

		var action = component.get("c.getIntsructionList");
		action.setParams({
			clientAccountId: clientAccountId,
			srcAcc: selectedAccountValue
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				if (respObj != null) {
					console.log("respObj pagination list " + respObj);
					if (respObj.respDesc == "SUCCESSFUL PROCESS") {
						var paginationList = [];
						var amount = [];
						for (var key in respObj.instruction) {
							paginationList.push(respObj.instruction[key]);
						}

						component.set("v.instructionList", paginationList);
						console.log("paginationList: " + paginationList);
						console.log("paginationList size: " + paginationList.length);

						this.getToast("Success!", "Service Response Success", "success");
					} else {
						this.getToast("Error!", "UNSUCCESSFUL " + respObj.respDesc, "error");
					}
				}
			}
		});
		$A.enqueueAction(action);
	},

	GetDailyLimits: function (component, event, account) {
		var action = component.get("c.getDailyLimits");
		action.setParams({ selectedCombiNumber: account });
		action.setCallback(this, function (response) {
			console.log("getting daily limits");
			var state = response.getState();
			if (state === "SUCCESS") {
				var getDailyLimitResponse = JSON.parse(response.getReturnValue());
				console.log("message---" + JSON.stringify(getDailyLimitResponse));

				if (getDailyLimitResponse != null) {
					component.set("v.selectedAccountDailyLimit", getDailyLimitResponse.cardTrfLim);
				}
			} else if (state === "ERROR") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: "Issue with getting Daily limit .",
					type: "error"
				});
				toastEvent.fire();
			} else {
			}
		});
		$A.enqueueAction(action);
	},

	actionUpdate: function (component, event, helper) {
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		var instrNo = component.get("v.instrNo");
		var selectedAccountValue = component.get("v.selectedAccountNumber");

		var action = component.get("c.updateFuturePayment");
		action.setParams({
			clientAccountId: clientAccountId,
			instrNo: instrNo,
			amount: component.get("v.amount"),
			instrRefName: component.get("v.recipientName"),
			srcAccNumber: selectedAccountValue,
			srcAccType: component.get("v.srcAccType"),
			srcBranchCode: component.get("v.srcClrCode"),
			srcRef: component.get("v.srcStmtRef"),
			trgAccNumber: component.get("v.accountNumber"),
			trgAccType: component.get("v.trgAccType"),
			trgBranchCode: component.get("v.trgClrCode"),
			trgRef: component.get("v.reference"),
			actDate: component.get("v.updateFutureDate")
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var reponse = response.getReturnValue();
				component.set("v.updatePaymentModal", false);

				helper.getToast("Success!", reponse, "Success");
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

				//helper.getToast("Error!", message, "Error");
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: message,
					type: "Error"
				});
				toastEvent.fire();
			} else {
				//helper.getToast("Error!", message, "Error");
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: message,
					type: "Error"
				});
				toastEvent.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(action);
	},

	actionRemove: function (component, event, helper) {
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		var actionRemoveBeneficiary = component.get("c.removePayment");
		var instrNr = component.get("v.instrNo");
		actionRemoveBeneficiary.setParams({
			clientAccountId: clientAccountId,
			instrNo: instrNr
		});

		console.log("no: " + instrNr);
		// Add callback behavior for when response is received
		actionRemoveBeneficiary.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var reponseRemove = response.getReturnValue();
				component.set("v.cancelPaymentModal", false);

				helper.getToast("Success!", reponseRemove, "Success");
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

				//helper.getToast("Error!", message,"Error");
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: message,
					type: "Error"
				});
				toastEvent.fire();
			} else {
				//helper.getToast("Error!", message, "Error" );
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: message,
					type: "Error"
				});
				toastEvent.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(actionRemoveBeneficiary);
	},

	getAccountBeneficiariesHelper: function (component, event) {
		this.showSpinner(component);
		var activeCombiNumber;
		var activeCombiAccList = component.get("v.activeCombiAccList");

		if (activeCombiAccList.length > 0) {
			activeCombiNumber = activeCombiAccList[0];
		}

		if (!activeCombiNumber) {
			this.getToast("Error", "Error: No active combi card to retrieve beneficiaries from", "error");
			component.set("v.showSpinner", false);
			return;
		}

		var action = component.get("c.getEBSBeneficiaryList");
		action.setParams({
			cifKey: component.find("clientCIFFieldIDnV").get("v.value"),
			sourceAccount: activeCombiNumber
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				component.set("v.accessAcc", activeCombiNumber);
				if (
					respObj &&
					respObj.ebsBeneficiariesResponse &&
					respObj.ebsBeneficiariesResponse.MBS326O &&
					respObj.ebsBeneficiariesResponse.MBS326O.outputCopybook &&
					respObj.ebsBeneficiariesResponse.MBS326O.outputCopybook.responseDescription == "SUCCESSFUL PROCESS" &&
					respObj.ebsBeneficiariesResponse.MBS326O.outputCopybook.instructionTable &&
					respObj.ebsBeneficiariesResponse.MBS326O.outputCopybook.instructionTable.length > 0
				) {
					//Success
					var accBeneficiaryList = respObj.ebsBeneficiariesResponse.MBS326O.outputCopybook.instructionTable;

					for (var key in accBeneficiaryList) {
                        if(accBeneficiaryList[key].targetAccount){
                            accBeneficiaryList[key].targetAccount = accBeneficiaryList[key].targetAccount.replace(/^0+/, "");
                        }else{
                            accBeneficiaryList[key].targetAccount;
                        }
						accBeneficiaryList[key].ivrNominate = Number(accBeneficiaryList[key].ivrNominate).toString();
					}

					component.set("v.accBeneficiaryList", accBeneficiaryList);
					//populate search data
					var childCmp = component.find("searchBen");
					childCmp.passUnfilteredData(component, event);
				} else {
					//Fire Error Toast
					this.getToast("Error", "Error no beneficiaries found for this client", "error");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error BeneficiarySelectionApex.getBeneficiaries: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/**
	 * @ Author: Simangaliso Mathenjwa
	 *@ Date: 31 March 2021
	 *@ Work Id: W-009736
	 *@ Description: Method Get last two payments made to a selected beneficiary
	 */
	getLastTwoTransactionDetails: function (component, event, helper, uniqueEFT) {
		component.set("v.lastTwoPaymentLoading", true);
		component.set("v.lastTwoPaymentsLabel", "Fetching last two payments summary");
		var action = component.get("c.getLastTwoTransactions");
		action.setParams({
			uniqueEFT: uniqueEFT
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var paymentTable = [];
				if (
					result != null &&
					result.MBgetPaymentDetailV3Response != null &&
					result.MBgetPaymentDetailV3Response.mbp323o != null &&
					result.MBgetPaymentDetailV3Response.mbp323o.payment != null &&
					result.statusCode == 200
				) {
					paymentTable = result.MBgetPaymentDetailV3Response.mbp323o.payment;

					for (var key in paymentTable) {
						paymentTable[key].actDate = $A.localizationService.formatDate(paymentTable[key].actDate);

						if (paymentTable[key].paymTime.length <= 7) {
							paymentTable[key].paymTime = paymentTable[key].paymTime.padStart(8, "0");
						}

						paymentTable[key].paymTime =
							paymentTable[key].paymTime.substring(0, 2) +
							":" +
							paymentTable[key].paymTime.substring(2, 4) +
							":" +
							paymentTable[key].paymTime.substring(4, 6);
					}

					if (paymentTable.length == 0) {
						component.set("v.lastTwoPaymentsLabel", "No Payments");
						component.set("v.noPaymentMadeToBeneficiary", "No payments have been made to this beneficiary");
					} else if (paymentTable.length > 0) {
						component.set("v.lastTwoPaymentsLabel", "Last Two Payments");
						component.set("v.beneficiaryPaymentTable", paymentTable.slice(0, 2));
					}
				} else {
					component.set("v.lastTwoPaymentsLabel", "Error");
					component.set("v.noPaymentMadeToBeneficiary", "Encountered this error while fetching last two payments " + JSON.stringify(result.status));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getLastTwoTransactions method. Error: " + JSON.stringify(errors));
				component.set("v.lastTwoPaymentsLabel", "Error");
				component.set("v.noPaymentMadeToBeneficiary", "Encountered this error while fetching last two payments " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getLastTwoTransactions method. State: " + state);
				component.set("v.lastTwoPaymentsLabel", "Error");
				component.set("v.noPaymentMadeToBeneficiary", "Encountered an unknown error while fetching last two payments");
			}
			component.set("v.lastTwoPaymentLoading", false);
		});
		$A.enqueueAction(action);
	},

	//Utility helper function to set Attribute values on the component
	//to be used in the Payment Request flow
	//added by Danie Booysen 08/02/2021
	setProofOfPaymentAttributes: function (component, initiatePaymentResp) {
		var uiFieldsForPOP = {
			YourReference: component.get("v.paymentRefName"),
			Amount: component.get("v.amount"),
			ImmediatePayment: component.get("v.paymentTypeOptionValue") == "immediate", //(component.find("ImmediatePayment").get("v.checked"),
			RecipientRef: component.get("v.recipientReference"),
			RecipientName: component.get("v.recipientRefName")
		};
		component.set("v.uiFieldsForProofOfPaymentToFlow", JSON.stringify(uiFieldsForPOP));
		component.set("v.sendProofOfPaymentToFlow", component.get("v.sendProofOfPaymentToFlow"));
		component.set("v.mbInitiateRespToFlow", initiatePaymentResp);
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
	}
});