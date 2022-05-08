({
	getAccountRecord: function (component, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getAccountAddress"); //Calling Apex class controller 'getAccountAddress' Method
		action.setParams({
			accountID: component.get("v.CaseAccountId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState(); //Checking response status
			if (state === "SUCCESS") {
				component.set("v.data", response.getReturnValue()); // Adding values in Aura attribute variable.
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getAccountRecord Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "getAccountRecord Error State: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	bookingDeliveryFaceToFace: function (component, helper, suburb, city) {
		helper.showSpinner(component);
		var action = component.get("c.bookingAvailSlots");
		action.setParams({
			townCode: city,
			suburbName: suburb,
			clientName: component.get("v.personName"),
			clientIDPassport: component.get("v.iDNumber"),
			searchRefValue: component.get("v.regNumber")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseObj = JSON.parse(response.getReturnValue());
				if (responseObj.Successful == "Y") {
					component.set("v.bookAvailSlots", JSON.stringify(responseObj));
					helper.navigateNext(component);
				} else {
					helper.fireToast("Error!", "Service Error", "error");
					component.set("v.errorMessage", JSON.stringify(responseObj.ErrorMessages));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("Error!", "Error Occurred", "error");
						component.set("v.errorMessage", errors[0].message);
					}
				}
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	navigateNext: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	sendEmailHelper: function (component, event, helper) {
		helper.showSpinner(component);

		let urgentDeliveryParamsMap = new Map();
		urgentDeliveryParamsMap["perName"] = component.get("v.personName");
		urgentDeliveryParamsMap["refValue"] = component.get("v.regNumber");
		urgentDeliveryParamsMap["deliveryLine1"] = component.find("addressline1").get("v.value");
		urgentDeliveryParamsMap["deliveryLine2"] = component.find("addressline2").get("v.value");
		urgentDeliveryParamsMap["suburb"] = component.find("suburb").get("v.value");
		urgentDeliveryParamsMap["town"] = component.find("city").get("v.value");
		urgentDeliveryParamsMap["province"] = component.find("province").get("v.value");
		urgentDeliveryParamsMap["country"] = component.find("country").get("v.value");
		urgentDeliveryParamsMap["postcode"] = component.find("postal").get("v.value");
		urgentDeliveryParamsMap["urgentDeliveryEmail"] = $A.get("$Label.c.EBDSV_Urgent_Delivery_Email_Address");
		urgentDeliveryParamsMap["splInstruction"] = component.get("v.splInstruction"); //Special Instruction

		var action = component.get("c.sendEmailUrgentDelivery");

		action.setParams({
			addressDetails: urgentDeliveryParamsMap
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				if (response.getReturnValue()) {
					component.set("v.isModalOpen", false);
					helper.fireToast("Success!", "Email sent successfully", "success");
					component.set("v.isFormReadOnly", true);
					component.find("caseStatusField").set("v.value", "Closed");
					component.find("caseEditForm").submit();
				} else {
					helper.fireToast("Error!", "Error sending email", "error");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						helper.fireToast("Error!", errors[0].message, "error");
						component.set("v.errorMessage", errors[0].message);
					}
				}
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", "false");
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", "true");
	}
});