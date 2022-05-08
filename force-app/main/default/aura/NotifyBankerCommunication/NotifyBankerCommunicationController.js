({
	doInit: function (component, event, helper) {
		if (component.get("v.isEmailEditable")) {
			component.find("clientEmailAddress").set("v.value", component.get("v.caseRecord.Client_Email_Address__c"));
		}
		if (component.get("v.mandateEmail") != "") {
			component.find("clientEmailAddress").set("v.value", component.get("v.mandateEmail"));
			component.find("mobile").set("v.value", component.get("v.mobileNumber"));
		}
		if (component.get("v.notifyBanker")) {
			helper.getBanker(component, event);
		}

		//Added by chandra to check service group and set hasBanker attribute dated 07/01/2021.
		if (component.get("v.caseRecord.sd_Service_Group__c") == "Business Banking") {
			component.set("v.hasBanker", true);
		} else {
			component.set("v.hasBanker", false);
		}
	},
	closeCase: function (component, event, helper) {
		component.set("v.isModalShow", true);
	},

	executeJob: function (component, event, helper) {
		component.set("v.isModalShow", false);
		component.set("v.executeAnotherJob", true);
		component.set("v.executeJobs", false);
		component.set("v.message", "Click next to select another job");
		helper.closeOpenAnotherJob(component, event);
	},

	closeModal: function (component, event, helper) {
		component.set("v.isModalShow", false);
		component.set("v.executeAnotherJob", false);
		helper.showSpinner(component);
		var notifyBanker = component.get("v.notifyBanker");
		var sendComfromation = component.get("v.sendConfirmation");
		var commsMethod = component.find("commMethod").get("v.value");

		if (!sendComfromation) {
			if (commsMethod == "SMS") {
				helper.sendCustomerSMS(component);
			} else if (commsMethod == "Email") {
				helper.sendCustomerEmail(component);
			} else {
				component.set("v.errorMessage", "Communication method currently not supported");
				helper.hideSpinner(component);
			}
		} else {
			helper.doNotSendConfirmation(component, event);
		}

		if (notifyBanker) {
			helper.notifyBanker(component, event);
		}
	}
});