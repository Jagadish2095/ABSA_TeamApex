({
	init: function (component, event, helper) {
		helper.setIsVisible(component);
		helper.fetchProductRecord(component, event, helper);
	},
	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
				helper.handleProductSelectionEvent(component, event, helper);
				break;
			case "FINISH":
				navigate(actionClicked);
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	},

	onChangeStatement: function (component, event, helper) {
		helper.setIsVisible(component);
	},

	handleCheckProduct: function (component, event, helper) {
		helper.manageSelectedProducts(component);
	}
});