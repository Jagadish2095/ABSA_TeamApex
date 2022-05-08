({
	getPrimaryCasa: function (component) {
		component.set("v.updating", true);
		var action = component.get("c.getPrimaryCasaDetails");
		action.setParams({
			objId: component.get("v.recordId")
		});
		action.setCallback(this, (response) => this.getPrimaryCasaCallback(component, response));
		$A.enqueueAction(action);
	},

	getPrimaryCasaCallback: function (component, response) {
		var state = response.getState();
		if (state === "SUCCESS") {
			var primaryCasa = response.getReturnValue();
			component.set("v.primaryCasa", primaryCasa);
			component.set("v.CasaReference", primaryCasa.CASA_Reference_Number__c);
			component.set("v.ScreeningDate", primaryCasa.CASA_Screening_Date__c);
			if (primaryCasa.Account != null) {
				component.set("v.FirstName", primaryCasa.Account.FirstName);
				component.set("v.Surname", primaryCasa.Account.LastName);
				component.set("v.IDNumber", primaryCasa.Account.ID_Number__pc);
			} else {
				component.set("v.EntityName", primaryCasa.Name);
				component.set("v.isIndividual", false);
			}
			this.handleCasaStatus(component,primaryCasa.CASA_Screening_Status__c);
		} else if (state === "ERROR") {
			this.displayCasaStatusError(component, response.getError());
		}
		component.set("v.updating", false);
	},

	handleCasaStatus: function (component,casaStatus) {
		if (!casaStatus.includes("Error")) {
			component.set("v.ScreeningStatus", casaStatus);
			var isCalledFromFlow = component.get("v.isCalledFromFlow");
			if (
				isCalledFromFlow == false &&
				(casaStatus == "CONTINUE" || casaStatus == "INCOMPLETE-RISKP")
			) {
				component.set("v.isSuccessful", true);
				component.set("v.showSuccess", true);
				component.set("v.showCmp", false);
			}else{
				component.set("v.enablePause", true);
			}
			if (casaStatus == "PENDING APPROVAL") {
				this.displayCasaStatusError(
					component,
					"We need to conduct further controls, expect the delay in the processing your application"
				);
			}
		} else {
			this.displayCasaStatusError(component, casaStatus);
		}
	},

	getCasaComments: function (component) {
		component.set("v.updating", true);
		var action = component.get("c.getAnalystComments");
		action.setParams({
			objId: component.get("v.recordId")
		});
		action.setCallback(this, (response) => this.getCasaCommentsCallback(component, response));
		$A.enqueueAction(action);
	},
	getCasaCommentsCallback: function (component, response) {
		var state = response.getState();
		if (state == "SUCCESS") {
			component.set("v.comment", response.getReturnValue());
			component.set("v.displayComment", "true");
		} else if (state == "ERROR") {
			var errors = response.getError();
			this.displayCasaStatusError(component,JSON.stringify(errors))
		}
		component.set("v.updating", false);
	},

	displayCasaStatusError: function (component, error) {
		component.set("v.enablePause", true);
		if (component.get("v.isCalledFromFlow") && (component.find("branchFlowFooter") != undefined)) {
			component.find("branchFlowFooter").set("v.heading", "Please note");
			component.find("branchFlowFooter").set("v.message", error);
			component.find("branchFlowFooter").set("v.showDialog", true);
		} else {
			component.set("v.errorDisplay", true);
			component.set("v.errorMessage", error);
		}
	}
});