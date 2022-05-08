({
	/****************@ Author: Chandra**************************************
	 ****************@ Date: 17/11/2020*************************************
	 ****************@ Work Id: W-006962************************************
	 ***@ Description: Method Added by chandra to close the case***********/
	caseCloseHelper: function (component, event, helper) {
		component.find("close").set("v.disabled", true);
		helper.showSpinner(component);
		var caseStatusUpdate = component.get("c.caseStatusUpdate");
		caseStatusUpdate.setParams({
			caseId: component.get("v.caseId")
		});

		caseStatusUpdate.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var returnResponse = response.getReturnValue();
				if (returnResponse == "success") {
					helper.fireToastEvent("Success!", "Case has been successfully closed!", "success");
					$A.get("e.force:refreshView").fire();
				} else {
					component.set("v.errorMessage", "Case could not be closed. Error: " + returnResponse);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
			}

			helper.hideSpinner(component);
		});
		$A.enqueueAction(caseStatusUpdate);
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 17/11/2020*************************************
	 ****************@ Work Id: W-006962************************************
	 ***@ Description: Method Added by chandra to get Arrear Status*********/
	preValidateAccountNumber: function (component, event, helper) {
		helper.showSpinner(component);
		var document = [];
		var selectedAccNumber = component.get("v.SelectedAccNumberFromFlow");
		var action = component.get("c.preValidateAccountInfo");
		action.setParams({
			accountNumber: parseInt(selectedAccNumber)
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnResponse = response.getReturnValue();
				if (returnResponse.statusCode == 200) {
					document = returnResponse.documents.document;
					document.forEach(function (documentItem) {
						if (documentItem.name == component.get("v.SelectedServiceTypeFromFlow")) {
							var indicator = documentItem.indicator;
							component.set("v.indicator", indicator);
							if (indicator == "N") {
								component.set(
									"v.errorMessage",
									"Validation for the selected account failed. The document cannot be generated. Validation error as follows: " +
										documentItem.message
								);
							}
						}
					});
				} else {
					component.set(
						"v.errorMessage",
						"Error in preValidateAccountInfo method. Unexpected response received. Response: " + JSON.stringify(returnResponse)
					);
					component.set("v.isCaseCloseShow", true);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error in preValidateAccountInfo method. Error message: " + JSON.stringify(errors));
				component.set("v.isCaseCloseShow", true);
			} else {
				component.set("v.errorMessage", "Unknown error in preValidateAccountInfo method. State: " + state);
				component.set("v.isCaseCloseShow", true);
			}

			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 17/11/2020**************************************
	 ****************@ Work Id: W-006962*************************************
	 ***@ Description: Method Added by chandra for Lightning toastie********/

	fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 17/11/2020*************************************
	 ****************@ Work Id: W-006962************************************
	 ***@ Description: Method Added by chandra for hiding spinner***********/
	hideSpinner: function (component) {
		component.set("v.showSpinner", "false");
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 17/11/2020*************************************
	 ****************@ Work Id: W-006962************************************
	 ***@ Description: Method Added by chandra for showing spinner**********/
	showSpinner: function (component) {
		component.set("v.showSpinner", "true");
	}
});