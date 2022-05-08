({
	createAccountContactRelationship: function (component, event, helper, payload) {
		return new Promise(function (resolve, reject) {
			var f = component.get("v.primaryEntityId");
			var action = component.get("c.createStokvelRelationship");
			action.setParams({
				relatedAccountId: payload.id,
				primaryEntityId: component.get("v.primaryEntityId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				var resp = response.getReturnValue();
				helper.hideSpinner(component);
				if (state == "SUCCESS") {
					if (resp.includes("SUCCESS")) {
						resolve("success");
					} else {
						helper.fireToast("Error", resp, "error");
						component.set("v.errorMessage", resp);
						console.log("createAccountContactRelationship Error: " + resp);
						reject("error");
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					helper.fireToast("Error", "createAccountContactRelationship Apex error: " + JSON.stringify(errors), "error");
					component.set("v.errorMessage", "createAccountContactRelationship Apex error: " + JSON.stringify(errors));
					console.log("createAccountContactRelationship Apex error: " + JSON.stringify(errors));

					reject(errors);
				} /*else{
                helper.fireToast("Error", "Unexpected error occurred, please contact your System Administrator. State Returned: " + state, "error");
				component.set("v.errorMessage", "createAccountContactRelationship Unexpected error occurred, state returned: " + state);
				console.log("createAccountContactRelationship Unexpected error occurred, state returned: " + state);
            }*/
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
			//  alert('wawass ' +  selectedAccount.Id);
			helper.showSpinner(component);
			var action = component.get("c.updateAccountDetails");
			action.setParams({
				accountId: selectedAccount // component.get("v.accountRecId")
			});

			// set a callBack
			action.setCallback(this, function (response) {
				var state = response.getState();
				var screenRespObj = response.getReturnValue();
				helper.hideSpinner(component);

				if (state == "SUCCESS") {
					resolve("success");
				} else {
					reject(screenRespObj);
				}
			});
			$A.enqueueAction(action);
		});
	},

	validateIdNumber: function (component) {
		let isIdNumberValid = true;
        component.set("v.errorMessage", "");
	
		const idNumberFieldComponent = component.find("idNumberField");
        let idNumberValue = idNumberFieldComponent.get("v.value");
		if(idNumberValue == null || idNumberValue == undefined)
		{
			isIdNumberValid = false;
		}
		if (idNumberValue.length != 13 ) {
            
			isIdNumberValid = false;
		}

		// get first 6 digits as a valid date
		var tempDate = new Date(idNumberValue.substring(0, 2), idNumberValue.substring(2, 4) - 1, idNumberValue.substring(4, 6));

		var id_date = tempDate.getDate();
		var id_month = tempDate.getMonth();
		var id_year = tempDate.getFullYear();

		var fullDate = id_date + "-" + id_month + 1 + "-" + id_year;

		if (!(tempDate.getYear() == idNumberValue.substring(0, 2) && id_month == idNumberValue.substring(2, 4) - 1 && id_date == idNumberValue.substring(4, 6))) {
			//error.append('<p>ID number does not appear to be authentic - date part not valid</p>');
			isIdNumberValid = false;
		}

		var tempTotal = 0;
		var checkSum = 0;
		var multiplier = 1;
		for (var i = 0; i < 13; ++i) {
			tempTotal = parseInt(idNumberValue.charAt(i)) * multiplier;
			if (tempTotal > 9) {
				tempTotal = parseInt(tempTotal.toString().charAt(0)) + parseInt(tempTotal.toString().charAt(1));
			}
			checkSum = checkSum + tempTotal;
			multiplier = multiplier % 2 == 0 ? 1 : 2;
		}
		if (checkSum % 10 != 0) {
			//error.append('<p>ID number does not appear to be authentic - check digit is not valid</p>');
			isIdNumberValid = false;
		}

		component.set("v.isIdNumberValid", isIdNumberValid);
	}
});