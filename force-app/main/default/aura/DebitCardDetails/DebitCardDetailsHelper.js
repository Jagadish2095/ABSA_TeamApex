({
	fetchData: function (component) {
		var oppId = component.get("v.OppurtunityId");
		var getAppProdIdAction = component.get("c.getAppProdAndAccount");
		getAppProdIdAction.setParams({
			oppId: oppId
		});
		getAppProdIdAction.setCallback(component, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (state === "SUCCESS" && component.isValid()) {
				var result = response.getReturnValue();
				component.set("v.AccountNumber", result.AccountNumber);
				component.set("v.ApplicationProdId", result.ApplicationId);
				component.set("v.personalisedName", result.PersonaliseName);
				component.set("v.combiCardIssued", result.CardIssuedStatus);
				component.set("v.showPersonalisedOptions", result.AllowPersonalisedCard);
				component.set("v.productFamily", result.ProductFamily);
				component.set("v.dataLoaded", true);
			} else if (state == "ERROR") {
				var errors = response.getError();
				component.find("branchFlowFooter").set("v.heading", "Failed to get Account number.");
				component.find("branchFlowFooter").set("v.message", errors[0].message);
				component.find("branchFlowFooter").set("v.showDialog", true);
			}
		});
		$A.enqueueAction(getAppProdIdAction);
	},

	fetchBrands: function (component) {
		var action = component.get("c.getBrands");
		var oppurtunityId = component.get("v.OppurtunityId");

		action.setParams({
			oppId: oppurtunityId,
			numberofBrand: "20"
		});
		action.setCallback(component, function (response) {
			var state = response.getState();
			if (state === "SUCCESS" && component.isValid()) {
				var result = response.getReturnValue();
				component.set("v.brandTypesList", result);
			} else if (state == "ERROR") {
				component.set("v.showSpinner", false);
				var errors = response.getError();
				component.find("branchFlowFooter").set("v.heading", "Failed to get Combi brands.");
				component.find("branchFlowFooter").set("v.message", errors[0].message);
				component.find("branchFlowFooter").set("v.showDialog", true);
			}
		});
		$A.enqueueAction(action);
	},

	getCClistNominatableAccounts: function (component) {
		var self = this;
		var nominatableSavingsAccountsList = [];
		var nominatableChequeAccountsList = [];
		var nominatableCreditCardAccountsList = [];

		var accountNumber = component.get("v.AccountNumber");
		var productFamily = component.get("v.productFamily");

		var oppId = component.get("v.OppurtunityId");
		var action = component.get("c.getNominatableAccounts");
		action.setParams({
			accountNumber: accountNumber,
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnedData = JSON.parse(response.getReturnValue());
				var nominatableAccountsList = returnedData.CClistNominatableAccountsV1Response.ccp315o.nomAccntLst;
				if (nominatableAccountsList != null) {
					nominatableAccountsList.forEach(function (nominatableAccount) {
						switch (nominatableAccount.prodType) {
							case "CQ":
								nominatableChequeAccountsList.push(nominatableAccount.accntNbr);
								break;
							case "SA":
							case "SV":
								nominatableSavingsAccountsList.push(nominatableAccount.accntNbr);
								break;
							case "CC":
							case "CA":
								nominatableCreditCardAccountsList.push(nominatableAccount.accntNbr);
								break;
						}
					});
					if (productFamily == "Cheque") {
						if (!nominatableChequeAccountsList.includes(accountNumber)) {
							nominatableChequeAccountsList.push(accountNumber);
						}
						component.set("v.SelectedNominatedChequeAccount", accountNumber);
					} else if (productFamily == "Savings") {
						if (!nominatableSavingsAccountsList.includes(accountNumber)) {
							nominatableSavingsAccountsList.push(accountNumber);
						}
						component.set("v.SelectedNominatedSavingsAccount", accountNumber);
					}
					component.set("v.NominatableSavingsAccountsList", nominatableSavingsAccountsList);
					component.set("v.NominatableCreditCardAccountsList", nominatableCreditCardAccountsList);
					component.set("v.NominatableChequeAccountsList", nominatableChequeAccountsList);

					component.set("v.showNominatableAccounts", true);

					//If card already issued get limits
					if (component.get("v.combiCardIssued")) {
						self.getCardDailyLimits(component);
					}
				}
			} else if (state == "ERROR") {
				var errors = response.getError();
				component.find("branchFlowFooter").set("v.heading", "Failed to get nominatable accounts.");
				component.find("branchFlowFooter").set("v.message", errors[0].message);
				component.find("branchFlowFooter").set("v.showDialog", true);
			}
		});
		$A.enqueueAction(action);
	},

	getCardDailyLimits: function (component) {
		component.set("v.showSpinner", true);
		var debitCardNumber = component.get("v.debitCardNumber");
		var action = component.get("c.getDailyLimits");
		action.setParams({
			selectedCombiNumber: debitCardNumber
		});
		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnedData = JSON.parse(response.getReturnValue());
				component.set("v.CashWithdrawalLimit", returnedData.CCgetDailyLimitsV2Response.ccp312o.cardCshLim);
				component.set("v.CashTransferLimit", returnedData.CCgetDailyLimitsV2Response.ccp312o.cardTrfLim);
				component.set("v.PointOfSalePurchaseLimit", returnedData.CCgetDailyLimitsV2Response.ccp312o.cardPosLim);
				component.set("v.CardCounterLimit", returnedData.CCgetDailyLimitsV2Response.ccp312o.cardCntLim);
			} else if (state == "ERROR") {
				var errors = response.getError();
				component.find("branchFlowFooter").set("v.heading", "Failed to get daily limits.");
				component.find("branchFlowFooter").set("v.message", errors[0].message);
				component.find("branchFlowFooter").set("v.showDialog", true);
			}
			component.set("v.showCardLimits", true);
		});
		$A.enqueueAction(action);
	},

	updCardDailyLimits: function (component) {
		return new Promise(function (resolve, reject) {
			component.set("v.showSpinner", true);
			var combiNbr = component.get("v.debitCardNumber");
			var cardCshLim = component.get("v.CashWithdrawalLimit");
			var cardPosLim = component.get("v.PointOfSalePurchaseLimit");
			var cardCntLim = component.get("v.CardCounterLimit");
			var cardTrfLim = component.get("v.CashTransferLimit");
			var cheqNomAcc = component.get("v.AccountNumber");

			var cdl = {
				CombiNbr: combiNbr,
				CardCshLim: cardCshLim,
				CardPosLim: cardPosLim,
				CardCntLim: cardCntLim,
				CardTrfLim: cardTrfLim,
				CheqNomAcc: cheqNomAcc
			};

			var action = component.get("c.updateDailyLimits");
			action.setParams({
				cdl: JSON.stringify(cdl)
			});
			action.setCallback(this, function (response) {
				component.set("v.showSpinner", false);
				var state = response.getState();
				if (state === "SUCCESS") {
					var returnData = response.getReturnValue();
					resolve("Continue");
				} else if (state == "ERROR") {
					var errors = response.getError();
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to update limits.");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						component.find("branchFlowFooter").set("v.heading", "Failed to update limits.");
						component.find("branchFlowFooter").set("v.message", "Unknown Error");
						component.find("branchFlowFooter").set("v.showDialog", true);
					}
					reject("Failed");
				}
			});
			$A.enqueueAction(action);
		});
	},

	issueCombiCard: function (component) {
		return new Promise(function (resolve, reject) {
			component.set("v.showSpinner", true);
			var CardNumber = component.get("v.debitCardNumber");
			var isPersonalisedCard = component.get("v.isPersonalisedCard");

			var AccountNumber = component.get("v.AccountNumber");
			var NomCheq = component.get("v.SelectedNominatedChequeAccount");
			var NomSavs = component.get("v.SelectedNominatedSavingsAccount");
			var NomCred = component.get("v.SelectedNominatedCreditCardAccount");
			var BrandNumber = component.get("v.brandNumber");
			var DeliveryBranch = component.get("v.deliveryBranch");
			var DeliveryMethod = component.get("v.deliveryMethod");
			var oppId = component.get("v.OppurtunityId");

			var cdo = {
				isPersonalisedCard: isPersonalisedCard,
				CardNumber: CardNumber,
				AccountNumber: AccountNumber,
				NomCheq: NomCheq,
				NomSavs: NomSavs,
				NomCred: NomCred,
				BrandNumber: BrandNumber,
				oppId: oppId,
				deliveryBranch: DeliveryBranch,
				deliveryMethod: DeliveryMethod
			};
			let action = component.get("c.issueCard");
			action.setParams({
				cdo: JSON.stringify(cdo)
			});
			action.setCallback(this, function (response) {
				component.set("v.showSpinner", false);
				var state = response.getState();
				if (state === "SUCCESS") {
					var returnData = response.getReturnValue();
					if (isPersonalisedCard == "Yes") {
						component.set("v.debitCardNumber", returnData);
					}
					resolve("Continue");
				} else if (state == "ERROR") {
					//resolve('Continue');
					var errors = response.getError();
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to issue card.");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						component.find("branchFlowFooter").set("v.heading", "Failed to issue card.");
						component.find("branchFlowFooter").set("v.message", "Unknown Error");
						component.find("branchFlowFooter").set("v.showDialog", true);
					}
					reject("Failed");
				}
			});
			$A.enqueueAction(action);
		});
	},

	BrandTypes: function (cmp, filedName, elementId) {
		var selectedBrand = cmp.find("Brand");
		var Brand = selectedBrand.get("v.value");
		cmp.set("v.SelectedBrandType", Brand);
	},

	checkCardDetailsValidity: function (component) {
		var isValid = true;

		if (!component.find("AccountNumber").get("v.validity").valid) {
			component.find("AccountNumber").showHelpMessageIfInvalid();
			isValid = false;
		}

		var isPersonalisedCard = component.get("v.isPersonalisedCard");

		if (isPersonalisedCard == "No") {
			if (!component.find("DebitCardNumber").get("v.validity").valid) {
				component.find("DebitCardNumber").showHelpMessageIfInvalid();
				isValid = false;
			}
		} else {
			if (!component.find("PersonalisedName").get("v.validity").valid) {
				component.find("PersonalisedName").showHelpMessageIfInvalid();
				isValid = false;
			}
		}

		if (!component.find("Brand").get("v.validity").valid) {
			component.find("Brand").showHelpMessageIfInvalid();
			isValid = false;
		}

		var showNominatableAccounts = component.get("v.showNominatableAccounts");
		if (showNominatableAccounts) {
			var productFamily = component.get("v.productFamily");

			if (productFamily == "Savings") {
				var NominatableSavingsAccount = component.find("NominatedSavingsAccount");
				var SelectedNominatedSavingsAccount = component.get("v.SelectedNominatedSavingsAccount");
				var NominatableSavingsAccountsList = component.get("v.NominatableSavingsAccountsList");
				if (NominatableSavingsAccountsList.length > 0 && SelectedNominatedSavingsAccount == "") {
					$A.util.addClass(NominatableSavingsAccount, "slds-has-error");
					isValid = false;
				} else {
					$A.util.removeClass(NominatableSavingsAccount, "slds-has-error");
				}
			}
			if (productFamily == "Cheque") {
				var NominatableChequeAccount = component.find("NominatedChequeAccount");
				var SelectedNominatedChequeAccount = component.get("v.SelectedNominatedChequeAccount");
				var NominatableChequeAccountsList = component.get("v.NominatableChequeAccountsList");
				if (NominatableChequeAccountsList.length > 0 && SelectedNominatedChequeAccount == "") {
					$A.util.addClass(NominatableChequeAccount, "slds-has-error");
					isValid = false;
				} else {
					$A.util.removeClass(NominatableChequeAccount, "slds-has-error");
				}
			}
			if (productFamily == "Credit Card") {
				var NominatedCreditCardAccount = component.find("NominatedCreditCardAccount");
				var SelectedNominatedCreditCardAccount = component.get("v.SelectedNominatedCreditCardAccount");
				var NominatableCreditCardAccountsList = component.get("v.NominatableCreditCardAccountsList");
				if (NominatableCreditCardAccountsList.length > 0 && SelectedNominatedCreditCardAccount == "") {
					$A.util.addClass(NominatedCreditCardAccount, "slds-has-error");
					isValid = false;
				} else {
					$A.util.removeClass(NominatedCreditCardAccount, "slds-has-error");
				}
			}
		}
		return isValid;
	},

	checkCardLimitsValidity: function (component) {
		var isValid = true;
		var CashWithdrawalLimit = component.find("CashWithdrawalLimit");
		var CashWithdrawalLimitValue = CashWithdrawalLimit.get("v.value");
		if (CashWithdrawalLimitValue != null && CashWithdrawalLimitValue != "") {
			$A.util.removeClass(CashWithdrawalLimit, "slds-has-error");
		} else {
			$A.util.addClass(CashWithdrawalLimit, "slds-has-error");
			isValid = false;
		}

		var CashTransferLimit = component.find("CashTransferLimit");
		var CashTransferLimitValue = CashTransferLimit.get("v.value");
		if (CashTransferLimitValue != null && CashTransferLimitValue != "") {
			$A.util.removeClass(CashTransferLimit, "slds-has-error");
		} else {
			$A.util.addClass(CashTransferLimit, "slds-has-error");
			isValid = false;
		}

		var PointOfSalePurchaseLimit = component.find("PointOfSalePurchaseLimit");
		var PointOfSalePurchaseLimitValue = PointOfSalePurchaseLimit.get("v.value");
		if (PointOfSalePurchaseLimitValue != null && PointOfSalePurchaseLimitValue != "") {
			$A.util.removeClass(PointOfSalePurchaseLimit, "slds-has-error");
		} else {
			$A.util.addClass(PointOfSalePurchaseLimit, "slds-has-error");
			isValid = false;
		}

		var CardCounterLimit = component.find("CardCounterLimit");
		var CardCounterLimitValue = CardCounterLimit.get("v.value");
		if (CardCounterLimitValue != null && CardCounterLimitValue != "") {
			$A.util.removeClass(CardCounterLimit, "slds-has-error");
		} else {
			$A.util.addClass(CardCounterLimit, "slds-has-error");
			isValid = false;
		}

		return isValid;
	},

	/**
	 * @description function to show spinner.
	 **/
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	/**
	 * @description function to hide spinner.
	 **/
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},

	searchForDeliveryBranchByName: function (component, queryTerm) {
		let action = component.get("c.searchDeliveryBranchByName");
		action.setParams({
			searchString: queryTerm
		});

		component.set("v.issearching", true);

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var valueData = component.get("v.listOfRecords");
				var returnData = response.getReturnValue();

				if (returnData.length == 0) {
					component.set("v.Message", "No Result Found...");
					component.set("showResults", true);
				} else {
					valueData = [];
					for (var item in returnData) {
						valueData.push({ key: item, value: returnData[item] });
					}

					component.set("v.Message", "");
					component.set("v.listOfRecords", valueData);
				}
				var forclose = component.find("searchRes");
			}

			component.set("v.issearching", false);
		});

		$A.enqueueAction(action);
	}
});