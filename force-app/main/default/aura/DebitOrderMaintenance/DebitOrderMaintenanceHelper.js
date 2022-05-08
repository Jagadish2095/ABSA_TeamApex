({
	getDataForHomeLoans: function (component, event, helper) {
		var action = component.get("c.getHomeLoansData");
		action.setParams({ combiNumberP: component.get("v.combiNumberFromFlow"), accountNumberP: component.get("v.accountNumberFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp && resp.NHgetAccountDetailV3Response && resp.NHgetAccountDetailV3Response.nhc039o) {
					var dateStr = resp.NHgetAccountDetailV3Response.nhc039o.mlPaymentDate;
					var year = dateStr.substring(0, 4);
					var month = dateStr.substring(4, 6);
					var day = dateStr.substring(6, 8);
					var formattedDueDate = year + "-" + month + "-" + day;
					component.set("v.curInsDueDay", formattedDueDate);
					component.set("v.curInstallment", resp.NHgetAccountDetailV3Response.nhc039o.mlPaymentDue);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "DebitOrderMaintenanceHelper.getDataForHomeLoans: Unknown error occurred");
			}
		});
		$A.enqueueAction(action);
	},

	getDataForAbsaLife: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getAbsaLifeData");
		var fieldList = ["Payment_Plan__c.Account_Type__c", "Payment_Plan__c.Debit_Order_Debit_Day__c"];
		action.setParams({
			policyNumber: component.get("v.accountNumberFromFlow"),
			fieldList: fieldList
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp) {
					var responseBean = resp["responseBean"];
					var picklistValues = resp["picklistValues"];
					var bankName = resp["bankName"];
					var branchName = resp["branchName"];

					component.set("v.bankName", bankName);
					component.set("v.branchName", branchName);

					if (component.get("v.bankingDetailsTabLoaded") && bankName && branchName) {
						helper.setSelectedBankAndBranchName(component, bankName, branchName);
					}

					if (picklistValues) {
						component.set("v.accountTypes", picklistValues["Payment_Plan__c.Account_Type__c"]);
						component.set("v.debitOrderDays", picklistValues["Payment_Plan__c.Debit_Order_Debit_Day__c"]);
					}

					if (responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o) {
						var dateStr = responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.commencementDate;
						var year = dateStr.substring(0, 4);
						var month = dateStr.substring(4, 6);
						var day = dateStr.substring(6, 8);
						var formattedDueDate = year + "-" + month + "-" + day;

						component.set("v.commencementDate", formattedDueDate);
						component.set("v.premiumFrequency", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.premiumFrequency);
						component.set("v.policyPremium", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.policyPremium);
						component.set("v.premiumCollectionDay", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.premiumCollectionDay);
						component.set("v.branchCode", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.branchCode);
						component.set("v.accountNumber", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.accountNumber);
						component.set("v.accountHolderName", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.accountholderName);
						component.set("v.sourceOfFund", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.sourceOfFund);
						component.set("v.sourceOfIncome", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.sourceOfIncome);
						component.set("v.policyStatus", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.policyStatus);
						component.set("v.accountType", responseBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.accountType);
                         if(component.get('v.policyStatus') === 'Inactive'){
                            component.set("v.saveBtnDisabled", true);
                        }
					}
				} else {
					component.set("v.errorMessage", "DebitOrderMaintenanceHelper.getDataForAbsaLife");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	setSelectedBankAndBranchName: function (component, bankName, branchName) {
		console.log("setSelectedBankAndBranchName");
		var customLookUpCmp = component.find("customLookUpCmp");
		if (customLookUpCmp) {
			customLookUpCmp.setSelectedBankName(bankName);
		}

		var dependentCutomLookupCmp = component.find("dependentCutomLookupCmp");
		if (dependentCutomLookupCmp) {
			dependentCutomLookupCmp.setSelectedBranchName(branchName);
		}
	},

	setUpHomeLoansView: function (component, event, helper) {
		component.set("v.dynamicLabel", "Debit Order Date");
		helper.getDataForHomeLoans(component, event, helper);
	},

	setUpAbsaLifeView: function (component, event, helper) {
		component.set("v.dynamicLabel", "Debit Order Maintenance");
		component.set("v.isAbsaLifeProduct", "true");
		helper.getDataForAbsaLife(component, event, helper);
	},

	setUpAbsaLifeExergyView: function (component, event, helper) {
		component.set("v.dynamicLabel", "Debit Order Maintenance");
		component.set("v.isAbsaLifeProduct", "true");
		helper.getExergyDataForAbsaLife(component, event, helper);
	},

	/****************@ Author: Humeblani Denge**************************************
	 ****************@ Date: 17/02/2021**************************************
	 ****************@ Work Id: W-007785*************************************
	 ***@ Description: Method to handle exergy debit order maintenance - Policy details retrieval********/
	getExergyDataForAbsaLife: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getExergyDataForAbsaLife");
		var fieldList = ["Payment_Plan__c.Debit_Order_Debit_Day__c"];
		action.setParams({
			policyNumber: component.get("v.accountNumberFromFlow"),
			fieldList: fieldList
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp) {
					var responseBean = resp["responseBean"];
					if (responseBean.statusCode != 200) {
						component.set("v.errorMessage", "DebitOrderMaintenanceHelper.getExergyDataForAbsaLife:" + responseBean.message);
					}

					if (responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract === null) {
						component.set("v.errorMessage", "DebitOrderMaintenanceHelper.getExergyDataForAbsaLife: unexpected response from service");
					}

					//Picklist values for Exergy are different to Elms
					let exergyAccountTypes = [
						{ label: "Savings" },
						{ label: "Current" },
						{ label: "Transmission" },
						{ label: "Bond" },
						{ label: "Credit Card" }
					];
					var picklistValues = resp["picklistValues"];

					if (picklistValues) {
						component.set("v.accountTypes", exergyAccountTypes);
						component.set("v.debitOrderDays", picklistValues["Payment_Plan__c.Debit_Order_Debit_Day__c"]);
					}

					if (responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.CommenceDate) {
						var dateStr = responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.CommenceDate;
						var year = dateStr.substring(0, 4);
						var month = dateStr.substring(4, 6);
						var day = dateStr.substring(6, 8);
						var formattedDueDate = year + "-" + month + "-" + day;

						component.set("v.commencementDate", formattedDueDate);
						component.set(
							"v.premiumFrequency",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.PaymentFrequency
						);
						component.set(
							"v.policyPremium",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.AdjustedPremium
						);
                        
                        var collectionDay = responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.DayOfPayment;
                        if(collectionDay < 10){
                            component.set("v.premiumCollectionDay",'0' + collectionDay);
													
                        };
                        
                        if(collectionDay >= 10){
                            component.set("v.premiumCollectionDay", collectionDay);
                        };
                        				
						component.set(
							"v.accountNumber",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.AccountNo
						);
						component.set(
							"v.accountHolderName",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.AccountName
						);
						component.set(
							"v.sourceOfFund",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.SourceOfFunds1
						);
						component.set(
							"v.policyStatus",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.StatusDescription
						);
                        
                        if(component.get('v.policyStatus') != 'In force'){
                            component.set("v.saveBtnDisabled", true);
                        }
						component.set(
							"v.bankName",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.BankName
						);
						component.set(
							"v.accountType",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.AccountTypeID
						);
						component.set(
							"v.exergyBankId",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.BankID
						);
						component.set(
							"v.exergyBranchId",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.BankBranchID
						);
						component.set(
							"v.exergyBankName",
							responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.BankName
						);
                        
                        
						var branchName = responseBean.Policy_LoadByRefNoResponse.Policy_LoadByRefNoResult.Contracts.V3_DC2Contract.BankContract.BankBranchName;
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
				} else {
					component.set("v.errorMessage", "DebitOrderMaintenanceHelper.getExergyDataForAbsaLife");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			}

			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	submit: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.updateLABankingDetails");
		action.setParams({
			clientCode: component.get("v.clientCode"),
			policyNumber: component.get("v.accountNumberFromFlow"),
			bankName: component.get("v.bankName"),
			sourceOfIncome: component.get("v.sourceOfIncome"),
			sourceOfFund: component.get("v.sourceOfFund"),
			bankAccountNo: component.get("v.accountNumber"),
			accountHolderName: component.get("v.accountHolderName"),
			collectionDay: component.get("v.premiumCollectionDay"),
			frequency: component.get("v.premiumFrequency"),
			accountType: component.get("v.accountType"),
			branchCode: component.get("v.branchCode"),
			amount: component.get("v.policyPremium")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (resp.LAupdateBankingDetailsV3Response.la950p5o.errorDescription) {
					helper.fireToastEvent(
						"Error!",
						"DebitOrderMaintenanceHelper.submit:" + JSON.stringify(resp.LAupdateBankingDetailsV3Response.la950p5o.errorDescription),
						"error"
					);
				} else {
					helper.fireToastEvent("Success!", "Details updated successfully", "success");
                    component.set("v.saveBtnDisabled", true);
				}
			} else if (state === "ERROR") {
				helper.fireToastEvent("Error!", "DebitOrderMaintenanceHelper.submit: Unknown error occurred", "error");
			}
			component.set("v.showConfirmation", "false");
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Humeblani Denge**************************************
	 ****************@ Date: 17/02/2021**************************************
	 ****************@ Work Id: W-007780*************************************
	 ***@ Description: Method to handle exergy debit order maintenance changes********/
	submitExergyChanges: function (component, event, helper) {
		helper.showSpinner(component);

		var bankName = component.get("v.bankName");
		var exergyBankName = component.get("v.exergyBankName");
		var bankID;
		var branchID;
		var bankDetailsChanged = false;

		if (exergyBankName != bankName) {
			bankID = bankName;
			branchID = component.get("v.branchCode");
			bankDetailsChanged = true;
		} else {
			bankID = component.get("v.exergyBankId");
			branchID = component.get("v.exergyBranchId");
			bankDetailsChanged = false;
		}

		var action = component.get("c.exergyBankAndContractInfoChange");
   		alert("SourceOfFunds on submit" +  component.get("v.sourceOfFund"));
		action.setParams({
			policyNo: component.get("v.accountNumberFromFlow"),
			accName: component.get("v.accountHolderName"),
			accNo: component.get("v.accountNumber"),
			accTypeID: component.get("v.accountType"),
			branchID: branchID,
			bankID: bankID,
			dayOfPayment: component.get("v.premiumCollectionDay"),
			sourceOfFunds: component.get("v.sourceOfFund"),
			bankDetailsChanged: bankDetailsChanged
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			var responseValue = response.getReturnValue();
			if (state === "SUCCESS") {
				if (responseValue.startsWith("Error:")) {
					//error
					component.set("v.errorMessage", responseValue);
				} else {
					helper.fireToastEvent("Success!", "Exergy infromation change transaction successfull.", "Success");
					component.set("v.saveBtnDisabled", true);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "DebitOrderMaintenanceHelper.submitExergyChanges: Unexpected error occurred, state returned: " + state);
			}
			component.set("v.showConfirmation", "false");
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 07/10/2020**************************************
	 ****************@ Work Id: W-006725*************************************
	 ***@ Description: Method Added by chandra to close case record ********/
	closeCase: function (component, event, helper) {
		component.set("v.simpleRecord.Status", "Closed");
		component.find("caseRecordLoader").saveRecord(function (saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
				helper.fireToastEvent("Success!", "Case successfully closed!", "success");
				$A.get("e.force:refreshView").fire();
			} else if (saveResult.state === "INCOMPLETE") {
				helper.fireToastEvent("Error!", "User is offline, device doesn't support drafts.", "error");
			} else if (saveResult.state === "ERROR") {
				helper.fireToastEvent("Error!", JSON.stringify(saveResult.error), "error");
			} else {
				helper.fireToastEvent("Error!", saveResult.state + ", error: " + JSON.stringify(saveResult.error), "error");
			}
		});
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

		if ($A.util.isEmpty(component.get("v.bankName")) || $A.util.isEmpty(component.get("v.branchName"))) {
			allValid = false;
		}
		return allValid;
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", "false");
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", "true");
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