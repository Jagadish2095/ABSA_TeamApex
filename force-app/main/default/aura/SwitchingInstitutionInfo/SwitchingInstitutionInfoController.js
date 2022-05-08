({
	handleKeyUp: function (component, event) {
		var isEnterKey = event.keyCode === 13;
		var searchCmp = component.find("institution-search");
		searchCmp.setCustomValidity("");
		var isValid = searchCmp.get("v.validity").valid;
		searchCmp.reportValidity();
		if (isValid && isEnterKey) {
			var searchText = searchCmp.get("v.value");
			component.set("v.institutionToSearch", searchText);
			component.set("v.canSearchInstitutions", true);
		}
	},

	checkSearch: function (component) {
		if (component.get("v.institutionResult") == "") {
			component.set("v.institutionName", "");
			component.set("v.institutionParticipation", "");
		}
		if (component.get("v.institutionResult") == "Canceled") {
			component.set("v.institutionResult", "");
		}
	},

	validate: function (component) {
		var searchCmp = component.find("institution-search");
		var institutionName = component.get("v.institutionName");
		var showParticipation = component.get("v.showParticipation");
		if ($A.util.isUndefinedOrNull(institutionName) || institutionName == "") {
			if (showParticipation) {
				searchCmp.setCustomValidity("Please capture Service Provider and press enter.");
			} else {
				searchCmp.setCustomValidity("Please capture Employer Name and press enter.");
			}
		}
		searchCmp.reportValidity();
		return searchCmp.get("v.validity").valid;
	}
});