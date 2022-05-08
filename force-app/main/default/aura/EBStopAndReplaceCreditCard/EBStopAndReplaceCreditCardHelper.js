({
	getCardDetailsHelper: function (component) {
		this.showSpinner(component);
		var action = component.get("c.getCardDetails");
		action.setParams({ CIF: component.get("v.cifFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("Error: ")) {
					// error
					this.getToast("Error!", "Unable to get card details ", "Error");
					component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getCardDetails  -" + responseValue);
				} else {
					// success
					var creditCardList = [];
					var creditCardAccountNumberList = [];
					var respObj = JSON.parse(responseValue);
					for (var key in respObj) {
						if ((respObj[key].productType == "CA" || respObj[key].productType == "Credit Account/Card") && respObj[key].status == "ACTIVE") {
							respObj[key].oaccntnbr = respObj[key].oaccntnbr.replace(/^0+/, "");
							creditCardList.push(respObj[key]);
							creditCardAccountNumberList.push(respObj[key].oaccntnbr);
						}
					}

					if (creditCardList.length == 0) {
						this.getToast("Error!", "No Credit card linked to this account ", "Error");
						component.set("v.errorMessage", "No Credit card linked to this account");
					} else {
						component.set("v.cardList", creditCardList);
						component.set("v.creditCardAccountNumberList", creditCardAccountNumberList);

						//fetch Transactions.
						this.getTransactionsHelper(component);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getCardDetails  -" + JSON.stringify(errors));
					}
				} else {
					component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getCardDetails -" + state);
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getTransactionsHelper: function (component) {
		this.showSpinner(component);
		var action = component.get("c.getTransactions");
		action.setParams({ accountNumbersList: component.get("v.creditCardAccountNumberList") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = JSON.parse(response.getReturnValue());
				component.set("v.cardDetailsList", responseValue);
				var cardList = component.get("v.cardList");
				var cardsWithTransactions = [];
				for (var j = 0; j < cardList.length; j++) {
					cardList[j]["transactionList"] = [];
					for (var i = 0; i < responseValue.length; i++) {
						if (cardList[j].oaccntnbr == responseValue[i].kbAcctNbr) {
							cardList[j]["kbAcctNbr"] = responseValue[i].kbAcctNbr;
							cardList[j]["cardHolderName"] = responseValue[i].acctPlasNumbers[0].tdEmbNmLn1;
							cardList[j]["transactionList"] = responseValue[i].txnLn.slice(0, 5);
						}
					}

					cardsWithTransactions.push(cardList[j]);
				}
				component.set("v.cardList", cardsWithTransactions.sort());
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getTransactions  -" + JSON.stringify(errors));
					}
				} else {
					component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getTransactions -" + state);
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	getPicklistTranslationsHelper: function (component, event) {
		var action = component.get("c.getPickListValuesListTranslations");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				var reasonsList = [];
				var circumstancesList = [];
				var deliveryMethodList = [];
				if (responseValue.length != 0) {
					for (var i = 0; i < responseValue.length; i++) {
						if (responseValue[i].Value_Type__c == "Reason") {
							reasonsList.push(responseValue[i]);
						} else if (responseValue[i].Value_Type__c == "Circumstances") {
							circumstancesList.push(responseValue[i]);
						} else if (responseValue[i].Value_Type__c == "Delivery Method") {
							deliveryMethodList.push(responseValue[i]);
						}
					}
				}
				component.set("v.reasonsList", reasonsList);
				component.set("v.circumstancesList", circumstancesList);
				component.set("v.deliveryMethodList", deliveryMethodList);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getPickListValuesListTranslations  -" + JSON.stringify(errors));
					}
				} else {
					component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.getPickListValuesListTranslations -" + state);
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	validateFieldsHelper: function (component, event) {
		var reasonsField = component.find("reasonsField");
		var circumstancesField = component.find("circumstancesField");
		var lostPlacedField = component.find("lostPlacedField");
		var whenLostField = component.find("whenLostField");
		var lastUsedPlaceField = component.find("lastUsedPlaceField");
		var whenLastUsedField = component.find("whenLastUsedField");
		var howLostField = component.find("howLostField");
		var homePhoneField = component.find("homePhoneField");
		var officePhoneField = component.find("officePhoneField");
		var stopOptionsValue = component.get("v.stopOptionsValue");

		//required fields array
		var requiredFields = [
			reasonsField,
			circumstancesField,
			lostPlacedField,
			whenLostField,
			lastUsedPlaceField,
			whenLastUsedField,
			howLostField,
			homePhoneField,
			officePhoneField
		];

		if (stopOptionsValue == "Stop and Replace Card") {
			var deliveryMethodField = component.find("deliveryMethodField");
			requiredFields.push(deliveryMethodField);

			if (deliveryMethodField.get("v.value") == "CB") {
				var branchCodeField = component.get("v.selectedSiteRecord");

				if (branchCodeField == "" || branchCodeField == null) {
					var message = "Please choose Site";
					var title = "Validation";
					this.getToast(title, message, "warning");
					return;
				}
			}
		}

		for (var i = 0; i < requiredFields.length; i++) {
			if (requiredFields[i].get("v.value") == "" || requiredFields[i].get("v.value") == null) {
				var title = "Validation";
				var message = "Please complete required field: " + requiredFields[i].get("v.label");
				this.getToast(title, message, "warning");
				return;
			}
		}

		//Stop Card
		this.StopReplaceCardHelper(component, event);
	},

	StopReplaceCardHelper: function (component, event) {
		this.showSpinner(component);
		var reasonsField = component.find("reasonsField").get("v.value");
		var circumstancesField = component.find("circumstancesField").get("v.value");
		var lostPlacedField = component.find("lostPlacedField").get("v.value");
		var whenLostField = component.find("whenLostField").get("v.value");
		var whenLostDate = $A.localizationService.formatDate(whenLostField, "yyyyMMdd");
		var whenLostTime = $A.localizationService.formatTime(whenLostField, "HHmm");
		var lastUsedPlaceField = component.find("lastUsedPlaceField").get("v.value");
		var whenLastUsedField = component.find("whenLastUsedField").get("v.value");
		var whenLastUsedDate = $A.localizationService.formatDate(whenLastUsedField, "yyyyMMdd");
		var whenLastUsedTime = $A.localizationService.formatTime(whenLastUsedField, "HHmm");
		var howLostField = component.find("howLostField").get("v.value");
		var homePhoneField = component.find("homePhoneField").get("v.value");
		var officePhoneField = component.find("officePhoneField").get("v.value");
		var stopOptionsValue = component.get("v.stopOptionsValue");
		var pasticCardNumber = component.get("v.selectedRecord").oaccntnbr;
		var replaceCard = stopOptionsValue == "Stop and Replace Card" ? "Y" : "N";
		var pxiStatNew;
		if (reasonsField == "APP" || reasonsField == "LST") {
			pxiStatNew = "L0P";
		} else if (reasonsField == "STL") {
			pxiStatNew = "L1P";
		}

		var checkBoxGroupOptionsValueList = component.get("v.checkBoxGroupOptionsValueList");
		var cardSigned = checkBoxGroupOptionsValueList.includes("cardSigned") ? "Y" : "N";
		var safePin = checkBoxGroupOptionsValueList.includes("safePin") ? "Y" : "N";
		var primaryAccountHolder = checkBoxGroupOptionsValueList.includes("primaryAccountHolder") ? "20" : " ";
		var noOtherCards = checkBoxGroupOptionsValueList.includes("noOtherCards") ? "Y" : "N";

		//Delivery
		var deliverySite;
		var deliveryMethodField;
		if (stopOptionsValue == "Stop and Replace Card") {
			deliveryMethodField = component.find("deliveryMethodField").get("v.value");

			if (deliveryMethodField == "CB") {
				deliverySite = component.get("v.selectedSiteRecord").Site_Code__c;
			} else {
				deliverySite = component.get("v.selectedRecord").branch;
                deliveryMethodField = "CB";
			}
		} else {
			deliveryMethodField = "";
			deliverySite = "";
		}

		var stopReplaceCardDataObject = {
			lsRptRsnCd: reasonsField,
			circCd: circumstancesField,
			whereLs: lostPlacedField,
			lsDt: whenLostDate,
			tmsLs: whenLostTime,
			lsPlLstUsed: lastUsedPlaceField,
			lsDtLstUsed: whenLastUsedDate,
			lsTmOfLoss: whenLastUsedTime,
			howLostLn1: howLostField,
			phnNbrPer: homePhoneField,
			phnNbrBus: officePhoneField,
			distReasCd: deliveryMethodField,
			distSiteCd: deliverySite,
			crdIsSgndInd: cardSigned,
			pinIsSafeInd: safePin,
			sof1: primaryAccountHolder,
			advcNoUseInd: noOtherCards,
			plasticNbr: pasticCardNumber,
			axiXfrRsn: reasonsField,
			pxiStatNew: pxiStatNew,
			crdRep: replaceCard
		};

		var action = component.get("c.stopReplaceCreditCard");

		action.setParams({ cardDetailsMap: stopReplaceCardDataObject });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());

				if (respObj.statusCode == 200) {
					if (respObj.CAstpLostStolenCardV2Response != null) {
						var CAstpLostStolenCardV2Response = respObj.CAstpLostStolenCardV2Response;
						var returnResults = CAstpLostStolenCardV2Response.can912o;

						var returnMessage = returnResults.returnMsg;

						if (returnMessage == "CHANGE SUCCESSFUL") {
							var message = "Card Stopped Successfully";
							var title = "Success";
							this.getToast(title, message, "success");

							component.set("v.stoppedCardNumber", stopReplaceCardDataObject.plasticNbr); //'04028370000342011'
						} else if (returnMessage == "STAT CHNG ITEM NOT FND -106024") {
							var message = "This card was already stopped: (returnMessage: " + returnMessage + ")";
							this.getToast("Error", message, "error");
							component.set("v.errorMessage", message);
						} else if (returnMessage == null) {
							var message = "Return Result: " + JSON.stringify(returnResults);
							component.set("v.errorMessage", message);
							this.getToast("Error", message, "error");
						} else {
							var message = JSON.stringify(returnMessage);
							component.set("v.errorMessage", message);
							this.getToast("Error", message, "error");
						}
					} else {
						var message = "Null Response received" + respObj.statusCode;
						this.getToast("Error", message, "error");
						component.set("v.errorMessage", message);
					}
				} else {
					var message = "Unknown response, statusCode: " + respObj.statusCode + " Response: " + JSON.stringify(respObj);
					this.getToast("Error", message, "error");
					component.set("v.errorMessage", message);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.stopReplaceCreditCard  -" + JSON.stringify(errors));
						this.getToast("Error", JSON.stringify(errors), "error");
					}
				} else {
					component.set("v.errorMessage", "EBStopAndReplaceCreditCardController.stopReplaceCreditCard -" + state);
					this.getToast("Error", "An Error Occurred", "error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
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