({
	//Create Account Contact Relationship
	createAccountContactRelationship: function (component, event, helper) {
		
		return new Promise(function (resolve, reject) {
			component.set("v.isSpinner", true);
			var action = component.get("c.createStokvelRelationship");

			action.setParams({
				relatedAccountId: component.get("v.relatedPartyRecordId"),
				primaryEntityId: component.get("v.primaryEntityId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				var resp = response.getReturnValue();

				if (state == "SUCCESS") {
					
					if (resp.includes("SUCCESS")) {
						
						console.log("createAccountContactRelationship SUCCESS");
						component.set("v.isSpinner", false);
						helper.fireToast("Success!", "The Related Party was Successfully linked to the Main Stokvel Account. ", "success");
						//Navigate
						debugger;
						resolve("success");
					} else {
						component.set("v.isSpinner", false);
						reject(errors);
						helper.fireToast("Error", resp, "error");
						component.set("v.errorMessage", resp);
						console.log("createAccountContactRelationship Error: " + resp);
					}
				} else if (state === "ERROR") {
					helper.hideSpinner(component);
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
	linkStokvelRelatedParty: function (component, event, helper) {
		//Validate that there is no Existing Relationship then create it

		let promise = helper.createAccountContactRelationship(component, event, helper).then(
			$A.getCallback(function (result) {
				var selectedAccount = component.get("v.accountSelected");
				component.set("v.recordId", selectedAccount.Id);

				helper.fireToast("Success!", "The Related Party was Successfully linked to the Main Stokvel Account. ", "success");
				//Navigate
				component.set("v.recordId", selectedAccount.Id);
				var navigate = component.get("v.navigateFlow");
				navigate("NEXT");
				debugger;
				resolve("success");
			}),
			$A.getCallback(function (error) {
				component.set("v.errorMessage", "There was an error while trying to link RelatedParty: \n" + error);
			})
		);
	}
});