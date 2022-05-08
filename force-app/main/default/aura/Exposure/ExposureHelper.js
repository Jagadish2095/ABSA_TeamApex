({
	getApplicationExposuresFuture: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var oppId = component.get("v.recordId");
		var action = component.get("c.getApplicationExposuresFuture");

		action.setParams({
			"oppID": oppId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				this.getApplicationExposures(component, event, helper);
			}
			else {
				this.showError(response, "getApplicationExposuresFuture");
			}
		});
		$A.enqueueAction(action);
	},

	getApplicationExposures: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var oppId = component.get("v.recordId");
		var action = component.get("c.getApplicationExposures");

		action.setParams({
			"oppID": oppId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var isLoaded = result.AppExpFutMethodDone;
				var ranCount = component.get("v.reLoadCount");
                //var AllExposureDone = result.AllExposureDone;

				console.log('getApplicationExposures::: ' + ranCount);

				if (isLoaded != null) {
					var appExpData = result.ApplicationExposures;

					if (appExpData != null) {
						var lastModifiedDate = appExpData[0].LastModifiedDate;

						component.set("v.ApplicantExposuresData", appExpData);
						component.set("v.lastRefresh", lastModifiedDate);
					}

					if (isLoaded[0].IsMethodLoaded == "true") {
						component.set("v.parentLoaded", true);
						component.set("v.showSpinner", false);
                        //var oppId = component.get("v.recordId");
                        helper.setValidationForTab(component,event,helper);
					}
				}
				else if (ranCount < 6) {
					setTimeout(
						$A.getCallback(function () {
							ranCount++;
							helper.reloadAppEx(component, Math.random(), ranCount)
						}), 20000
					);
				}
				else if (ranCount >= 6) {
					component.set("v.parentLoaded", true);
					component.set("v.showSpinner", false);
                    helper.setValidationForTab(component,event,helper);
				}
			}
			else {
				this.showError(response, "getApplicationExposures");
			}
			//component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},
	setValidationForTab: function (component, event, helper) {
      component.set("v.showSpinner", true);
		var oppId = component.get("v.recordId");
		var action = component.get("c.setValidation");

		action.setParams({
			"oppID": oppId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var eventHandler = $A.get("e.c:creditOriginationEvent");
                        eventHandler.setParams({ "sourceComponent": "Exposure" });
                        eventHandler.setParams({ "opportunityId": oppId });
                        eventHandler.fire();
				
				
			}
			else {
				this.showError(response, "setValidationForTab");
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);  
    },
	reloadAppEx: function (component, random, ranCount) {
		component.set("v.reLoadCount", ranCount);
		component.set("v.reLoad", random);
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
		var toastEvent = this.getToast("Error: Exposure " + errorMethod + "! ", message, "Error");
		toastEvent.fire();
	}
})