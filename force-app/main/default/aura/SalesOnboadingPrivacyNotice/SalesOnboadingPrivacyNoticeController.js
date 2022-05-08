({
	handleNext: function (component, event, helper) {
		component.set("v.showPrivacyNotice", false);
		component.set("v.showXDSComponent", true);
	},

	closePrivacyNoticeModal: function (component, event, helper) {
		component.set("v.showPrivacyNotice", false);
	}
});