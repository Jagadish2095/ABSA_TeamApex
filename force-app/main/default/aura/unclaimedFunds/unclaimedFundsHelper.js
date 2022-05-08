/**
 * Unclaimed funds wizard helper
 * @Author: Mbuyiseni Mbhokane
 * @Since: 20/10/2020
 */
({
	//GET CUSTOMER ACCOUNTS
	getCustomerAccounts: function (component, event, helper) {
		this.showSpinner(component);
		component.set("v.productColumns", [
			{ label: "Product", fieldName: "product", type: "text" },
			{ label: "Account Number", fieldName: "oaccntnbr", type: "text" },
			{ label: "Status", fieldName: "status", type: "text" },
			{ label: "Balance", fieldName: "balance", type: "text" },
			{ label: "Available Balance", fieldName: "availableBalance", type: "text" }
		]);

		var action = component.get("c.getAccountLinkedToClient");
		console.log("account Id " + component.get("v.accountRecordId"));

		//Hardcoded the record Id of account with CIF number and account linked to it
		action.setParams({ clientAccountId: component.get("v.accountRecordId") /*'0010E00000z15buQAA'*/ });
		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("State: " + state);
			console.log("response: " + JSON.stringify(response));
			if (state === "SUCCESS") {
				var relatedAccounts = response.getReturnValue();
				console.log("Client returned Accounts : " + relatedAccounts);
				var clientAccounts = JSON.parse(relatedAccounts);
				console.log("Customer accounts : " + clientAccounts);

				if (clientAccounts != null) {
					var filteredClientAccounts = clientAccounts
						.filter(function (acc) {
							return (acc.productType == "SA" || acc.productType == "CQ") && acc.status != "CLOSED";
						})
						.sort(function (amount1, amount2) {
							return amount2.balance - amount1.balance;
						});

					if (filteredClientAccounts.length > 0) {
						console.log("Filtered Data: " + JSON.stringify(filteredClientAccounts));
						component.set("v.showClientAccounts", true);
						component.set("v.customerAccountDetails", filteredClientAccounts);
						this.accpreparePagination(component, component.get("v.customerAccountDetails"));
					} else {
						component.set("v.showScript", true);
						var toast = this.getToast("Error", "Client doesnt have ACTIVE accounts", "Error");
						toast.fire();
					}

					//filter another list of account for Display purposes
					var filteredClientAccountsForView = clientAccounts.filter(function (accView) {
						return (accView.productType == "CS" || accView.productType == "LX" || accView.productType == "PL") && accView.status != "CLOSED";
					});

					if (filteredClientAccountsForView.length > 0) {
						console.log("filteredClientAccountsForView: " + filteredClientAccountsForView);
						component.set("v.showClientOtherAccounts", true);
						component.set("v.viewCustomerAccountDetails", filteredClientAccountsForView);
						this.preparePagination(component, component.get("v.viewCustomerAccountDetails"));
					}
				} else {
					console.log("NO PRODUCTS RETURNED!!! " + clientAccounts);
					component.set("v.showScript", true);
					var toast = this.getToast("Error", "NO PRODUCTS RETURNED!!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				component.set("v.showScript", true);
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/**
	 * START OF THE CHEQUE ACCOUNT HOLDS SERVICES
	 * ADDED BY: MBUYISENI MBHOKANE
	 */

	//VIEW SELECTED CHEQUE ACCOUNT HOLD DETAILS
	chequeViewAccount: function (component, event, helper) {
		this.showSpinner(component);
		console.log("account number: " + component.get("v.selectedAccountNumber"));
		var action = component.get("c.viewHoldsOnchequeAccount");
		action.setParams({ accountNumberP: component.get("v.selectedAccountNumber") /*'4048017641'*/ });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var viewChequeAccount = response.getReturnValue();
				var modifiedResponse = JSON.parse(viewChequeAccount);
				console.log("chequeViewAccount: viewChequeAccount: " + viewChequeAccount);
				console.log("chequeViewAccount: modifiedResponse: " + modifiedResponse);
				if (modifiedResponse != null) {
					console.log("CQ Message: " + JSON.stringify(modifiedResponse.msgTxt));
					if (modifiedResponse.msgTxt == null) {
						component.set("v.viewChequeAccountDetails", modifiedResponse);
						console.log("SET Data: " + component.get("v.viewChequeAccountDetails"));
						if (!$A.util.isEmpty(component.get("v.viewChequeAccountDetails"))) {
							this.chequeDigitalHold(component, event, helper);
						}
					} else {
						var toast = this.getToast("Error", modifiedResponse.msgTxt, "Error");
						toast.fire();
					}
				} else {
					console.log("NO DATA RETURNED!!!");
					var toast = this.getToast("Error", "NO DATA RETURNED FROM THE SERVER!!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//BLOCK CHEQUE ACCOUNT
	chequeDigitalHold: function (component, event, helper) {
		var viewChequeAccountResponse = component.get("v.viewChequeAccountDetails");
		console.log("hold indicator: " + component.get("v.holdIndicator"));
		console.log("viewChequeAccountResponse: " + viewChequeAccountResponse);
		console.log("viewChequeAccountResponse.accountNbrOut: " + viewChequeAccountResponse.accountNbrOut);
		console.log("viewChequeAccountResponse.blocked: " + viewChequeAccountResponse.blocked);

		var action = component.get("c.cqUpdateHolds");
		action.setParams({
			accountNumber: component.get("v.selectedAccountNumber"), //'4048017641',//viewChequeAccountResponse.accountNbrOut,
			blocked: component.get("v.holdIndicator"),
			courtOrder: viewChequeAccountResponse.courtOrder,
			mandateRequired: viewChequeAccountResponse.mandateRequired,
			dormant: viewChequeAccountResponse.dormant,
			semiDormant: viewChequeAccountResponse.semiDormant,
			confiscated: viewChequeAccountResponse.confiscated,
			externalTransfer: viewChequeAccountResponse.externalTransfer,
			staff: viewChequeAccountResponse.staff,
			creditAccount: viewChequeAccountResponse.creditAccount,
			excludeFromEstate: viewChequeAccountResponse.excludeFromEstate,
			blockAdhocDbt: viewChequeAccountResponse.blockAdhocDbt,
			blockAdhocCrd: viewChequeAccountResponse.blockAdhocCrd,
			specialRqpRedirect: viewChequeAccountResponse.specialRqpRedirect,
			commercialPropFin: viewChequeAccountResponse.commercialPropFin,
			misHold: viewChequeAccountResponse.misHold,
			genSecMsg: viewChequeAccountResponse.genSecMsg,
			wapWildAccPickup: viewChequeAccountResponse.wapWildAccPickup,
			exclFromInsolvent: viewChequeAccountResponse.exclFromInsolvent,
			digitalHold: viewChequeAccountResponse.digitalHold,
			odSwitchInd: viewChequeAccountResponse.odSwitchInd
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var chequeHoldData = response.getReturnValue();
				console.log("cqUpdate Raw Data: " + chequeHoldData);
				if (chequeHoldData != null) {
					if (chequeHoldData.startsWith("BLCKD-A/C")) {
						var toast = this.getToast("Success", JSON.stringify(chequeHoldData), "Success");
						toast.fire();
					} else {
						var toast = this.getToast("Error", JSON.stringify(chequeHoldData), "Error");
						toast.fire();
					}
				} else {
					var toast = this.getToast("Error", "Empty Response was returned from the Server", "Error");
					toast.fire();
				}
			} else {
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	},

	/**
	 * START OF THE SAVINGS ACCOUNT HOLDS SERVICES
	 * ADDED BY: MBUYISENI MBHOKANE
	 */

	//VIEW SELECTED SAVINGS ACCOUNT HOLD DETAILS:
	savingsViewAccount: function (component, event, helper) {
		this.showSpinner(component);
		console.log("selected Account Number: " + component.get("v.selectedAccountNumber"));
		var action = component.get("c.viewHoldsOnSavingsAccount");
		action.setParams({ accountNumberP: component.get("v.selectedAccountNumber") /*'9050986380'*/ });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				if (response != null) {
					var viewSavingsAccount = response.getReturnValue();
					console.log("SV Message: " + viewSavingsAccount.msgTxt);
					if (viewSavingsAccount.msgTxt == null) {
						component.set("v.viewSavingsAccountDetails", JSON.parse(viewSavingsAccount));
						console.log("SET SAVINGS VALUES: " + component.get("v.viewSavingsAccountDetails"));
						console.log("SET SAVINGS VALUES: " + component.get("v.viewSavingsAccountDetails.frozenInd"));
						if (!$A.util.isEmpty(component.get("v.viewSavingsAccountDetails"))) {
							this.savingsDigitalHold(component, event, helper);
						}
					} else {
						console.log("Savings Customer Account Holds : " + JSON.stringify(viewSavingsAccount.msgTxt));
						var toast = this.getToast("Error", JSON.stringify(viewSavingsAccount.msgTxt), "Error");
						toast.fire();
					}
				} else {
					console.log("NOT RESPONSE RETURNED!!!!");
					var toast = this.getToast("Error", "NOT RESPONSE RETURNED!!!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//FREEZE THE SAVINGS ACCOUNT
	savingsDigitalHold: function (component, event, helper) {
		var viewSavingsAccountResponse = component.get("v.viewSavingsAccountDetails");
		console.log("viewSavingsAccountResponse.frozenInd: " + viewSavingsAccountResponse.frozenInd);
		console.log("viewSavingsAccountResponse.securityNbr: " + viewSavingsAccountResponse.securityNbr);
		console.log("viewSavingsAccountResponse.offlEnqFrDate: " + viewSavingsAccountResponse.offlEnqFrDate);
		console.log("viewSavingsAccountResponse.holdIndicator: " + component.get("v.holdIndicator"));
		var action = component.get("c.svUpdateHolds");
		action.setParams({
			accountNumber: component.get("v.selectedAccountNumber"),
			frozenInd: component.get("v.holdIndicator"),
			stoppedInd: viewSavingsAccountResponse.stoppedInd,
			dormantInd: viewSavingsAccountResponse.dormantInd,
			semiDormantInd: viewSavingsAccountResponse.semiDormantInd,
			exclEstateInd: viewSavingsAccountResponse.exclEstateInd,
			exclInslvntInd: viewSavingsAccountResponse.exclInslvntInd,
			courtOrderInd: viewSavingsAccountResponse.courtOrderInd,
			signingAuthInd: viewSavingsAccountResponse.signingAuthInd,
			monitorActivityInd: viewSavingsAccountResponse.monitorActivityInd,
			potBadDebtInd: viewSavingsAccountResponse.potBadDebtInd,
			legalActionInd: viewSavingsAccountResponse.legalActionInd,
			nonResidentInd: viewSavingsAccountResponse.nonResidentInd,
			lostBookInd: viewSavingsAccountResponse.lostBookInd,
			blockedInd: viewSavingsAccountResponse.blockedInd,
			offlineEnqInd: viewSavingsAccountResponse.offlineEnqInd,
			securityMessageInd: viewSavingsAccountResponse.securityMessageInd,
			restricHoldInd: viewSavingsAccountResponse.restricHoldInd,
			exceedMaxBalInd: viewSavingsAccountResponse.exceedMaxBalInd,
			wtiCountry: viewSavingsAccountResponse.wtiCountry,
			rbaEddHold: viewSavingsAccountResponse.rbaEddHold
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var savingsHoldData = response.getReturnValue();
				console.log("Savings Digital Hold Data : " + JSON.stringify(savingsHoldData));
				if (savingsHoldData != null) {
					if (savingsHoldData == "IMPOSE" || savingsHoldData == "RELEASE") {
						var toast = this.getToast("Success", JSON.stringify(savingsHoldData), "Success");
						toast.fire();
					} else {
						var toast = this.getToast("Error", JSON.stringify(savingsHoldData), "Error");
						toast.fire();
					}
				} else {
					console.log("NO DATA RETURNED FROM THE SERVER!!!");
					var toast = this.getToast("Error", "NO DATA RETURNED FROM THE SERVER!!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	},

	//GET CHEQUE CLOSE ACCOUNT DETAILS
	cqCloseAccountDetails: function (component, event, helper) {
		this.showSpinner(component);
		console.log("account number: " + component.get("v.selectedAccountNumber"));
		console.log("cqCloseAccountDetails: BEFORE CALLING : cqGetCloseAccDetails");
		var action = component.get("c.cqGetCloseAccDetails");
		action.setParams({
			CQS534I_ACCOUNT_NBR: component.get("v.selectedAccountNumber") /*'00000001404560073'*/,
			CQS534I_EFFECTIVE_CLSD_DATE: "20201120"
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var getCloseAccountDetails = response.getReturnValue();
				component.set("v.chequeAccountClosureDetails", getCloseAccountDetails);
				var formattedGetCloseAccDetails = JSON.parse(getCloseAccountDetails);
				console.log("Close Account Details: " + getCloseAccountDetails);
				console.log("Formatted Close Account Details: " + formattedGetCloseAccDetails);
				if (formattedGetCloseAccDetails != null) {
					if (formattedGetCloseAccDetails.statusCode == 200) {
						//breaking down the response to make code readable

						var messageResponse = formattedGetCloseAccDetails.NBSMSGO3;
						console.log("cqCloseAccountDetails: messageResponse : " + messageResponse);
						var closeAccountDetails = formattedGetCloseAccDetails.CQS534O;
						console.log("cqCloseAccountDetails: closeAccountDetails : " + closeAccountDetails);
						var accountHolds =
							formattedGetCloseAccDetails.CQS534O != null ? formattedGetCloseAccDetails.CQS534O.CQS534O_TABLE_I.CQS534O_LINE_I : ""; //will be used for validation.
						console.log("cqCloseAccountDetails : accountHolds : " + accountHolds);

						//filter the account holds (may be used for routing the case to another team)
						if (accountHolds.length > 0) {
							var filteredAccountHolds = accountHolds.filter(function (accountHold) {
								return accountHold.CQS534O_ACCOUNT_HOLDS != "";
							});

							console.log("filteredAccountHolds: " + JSON.stringify(filteredAccountHolds));
							//set the account holds attribute
						}

						if (messageResponse.NBNMSGO3_NBR_USER_MSGS == 0) {
							//console.log('closeAccountDetails : ' + JSON.stringify(closeAccountDetails));
							//component.set('v.closeAccountDetails', closeAccountDetails);

							// set values to be displed to the UI (should there be a need to display more details then we can use list attribute to set the response)
							console.log("Account Number : " + closeAccountDetails.CQS534O_ACCOUNT_NBR_OUT);
							component.set("v.closeAccountNumber", closeAccountDetails.CQS534O_ACCOUNT_NBR_OUT);
							console.log("Closure Amount : " + closeAccountDetails.CQS534O_CLOSURE_AMTS);
							component.set("v.closureAmount", closeAccountDetails.CQS534O_CLOSURE_AMTS);
							console.log("Account Name : " + closeAccountDetails.CQS534O_ACCOUNT_NAME);
							component.set("v.closeAccountName", closeAccountDetails.CQS534O_ACCOUNT_NAME);
							console.log("Current Balance : " + closeAccountDetails.CQS534O_CURRENT_BAL);
							component.set("v.closureCurrentBalance", closeAccountDetails.CQS534O_CURRENT_BAL);
						} else {
							console.log("messageResponse : " + JSON.stringify(messageResponse.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT));
							var toast = this.getToast("Error", JSON.stringify(messageResponse.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT), "Error");
							toast.fire();
						}
					} else {
						console.log("formattedGetCloseAccDetails.statusCode : " + JSON.stringify(formattedGetCloseAccDetails.statusCode));
						var toast = this.getToast(
							"Error",
							JSON.stringify(formattedGetCloseAccDetails.statusCode) + ": " + JSON.stringify(formattedGetCloseAccDetails.message),
							"Error"
						);
						toast.fire();
					}
				} else {
					console.log("NO DATA RETUNED FROM THE SERVER!!");
					var toast = this.getToast("Error", "NO DATA RETUNED FROM THE SERVER!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//UPDATE ACCOUNT CLOSURE
	cqUpdateAccountClosureDetails: function (component, event, helper) {
		//this.showSpinner(component);
		console.log("account number: " + component.get("v.selectedAccountNumber"));
		console.log("cqUpdateAccountClosureDetails: BEFORE CALLING : cqUpdateCloseAccDetails");
		var action = component.get("c.cqUpdateCloseAccDetails");
		action.setParams({
			CQN960I_ACCOUNT_NBR: component.get("v.selectedAccountNumber") /*'00000001404560073'*/,
			CQN960I_CLOSE_REASON: "3" //should be dynamic based on the case type
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var accountClosureResponse = response.getReturnValue();
				var accountClosureDetails = JSON.parse(accountClosureResponse);
				console.log("cqUpdateAccountClosureDetails: accountClosureResponse: " + accountClosureResponse);
				console.log("cqUpdateAccountClosureDetails: accountClosureDetails: " + accountClosureDetails);
				console.log("Status Code: " + accountClosureDetails.statusCode);

				if (accountClosureDetails != null) {
					if (accountClosureDetails.statusCode == 200) {
						if (accountClosureDetails.NBSMSGO3.NBNMSGO3_NBR_USER_MSGS == 0) {
							component.set("v.closureReason", accountClosureDetails.CQS960O.CQN960O_CLOS_REASON);
							component.set("v.closedAccountNumber", accountClosureDetails.CQS960O.CQS960O_ACCOUNT_NUMBER);
							component.set("v.closedAccountBalance", accountClosureDetails.CQS960O.CQN960O_ABAL);
							component.set("v.closedAccountAvailableBalance", accountClosureDetails.CQS960O.CQN960O_AVBL);
							component.set("v.closedAccountStatus", accountClosureDetails.CQS960O.CQN960O_STATUS);

							var toast = this.getToast("Success", "Account sent for closure", "Success");
							toast.fire();
						} else {
							console.log("messageResponse : " + JSON.stringify(accountClosureDetails.NBSMSGO3.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT));
							component.set("v.closureReason", accountClosureDetails.CQS960O.CQN960O_CLOS_REASON);
							component.set("v.closedAccountNumber", accountClosureDetails.CQS960O.CQS960O_ACCOUNT_NUMBER);
							component.set("v.closedAccountBalance", accountClosureDetails.CQS960O.CQN960O_ABAL);
							component.set("v.closedAccountAvailableBalance", accountClosureDetails.CQS960O.CQN960O_AVBL);
							component.set("v.closedAccountStatus", accountClosureDetails.CQS960O.CQN960O_STATUS);

							var toast = this.getToast("Error", JSON.stringify(accountClosureDetails.NBSMSGO3.NBNMSGO3_MSG_ENTRY[0].NBNMSGO3_MSG_TXT), "Error");
							toast.fire();
						}
					} else {
						console.log("formattedGetCloseAccDetails.statusCode : " + JSON.stringify(accountClosureDetails.statusCode));
						var toast = this.getToast(
							"Error",
							JSON.stringify(accountClosureDetails.statusCode) + ": " + JSON.stringify(accountClosureDetails.message),
							"Error"
						);
						toast.fire();
					}
				} else {
					console.log("NO DATA RETUNED FROM THE SERVER!!");
					var toast = this.getToast("Error", "NO DATA RETUNED FROM THE SERVER!!", "Error");
					toast.fire();
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
				var toast = this.getToast("Error", "Failed with state: " + JSON.stringify(response), "Error");
				toast.fire();
			}
			//this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//TOAST METHOD
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		return toastEvent;
	},

	//Function to show spinner when loading
	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	//Function to hide spinner after loading
	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	//START OF THE PAGINATION
	preparePagination: function (component, filteredClientAccountsForView) {
		var countTotalPage = Math.ceil(filteredClientAccountsForView.length / component.get("v.pageSize"));
		var totalPage = countTotalPage > 0 ? countTotalPage : 1;
		component.set("v.totalPages", totalPage);
		component.set("v.currentPageNumber", 1);
		this.setPageDataAsPerPagination(component);
	},

	setPageDataAsPerPagination: function (component) {
		var data = [];
		var pageNumber = component.get("v.currentPageNumber");
		var pageSize = component.get("v.pageSize");
		var filteredData = component.get("v.viewCustomerAccountDetails");

		for (var x = (pageNumber - 1) * pageSize; x < pageNumber * pageSize; x++) {
			if (filteredData[x]) {
				data.push(filteredData[x]);
			}
		}
		component.set("v.tableData", data);
	},

	//FOR ACCOUNTS THAT CAN BE CLOSED
	accpreparePagination: function (component, filteredClientAccountsForView) {
		var countTotalPage = Math.ceil(filteredClientAccountsForView.length / component.get("v.pageSizeNo"));
		var totalPage = countTotalPage > 0 ? countTotalPage : 1;
		component.set("v.totalNoPages", totalPage);
		component.set("v.currentPageNo", 1);
		this.accsetPageDataAsPerPagination(component);
	},

	accsetPageDataAsPerPagination: function (component) {
		var accdata = [];
		var pageNumber = component.get("v.currentPageNo");
		var pageSize = component.get("v.pageSizeNo");
		var filteredData = component.get("v.customerAccountDetails");

		for (var x = (pageNumber - 1) * pageSize; x < pageNumber * pageSize; x++) {
			if (filteredData[x]) {
				accdata.push(filteredData[x]);
			}
		}
		component.set("v.acctableData", accdata);
	}
	//END OF THE PAGINATION
});