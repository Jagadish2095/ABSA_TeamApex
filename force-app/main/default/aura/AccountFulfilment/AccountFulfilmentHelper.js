({
	FraudCallDetails: function (component, helper) 
	{
		component.set("v.fraudIndicator", "N");
		var opportunityId = component.get("v.opportunityId");
			var clientCode = component.get("v.clientCode");
		component.set("v.showSpinner", true);
		var action = component.get("c.FraudCallDetails");

		action.setParams({
			opportunityId: opportunityId
		});

		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var fraudResponse = "";
			var fruadAppIdVal = "";
			var fraudStatusVal = "";
			var fraudIndicator = "";

			if (state == "SUCCESS") {
				var screenRespObj = response.getReturnValue();
				

				if (screenRespObj != null) {
					var fraudStatusVal = screenRespObj["fraudStatus"];

					fruadAppIdVal = screenRespObj["applicationNbr"];
					component.set("v.fraudApplicationId", fruadAppIdVal);
					
				}
				
				if (fraudStatusVal == "HIGH_FRAUD_POTENTIAL" || fraudStatusVal == "SUSPICIOUS" ||fraudStatusVal == "SUSPECT") {
					fraudResponse = "Fraud Refer";
					component.set("v.fraudIndicator", "Y");
					component.set("v.checkFraudStatus", true);
				}
				else
				{
					component.set("v.fraudIndicator", "N");
				}
			}
		});

		$A.enqueueAction(action);
	},

	riskProfile: function (component, helper) {
		var opportunityId = component.get("v.opportunityId");
		var clientCode = component.get("v.clientCode");
		component.set("v.showSpinner", true);
		var action = component.get("c.attempEntityRiskProfiling");

		action.setParams({
			opportunityId: opportunityId
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var screenRespObj = response.getReturnValue();
				if (screenRespObj == null || screenRespObj == "") {
					component.set("v.showSpinner", false);
					component.set("v.riskProfileService", false);
					component.find("branchFlowFooter").set("v.heading", "Risk Profile Error");
					component.find("branchFlowFooter").set("v.message", "There is an Error while Risk Profiling");
					component.find("branchFlowFooter").set("v.showDialog", true);
					return;
				}
				var riskRating = screenRespObj.match(/\b(\w)/g).join("");
				component.set("v.riskRating", riskRating);
				component.set("v.showSpinner", false);
				var displayMessage = "The entity has been successfully RISK PROFILED.";

				component.set("v.wasNotRiskProfiled", false);
				if (screenRespObj != null && (screenRespObj.toLowerCase() == "high" || screenRespObj.toLowerCase == "very high")) {
					displayMessage = "Please note:  We need to conduct further controls, expect a delay in the processing of your application";
					component.find("branchFlowFooter").set("v.heading", "Enhanced Due Diligence");
					component.find("branchFlowFooter").set("v.message", displayMessage);
					component.find("branchFlowFooter").set("v.showDialog", true);
				}
				helper.fireToast("Success", displayMessage, "success");
			} else {
				component.set("v.riskProfileService", false);
				var errors = response.getError();
				component.set("v.errorMessage", " Risk profiling error: " + errors[0]);
				helper.fireToast("Error", "Risk profiling error: " + errors, "error");
			}

			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	generateDocuments: function (component, helper) {
		return new Promise(function (resolve, reject) {
			component.set("v.showSpinner", true);
			var opportunityId = component.get("v.opportunityId");
			var action = component.get("c.callGenerateDocs");
			action.setParams({
				oppId: opportunityId
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				var returnValue = response.getReturnValue();
				component.set("v.showSpinner", false);
				if (state == "SUCCESS") {
					resolve(returnValue);
				} else {
					reject(returnValue);
				}
			});
			$A.enqueueAction(action);
		});
	},

	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	fetchValidatedTranslationValues: function (component, listName, systemName, valueType, direction, objName, objField) {
		var action = component.get("c.getValidatedTranslationValues");
		var objObject = { sobjectType: objName };
		action.setParams({
			systemName: systemName,
			valueType: valueType,
			direction: direction,
			objObject: objObject,
			objField: objField
		});
		action.setCallback(this, function (response) {
			var mapValues = response.getReturnValue();
			var listValues = [];
			for (var itemValue in mapValues) {
				if (mapValues[itemValue] == "valid") {
					listValues.push(itemValue);
					console.log(itemValue);
				} else {
					// Add function to log/mail system admin with missing values
				}
			}
			listValues.sort();
			component.set(listName, listValues);
		});
		$A.enqueueAction(action);
	},

	fetchTranslationValues: function (component, listName, systemName, valueType, direction) {
		var action = component.get("c.getTranslationValues");
		action.setParams({
			systemName: systemName,
			valueType: valueType,
			direction: direction
		});
		action.setCallback(this, function (response) {
			var mapValues = response.getReturnValue();
			var listValues = [];
			for (var itemValue in mapValues) {
				listValues.push(mapValues[itemValue]);
			}
			listValues.sort();
			component.set(listName, listValues);
		});
		$A.enqueueAction(action);
	},

	fireToast: function (title, msg, type) {
		let toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	validateRequiredFields: function (component) {
		//   const brokerSourceComponent = component.find("BrokerSource");
		//   const brokerNumberComponent = component.find("BrokerNumber");
		const sofComponent = component.find("SOF");
		const purposeOfAccountComponent = component.find("PurposeOfAccount");
		const creditSourceComponent = component.find("creditSource");
		const creditChannelComponent = component.find("creditChannel");
		const debitReasonComponent = component.find("debitReason");

		sofComponent.showHelpMessageIfInvalid();
		purposeOfAccountComponent.showHelpMessageIfInvalid();
		creditSourceComponent.showHelpMessageIfInvalid();
		creditChannelComponent.showHelpMessageIfInvalid();
		debitReasonComponent.showHelpMessageIfInvalid();

		return (
			sofComponent.checkValidity() &&
			purposeOfAccountComponent.checkValidity() &&
			creditSourceComponent.checkValidity() &&
			creditChannelComponent.checkValidity() &&
			debitReasonComponent.checkValidity()
			/*&& investTermComponent.checkValidity()&& noticePeriodComponent.checkValidity() && percentageAvailableforWithdrawComponent.checkValidity()*/
		);
	},

	setDefaultValues: function (component) {
		component.set("v.sourceOfFunds", "MEMBERS CONTRIBUTIONS");
		component.set("v.purposeOfAccount", "ACCOUNT OPENED - REASON : INVESTMENTS");
	}
});