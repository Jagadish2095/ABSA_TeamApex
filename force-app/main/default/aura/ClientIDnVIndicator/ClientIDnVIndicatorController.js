({
	doInit: function (component, event, helper) {
        helper.checkIDnVPollingUser(component);
	},

	handleAccountLoadIDnV: function (component, event, helper) {
		component.set("v.cifCode", component.find("clientCIFFieldIDnV").get("v.value"));
	},

    handleObjectChange: function (component, event, helper) {
		helper.checkIDnVStatus(component);
	},

	handleRefresh: function (component, event, helper) {
		component.set("v.reinitializeChild", true);
	}
});