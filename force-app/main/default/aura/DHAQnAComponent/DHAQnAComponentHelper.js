({
    getDHADetails: function (component, event, helper) {
        this.showSpinner(component);
        var action = component.get("c.callHanisService");
        console.log('Id number:'+component.get("v.clientID"));
        action.setParams({
            idNumber: component.get("v.clientID")//'8904145240086'
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("The data>>>" + data);
                data = JSON.parse(data);
                console.log("Parse data>>>" + data);
                if (data.statusCode == 200) {
                    if(data.hasSmartCard){
                        component.set("v.smartCardIssued",'YES');
                    }else{
                        component.set("v.smartCardIssued",'NO');
                    }
                    
                    component.set("v.idDateIssued",data.dateIssued);
                    
                    if(data.idBlocked){
                        component.set("v.idBlocked",'YES');
                    }else{
                        component.set("v.idBlocked",'NO');
                    }
                    
                    component.set("v.maritalStatus",data.maritalStatus);
                    component.set("v.countryofBirth",data.birthPlaceCountryCode);
                    
                    if(data.birthPlaceCountryCode == 'ZAF'){
                        component.set("v.citizenship",'CITIZEN');
                    }else{
                        component.set("v.citizenship",'NOT CITIZEN');
                    }
                    
                    if(data.Cert){
                        component.set("v.pdfData",data.Cert);
                    }else{
                        component.set("v.errorMessage","No certificate detail available for the client");
                    }
                    
                }
                else
                    if (data.statusCode == 404) {
                    var message = respObjHanis.message;
                    var toast = helper.getToast("Hanis Service Error!", message, "error");
                    toast.fire();
                }
                    else {
                        var message = "Client not found by Hanis service.";
                        var toast = helper.getToast("Hanis Service Error!", message, "warning");
                        toast.fire();
                    }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
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
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
            } else {
                var errors = response.getError();
                var toast = helper.getToast("Error", message, "error");
                toast.fire();
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    //Function to show toast for Errors/Warning/Success
    getToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
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