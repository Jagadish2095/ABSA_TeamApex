({
	// Initiate Scoring
	callFinalScoring : function(component, actionClicked) {
        var navigate = component.get("v.navigateFlow");

		console.log(`Calling Final Scoring... START`);

		var action = component.get("c.callFinalScoring");
        action.setParams({
            applicationId: component.get("v.applicationId"),
            applicationNumber: component.get("v.applicationNumber"),
            lockVersionId: component.get("v.lockVersionId"),
            preAssessedCreditLimit: component.get("v.preAssessedCreditLimit"),
            mayCheckCreditWorthiness: component.get("v.mayCheckCreditWorthiness")
        });
		console.log("applicationId: " + component.get("v.applicationId"));
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("Data Response: " + data);

				data = JSON.parse(data);
                console.log("Parse data msg: " + data.msg);

				if(data.msg.toLowerCase() =='success'){
					this.fireToast('Final Scoring Success', data.msg, 'success');
					console.log("Done. SUCCESS:  " + data.msg);

					navigate(actionClicked);

				}else{
					this.fireToast('Final Scoring Error', data.msg, 'error');
					console.error("Done. ERROR:  " + data.msg);

				}



            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error("ERRORS: " + data);
                console.error("STRINGIFY ERRORS: " + JSON.stringify(data));


                if (errors) {
                    for (var i = 0; i < errors.length; i++) {
                        for (
                            var j = 0;
                            errors[i].pageErrors && j < errors[i].pageErrors.length;
                            j++
                        ) {
                            message +=
                                (message.length > 0 ? "\n" : "") +
                                errors[i].pageErrors[j].message;
                        }
                        if (errors[i].fieldErrors) {
                            for (var fieldError in errors[i].fieldErrors) {
                                var thisFieldError = errors[i].fieldErrors[fieldError];
                                for (var j = 0; j < thisFieldError.length; j++) {
                                    message +=
                                        (message.length > 0 ? "\n" : "") +
                                        thisFieldError[j].message;
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
                var toast = this.getToast("Error", message, "error");
                toast.fire();
            } else {
                var errors = response.getError();
                var toast = this.getToast("Error", message, "error");
                toast.fire();
            }
            this.hideSpinner(component);
			console.log(`Calling FINAL SCORING... END`);

        });
        $A.enqueueAction(action);
		console.log(`Calling Final Scoring.....`);
		this.showSpinner(component);

	},

	//Function to return toast for Errors/Warning/Success
	getToast: function(title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		
		return toastEvent;
	},

	//Function to show toast for Errors/Warning/Success
	fireToast: function(title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		
		toastEvent.fire();
	},
	
	//Show lightning spinner
	showSpinner: function (component) {
		console.log('inside showSpinner');
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Hide lightning spinner
	hideSpinner: function (component) {
		console.log('inside hideSpinner');
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},
})