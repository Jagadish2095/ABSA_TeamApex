({
	fetchData: function (component) {
		var self = this;
		self.showSpinner(component);
		var showParticipation = component.get("v.showParticipation");
        if (showParticipation) {
            component.set("v.columns", [
                { label: "Institution Name", fieldName: "Name", type: "text" },
                { label: "Participation", fieldName: "Participation", type: "text" }
            ]);
        } else {
            component.set("v.columns", [
                { label: "Institution Name", fieldName: "Name", type: "text" }
            ]);
        }
		let action = component.get("c.searchNameLike");
		var nameLike = component.get("v.institutionToSearch");
		action.setParams({
			nameLike: nameLike
		});
		action.setCallback(this, function (response) {
			var institutionData = response.getReturnValue();
			component.set("v.institutionData", institutionData);
			self.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	validateFields: function (component, event, helper) {
		var isValid = true;

		var name = component.find("addInstitutionName");
		var nameValue = name.get("v.value");
		if (nameValue != null && nameValue != "") {
			$A.util.removeClass(name, "slds-has-error");
			name.setCustomValidity("");
			name.reportValidity();
		} else {
			$A.util.addClass(name, "slds-has-error");
			name.setCustomValidity("Please enter institution name.");
			name.reportValidity();
			isValid = false;
		}
		return isValid;
	},

	showSpinner: function (component) {
		component.set("v.ShowSpinner", true);
	},
	hideSpinner: function (component) {
		component.set("v.ShowSpinner", false);
	},
});