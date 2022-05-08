({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getAccountDetails");
		var clientAccountId = component.get("v.clientAccountIdFromFlow");

		action.setParams({ clientAccountId: clientAccountId });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				component.set("v.responseAccList", respObj);

				var combiAccountList = [];
				var accountNumberList = [];
				var name = [];
				var accSet = new Set();

				for (var key in respObj) {
					if (!combiAccountList.includes(respObj[key].oaccntnbr) && respObj[key].productType == "CO" && respObj[key].status == "ACTIVE") {
						//
						combiAccountList.push(respObj[key].oaccntnbr);
					
					} 

					//SMath W- 010961 7 june 2021
					if (respObj[key].productType == "CQ" && (respObj[key].status == "ACTIVE" || respObj[key].status == "CURRENT")) {
						component.set("v.nomCheq", respObj[key].oaccntnbr);
					}

					if (respObj[key].productType == "SA" && respObj[key].product=="ACTIVE" && (respObj[key].status == "ACTIVE" || respObj[key].status == "CURRENT" || respObj[key].status == "OPEN")) {
						component.set("v.nomSavs", respObj[key].oaccntnbr);
					}

					if (respObj[key].productType == "CA" && (respObj[key].status == "ACTIVE" || respObj[key].status == "CURRENT")) {
						component.set("v.nomCred", respObj[key].oaccntnbr);
					}
					
				}
				component.set("v.combiCardsAccounts", combiAccountList);

				if (combiAccountList.length === 0) {
					component.set("v.noCombiMsg", true);
				}
			} else if (state === "ERROR") {
				helper.fireToast("Error!", "Service Issue ..Please try again", "error");
			} else {
				helper.fireToast("Error!", "State:" + state, "error");
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	loadReasonToStopCard: function (component, event, helper) {
		var opts = [];
		opts.push({ class: "optionClass", label: "Customer Request", value: "Customer Request" });
		opts.push({ class: "optionClass", label: "Bank Request", value: "Bank Request" });
		opts.push({ class: "optionClass", label: "System Request", value: "System Request" });
		component.set("v.reason", opts);
	},

	loadBrand: function (component, event, helper) {
		var opts = [];
		var serviceGroup = component.get("v.serviceGroupFromFlow");

		if (serviceGroup == "Everyday Banking - General Enquiries" || serviceGroup == "Everyday Banking - Telephone Banking") {
			opts.push({ class: "optionClass", label: "Premium Vertical Contactless Card", value: "2141" });
			opts.push({ class: "optionClass", label: "Gold Contactless Debit Card ", value: "2618" });
			opts.push({ class: "optionClass", label: "Student Vertical Debit Card", value: "2632 " });
			opts.push({ class: "optionClass", label: "Flexi Chip Multi Application", value: "2630" });
			opts.push({ class: "optionClass", label: "Youth Debit Contactless ", value: "2627" });
			opts.push({ class: "optionClass", label: "Generic Savings Debit Card", value: "2148" });
		} else {
			opts.push({ class: "optionClass", label: "Visa Flag Debit Business Transact", value: "1300" });
			opts.push({ class: "optionClass", label: "Maestro Debit Blind", value: "1553" });
			opts.push({ class: "optionClass", label: "Visa Classic Business Debit", value: "2818 " });
			opts.push({ class: "optionClass", label: "Electron Debit Chip AC & BB", value: "2138 " });
			opts.push({ class: "optionClass", label: "Visa Flag Debit Chip Business Transact", value: "2155" });
			opts.push({ class: "optionClass", label: "Electron Debit Vanilla", value: "1565" });
			opts.push({ class: "optionClass", label: "Electron Debit Flexi", value: "1318" });
			opts.push({ class: "optionClass", label: "Gold Paypass Chip MasterCard Flag", value: "2506" });
			opts.push({ class: "optionClass", label: "Flexi Debit Chip Visa Flag", value: "2159" });
			opts.push({ class: "optionClass", label: "Visa Student", value: "2828" });
			opts.push({ class: "optionClass", label: "Islamic Debit Chip Visa Flag", value: "2806" });
			opts.push({ class: "optionClass", label: "Absa Visa Silver", value: "2812" });
			opts.push({ class: "optionClass", label: "Business Debit", value: "2631" });
			opts.push({ class: "optionClass", label: "Other", value: "1601" });
		}
		component.set("v.brandList", opts);
	},

	retrievePersonDetails: function (component, event, helper) {
		helper.showSpinner(component);
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		var action = component.get("c.personDetails");
		action.setParams({
			clientAccountId: clientAccountId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var outPutList = JSON.parse(response.getReturnValue());

				for (var key in outPutList) {
					console.log("===" + outPutList[0].Id);
				}
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//load personal details when Yes option is selected
	onPersonalize: function (component, event, helper) {
		component.set("v.showAccountDetails", true);
	},

	submit: function (component, event, helper) {
		this.showSpinner(component);
		// component.set("v.showStopButton",false);
		var selectedReason = component.get("v.selectedReason");
		var selectedSubReason = component.get("v.selectedSubReason");
		var combiNumber = component.get("v.combiNumber");

		var action = component.get("c.closeCombicard");
		action.setParams({
			combiNbr: combiNumber,
			reason: selectedReason,
			subReason: selectedSubReason
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			var response = response.getReturnValue();

			if (state == "SUCCESS") {
				if (response == "Y") {
					this.fireToast("Success!", "Card successfully stopped", "success");
					component.set("v.showReplaceCardOpt", false);
					component.set("v.showStopButton", true);
				} else {
					component.set("v.showStatusErrorMsg", response);
					component.set("v.showReplaceCardOpt", false);
					component.set("v.showStopButton", true);
					this.fireToast("Error!", "Error: " + response, "error");
				}
			} else if (state === "ERROR") {
				this.fireToast("Error!", "Service Issue ..Please try again", "error");
			} else {
				this.fireToast("Error!", "State: " + state, "error");
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	submitReplaceHelper: function (component, event, helper) {
		var accountNo = component.get("v.selectedAccountNumber"),
			persInd = component.get("v.personalize"),
			persName = component.get("v.personalize") != "N" ? component.get("v.name") : "",
			persTitl = component.get("v.personalize") != "N" ? component.get("v.title") : "",
			persInit = component.get("v.personalize") != "N" ? component.get("v.initials") : "",
			persSurn = component.get("v.personalize") != "N" ? component.get("v.surname") : "",
			autoLink = component.get("v.autoLink"),
			clientCode = component.get("v.clientCode"),
			sbuCode = component.get("v.segmentCode"),
			delvBranch = component.get("v.selectedSiteCode"),
			issueBranch = component.get("v.selectedSiteCode"),
			brandNbr = component.get("v.brandNr"),
			cardNbr = component.get("v.combiNumber");
		var action = component.get("c.issueCombiCard");
		var selectedSavingsNumber = component.get("v.selectedProductValue") == "SA" ? component.get("v.selectedAccountNumber") : component.get("v.nomSavs"),
			selectedChequeNumber = component.get("v.selectedProductValue") == "CQ" ? component.get("v.selectedAccountNumber") :component.get("v.nomCheq"),
			selectedCreditNumber = component.get("v.selectedProductValue") == "CA" ? component.get("v.selectedAccountNumber") :component.get("v.nomCred");

		if (component.get("v.selectedProductValue") == "" || component.get("v.selectedProductValue") == null) {
			this.fireToast("Error!", "Product cannot be blank.", "error");
		} else if (accountNo == "" || accountNo == null) {
			this.fireToast("Error!", "Account number cannot be blank.", "error");
		} else if (brandNbr == "" || brandNbr == null) {
			this.fireToast("Error!", "Brand type cannot be blank.", "error");
		} else if (autoLink == "" || autoLink == null) {
			this.fireToast("Error!", "Autolink cannot be blank.", "error");
		} else if (persInd == "" || persInd == null) {
			this.fireToast("Error!", "Personalize cannot be blank.", "error");
		} else if (component.get("v.selectedSiteCode") == "" || component.get("v.selectedSiteCode") == null) {
			this.fireToast("Error!", "Site cannot be blank.", "error");
		} else {
			this.showSpinner(component);
			action.setParams({
				accountNo: accountNo,
				issueBranch: issueBranch,
				persInd: persInd,
				brandNbr: brandNbr,
				autoLink: autoLink,
				persName: persName,
				persTitl: persTitl,
				persInit: persInit,
				persSurn: persSurn,
				delvBranch: delvBranch,
				sbuCode: sbuCode,
				clntCode: clientCode,
				nomCheq: selectedChequeNumber,
				nomSavs: selectedSavingsNumber,
				nomCred: selectedCreditNumber,
				cardNbr: cardNbr
			});

			action.setCallback(this, function (response) {
				var state = response.getState();
				var response = JSON.parse(response.getReturnValue());

				if (response != null) {
					var replacementStatus = response.CCissueCombiCardV1Response.ccp348o.cardIssueInd;
					var msgEntryList = response.CCissueCombiCardV1Response.nbsmsgo3.msgEntry;
					var msgTxt = "";
					msgEntryList.forEach(function (msgEntry) {
						if (msgTxt == "") {
							msgTxt = msgEntry.msgTxt;
						}
					});
					if (state === "SUCCESS" && replacementStatus === "Y") {
						this.fireToast("Success!", "Successfully replaced the card", "success");
					} else {
						this.fireToast("Error!", "Error: " + msgTxt, "error");
						component.set("v.showErrorMsg", true);
						component.set("v.showStatusErrorMsg", msgTxt);
					}
				} else {
					var errorsmsg = "Null response received from the service: Bad Request";
					component.set("v.showErrorMsg", true);
					component.set("v.showStatusErrorMsg", errorsmsg);
				}
				this.hideSpinner(component);
			});
			$A.enqueueAction(action);
		}
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
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