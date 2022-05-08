({
	getClientData: function (component, event, helper) {
		component.set("v.errorMessage", null);
		helper.showSpinner(component);
		var action = component.get("c.getClientDetails");
		action.setParams({
			clientCodeP: component.get("v.clientCodeP"),
			accNumberP: "0",
			siteCodeP: "0"
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (resp["isResponseSuccess"]) {
					component.set("v.notifyMe", resp["notifyMeFlag"]);
					component.set("v.absaRewardsLoyalty", resp["absaRewardFlag"]);
					component.set("v.mobileApp", resp["cellphoneBankingFlag"]);
					component.set("v.internetBanking", resp["internetBankingFlag"]);
					component.set("v.telephoneBanking", resp["telebankingFlag"]);
					component.set("v.cellphoneBanking", resp["cellphoneBankingFlag"]);
					component.set("v.pingItWallet", resp["pingItWalletFlag"]);
					component.set("v.pingItReceive", resp["pingitReceiveFlag"]);
					component.set("v.unclaimedFunds", resp["unclaimedFundsFlag"]);
					component.set("v.securityHeld", resp["securityIndicatorFlag"]);
				} else {
					component.set("v.errorMessage", "Error retrieving service & channel subscriptions, please contact your admin!");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error retrieving service & channel subscriptions", +JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getClientData method. State: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	hideSpinner: function (component) {
		component.set("v.isShowSpinner", "false");
	},

	showSpinner: function (component) {
		component.set("v.isShowSpinner", "true");
	}
});