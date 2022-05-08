({
	init: function (component, event, helper) {
		let isDigitalBnkingDisabled = helper.checkIsDigitalBankingDisabled(component);
		if (!isDigitalBnkingDisabled) {
			helper.checkInternetBankingAllowed(component);
		}
	},

	handleDigitalBankingIconClick: function (component, event, helper) {
		if (component.get("v.digitalBankingSelected")) {
			component.set("v.digitalBankingSelected", false);
			component.set("v.digitalBankingIconName", "utility:add");
		} else {
			component.set("v.digitalBankingSelected", true);
			component.set("v.digitalBankingIconName", "utility:success");
		}
	},

	handleSetupInternetBankingClick: function (component, event, helper) {
		let IsValid = helper.validateRequiredFieldsForSetupIB(component);
		if (IsValid) {
			helper.setupInternetBanking(component);
		}
	},

	handleMaintainUserDetails: function(component, event, helper) {
		helper.maintainUsers(component);
	},

	addAnotherUser: function (component, event, helper) {
		helper.addUserRecord(component);
	},

	handleSelectUserEvent: function (component, event, helper) {
		helper.setSelectedUser(component, event);
	},

	handleGetUserEvent : function (component, event, helper) {
		helper.maintainUser(component, event);
	},

	// handlerSetPinEvent : function (component, event, helper) {
	// 	let userNumber = event.getParam("userNumber");
	// 	component.set("v.pinpadUserNumber", userNumber);
	// 	component.set("v.isPinPadOpen", true);
	// },
	//
	// pinPadComplete : function (component, event, helper) {
	// 	component.set("v.isPinPadOpen", false);
	// 	let pinPadResponse = JSON.parse(component.get("v.pinPadResponse"));
	// 	if (pinPadResponse.IsSuccessful && pinPadResponse.Message != null) {
	// 		helper.showServiceResponse(component, ' Pinpad Successful set', false);
	// 	} else {
	// 		helper.showServiceResponse(component, 'Error Pinpad Response', true);
	// 	}
	// },
	//
	// handleClosePinPad : function (component, event, helper) {
	// 	component.set("v.isPinPadOpen", false);
	// }
});