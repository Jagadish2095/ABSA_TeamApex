({
	fetchTranslationValues: function (component, listName, systemName, valueType, direction) {
		var action = component.get("c.getTranslationValues");
		action.setParams({
			systemName: systemName,
			valueType: valueType,
			direction: direction
		});
		action.setCallback(this, function (response) {
			var mapValues = response.getReturnValue();
			var listValues = [];
			for (var itemValue in mapValues) {
				listValues.push(mapValues[itemValue]);
			}
			listValues.sort();
			component.set(listName, listValues);
		});
		$A.enqueueAction(action);
	},
	validateRequiredFields: function (component) {
		if (component.find("InvestTerm") != undefined) {
			const investTermComponent = component.find("InvestTerm");
			investTermComponent.showHelpMessageIfInvalid();
			const percentageAvailableforWithdrawComponent = component.find("PercentageAvailableforWithdraw");
			percentageAvailableforWithdrawComponent.showHelpMessageIfInvalid();
			return investTermComponent.checkValidity() && percentageAvailableforWithdrawComponent.checkValidity();
		}

		if (component.find("NoticePeriod") != undefined) {
			const noticePeriodComponent = component.find("NoticePeriod");
			noticePeriodComponent.showHelpMessageIfInvalid();
			const percentageAvailableforWithdrawComponent = component.find("PercentageAvailableforWithdraw");
			percentageAvailableforWithdrawComponent.showHelpMessageIfInvalid();
			return noticePeriodComponent.checkValidity() && percentageAvailableforWithdrawComponent.checkValidity();
		}
	},
	callupdateAccountConditionsRequestService: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			component.set("v.showSpinner", true);

			var opportunityId = component.get("v.opportunityId");
			var withdrawalPercentage = component.get("v.percentageAvailableforWithdraw");
			var noticePeriod = component.get("v.noticePeriod");
			var investTerm = component.get("v.investTerm");
			var riskRating = component.get("v.riskRating");
			var accountnbr = component.get("v.accountNumber");
			var prodcode = component.get("v.productCode");

			if (investTerm == undefined) {
				investTerm = "0";
			}
			if (noticePeriod == undefined) {
				noticePeriod = "0";
			}
			var action = component.get("c.updateAccountConditionsRequest");
			action.setParams({
				accountnbr: accountnbr,
				noticePeriod: noticePeriod,
				withdrawalPercentage: withdrawalPercentage,
				investTerm: investTerm,
				riskRating: riskRating,
				prodcode: prodcode
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				var resp = response.getReturnValue();
				component.set("v.showSpinner", false);
				if (state == "SUCCESS" && resp == "success") {
					resolve("success");
				} else if (resp.includes("error")) {
					component.find("branchFlowFooter").set("v.heading", "Failed to update account conditions");
					component.find("branchFlowFooter").set("v.message", resp);
					component.find("branchFlowFooter").set("v.showDialog", true);
					reject(resp);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							component.find("branchFlowFooter").set("v.heading", "Failed to update account");
							component.find("branchFlowFooter").set("v.message", errors[0].message);
							component.find("branchFlowFooter").set("v.showDialog", true);

							reject(errors);
						} else {
							console.log("unknown error");
							reject("ERROR");
						}
					}
				}
			});
			$A.enqueueAction(action);
		});
	}
});