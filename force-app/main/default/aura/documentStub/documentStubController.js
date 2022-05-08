({
	doInit: function(component, event, helper) {
	},

	handleMenuSelect : function(component, event, helper) {
		var selectedMenuItemValue = event.getParam("value");
		var docName = component.get("v.documenttemplate");
        if (selectedMenuItemValue == 'generate'){
            helper.generateDocument(component,docName);
        }
	},
})