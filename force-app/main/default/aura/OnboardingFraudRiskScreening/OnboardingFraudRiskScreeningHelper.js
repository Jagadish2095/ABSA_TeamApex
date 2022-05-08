({
	getFraudResults: function (component, event, helper) {
		var opportunityId = component.get("v.recordId");
		//var opportunityId = '0060E00000VVu6YQAT';
		console.log("opportunityId:" + opportunityId);

		var action = component.get("c.getOpportunityData");
		action.setParams({ recordId: opportunityId });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var opportunity = response.getReturnValue();

				component.set("v.opportunityRecord", response.getReturnValue());
				if (opportunity.FraudRiskAlert__c != undefined || opportunity.FraudRiskActionTaken__c != undefined) {
					component.set("v.showFraudResponse", true);
					var appEvent = $A.get("e.c:FraudRiskAppEvent");
					appEvent.setParams({
						fraudRiskAlertP: opportunity.FraudRiskAlert__c,
						fraudRiskActionP: opportunity.FraudRiskActionTaken__c
					});
					appEvent.fire();
					$A.get("e.force:refreshView").fire();
				}
			} else {
				var toast = this.getToast("Error", "Something went wrong. Please contact Administrator", "error");
				toast.fire();
			}
		});
		$A.enqueueAction(action);
	},
	submitFraudRisk: function (component, event, helper) {
		this.showSpinner(component);
		var action = component.get("c.callFraudRiskScreening");
		var opportunityId = component.get("v.recordId");
		console.log("opportunityId:" + opportunityId);
		//var opportunityId = '0060E00000VVu6YQAT';

		action.setParams({ recordId: opportunityId });
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state == "SUCCESS") {
				console.log("Fraud Response>>" + response.getReturnValue());
				if (response.getReturnValue() != null && response.getReturnValue().toUpperCase().includes("SUCCESS") == true) {
					var response = response.getReturnValue();
					this.getFraudResults(component);
					component.set("v.showFraudResponse", true);

					$A.util.addClass(component.find("fraudSubmitButton"), "slds-hide");
					component.set("v.activeFraudSections", "FraudRiskScreeningResults");
					/*
                    if(opportunity.FraudRiskAlert__c=='Suspect' || opportunity.FraudRiskAlert__c=='High Fraud Potential'){
                        $A.util.removeClass(component.find("fraudRefreshButton"), 'slds-hide');
                    }
                    */
					helper.hideSpinner(component);
					helper.getToast("Success", "Instinct Fraud Risk Screening has been Successfully Completed.", "success");
				} else {
					console.log("Failed with state: " + response.getReturnValue());
					helper.hideSpinner(component);
					helper.getToast("Error", response.getReturnValue(), "error");
				}
			}
		});
		$A.enqueueAction(action);
	},
	//Function to show spinner when loading
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Function to hide spinner after loading
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},

	//Lightning toastie
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});