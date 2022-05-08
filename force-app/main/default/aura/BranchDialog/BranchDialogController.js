({
	handleDialogOk: function (component, event, helper) {
		component.set("v.dialogOk", true);
		component.set("v.showDialog", false);
	},
	handleDialogNo: function (component, event, helper) {
		component.set("v.yesNoSelection", "No");
		component.set("v.showDialog", false);
	},
	handleDialogYes: function (component, event, helper) {
		component.set("v.yesNoSelection", "Yes");
		component.set("v.showDialog", false);
	}
});