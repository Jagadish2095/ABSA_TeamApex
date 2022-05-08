({
    doInit: function (component, event, helper) {
        helper.getAppDetails(component,helper);
		},
	createmarbleAccount : function(component, event, helper) {
        component.set("v.showSpinner", true);
		helper.marbleaccountcreate(component, event);
	}
})