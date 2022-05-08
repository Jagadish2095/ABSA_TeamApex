({
	searchHelper: function (component, event, getInputkeyWord) {
		var action = component.get("c.getProductsList");
		var recordIdVal = component.get("v.recordId");
		var objectNameVal = component.get("v.sObjectName");

		action.setParams({
			recordId: recordIdVal,
			objectName: objectNameVal
		});

		action.setCallback(this, function (response) {
			$A.util.removeClass(component.find("mySpinner"), "slds-show");
			console.log("State" + state);
			var message = "";
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();

				if (storeResponse == undefined) {
					component.set("v.message", "No Products found for this Client");
					component.set("v.showMessage", true);
				} else {
					component.set("v.message", "");
					component.set("v.showMessage", false);
				}
				component.set("v.productList", storeResponse);
				component.set("v.productCount", storeResponse.length);
			} else if (state === "ERROR") {
				var errors = response.getError();
				console.log(errors);
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

				console.log("message ERROR: " + message);
				component.set("v.message", message);
				component.set("v.showMessage", true);
			} else {
				var errors = response.getError();
				component.set("v.message", errors);
				component.set("v.showMessage", true);
				console.log("message OTHER : " + errors);
			}
		});
		// enqueue the Action
		$A.enqueueAction(action);
	},
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
		//alert('inside Show Spinner');
	},
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
		//alert('inside hide Spinner');
	},
	//Function to show toast for Errors/Warning/Success
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		return toastEvent;
	}
});