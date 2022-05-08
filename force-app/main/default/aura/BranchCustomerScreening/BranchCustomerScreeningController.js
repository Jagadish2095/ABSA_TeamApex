({
	init: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var promise = helper.CallScreening(component, helper).then(
			$A.getCallback(function (result) {
				component.set("v.showSpinner", false);
				if (!result.includes("Error")) {
					component.set("v.casaStatus", result);
					if (result == "CONTINUE" || result == "INCOMPLETE-RISKP") {
						component.set("v.screeningPassed", true);
					}
				}
				var isCalledFromFlow = component.get("v.isCalledFromFlow");
				if (isCalledFromFlow) {
					var navigate = component.get("v.navigateFlow");
					navigate("NEXT");
				} else {
					if (component.get("v.screeningPassed")) {
						component.set("v.showSuccess", true);
						component.set("v.isSuccessful", true);
					} else {
						component.set("v.isAnalystComments", true);
					}
				}
			}),
			$A.getCallback(function (error) {
				component.set("v.errorMessage", error);
				var isCalledFromFlow = component.get("v.isCalledFromFlow");
				if (isCalledFromFlow) {
					component.set("v.showMessageDialog", true);
				} else {
					component.set("v.hasProcessStopped", true);
					component.set("v.showSpinner", false);
					component.set("v.showError", true);
					component.set("v.errorDisplay", true);
				}
			})
		);
	},

	handleStatusMessage: function (component, event, helper) {
		var status = component.get("v.casaStatus");
		if (status != "") {
			component.set("v.statusLabel", "CASA Status: ");
			helper.setCasaStatusMessage(component, status);
		} else {
			component.set("v.statusLabel", "");
			component.set("v.casaStatusMessage", "");
		}
	}
});