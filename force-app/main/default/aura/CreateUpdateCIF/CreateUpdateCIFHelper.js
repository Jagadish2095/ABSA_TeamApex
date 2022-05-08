({
	CreateUpdateCIF: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			component.set("v.isSpinner", true);
			var accid = component.get("v.relatedPartyRecordId");
			var action = component.get("c.generateORUpdateCIF");
			action.setParams({
				accountId: accid
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();

				if (state == "SUCCESS" && screenRespObj.includes("Success")) {
					component.set("v.isSpinner", false);
                  //  helper.fireToast("Success", "CIF created successfully","success");
					resolve("success");
				
				} else if (state == "SUCCESS" && screenRespObj.includes("Error")) {
					component.set("v.isSpinner", false);
					
					var error = JSON.stringify(screenRespObj);
					reject(error);
				} else if (state == "ERROR") {
					component.set("v.isSpinner", false);
					var errors = response.getError();
					//  component.set("v.errorMessage", "There was an error while trying to create CIF Error: " + JSON.stringify(errors));
					reject(JSON.stringify(errors));
				}
			});
			$A.enqueueAction(action);
		});
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
	ScreenRelatedParties: function (component, event, helper) {
		return new Promise(function (resolve, reject) {
			component.set("v.isSpinner", true);
			var action = component.get("c.screenRelatedParty");
			action.setParams({
				relatedPartyId: component.get("v.relatedPartyRecordId"),
				mainaccountId: component.get("v.primaryEntityId")
			});

			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();

				if (state == "SUCCESS" && screenRespObj == "SUCCESS") {
					component.set("v.isSpinner", false);

					resolve("success");
				} else
                if (state == "SUCCESS" && !screenRespObj.includes("SUCCESS")) {
					component.set("v.isSpinner", false);
					reject(screenRespObj);
				}
                else if (state == "ERROR") {
					component.set("v.isSpinner", false);
					var errors = response.getError();
					reject(errors);
				} 
			});
			$A.enqueueAction(action);
		});
	}
});