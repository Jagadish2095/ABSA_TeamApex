({
	doInit: function (component, event, helper) {
		/*  Added by : Humbelani Denge
		 *  Date : 2021/01/18
		 *  Initialize Transaction history table columns.
		 */
		component.set("v.columns", [
			{ label: "Date", fieldName: "Processing_Date__c", type: "date" },
			{ label: "Amount", fieldName: "Transaction_Amount__c", type: "text" },
			{ label: "Balance", fieldName: "Balance_After_Transaction__c", type: "text" },
			{ label: "Trans Fee", fieldName: "Transaction_Cost__c", type: "text" },
			{ label: "Type", fieldName: "Transaction_Type__c", type: "text" },
			{ label: "Desc 1", fieldName: "Description1__c", type: "text" },
			{ label: "Desc 2", fieldName: "Description2__c", type: "text" }
		]);

		var opts = [];
		opts.push({
			class: "optionClass",
			label: "DATA PURCHASE",
			value: "DATA PURCHASE"
		});
		opts.push({
			class: "optionClass",
			label: "ADMIN CHARGE",
			value: "ADMIN CHARGE"
		});
		opts.push({
			class: "optionClass",
			label: "AIRTIME PURCHASE",
			value: "AIRTIME PURCHASE"
		});
		opts.push({
			class: "optionClass",
			label: "MONTHLY ACC FEE",
			value: "MONTHLY ACC FEE"
		});
		opts.push({
			class: "optionClass",
			label: "IMMEDIATE TRF DT",
			value: "IMMEDIATE TRF DT"
		});

		component.set("v.descrTypeoptions", opts);

		//Set the default 3 month transaction window
		var d = new Date();
		d.setMonth(d.getMonth() - 2);
		component.set(
			"v.fromDate",
			d.getFullYear() + "-" + ((d.getMonth() < 10 ? "0" : "") + d.getMonth()) + "-" + (d.getDate() < 10 ? "0" : "") + d.getDate()
		);

		var d = new Date();
		component.set("v.toDate", d.getFullYear() + "-"  + ((d.getMonth() + 1 < 10 ? "0" : "") + parseInt(d.getMonth() + 1)) + "-" + (d.getDate() < 10 ? "0" : "")  + d.getDate()); //W-017161: Hloni Matsoso
		
		var action = component.get("c.getAccountDetails");
		var clientAccountId = component.get("v.clientAccountIdFromFlow");

		action.setParams({ clientAccountId: clientAccountId });

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				console.log("respobj" + respObj);
				component.set("v.responseList", respObj);

				//**New Code added  **
				var selectedAccountValue = component.get("v.selectedAccountNumber");
				var respObj = component.get("v.responseList");
				var accBalance;
				for (var key in respObj) {
					if (respObj[key].oaccntnbr == selectedAccountValue) {
						accBalance = respObj[key].availableBalance;
					}
				}
				console.log("Accbal:" + accBalance);
				component.set("v.selectedAccountBalance", accBalance);
				//** New Code Ends **

				var prodList = [];
				var prodSet = new Set();

				for (var key in respObj) {
					if (!prodList.includes(respObj[key].productType)) {
						prodList.push(respObj[key].productType);
					}
				}
				component.set("v.prodTypesList", prodList);
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.fireToast("Error!", "Service Issue:" + JSON.stringify(errors[0].message), "Error");
			} else {
			}
		});

		$A.enqueueAction(action);

		//Todate equals to Todays date
		var today = new Date();
        component.set("v.toDate1", today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

		// Fromdate equal to Todays date minus 120
		var result = new Date();
		result.setDate(result.getDate() - 120);
		component.set("v.fromDate1", result.getFullYear() + "-" + (result.getMonth() + 1) + "-" + result.getDate());
	},

	getAccountNumbers: function (component, event, helper) {
		var selectedProdType = component.get("v.selectedProductValue");
		var respObj = component.get("v.responseList");

		var acc = [];

		for (var key in respObj) {
			if (respObj[key].productType == selectedProdType) {
				acc.push(respObj[key].oaccntnbr);
			}
		}
		component.set("v.accNumList", acc);
	},

	getSelectedAccount: function (component, event, helper) {
		var selectedAccountValue = component.get("v.selectedAccountNumber");

		component.set("v.selectedAccountNumberToFlow", selectedAccountValue);

		var respObj = component.get("v.responseList");
		var accBalance;
		for (var key in respObj) {
			if (respObj[key].oaccntnbr == selectedAccountValue) {
				accBalance = respObj[key].availableBalance;
			}
		}

		component.set("v.selectedAccountBalance", accBalance);
	},

	dispTransactionHistory: function (component, event, helper) {
		var fDate = component.find("fDate").get("v.value");
		var tDate = component.find("tDate").get("v.value");
	},

	loadTransactionData: function (component, event, helper) {
		helper.showSpinner(component);

		component.set("v.showForm", false);

		var accountNumber = component.get("v.selectedAccountNumber");
		var fdate = component.get("v.fromDate");
		var tdate = component.get("v.toDate");

		var action = component.get("c.loadTransactions");

		action.setParams({
			pAccountNumber: accountNumber,
			fromDate: fdate,
			toDate: tdate
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var responseBean = result["responseBean"];
				var transactionData = result["filteredTransactions"];
				component.set("v.transactionData", transactionData);
				component.set("v.transactionHistoryResp", responseBean[0]);
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.fireToast(
					"Error",
					"There was an error retrieving a list of transaction history for this account : " + JSON.stringify(errors[0].message),
					"error"
				);
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	filterTransactionData: function (component, event, helper) {
		//RN Update method
		//Load transcation data with a 3 month window
		helper.showSpinner(component);

		var filterIIPRef = component.get("v.iipRefNo");
		var filterPayDate = component.get("v.iipPayDate");
		var filterData = component.get("v.data");
		var filterAdmin = component.get("v.admin");
		var filterAirtime = component.get("v.airtime");
		var filterAccFee = component.get("v.accFee");
		var filterImmediate = component.get("v.immediateDT");

		var action = component.get("c.filterTransactions");

		action.setParams({
			iipRefNo: filterIIPRef,
			payDate: filterPayDate,
			data: filterData,
			admin: filterAdmin,
			airtime: filterAirtime,
			accFee: filterAccFee,
			immediateDT: filterImmediate
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var result = response.getReturnValue();

				component.set("v.transactionData", result);

				helper.hideSpinner(component);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("sticky", "Error retrieving transaction list : " + JSON.stringify(errors[0].message), "error");
					}
				}
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	transactionHistory: function (component, event) {
		component.set("v.showDataTable", true);
		component.set("v.showFilter", true);

		var action = component.get("c.viewTransactionHistory");
		var selectedAccountNumber = component.get("v.selectedAccountNumber");

		var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		component.set("v.todaysDate", today);

		// endDate set to Todays date
		var today = new Date();
		component.set('v.max="{!v.todaysDate}"', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());

		// Fromdate equal to Todays date minus 30
		var result = new Date();
		result.setDate(result.getDate() - 30);
		component.set("v.fromDate", result.getFullYear() + "-" + (result.getMonth() + 1) + "-" + result.getDate());

		action.setParams({ accountNumberP: selectedAccountNumber, fromDateP: fromdate, toDateP: todate });

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());

				component.set("v.viewTransactionList", respObj);
				component.set("v.columns", [
					{ label: "DATE", fieldName: "processingDate", type: "text" },
					{ label: "AMOUNT", fieldName: "tranAmount", type: "text", sortable: true },
					{ label: "BALANCE", fieldName: "balAfterTran", type: "text", sortable: true },
					{ label: "DESCRIPTION", fieldName: "description1", type: "text", sortable: true }
				]);

				if (respObj.respCode == "47" && respObj.statementDetails == "") {
					helper.fireToast("Error!", "Please select valid Check or Savings Account Number", "Error");
				} else if (respObj.statementDetails == "") {
					helper.fireToast("Error!", "There are currently no transactions available to display.", "error");
				}
			}
		});

		$A.enqueueAction(action);
	},

	updateColumnSorting: function (component, event, helper) {
		var fieldName = event.getParam("fieldName");
		var sortDirection = event.getParam("sortDirection");
		// assign the latest attribute with the sorted column fieldName and sorted direction
		component.set("v.sortedBy", fieldName);
		component.set("v.sortedDirection", sortDirection);
		helper.sortData(component, fieldName, sortDirection);
	},

	filterTrData: function (component, event, helper) {
		var data = component.get("v.viewTransactionList.statementDetails"),
			//console.log('Data :'+data);

			term = component.get("v.filterTr"),
			//console.log('Term :'+term);
			results = data,
			regex;

		regex = new RegExp(term, "i");

		// filter checks each row, constructs new array where function returns true
		console.log("Results  : " + term + results);
		if (results != null) {
			results = data.filter((row) => regex.test(row.description1));
			console.log("Check term : " + term + data);
		}
		if (term != "" && data != null) {
			component.set("v.viewTransactionList.statementDetails", results);
		} else {
			if (term === "" && data === null) {
				this.transactionHistory(component);
			}
		}
	},

	handleIIPCheck: function (component, event, helper) {
		var isChecked = component.find("iipFilter").get("v.checked");
		component.set("v.iipChecked", isChecked);
	},

	handleTypeCheck: function (component, event, helper) {
		var isChecked = component.find("typeFilter").get("v.checked");
		component.set("v.typeChecked", isChecked);
	},

	handleCheckboxFilter: function (component, event, helper) {
		if (component.find("iData").get("v.checked")) {
			component.set("v.data", component.find("iData").get("v.value"));
		} else {
			component.set("v.data", "");
		}
		if (component.find("iAdmin").get("v.checked")) {
			component.set("v.admin", component.find("iAdmin").get("v.value"));
		} else {
			component.set("v.admin", "");
		}
		if (component.find("iAirtime").get("v.checked")) {
			component.set("v.airtime", component.find("iAirtime").get("v.value"));
		} else {
			component.set("v.airtime", "");
		}
		if (component.find("iAccFee").get("v.checked")) {
			component.set("v.accFee", component.find("iAccFee").get("v.value"));
		} else {
			component.set("v.accFee", "");
		}
		if (component.find("iImmediate").get("v.checked")) {
			component.set("v.immediateDT", component.find("iImmediate").get("v.value"));
		} else {
			component.set("v.immediateDT", "");
		}
	},

	closeCase: function (component, event, helper) {
		helper.showSpinner(component);

		component.find("caseStatusFieldModal").set("v.value", "Closed");
		component.find("caseEditFormModal").submit();
		helper.hideSpinner(component);
	},

	//Humbelani Denge. 2021/04/09
	//function to handle the post load actions of the caseEditFormModal
	handleAccountLoadModal: function (component, event, helper) {
		if (component.get("v.isBusinessAccountFromFlow") == "No") {
			//Non business account
			component.set("v.clientEmailAddress", component.find("personEmailFieldModal").get("v.value"));
		} else {
			//Business account
			component.set("v.clientEmailAddress", component.find("activeEmailFieldModal").get("v.value"));
		}
	},

	openModal: function (component, event, helper) {
		component.set("v.showModal", true);
	},

	closeModal: function (component, event, helper) {
		component.set("v.showModal", false);
	},

	sendEmailCloseCase: function (component, event, helper) {
		if (!component.get("v.clientEmailAddress")) {
			helper.fireToast("error", "Email not populated!", "error");
			return;
		} else {
			helper.sendTransactionListHelper(component, event, helper);
		}
	},

	//function to handle the actions of the caseEditFormModal when successfully saved
	handleCaseSuccessModal: function (component, event, helper) {
		helper.fireToast("Success", "Case Closed Successfully", "success");
		component.set("v.showModal", false);
	}
});