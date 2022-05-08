({
	init: function (component, event, helper) {
		
		helper.getPrimaryCasa(component);
	},
	refresh: function (component, event, helper) {
		helper.getPrimaryCasa(component);
	},
	viewComments: function (component, event, helper) {
		helper.getCasaComments(component);
	},
	closeComments: function (component, event, helper) {
		component.set("v.displayComment", "false");
	},
	handleNavigate: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		component.set("v.updating", true);
		component.set("v.actionClicked", actionClicked);
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				component.set("v.updating", false);
				var casaScreeningStatus = component.get("v.ScreeningStatus");
				if (casaScreeningStatus == "CONTINUE" || casaScreeningStatus == "INCOMPLETE-RISKP") {
					navigate(actionClicked);
				}else{
					helper.displayCasaStatusError(component,"Incorrect CASA status, cannot continue.");
					break;
				}
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