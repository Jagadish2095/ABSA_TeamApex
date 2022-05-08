({
	init: function (component, event, helper) {
		var listType = component.get("v.questionListType");
		helper.knockoutHelper(component, listType);
	},

	atestationChange: function (component, event) {
		var result = event.getParam("value");
		component.set("v.knockoutQuestionResult", result);
		var knockoutQuestionResultValue = component.get("v.knockoutQuestionResult", result);
		if (knockoutQuestionResultValue == "accept") {
			component.set("v.knockoutQuestionResultAccept", true);
		} else {
			component.set("v.knockoutQuestionResultAccept", false);
            component.set("v.isAllClausesSet",false);
		}
	},

	RequireIDPORChange: function (component, event, helper) {
		var globalId = component.getGlobalId();
		var requireIDPOR = document.getElementById(globalId + "_RequireIDPOR");
		component.set(" v.requireIDPORChecked ", requireIDPOR.checked);
		helper.SelectionCallback(component, event);
	},

	CasaClauseChange: function (component, event, helper) {
		var globalId = component.getGlobalId();
		var casaClause = document.getElementById(globalId + "_CasaClause");
		component.set(" v.casaClauseChecked ", casaClause.checked);

		helper.SelectionCallback(component, event);
	},

	ReadCasaClause: function (component, event, helper) {
		component.set("v.isCheckBoxOn", false);
	}
});