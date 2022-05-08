({
	doInit: function (component, event, helper) {
		helper.fetchData(component);
		var heading = "Active Institution(s) based on Search: " + component.get("v.institutionToSearch");
		component.set("v.searchHeading", heading);
	},

	selectInstitution: function (component, event, helper) {
		var showParticipation = component.get("v.showParticipation");
		var institutionParticipation = "";
		var institutionResult = "";
		var row = event.getParam("selectedRows");
		var institutionName = row[0].Name;
		if (showParticipation) {
			institutionParticipation = row[0].Participation;
			institutionResult = institutionName + " (" + institutionParticipation + ")";
		} else {
			institutionResult = institutionName;
		}
		component.set("v.institutionName", institutionName);
		component.set("v.institutionParticipation", institutionParticipation);
		component.set("v.institutionResult", institutionResult);
		component.set("v.searchInstitutionInfo", false);
	},

	addInstitution: function (component, event, helper) {
		component.set("v.addInstitutionInfo", true);
		component.set("v.saveBtnHeading", "Save");
		component.set("v.isSaving", false);
	},

	closeSearch: function (component, event, helper) {
		component.set("v.institutionResult", "Canceled");
		component.set("v.institutionName", "");
		component.set("v.institutionParticipation", "");
		component.set("v.searchInstitutionInfo", false);
	},

	saveInstitution: function (component, event, helper) {
		var isValid = helper.validateFields(component);
		if (!isValid) {
			return;
		}
		component.set("v.saveBtnHeading", "Saving...");
		component.set("v.isSaving", true);
		var action = component.get("c.saveInstitutionToSwitchIt");
		var name = component.get("v.addInstitutionName");
		name = name.toUpperCase();
		var email = component.get("v.addInstitutionContactEmail");
		action.setParams({
			name: name,
			email: email
		});
		action.setCallback(this, function (response) {
			var result = response.getReturnValue();
			if (response.getState() === "SUCCESS") {
				component.set("v.institutionName", name);
				component.set("v.institutionParticipation", "NON_PARTICIPATING");
				component.set("v.institutionResult", name);
				component.set("v.searchInstitutionInfo", false);
			} else if (response.getState() === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						component.set("v.serviceResponse", errors[0].message);
					} else {
						component.set("v.serviceResponse", "Unknown error");
					}
				}
			} else if (response.getState() === "INCOMPLETE") {
				cmp.set("v.serviceResponse", "Incomplete action. The server might be down or the client might be offline.");
			}
			component.set("v.saveBtnHeading", "Save");
			component.set("v.isSaving", false);
		});
		$A.enqueueAction(action);
	}
});