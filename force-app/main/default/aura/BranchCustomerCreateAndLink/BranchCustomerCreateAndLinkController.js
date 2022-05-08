({
	init: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var IsNoneScoredProduct = component.get("v.IsNoneScoredProduct");
		if (IsNoneScoredProduct) {
			var isNewToBank = component.get("v.IsNewToBank");
			if (isNewToBank) {
				component.set("v.accoutOpeningReason", "ACC OPENED - NO ACC PREVIOUSLY");
			} else {
				component.set("v.accoutOpeningReason", "ACC OPENED - HAS AN ACC IN ABSA");
			}

			helper.loadProductData(component, event);

			helper.fetchTranslationValues(component, "v.sourceOfFundsList", "CIFCodesList", "Sof", "Outbound");

			helper.fetchTranslationValues(component, "v.groupSchemeList", "CIFCodesList", "Group Scheme", "Outbound");

			helper.fetchAccountOpeningReasonsValues(component, "v.accoutOpeningReasonList", "Reason", "Outbound");

		} else {
			var createAction = component.get("c.callCreateAndLinkService");
			createAction.setParams({
				component: component,
				event: event
			});
			$A.enqueueAction(createAction);
		}
	},

	handleNavigate: function (component, event) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				var createAction = component.get("c.callCreateAndLinkService");
				createAction.setParams({
					component: component,
					event: event
				});
				$A.enqueueAction(createAction);
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	},

	callCreateAndLinkService: function (component, event) {
		component.set("v.showSpinner", true);
		component.set("v.spinnerText", "Calling Create and Link");
		var oppId = component.get("v.opportunityId");
		var paymentPlanId = component.get("v.paymentPlanId");
		var usePackageAccount = component.get("v.usePackageAccount");
		var sourceOfFunds = component.get("v.sourceOfFunds");
		var productFamily = component.get("v.productFamily");
		var primaryAccountNumber = component.get("v.primaryAccountNumber");

		var accountOppeningCommon = {
			paymentPlanId: paymentPlanId,
			usePackageAccount: usePackageAccount,
			sourceOfFunds: sourceOfFunds,
			productFamily: productFamily,
			spouseAccountNumber: primaryAccountNumber
		};

		//setup call
		var action = component.get("c.createAndLinkProductByFamily");
		action.setParams({
			oppId: oppId,
			createRetailObj: JSON.stringify(accountOppeningCommon)
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var spinner = component.find("spinner");
			component.set("v.showSpinner", false);
			if (state == "SUCCESS") {
				var response = response.getReturnValue();
				var updateAction = component.get("c.callUpdateAccountOpeningService");
				updateAction.setParams({
					component: component,
					event: event
				});
				if (response == "HIGH_FRAUD_POTENTIAL" || response == "SUSPECT") {
					component.find("branchFlowFooter").set("v.heading", "Fraud Refer: ");
					component.find("branchFlowFooter").set("v.message", "Fraud Refer: " + response);
					component.find("branchFlowFooter").set("v.showDialog", true);

					$A.enqueueAction(updateAction);
				} else {
					$A.enqueueAction(updateAction);
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

	callUpdateAccountOpeningService: function (component, event) {
		component.set("v.showSpinner", true);
		component.set("v.spinnerText", "Updating Account opening details");
		var oppId = component.get("v.opportunityId");

		var accountName = component.get("v.accountName");
		var managerNumber = component.get("v.managerNumber");
		var mandateNumber = component.get("v.mandateNumber");
		var openingReason = component.get("v.accoutOpeningReason");
		var sourceOfFunds = component.get("v.sourceOfFunds");
		var productFamily = component.get("v.productFamily");
		var groupScheme = component.get("v.groupSchemeName");

		var accountOppeningCommon = {
			accountName: accountName,
			managerNumber: managerNumber,
			mandateNumber: mandateNumber,
			openingReason: openingReason,
			sourceOfFunds: sourceOfFunds,
			productFamily: productFamily,
			groupSchemeEmployer: groupScheme,
		};

		var action = component.get("c.productUpdateAccountOpenDetails");
		action.setParams({
			oppId: oppId,
			createRetailObj: JSON.stringify(accountOppeningCommon)
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var spinner = component.find("spinner");
			component.set("v.showSpinner", false);
			if (state == "SUCCESS") {
				var ciUpdateAction = component.get("c.callUpdateCIFWithAccountOpeningService");
				ciUpdateAction.setParams({
					component: component,
					event: event
				});
				$A.enqueueAction(ciUpdateAction);
			} else {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to update account opening service");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						console.log("unknown error");
					}
				}
			}
		});

		$A.enqueueAction(action);
	},

	callUpdateCIFWithAccountOpeningService: function (component, event) {
		component.set("v.showSpinner", true);
		component.set("v.spinnerText", "Updating CIF with Account details");
		var oppId = component.get("v.opportunityId");
		var sourceOfFunds = component.get("v.sourceOfFunds");
		var productFamily = component.get("v.productFamily");

		var action = component.get("c.updateCIFWithAccountOpening");
		action.setParams({
			oppId: oppId,
			sourceOfFunds: sourceOfFunds,
			productFamily: productFamily
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var spinner = component.find("spinner");
			component.set("v.showSpinner", false);
			if (state == "SUCCESS") {
				var submitMetadataAction = component.get("c.callSubmitAccountMetadataService");
				submitMetadataAction.setParams({
					component: component,
					event: event
				});
				$A.enqueueAction(submitMetadataAction);
			} else {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to update CIF");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						console.log("unknown error");
					}
				}
			}
		});

		$A.enqueueAction(action);
	},

	callSubmitAccountMetadataService: function (component, event) {
		component.set("v.showSpinner", true);
		component.set("v.spinnerText", "Updating Account Metadata service");
		var oppId = component.get("v.opportunityId");
		var productFamily = component.get("v.productFamily");

		var action = component.get("c.submitAccountMetadata");
		action.setParams({
			oppId: oppId,
			productFamily: productFamily
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var spinner = component.find("spinner");
			component.set("v.showSpinner", false);
			if (state == "SUCCESS") {
				var navigate = component.get("v.navigateFlow");
				navigate("NEXT");
			} else {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.find("branchFlowFooter").set("v.heading", "Failed to update account metadata");
						component.find("branchFlowFooter").set("v.message", errors[0].message);
						component.find("branchFlowFooter").set("v.showDialog", true);
					} else {
						console.log("unknown error");
					}
				}
			}
		});

		$A.enqueueAction(action);
	}
});