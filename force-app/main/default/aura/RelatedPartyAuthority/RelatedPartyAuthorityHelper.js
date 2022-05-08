({
	getRelatedPartyData: function (component, event, helper) {
		var action = component.get("c.getRelatedPartiesDetails");
		action.setParams({
			oppId: component.get("v.opportunityId")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state == "SUCCESS") {
				var resp = response.getReturnValue();

				var arrlength = Object.keys(resp).length;

				component.set("v.numberOfRelatedPatries", arrlength);

				console.log("resp: " + resp);
				component.set("v.relatedpartydata", resp);

				//Enable or Disable Next button.

				var boolVisible = false;
				var TempIsRadioChecked = false;

				if (resp != null && resp.length > 1) {
					var selectedController = resp.filter((c) => c.accountMandatorySignatory == true).length;
					component.set("v.numberOfSelectedSignatories", selectedController);
				}

				let allIdsList = component.get("v.relatedpartydata");
				let ids = new Array();
				for (let index = 0; index < allIdsList.length; ++index) {
					var IsRadioSelected = JSON.stringify(allIdsList[index].contactController);
					var IsMandatorySignatorySelected = JSON.stringify(allIdsList[index].accountMandatorySignatory);

					if (IsRadioSelected == "true") {
						TempIsRadioChecked = "true";
					}
					if (TempIsRadioChecked == "true" /*&& IsMandatorySignatorySelected == "true"*/) {
						component.set("v.controllerSelected", true);
					}
				}
				helper.validateMandatorySignatory(component);
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.log("getRelatedPartyData Apex error: " + JSON.stringify(errors));
			} else {
				console.log("getRelatedPartyData Unexpected error occurred, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},
	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
	validateMandatorySignatory: function (component) {
		let allIdsList = component.get("v.relatedpartydata");
		let SelectedSignatories = new Array();
		for (let index = 0; index < allIdsList.length; ++index) {
			var MandatorySignatorySelected = JSON.stringify(allIdsList[index].accountMandatorySignatory);
			if (MandatorySignatorySelected == "true") {
				SelectedSignatories.push(MandatorySignatorySelected);
			}
		}
		if (SelectedSignatories.length >= 2) {
			component.set("v.CanNavigate", true);
		} else {
			component.set("v.CanNavigate", false);
		}
	},

	createAuthLinkForRelatedParties: function (component, helper) {
		return new Promise(function (resolve, reject) {
			var signinginstruction = "";
			if (component.get("v.commentsNeeded") == true) {
				signinginstruction = component.get("v.signatoryInstruction");
			}
			var signatoryCount = component.get("v.signatoryCount");
			helper.showSpinner(component);
			var relatedAuth = component.get("v.relatedpartydata");
			var opportunityID = component.get("v.opportunityId");
			var specialInstruction = signinginstruction;
			var signatoryCount = signatoryCount;
			var relatedParties = JSON.stringify(relatedAuth);
			var action = component.get("c.createRelatedPartiesAuth");
			action.setParams({
				relatedParties: relatedParties,
				opportunityID: opportunityID,
				specialInstruction: specialInstruction,
				signatoryCount: signatoryCount
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS" && screenRespObj == "sucess") {
					component.set("v.errorMessage", "");
					resolve("success");
				} else if (state == "SUCCESS" && screenRespObj.includes("Error")) {
					if (screenRespObj.includes("PLEASE ENTER THE COMMENTS FOR VARIABLE INSTRUCTION ")) {
						component.set("v.commentsNeeded", true);
					} else {
						component.set("v.commentsNeeded", false);
					}
					component.set("v.errorMessage", screenRespObj);
					reject(screenRespObj);
				} else if (state == "ERROR") {
					var errors = response.getError();
					reject(errors);
				}
			});
			$A.enqueueAction(action);
		});
	},
	createProductContactRelationship: function (component, helper) {
		return new Promise(function (resolve, reject) {
			helper.showSpinner(component);
			var signinginstruction = "";
			if (component.get("v.commentsNeeded") == true) {
				signinginstruction = component.get("v.signatoryInstruction");
			}
			var signatoryCount = component.get("v.signatoryCount");
			var relatedAuth = component.get("v.relatedpartydata");
			var opportunityID = component.get("v.opportunityId");
			var action = component.get("c.createProductContactRelation");
	
			var relatedParties = JSON.stringify(relatedAuth);
			action.setParams({
				relatedParties: relatedParties,
				opportunityID: opportunityID,
				specialInstruction: signinginstruction,
				signatoryCount: signatoryCount
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS" && screenRespObj == "Success") {
					resolve("success");
				} else if (state == "SUCCESS" && screenRespObj.includes("ERROR")) {
					reject(screenRespObj);
				} else if (state == "ERROR") {
					var errors = response.getError();
					reject(errors);
				} else {
					var errors = response.getError();
					reject(errors);
				}
			});
			$A.enqueueAction(action);
		});
	},
	validateRequiredFields: function (component) {
		const signatoryCountComponent = component.find("SignatoryCount");

		signatoryCountComponent.showHelpMessageIfInvalid();

		return signatoryCountComponent.checkValidity();
	}
});