({
	doInit: function (component, event, helper) {
		helper.doInit(component, event, helper);
		helper.loadReasonToStopCard(component, event);
		helper.loadBrand(component, event);
		component.set("v.selectCombiCard", true);
	},

	//Added by Chandra to stop propagation of selectedJobEvent dated 07/01/2021
	handleSelectedJobEvent: function (component, event, helper) {
		event.stopPropagation();
	},

	handleComponentEvent: function (component, event, helper) {
		var selectedSiteCodeGetFromEvent = event.getParam("recordByEvent");
		component.set("v.siteCode", selectedSiteCodeGetFromEvent);
		component.set("v.selectedSiteCode", selectedSiteCodeGetFromEvent.Site_Code__c);
	},

	onReplaceCard: function (component, event, helper) {
		component.set("v.showCloseSuccessMsg", false);
		component.set("v.showStopButton", false);
		component.set("v.showErrorMsg", false);
		var respObj = component.get("v.responseAccList");
		var selectedChequeNumber = component.get("v.selectedChequeNumber");
		var selectedSavingsNumber = component.get("v.selectedSavingsNumber");
		var replaceCardCheck = component.find("replaceCardCheck").get("v.checked");
		var acc = [];
		var accType = [];
		var chequeAccountNumber = [];
		var savingsAccountNumber = [];
		var prodList = [];

		if (replaceCardCheck === true) {
			component.set("v.showStopButton", false);
			component.set("v.showReplaceCardOpt", true);
			for (var key in respObj) {
				if (!prodList.includes(respObj[key].productType)) {
					if (respObj[key].productType == "CQ" || respObj[key].productType == "SA") {
						prodList.push(respObj[key].productType);
					}
				}
			}
			component.set("v.prodTypesList", prodList);
		} else {
			component.set("v.showStopButton", true);
			component.set("v.showReplaceCardOpt", false);
		}
		var selectedAccountNumber = component.get("v.selectedAccountNumber");
	},

	getAccountNumbers: function (component, event, helper) {
		var selectedProdType = component.get("v.selectedProductValue");
		var respObj = component.get("v.responseAccList");
		var acc = [];

		for (var key in respObj) {
			if (respObj[key].productType == selectedProdType && (respObj[key].status == "ACTIVE" || respObj[key].status == "CURRENT" || respObj[key].status == "OPEN")) {
				acc.push(respObj[key].oaccntnbr.replace(/^0+/, ""));
			}
		}
		component.set("v.accNumList", acc);
	},

	getSelectedAccount: function (component, event, helper) {
		var selectedAccountValue = component.get("v.selectedAccountNumber");
	},

	//load personal details when Yes option is selected
	onPersonalize: function (component, event, helper) {
		var pers = component.get("v.personalize");
		if (pers === "Y") {
			helper.onPersonalize(component, event);
		} else {
			component.set("v.showAccountDetails", false);
		}
	},

	showTransactionDetails: function (component, event, helper) {
		helper.showSpinner(component);
		var combiAccountList = component.get("v.combiCardsAccounts");
		var indexvar = event.getSource().get("v.value");
		var combiNr;
		var action = component.get("c.getPortfolioDetails");

		for (var index in combiAccountList) {
			if (combiAccountList[index] == indexvar) {
				component.set("v.selectCombiCard", false);
				component.set("v.showSelectedCardDetails", true);

				combiNr = combiAccountList[index];
			}
			component.set("v.combiNumber", combiNr);
		}

		action.setParams({ combiNbr: combiNr });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				if (respObj != null) {
					component.set("v.clientCode", respObj.clientCode);
					component.set("v.clientName", respObj.clientName);
					component.set("v.expDate", respObj.exprDate);
					component.set("v.sbuSiteCode", respObj.sbuSiteCode);
					component.set("v.segmentCode", respObj.segmCode);
				} else {
					helper.fireToast("Error!", "Get Portfolio Detail Service Issue  ..Please try again", "error");
				}
			} else if (state === "ERROR") {
				helper.fireToast("Error!", "Service Issue ..Please try again", "error");
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	onSelectReasonOpt: function (component, event, helper) {
		var selectedReason = component.get("v.selectedReason");
		var opts1 = [];
		opts1.push({ class: "optionClass", label: "Acceptance limited ATM", value: "Acceptance limited ATM" });
		opts1.push({ class: "optionClass", label: "Close Card And Account", value: "Close Card And Account" });
		opts1.push({ class: "optionClass", label: "Close Due To Conversion", value: "Close Due To Conversion" });
		opts1.push({ class: "optionClass", label: "Poor Service", value: "Poor Service" });
		opts1.push({ class: "optionClass", label: "Acceptance limited POS", value: "Acceptance limited POS" });
		opts1.push({ class: "optionClass", label: "Others", value: "Others" });

		var opts2 = [];
		opts2.push({ class: "optionClass", label: "Close Card Uncollected", value: "Close Card Uncollected" });
		opts2.push({ class: "optionClass", label: "Fraudulent Usage", value: "Fraudulent Usage" });
		opts2.push({ class: "optionClass", label: "Others", value: "Others " });

		var opts3 = [];
		opts3.push({ class: "optionClass", label: "Closed By System", value: "Closed By System" });

		if (selectedReason === "Customer Request") {
			component.set("v.subReason", opts1);
		} else if (selectedReason === "Bank Request") {
			component.set("v.subReason", opts2);
		} else if (selectedReason === "System Request") {
			component.set("v.subReason", opts3);
		}
	},

	submit: function (component, event, helper) {
		var selectedReason = component.get("v.selectedReason");
		var selectedSubReason = component.get("v.selectedSubReason");
		var combiNumber = component.get("v.combiNumber");

		if (selectedReason == "" && selectedReason == null) {
			helper.fireToast("Error!", "Reason for stopping card Cannot Be Blank.", "error");
		} else if (selectedSubReason == "" || selectedSubReason == null) {
			helper.fireToast("Error!", "Place Of lost or theft Cannot Be Blank.", "error");
		} else {
			helper.submit(component, event);
		}
	},

	submitReplace: function (component, event, helper) {
		helper.submitReplaceHelper(component, event);
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
				console.log("StopReplaceCombiCardController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	}
});