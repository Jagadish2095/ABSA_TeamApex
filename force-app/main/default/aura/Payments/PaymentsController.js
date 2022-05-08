({
	doInit: function (component, event, helper) {
		helper.doInit(component, event);
	},

	//Function to handle tab onselect event
	handleTabSelect: function (component, event, helper) {
		component.set("v.showForm", false);
	},

	onPOACombiSelect: function (component, event, helper) {
		helper.getCombiLinkedAccounts(component);
	},

	onLinkedAccountSelect: function (component, event, helper) {
		//get combi's linked to selected account.
		helper.getAccountDetailsByAccNo(component);
		//get beneficiaries linked to selected account
	},

	//handle active tab
	handleActiveTab: function (component, event, helper) {
		var tab = event.getSource();
		var tabId = tab.get("v.id");
		component.set("v.activeTabId", tabId);
		helper.clearFields(component, event);
		if (tabId == "absaListed") {
			component.set("v.showForm", false);
			component.set("v.hideTable", false);
		} else if (tabId == "payBeneficiary") {
			var cmpTarget = component.find("combiselection");
			$A.util.removeClass(cmpTarget, "slds-hidden");
			if(component.find("toggleLinkedAcc")){
				component.find("toggleLinkedAcc").set("v.value", false);
			}
			component.set("v.showPowerOfAttorneyPayments", false);
			component.set("v.showForm", false);
			component.set("v.hideTable", false);
		}
	},

	HandlePaymentTypeSelect: function (component, event, helper) {
		component.set("v.showForm", true);
		component.set("v.showPaymentStatusError", false);
		component.set("v.showPaymentStatusSuccess", false);
		component.set("v.showPaymentStatusErrorMsg", null);
	},

	HandleChangeBeneficiary: function (component, event, helper) {
		component.set("v.showForm", false);
		component.set("v.hideTable", false);
		component.set("v.showPaymentStatusError", false);
		component.set("v.showPaymentStatusSuccess", false);
		component.set("v.showPaymentStatusErrorMsg", null);
		component.set("v.paymentTypeOptionValue", null);
		component.set("v.disablePaymentTypeSelection", false);
		component.set("v.selectedProductValue", null);
	},

	//Function to get Account numbers on Product Type selection
	getAccountNumbers: function (component, event, helper) {
		var selectedProdType = component.get("v.selectedProductValue");
		var respObj = component.get("v.responseList");
		var acc = [];
		for (var key in respObj) {
			if (respObj[key].productType == selectedProdType) {
				respObj[key].oaccntnbr = respObj[key].oaccntnbr.replace(/^0+/, "");
				acc.push(respObj[key].oaccntnbr);
			}
		}

		component.set("v.accNumList", acc);
	},

	//Function to get Account Limits and set branch code on account selection
	getSelectedAccount: function (component, event, helper) {
		var selectedAccountValue = component.get("v.selectedAccountNumber");
		var accBranchCode;
		var respObj = component.get("v.responseList");
		var accBalance;
		component.set("v.selectedAccountNumberToFlow", selectedAccountValue);

		for (var key in respObj) {
			if (respObj[key].oaccntnbr == selectedAccountValue) {
				accBranchCode = respObj[key].branch;
				accBalance = respObj[key].availableBalance;
			}
		}

		component.set("v.selectedProductBranch", accBranchCode);
		component.set("v.selectedAccountBalance", accBalance);

		if (component.get("v.activeTabId") == "onceOffPayment") {
			component.set("v.selectedTargetAccType", "Cheque");
		}

		//showTable Cancel/Update Future payment table
		if (component.get("v.activeTabId") == "cancelUpdateFuturePayment") {
			component.set("v.showForm", false);
			component.set("v.hideTable", false);
			component.set("v.showUpdatePayment", true);
			component.set("v.showViewDataBtn", true);
			helper.submitRequest(component, event, helper);

			//Check the Daily Bank account Limit
			helper.GetDailyLimits(component, event, selectedAccountValue);
		}
	},

	togglePOAView: function (component, event, helper) {
		var cmpTarget = component.find("combiselection");
		if (event.getSource().get("v.value")) {
			component.set("v.showPowerOfAttorneyPayments", true);
			component.find("linkedAccId").set("v.disabled", true);
			component.find("linkedCombiId").set("v.disabled", true);

			$A.util.addClass(cmpTarget, "slds-hidden");
		} else {
			component.set("v.showPowerOfAttorneyPayments", false);

			$A.util.removeClass(cmpTarget, "slds-hidden");
		}
	},

	//Get Beneficiaries linked to the select combi card
	onSelectCombiAccount: function (component, event, helper) {
		component.set("v.accBeneficiaryList", null);

		helper.getAccountBeneficiariesHelper(component, event);
		if (component.get("v.activeTabId") == "payBeneficiary") {
			component.set("v.showTable", true);
		}
	},

	//function to show beneficiary Table for selecting a different beneficiary
	MakeAnotherPayment: function (component, event, helper) {
		component.set("v.disableSubmitButton", false);
		component.set("v.showPaymentStatusError", false);
		component.set("v.showPaymentStatusSuccess", false);
		component.set("v.showPaymentStatusErrorMsg", null);
		component.set("v.disablePaymentTypeSelection", false);
		component.set("v.disableChangeBenButton", true);
		component.set("v.disableChangeBenButton", false);
		component.set("v.showAddBenBtn", false);
	},

	/*call dateUpdate function on onchange event on date field*/
	dateUpdate: function (component, event, helper) {
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
		if (component.get("v.myDate") != "" && component.get("v.myDate") < todayFormattedDate) {
			component.set("v.dateValidationError", true);
			console.log("Inside true mydate" + component.get("v.myDate"));
		} else {
			component.set("v.dateValidationError", false);
			console.log("Inside false mydate" + component.get("v.myDate"));
		}
	},

	//This function will handle Absa listed beneficiary event
	handleEvent: function (component, event, helper) {
		//get the Selected Absa listed Event beneficiary record
		var selectedAbsaListedBen = event.getParam("record_event");

		//set form fields
		component.set("v.selectedRecord", selectedAbsaListedBen);
		component.set("v.selectedBranchCode", selectedAbsaListedBen.BranchCode__c);
		component.set("v.targetAccountNo", selectedAbsaListedBen.Beneficiary_Account_Number__c);
		component.set("v.recipientRefName", selectedAbsaListedBen.Name);
		component.set("v.selectedTargetAccType", "Cheque");
		component.set("v.hideTable", true);
	},

	// This function handles SelectedBeneficiaryEvent event on beneficiary selection
	handleSelectBeneficiaryEvent: function (component, event, helper) {
		//get the beneficiary record record from the event
		var selectedBeneficiary = event.getParam("beneficiaryEventRecord");

		//Set Beneficiary fields
		component.set("v.selectedBenRecord", selectedBeneficiary);
		component.set("v.targetBankName", selectedBeneficiary.targetInstCode);
		component.set("v.targetAccountNo", selectedBeneficiary.targetAccount);
		component.set("v.paymentRefName", selectedBeneficiary.sourceStatementRef);
		component.set("v.selectedBranchCode", selectedBeneficiary.targetClrCode);
		component.set("v.recipientReference", selectedBeneficiary.targetStatementRef);
		component.set("v.recipientRefName", selectedBeneficiary.sourceStatementRef);
		component.set("v.instructionNumber", selectedBeneficiary.instrNumber);
		component.set("v.selectedTargetAccType", selectedBeneficiary.targetAccountType);
		component.set("v.ivrNominate", selectedBeneficiary.ivrNominate);
        component.set("v.selectedBenTIEBVal", selectedBeneficiary.tieb);//Added by chandra dated 12/01/2022
        
        //Get the last two payments made to to the beneficiary
		helper.getLastTwoTransactionDetails(component, event, helper, selectedBeneficiary.uniqueEFT);
		component.set("v.hideTable", true);
	},

	//Submit Payment function
	SubmitPayment: function (component, event, helper) {
		var paymentOption = component.get("v.activeTabId");

		if (paymentOption == "absaListed") {
			helper.ValidateAbsaListed(component, event);
		} else if (paymentOption == "onceOffPayment") {
			helper.ValidateOnceOffPayment(component, event);
		} else if (paymentOption == "payBeneficiary") {
			helper.ValidatePayBeneficiary(component, event);
		}
	},

	//Cancel/Update future Payment Functions - Start
	handleClickUpdate: function (component, event, helper) {
		var selectedRec = event.getSource().get("v.value");
		component.set("v.updatePaymentModal", true);
		component.set("v.amount", selectedRec.amount);
		component.set("v.recipientName", selectedRec.sourceStatementRef);
		component.set("v.accountNumber", selectedRec.trgAcc);
		component.set("v.srcAccType", selectedRec.srcAccType);
		component.set("v.instrNo", selectedRec.instrNo);
		component.set("v.srcClrCode", selectedRec.srcClrCode);
		component.set("v.srcStmtRef", selectedRec.srcStmtRef);
		component.set("v.trgAccType", selectedRec.trgAccType);
		component.set("v.reference", selectedRec.trgStmtRef);
		component.set("v.trgClrCode", selectedRec.trgClrCode);
		component.set("v.actDate", selectedRec.actDate);
	},

	handleClickRemove: function (component, event, helper) {
		var selectedRec = event.getSource().get("v.value");
		component.set("v.cancelPaymentModal", true);
		component.set("v.instrNo", selectedRec.instrNo);
		console.log("insr: " + component.get("v.instrNo"));
	},

	cancel: function (component, event, helper) {
		component.set("v.updatePaymentModal", false);
		component.set("v.cancelPaymentModal", false);
	},

	actionUpdate: function (component, event, helper) {
		var amount = component.find("amountId").get("v.value");
		var name = component.find("recipientNameId").get("v.value");
		var accountNo = component.find("accountNumberId").get("v.value");
		var reference = component.find("referenceId").get("v.value");
		var actDate = component.find("actDateId").get("v.value");

		if (amount == "" || amount == null) {
			helper.getToast("Error", "Amount Cannot Be Blank.", "error");
		} else if (name == "" || name == null) {
			//helper.getToast("Error", "Recipient name Cannot Be Blank.", "error");
		} else if (accountNo == "" || accountNo == null) {
			helper.getToast("Error", "Account number Cannot Be Blank.", "error");
		} else if (reference == "" || reference == null) {
			helper.getToast("Error", "Reference Cannot Be Blank.", "error");
		} else if (actDate == "" || actDate == null) {
			helper.getToast("Error", "Date Cannot Be Blank.", "error");
		} else {
			helper.actionUpdate(component, event);
		}
		helper.submitRequest(component, event, helper);
	},

	actionRemove: function (component, event, helper) {
		helper.actionRemove(component, event);
	},

	//This function refreshes table data on the Update/Cancel Future Payment Table
	onViewData: function (component, event, helper) {
		helper.submitRequest(component, event);
	},

	/*call dateUpdate function on onchange event on date field*/
	onUpdateFutureDate: function (component, event, helper) {
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
		if (component.get("v.updateFutureDate") != "" && component.get("v.updateFutureDate") < todayFormattedDate) {
			component.set("v.FutureDateValidationError", true);
			console.log("Inside true mydate" + component.get("v.updateFutureDate"));
		} else {
			component.set("v.FutureDateValidationError", false);
			console.log("Inside false mydate" + component.get("v.updateFutureDate"));
		}
	},
	//Cancel/Update future Payment Functions - End

	//Open Add Beneficiary Function
	openAddBeneficiaryModal: function (component, event, helper) {
		component.set("v.showAddBeneficiary", true);
	},

	//Close Open Beneficiary function
	closeAddBeneficiarayModal: function (component, event, helper) {
		component.set("v.showAddBeneficiary", false);
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function called when clientIDnVObjectParent attribute value changes
	//closes case
	handleObjectChange: function (component, event, helper) {
		var cacheObject = component.get("v.clientIDnVObjectParent");
		if (!cacheObject) {
			helper.showSpinner(component);
			//Close case
			component.find("statusFieldIDnV").set("v.value", "Closed");
			component.find("caseEditFormIDnV").submit();
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to set attributes once the caseEditFormIDnV has loaded
	handleCaseLoadIDnV: function (component, event, helper) {
		var serviceGroupsPollingAllowed = $A.get("$Label.c.Client_IDnV_Polling_Service_Groups");

		var currentServiceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
		if (serviceGroupsPollingAllowed.includes(currentServiceGroup)) {
			component.set("v.clientCifCodeParent", component.find("clientCIFFieldIDnV").get("v.value"));
			component.set("v.allowClientIDnVPolling", true);
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to execute when the caseEditFormIDnV save is successful
	handleCaseSuccessIDnV: function (component, event, helper) {
		var caseNumber = component.find("caseNumberFieldIDnV").get("v.value");
		var cifNumber = component.find("clientCIFFieldIDnV").get("v.value");
		helper.fireStickyToast("Error!", "Call dropped. Case number: " + caseNumber + " was auto closed for the client with CIF: " + cifNumber, "error");
		helper.hideSpinner(component);

		//Close the case subTab to go to the previous consultants' view
		var workspaceAPI = component.find("workspace");
		workspaceAPI
			.getFocusedTabInfo()
			.then(function (response) {
				var focusedTabId = response.tabId;
				workspaceAPI.closeTab({ tabId: focusedTabId });
			})
			.catch(function (error) {
				console.log("PaymentsController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	}
});