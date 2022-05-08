({
    doInit : function(component, event, helper) {
        helper.showSpinner(component);
		var action = component.get("c.setIdDerivedGenderAndDob");
		action.setParams({
			accountId:component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
                var navigate = component.get("v.navigateFlow");
		        navigate("NEXT");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error BranchCustomerPersonalInformationCTRL.setIdDerivedGenderAndDob: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
        helper.hideSpinner(component);
    },

    hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

})