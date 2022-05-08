({
	getRelatedPartyData: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			var action = component.get("c.getRelatedPartiesDetails");
			action.setParams({
				accountId: component.get("v.accountRecId")
			});
			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();

				if (state == "SUCCESS") {
					var resp = response.getReturnValue();

					var arrlength = Object.keys(resp).length;
					component.set("v.numberOfRelatedPatries", arrlength);
					component.set("v.test", resp);
					component.set("v.thirdpartydata", resp);
					
					//Enable or Disable Next button.

					var boolVisible = false;
					var TempIsRadioChecked = false;

					if (resp != null && resp.length > 1) {
						var selectedController = resp.filter((c) => c.accountMandatorySignatory == true).length;
						component.set("v.numberOfSelectedSignatories", selectedController);
					}

					let allIdsList = component.get("v.thirdpartydata");
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
					resolve("success");
				} else if (state === "ERROR") {
					var errors = response.getError();
					console.log("getRelatedPartyData Apex error: " + JSON.stringify(errors));
					reject("error");
				} else {
					console.log("getRelatedPartyData Unexpected error occurred, state returned: " + state);
					reject("error");
				}
			});
			$A.enqueueAction(action);
		});
	},
	getCasaMainRefnumber: function (component, helper) {
		return new Promise(function (resolve, reject) {
			var action = component.get("c.getCasaReferenceNum");

			action.setParams({
				accountId: component.get("v.accountRecId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var casarefnum = response.getReturnValue();

					component.set("v.casamainreferencenumber", casarefnum);
					resolve("success");
				} else if (state === "ERROR") {
					var errors = response.getError();

					component.set("v.errorMessage", "getCasaRefnumberByAcountnumber Error: " + JSON.stringify(errors));
					reject("error");
				} else {
					component.set("v.errorMessage", "getCasaRefnumberByAcountnumber Unexpected error occurred, state returned: " + state);
					reject("error");
				}
			});
			$A.enqueueAction(action);
		});
	},
	getCasaRefnumberByRecordID: function (component, helper, isRelatedParty) {
		return new Promise(function (resolve, reject) {
			var action = component.get("c.getCasaReferenceNum");
			var accountId;
			if (isRelatedParty && component.get("v.relatedPartyIDNumber") != "") {
				accountId = component.get("v.relatedPartyIDNumber");
			} else {
				accountId = component.get("v.accountRecId");
			}
			action.setParams({
				accountId: accountId //component.get("v.accountRecId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var casarefnum = response.getReturnValue();
					console.debug("response.casaRefNumbers " + casarefnum);
					component.set("v.casareferencenumber", casarefnum);
					var f = component.get("v.casareferencenumber");
					console.debug("v.casareferencenumber  " + component.get("v.casareferencenumber"));
					resolve("success");
				} else if (state === "ERROR") {
					var errors = response.getError();

					component.set("v.errorMessage", "getCasaRefnumberByAcountnumber Error: " + JSON.stringify(errors));
					reject("error");
				} else {
					component.set("v.errorMessage", "getCasaRefnumberByAcountnumber Unexpected error occurred, state returned: " + state);
					reject("error");
				}
			});
			$A.enqueueAction(action);
		});
	},

	ScreenRelatedParties: function (component, helper) {
		return new Promise(function (resolve, reject) {
			helper.showSpinner(component);
			var action = component.get("c.screenstokvelRelatedParties");
			action.setParams({
				accountId: component.get("v.accountRecId"),
				casaRefNumber: component.get("v.casamainreferencenumber")
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS" && screenRespObj == "SUCCESS") {
					helper.fireToast("SUCCESS", "Signatories Screened successfully", "success");
					component.set("v.errorMessage", "");
					resolve("success");
				} else if (state == "ERROR") {
					var errors = response.getError();
					reject(errors);
				} else {
					reject(screenRespObj);
				}
			});
			$A.enqueueAction(action);
		});
	},

	getOverallcasaStatus: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getOverallCasastatus");
		action.setParams({
			casaRefNum: component.get("v.casamainreferencenumber"),
			accountId: component.get("v.accountRecId")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();

			if (state === "ERROR") {
				var errors = response.getError();
				helper.fireToast("Error", "An error occurred on getOverallcasaStatus. ", "error");
				console.log("getOverallcasaStatus Apex error: " + JSON.stringify(errors));
			}
		});
		$A.enqueueAction(action);
	},

	saveDocumentInfo: function (component, event, helper) {
		helper.showSpinner(component);
		var relatedPartyRecordID = component.get("v.relatedPartyRecordID");
		var accountRecId = component.get("v.accountRecId");
		var currentScannedDocuments = component.get("v.currentScannedDocuments");
		var action = component.get("c.insertDocumentInformation");
		action.setParams({
			currentScannedDocuments: currentScannedDocuments,
			accountRecId: accountRecId,
			relatedPartyRecordID: relatedPartyRecordID
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();

			if (state === "ERROR") {
				helper.hideSpinner(component);
				var errors = response.getError();
				helper.fireToast("Error", "An error occurred on saveDocumentInfo. ", "error");
				console.log("saveDocumentInfo Apex error: " + JSON.stringify(errors));
			}
			helper.hideSpinner(component);
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
		component.set("v.isButtonActive", false);

		let controllerSelected = component.get("v.controllerSelected");
		let SelectedSignatories = component.get("v.numberOfSelectedSignatories");

		let arrlength = component.get("v.numberOfRelatedPatries");
		if (arrlength == 5) {
			component.set("v.CanAddRelatedParty", false);
			//$A.util.addClass(component.find("addSignatoryBtn"), "slds-hide");
		} else {
			//$A.util.addClass(component.find("addSignatoryBtn"), "slds-show");
			component.set("v.CanAddRelatedParty", true);
			$A.util.addClass(component.find("mySpinner"), "slds-show");
		}
		if (controllerSelected && arrlength >= 2) {
			component.set("v.CanNavigate", true);
		} else {
			component.set("v.CanNavigate", false);
		}
		if (arrlength < 2) {
			component.set("v.addRelatedParty", true);
			//alert("A minimun of 2 related parties are required to proceed.");
			component.set("v.isButtonActive", true);
		}
	},

	isRefreshed: function (component, event, helper) {
		location.reload();
	},
	getRelatedpartiesCount: function (component) {
		var action = component.get("c.getRelatedpartyCount");
		action.setParams({
			mainAccountId: component.get("v.accountRecId")
		});
		// set a callBack
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			component.set("v.numberOfRelatedPatries", resp);
			
			if (state === "ERROR") {
				var errors = response.getError();
				helper.fireToast("Error", "An error occurred on getRelatedpartyCount. ", "error");
				console.log("getRelatedpartyCount Apex error: " + JSON.stringify(errors));
			}
		});
		$A.enqueueAction(action);
	},

});