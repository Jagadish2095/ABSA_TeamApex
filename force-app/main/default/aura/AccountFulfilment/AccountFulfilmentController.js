({
	doInit: function (component, event, helper) {
		var today = new Date().toJSON().slice(0, 10).replace(/-/g, "/");
		component.set("v.todayData", today);
		component.set("v.wasNotRiskProfiled", true);
		//component.set("v.wasNotRiskProfiled", false);
		helper.fetchValidatedTranslationValues(component, "v.sourceOfFundsList", "CIF", "Source of Funds", "Outbound", "Application__c", "Source_of_Funds__c");
		helper.fetchTranslationValues(component, "v.purposeOfAccountList", "Savings", "Reason", "Outbound");
		helper.fetchTranslationValues(component, "v.brokerSourceList", "Savings", "Brocker Source", "Outbound");
		helper.fetchTranslationValues(component, "v.investmentTermList", "Savings", "Investment Term", "Outbound");
		helper.fetchTranslationValues(component, "v.noticePeriodList", "Savings", "Notice Period", "Outbound");
		helper.setDefaultValues(component);
		debugger;

		helper.riskProfile(component, helper);
		helper.generateDocuments(component, helper);
		helper.FraudCallDetails(component, helper);
	},

	handleNavigate: function (component, event, helper) {
		const fieldIsMandatoryError = "Please fulfill required fields";

		if (!helper.validateRequiredFields(component)) {
			helper.fireToast("Error", fieldIsMandatoryError, "error");
			return;
		}

		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		var wasNotProfiled = component.get("v.wasNotRiskProfiled");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				if (wasNotProfiled) {
					helper.riskProfile(component, helper);
				} else {
					var createAction = component.get("c.callCreateAndLinkService");
					createAction.setParams({
						component: component,
						event: event
					});
					$A.enqueueAction(createAction);
				}
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	},

	submitDetails: function (component, event) {
		//update account
		var brokerNumber = ""; //component.get("v.brokerNumber");
		var opportunityId = component.get("v.opportunityId");
		var accountnumber = component.get("v.accountNumber");
		var action = component.get("c.updateAccountOpeningDet");
		var brokerSource = ""; //component.get("v.brokerSource");
		var purposeofaccount = component.get("v.purposeOfAccount");
		var accountname = component.get("v.accountName");
		var clientCode = component.get("v.clientCode");

		action.setParams({
			opportunityId: opportunityId,
			accountNumber: accountnumber,
			brokerNumber: brokerNumber,
			openReasonCode: purposeofaccount,
			accountname: accountname,
			clientCode: clientCode
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				//testing
				var e = response.getReturnValue();
				if (e.includes("success")) {
					var navigate = component.get("v.navigateFlow");
					var actionClicked = event.getParam("action");
					navigate("NEXT");
				} else {
					component.set("v.errorupdate", e);
				}
			}
			if (state === "ERROR") {
				var errors = response.getError();
				if (errors[0] && errors[0].message) {
					component.set("v.errorupdate", errors[0].message);
				}
			}
		});

		// enqueue the Action
		$A.enqueueAction(action);
	},

	callCreateAndLinkService: function (component, event) {
		component.set("v.showSpinner", true);
		var opportunityId = component.get("v.opportunityId");
		var withdrawalPercentage = ""; // component.get("v.percentageAvailableforWithdraw");
		var noticePeriod = ""; //component.get("v.noticePeriod");
		var sourceOfFunds = component.get("v.sourceOfFunds");
		var brokerNumber = ""; //component.get("v.brokerNumber");
		var investTerm = ""; //component.get("v.investTerm");
		var riskRating = component.get("v.riskRating");
		var clientCode = component.get("v.clientCode");
		var creditChannel = component.get("v.creditChannel");
		var creditSource = component.get("v.creditSource");
		var debitReason = component.get("v.debitReason");
		var interestPayoutOptionValue = component.get("v.interestPayoutOptionValue");

		var fraudApplicationId = component.get("v.fraudApplicationId");
		var fraudIndicator = component.get("v.fraudIndicator");

		//setup call
		var action = component.get("c.createSavingsAccount");
		action.setParams({
			opportunityId: opportunityId,
			withdrawalPercentage: withdrawalPercentage,
			sourceOfFunds: sourceOfFunds,
			noticePeriod: noticePeriod,
			brokerNumber: brokerNumber,
			investTerm: investTerm,
			riskRating: riskRating,
			crpCode: clientCode,
			creditChannel: creditChannel,
			creditSource: creditSource,
			debitReason: debitReason,
			fraudApplicationId: fraudApplicationId,
			fraudIndicator: fraudIndicator
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			component.set("v.showSpinner", false);
			if (state == "SUCCESS") {
				let accountFulfillmentResult = response.getReturnValue();
				if (accountFulfillmentResult) {
					let accountFulfillment = JSON.parse(accountFulfillmentResult);
					if (accountFulfillment.accountNumber != null) {
						component.set("v.accountNumber", accountFulfillment.accountNumber);
						component.set("v.customerName", accountFulfillment.customerName);
						component.set("v.domicileBranch", accountFulfillment.domicileBranch);
						component.set("v.productType", accountFulfillment.productType);
						component.set("v.domicileBranchCode", accountFulfillment.domicileBranchCode);
						component.set("v.salesConsultant", accountFulfillment.salesConsultant);
						component.set("v.bankClearingCode", "632005");
						component.set("v.productCode", accountFulfillment.productCode);
						const cmpTarget = component.find("Modalbox");
						const cmpBack = component.find("Modalbackdrop");
						$A.util.addClass(cmpTarget, "slds-fade-in-open");
						$A.util.addClass(cmpBack, "slds-backdrop--open");
					} else {
						let displayMessage = "Failed to open account";
						component.find("branchFlowFooter").set("v.heading", "An error has occured");
						component.find("branchFlowFooter").set("v.message", displayMessage);
						component.find("branchFlowFooter").set("v.showDialog", true);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to open account");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						console.log("unknown error");
					}
				}
			} else if (state === "INCOMPLETE") {
				component.find("branchFlowFooter").set("v.heading", "Incomplete action");
				component.find("branchFlowFooter").set("v.message", "The server might be down or the client might be offline.");
				component.find("branchFlowFooter").set("v.showDialog", true);
			}
		});

		// enqueue the Action
		$A.enqueueAction(action);
	},

	handleRiskprofileRetry: function (component, event, helper) {
		helper.riskProfile(component);
	},

	closeModel: function (component, event, helper) {
		const cmpTarget = component.find("Modalbox");
		const cmpBack = component.find("Modalbackdrop");
		$A.util.removeClass(cmpTarget, "slds-fade-in-open");
		$A.util.removeClass(cmpBack, "slds-backdrop--open");
	},
	closeConfirmModal: function (component, event, helper) {
		component.set("v.checkFraudStatus", false);
	},
	closeModal: function (component, event, helper) {
		component.set("v.checkFraudStatus", false);
	}
});