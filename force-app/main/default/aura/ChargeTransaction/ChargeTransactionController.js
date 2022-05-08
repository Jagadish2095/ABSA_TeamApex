({
	handleCaseLoad: function (component, event, helper) {
		console.log("accountIdField: " + component.find("accountIdField").get("v.value")); //added to assist troubleshooting if needed
		component.set("v.accountId", component.find("accountIdField").get("v.value"));
		component.set("v.UCIDValue", component.find("UCIDCaseField").get("v.value"));
	},

	handleAccountLoad: function (component, event, helper) {
		console.log("accountCIFField: " + component.find("accountCIFField").get("v.value")); //added to assist troubleshooting if needed
		component.set("v.CIFValue", component.find("accountCIFField").get("v.value"));
	},

	saveChargeLog: function (component, event, helper) {
		var chargeToggleIndicator = component.find("chargeToggle").get("v.checked");
		if (chargeToggleIndicator == true) {
			let currentDateTime = new Date();

			//add preceding 0 before single digit date value e.g 5 becomes 05
			let date = ("0" + currentDateTime.getDate()).slice(-2);

			//add preceding 0 before single current month value e.g 5 becomes 05
			let month = ("0" + (currentDateTime.getMonth() + 1)).slice(-2);

			//current year value
			let year = currentDateTime.getFullYear();

			//add preceding 0 before single current hours value e.g 5 becomes 05
			let hours = ("0" + currentDateTime.getHours()).slice(-2);

			//add preceding 0 before single current minutes value e.g 5 becomes 05
			let minutes = ("0" + currentDateTime.getMinutes()).slice(-2);

			//add preceding 0 before single current seconds value e.g 5 becomes 05
			let seconds = ("0" + currentDateTime.getSeconds()).slice(-2);

			//Concatenates date & time in YYYY-MM-DD HH:MM:SS format
			var formattedDateTime = year + "-" + month + "-" + date + "T" + hours + ":" + minutes + ":" + seconds;
			component.find("transactionDateField").set("v.value", formattedDateTime);

			var params = event.getParam("arguments");
			component.find("transactionCodeField").set("v.value", params.transactionCode);
			component.find("chargeLogCreateForm").submit();
		}
	},

	handleChargeLogSuccess: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			message: "Charge Log created successfully for transaction.",
			type: "success"
		});
		toastEvent.fire();
	},

	handleChargeLogError: function (component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Error!",
			message: "There has been an error creating the charge log for this transaction.",
			type: "error"
		});
		toastEvent.fire();
		var errorMessage = "Error saving Charge Log record: " + event.getParam("message");
		console.log(errorMessage + ". Error params: " + JSON.stringify(event.getParams()));
	}
});