({
	init: function (component, event, helper) {
		component.set("v.referralOptions", helper.getReferralOptions());
		if (!component.get("v.isReferred")) {
			helper.getScoringValues(component);
		} else {
			component.set("v.fromScoring", false);
			helper.getApplicationInfo(component);
		}
	},

	referralButtonIcon: function (component, event) {
		if (component.get("v.referralSelected")) {
			component.set("v.referralSelected", false);
			component.set("v.referralIconName", "utility:add");
			component.find("branchFlowFooter").set("v.finishLabel", "Finish");
			component.find("branchFlowFooter").set("v.finishDisabled", "false");
			component.set("v.activeReferralSections", "");
		} else {
			component.set("v.referralSelected", true);
			component.set("v.referralIconName", "utility:success");
			component.find("branchFlowFooter").set("v.finishLabel", "Refer Application");
			component.find("branchFlowFooter").set("v.finishDisabled", "true");
			component.set("v.activeReferralSections", "ReferApplication");
		}
	},

	referralOptionChange: function (component, event) {
		var optionSelected = event.getParam("value");
		if (optionSelected == "Stop") {
			component.set("v.showComments", false);
		} else {
			component.set("v.showComments", true);
		}
	},

	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		component.set("v.updating", true);
		component.set("v.actionClicked", actionClicked);

		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				if (component.get("v.fromScoring")) {
					var confirmed = helper.confirmSelection(component);
					if (confirmed) {
						helper.executeSelection(component);
					} else {
						component.set("v.updating", false);
					}
				} else {
					component.set("v.updating", false);
					navigate(actionClicked);
				}
				break;
			case "PAUSE":
				component.set("v.updating", false);
				navigate(actionClicked);
				break;
		}
	},

	handleKofaxResponse: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		component.set("v.showKofax", false);
		component.set("v.isReferred", true);
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			message: "Credit Card Application Successfully Referred",
			type: "success"
		});
		toastEvent.fire();
		navigate("PAUSE");
	},

	closeKofax: function (component, event, helper) {
		component.set("v.showKofax", false);
	}
});