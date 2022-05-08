({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		helper.getPolicyData(component);

		var columns = [
			{ label: "Name", fieldName: "firstName", type: "text" },
			{ label: "Surname", fieldName: "surname", type: "Text" },
			{ label: "Benefit Type", fieldName: "benefitType", type: "text" },
			{ label: "Date Of Birth", fieldName: "dateOfBirth", type: "text" },
			{ label: "Cover Option", fieldName: "cover", type: "text" },
			{ label: "Premium", fieldName: "premium", type: "text" },
			{ label: "Action", type: "button-icon", typeAttributes: { iconName: "utility:edit", name: "edit" } }
		];
		component.set("v.sumAssuredDataColumns", columns);
	},

	handleRowAction: function (component, event, helper) {
		var row = event.getParam("row");
		component.set("v.rowData", row);

		var actionName = event.getParam("action").name;

		if (actionName == "edit") {
			component.set("v.ammendDetails", true);
			component.find("fCoverAmount").set("v.value", "");
			if (component.get("v.errorMessage")) {
				component.find("btnSubmit").set("v.disabled", true);
			} else {
				component.find("btnSubmit").set("v.disabled", false);
			}
		}
	},

	closeAmendMemberDetails: function (component, event, helper) {
		component.set("v.ammendDetails", false);
	},

	handleSubmitMemberDetails: function (component, event, helper) {
		helper.submitMemberDetails(component, event, helper);
	},

	closeConfirmMemberDetails: function (component, event, helper) {
		component.set("v.confirmMemberDetails", false);
		component.set("v.ammendDetails", true);
	},

	handleConfirmMemberDetails: function (component, event, helper) {
		helper.confirmMemberDetails(component, event, helper);
	}
});