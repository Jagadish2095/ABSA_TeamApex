({
	getAccount: function (component, event, helper) {
		// component.set("v.showSpinner",true);
		var accId = component.get("v.recordId");
		var action = component.get("c.getAccounts");
		action.setParams({
			accId: accId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var accResp = response.getReturnValue();

			console.log("accResp" + JSON.stringify(accResp));
			component.set("v.accRecord", accResp);
			// component.set("v.showSpinner",false);
		});

		$A.enqueueAction(action);
	},

	getCreditGrpVw: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var accId = component.get("v.recordId");
		var action = component.get("c.GetCreditGroupView");
		action.setParams({
			accId: accId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var creditGrpResp = response.getReturnValue();

			console.log("creditGrpResp" + JSON.stringify(creditGrpResp));
			if (state === "SUCCESS") {
				if (creditGrpResp != null && creditGrpResp.length > 0) {
					component.set("v.data", creditGrpResp);
					component.set("v.ultimateClient", creditGrpResp[0].UltimateClient);
					component.set("v.showData", true);
					component.set("v.noData", false);

					var toastEvent = this.getToast("Success:  ", "Account Credit Group View Fetched Successfully", "Success");
					toastEvent.fire();
				} else {
					component.set("v.noData", true);
					component.set("v.showData", false);

					var toastEvent = this.getToast("Error!", "Client is not Part of a Credit Group", "Error");
					toastEvent.fire();
				}
			} else {
				this.showError(response, "getCreditGrpVw");
			}
			component.set("v.showSpinner", false);
		});

		$A.enqueueAction(action);
	},

	showError: function (response, errorMethod) {
		var message = "";
		var errors = response.getError();
		if (errors) {
			for (var i = 0; i < errors.length; i++) {
				for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
					message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
				}
				if (errors[i].fieldErrors) {
					for (var fieldError in errors[i].fieldErrors) {
						var thisFieldError = errors[i].fieldErrors[fieldError];
						for (var j = 0; j < thisFieldError.length; j++) {
							message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
						}
					}
				}
				if (errors[i].message) {
					message += (message.length > 0 ? "\n" : "") + errors[i].message;
				}
			}
		} else {
			message += (message.length > 0 ? "\n" : "") + "Unknown error";
		}

		// show error notification
		var toastEvent = this.getToast("GroupGrpView " + errorMethod + "! ", message, "Error");
		toastEvent.fire();
	},

	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		return toastEvent;
	},

	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	}
});