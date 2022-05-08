({
	doInit: function (component, event, helper) {
		helper.setFieldsHelper(component, event);
		helper.getAccountDataHelper(component, event);
	},

	handleRecordEditFormLoad: function (component, event, helper) {
		if (component.get("v.isBusinessAccountFromFlow") == "true") {
			//Business account
			component.set("v.clientEmailAddress", component.find("accountActiveEmailField").get("v.value"));
		} else {
			//Non business account
			component.set("v.clientEmailAddress", component.find("accountPersonEmailField").get("v.value"));
		}
	},

	handleSubmit: function (component, event, helper) {
		helper.updateDueDateHelper(component, event);
	}
});