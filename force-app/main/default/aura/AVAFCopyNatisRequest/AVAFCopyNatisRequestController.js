({
	sendAVAFCopyNatis: function (component, event, helper) {
		if (helper.allFieldsValid(component)) {
			helper.sendAVAFCopyNatisHelper(component, event, helper);
		}
	}
});