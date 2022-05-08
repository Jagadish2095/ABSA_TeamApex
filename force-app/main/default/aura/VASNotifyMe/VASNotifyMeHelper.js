({
	NotifyMeCall: function (component, event) {
		component.set("v.showSpinner", true);
		var compEvent = component.getEvent("vasFulfilmentEvent");
		var oppId = component.get("v.opportunityId");
		var action = component.get("c.checkNotifyMe");
		var self = this;
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());

				if (respObj.statusCode == 200) {
					if (respObj.NQlistRecipientsRegisteredForCustV1Response.nqp904o.dets.recipNm != null) {
						component.set("v.NotifymeIconName", "utility:success");
						component.set("v.ShowServiceResponse", true);
						component.set("v.ServiceResponse", "The customer is already registered for Notify Me.");
						self.showResponseInRed(component, false);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "Y"
						});
						compEvent.fire();
					} else if (respObj.NQlistRecipientsRegisteredForCustV1Response.nbsmsgo.nbrUserErrs != "0") {
						component.set("v.NotifymeIconName", "utility:clear");
						component.set("v.ShowServiceResponse", true);
						component.set("v.ServiceResponse", "Something went wrong trying checking for NotifyMe on customer's profile.");
						self.showResponseInRed(component, true);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "N"
						});
						compEvent.fire();
					} else {
						component.set("v.NotifymeIconName", "utility:add");
						component.set("v.isdisable", false);
						self.showResponseInRed(component, true);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "N"
						});
						compEvent.fire();
					}
				} else {
					component.set("v.NotifymeIconName", "utility:clear");
					component.set("v.ShowServiceResponse", true);
					component.set("v.isdisable", false);
					if (respObj.status != null && respObj.message != null) {
						component.set("v.ServiceResponse", respObj.status + ": " + respObj.message);
					} else {
						component.set("v.ServiceResponse", "Something went wrong checking for Notify Me.");
					}
					self.showResponseInRed(component, true);
					//Inform parent component
					compEvent.setParams({
						notifyMeInd: "N"
					});
					compEvent.fire();
				}
			} else if (state === "ERROR") {
				component.set("v.NotifyMeIconName", "utility:clear");
				component.set("v.ShowServiceResponse", true);
				component.set("v.ServiceResponse", "Something went wrong checking for existing customer checking for Notifyme.");
				self.showResponseInRed(component, true);
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
				var toastEvent = this.getToast("Error!", message, "Error");
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},
	RegisterNotifyMe: function (component, event) {
		component.set("v.showSpinner", true);
		component.set("v.isdisable", true);
		var compEvent = component.getEvent("vasFulfilmentEvent");
		var oppId = component.get("v.opportunityId");
		var productFamily = component.get("v.productFamily");
		var self = this;

		var action = component.get("c.registerForNotifyMe");

		action.setParams({
			oppId: oppId,
			productFamily: productFamily
		});

		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var respObj = JSON.parse(response.getReturnValue());
				if (respObj.statusCode == 200) {
					if (
						respObj.NQcreateNewOrAddRecipientV2Response.nqp906o != null &&
						(respObj.NQcreateNewOrAddRecipientV2Response.nqp906o.rcode == "9002" ||
							respObj.NQcreateNewOrAddRecipientV2Response.nbsmsgo.msgEntry.msgTxt == "The details are already recorded.")
					) {
                        component.set("v.isdisable", true);
						component.set("v.NotifymeSelected", true);
						component.set("v.NotifymeIconName", "utility:success");
						component.set("v.ShowServiceResponse", true);
						component.set("v.ServiceResponse", "Already registered for Notify Me.");
						self.showResponseInRed(component, false);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "Y"
						});
						compEvent.fire();
					} else if (
						respObj.NQcreateNewOrAddRecipientV2Response.nqp906o != null &&
						(respObj.NQcreateNewOrAddRecipientV2Response.nqp906o.rcode == "0" ||
							respObj.NQcreateNewOrAddRecipientV2Response.nqp906o.pnsRecipientIdO != "0")
					) {
						component.set("v.isdisable", true);
						component.set("v.NotifymeSelected", true);
						component.set("v.NotifymeIconName", "utility:success");
						component.set("v.ShowServiceResponse", true);
						component.set("v.ServiceResponse", "Successfully registered for Notify Me.");
						self.showResponseInRed(component, false);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "Y"
						});
						compEvent.fire();
					} else {
						var errorMessage = "";
						if (respObj.NQcreateNewOrAddRecipientV2Response.nbsmsgo.msgEntry != null) {
							if (respObj.NQcreateNewOrAddRecipientV2Response.nbsmsgo.msgEntry.msgTxt != null) {
								errorMessage = respObj.NQcreateNewOrAddRecipientV2Response.nbsmsgo.msgEntry.msgTxt;
							}
						}
						component.set("v.isdisable", false);
						component.set("v.NotifymeIconName", "utility:clear");
						component.set("v.ShowServiceResponse", true);
						component.set("v.ServiceResponse", "Error code: " + respObj.NQcreateNewOrAddRecipientV2Response.nqp906o.rcode + " " + errorMessage);
						self.showResponseInRed(component, true);
						//Inform parent component
						compEvent.setParams({
							notifyMeInd: "N"
						});
						compEvent.fire();
					}
				} else {
					component.set("v.NotifymeIconName", "utility:clear");
					component.set("v.ShowServiceResponse", true);
					component.set("v.isdisable", false);
					if (respObj.status != null && respObj.message != null) {
						component.set("v.ServiceResponse", respObj.status + ": " + respObj.message);
					} else {
						component.set("v.ServiceResponse", "Something went wrong applying for Notify Me.");
					}
					self.showResponseInRed(component, true);
					//Inform parent component
					compEvent.setParams({
						notifyMeInd: "N"
					});
					compEvent.fire();
				}
			} else if (state === "ERROR") {
				component.set("v.NotifymeIconName", "utility:clear");
				component.set("v.ShowServiceResponse", true);
				component.set("v.isdisable", false);
				component.set("v.ServiceResponse", "Something went wrong applying for Notify Me. Please try again by clicking on the cross icon.");
				self.showResponseInRed(component, true);
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
			}
		});
		$A.enqueueAction(action);
	},
	showResponseInRed: function (component, showAsRed) {
		var responseText = component.find("responseText");
		if (showAsRed) {
			$A.util.addClass(responseText, "error-color");
			$A.util.removeClass(responseText, "success-color");
		} else {
			$A.util.addClass(responseText, "success-color");
			$A.util.removeClass(responseText, "error-color");
		}
	}
});