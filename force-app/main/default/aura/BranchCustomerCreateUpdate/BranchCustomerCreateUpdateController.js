({
	init: function (component, event, helper) {
		helper.callCreateUpdate(component, event, helper);
	},

	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				helper.callCreateUpdate(component, event, helper);
				break;
			case "BACK":
				navigate(actionClicked);
				break;
			case "PAUSE":
				navigate(actionClicked);
				break;
		}
	}
});