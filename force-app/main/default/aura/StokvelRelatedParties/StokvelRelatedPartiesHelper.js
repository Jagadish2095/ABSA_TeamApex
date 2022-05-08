({
	//Create Account Contact Relationship
	createAccountContactRelationship: function (component, event, helper) {
		debugger;
		return new Promise(function (resolve, reject) {
			var selectedAccount = component.get("v.accountSelected");
			component.set("v.relatedPartyRecordId", selectedAccount.Id);
			console.log("relatedPartyRecordId: " + component.get("v.relatedPartyRecordId"));
			var action = component.get("c.createStokvelRelationship");

			helper.showSpinner(component);
			action.setParams({
				relatedAccountId: selectedAccount.Id,
				primaryEntityId: component.get("v.primaryEntityId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				var resp = response.getReturnValue();
				helper.hideSpinner(component);
				if (state == "SUCCESS") {
					if (resp.includes("SUCCESS")) {
						
						console.log("createAccountContactRelationship SUCCESS");
						helper.fireToast("Success!", "The Related Party was Successfully linked to the Main Stokvel Account. ", "success");
						
						resolve("success");
						
					} else {
						var errors = response.getError();
						reject(errors);
						helper.fireToast("Error", resp, "error");
						component.set("v.errorMessage", resp);
						console.log("createAccountContactRelationship Error: " + resp);
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					helper.fireToast("Error", "createAccountContactRelationship Apex error: " + JSON.stringify(errors), "error");
					component.set("v.errorMessage", "createAccountContactRelationship Apex error: " + JSON.stringify(errors));
					console.log("createAccountContactRelationship Apex error: " + JSON.stringify(errors));
					reject(errors);
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

	//Fire Lightning toast
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
	UpdateRelatedPartiesGender: function (component, helper, selectedAccount) {
		return new Promise(function (resolve, reject) {
			helper.showSpinner(component);
			var action = component.get("c.updateAccountDetails");

			action.setParams({
				accountId: selectedAccount.Id // component.get("v.accountRecId")
			});
			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS") {
					resolve("success");
				} else {
					var errors = response.getError();
					reject(errors);
				}
			});
			$A.enqueueAction(action);
		});
	},
	UpdateRelatedAccount: function (component, helper, selectedAccount) {
		return new Promise(function (resolve, reject) {
			helper.showSpinner(component);
			var action = component.get("c.updateAccountInfo");

			action.setParams({
				selectedAccount: selectedAccount // component.get("v.accountRecId")
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS") {
                    component.set("v.recordId", screenRespObj);
                    component.set("v.relatedPartyRecordId", screenRespObj);
					resolve("success");
				} else {
					var errors = response.getError();
					reject(errors);
				}
			});
			$A.enqueueAction(action);
		});
	}
});