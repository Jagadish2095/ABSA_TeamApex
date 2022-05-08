({
    
    doInit: function (component) {
        var options = [{'label': 'Yes', 'value': 'Yes'}, {'label': 'No', 'value': 'No'}];
        component.set("v.checkingRequiredOptions", options);
        var noCheckingReasons = [{"class": "optionClass", "label": "----Please Select---", "value": ""},
                                 {"class": "optionClass", "label": "No complex edits required", "value": "No complex edits required"},
                                 {"class": "optionClass", "label": "Only revision", "value": "Only revision"}];
        component.set("v.noCheckingReasons", noCheckingReasons);
        //component.set("v.showDispatch", true); //need to refactor this
        var action = component.get("c.getApplicationDetails");       
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert(response.getReturnValue());
                if(JSON.parse(response.getReturnValue()) != null) {
                    var app = JSON.parse(response.getReturnValue());
                    component.set("v.checkingCompleted", app.Legality_Checking_Completed__c);
                    component.set("v.checkingRequired", app.Legality_Checking_Required__c);
                    component.set("v.noCheckingReason", app.Legality_Check_Required_Reason__c);    
                    if (app.Legality_Checking_Required__c === 'Yes') {
                        component.set("v.showCheckingCompleted", true);
                        component.set("v.showNoCheckingReasons", false);
                        component.set("v.showDispatch", true);
                    } else if (app.Legality_Checking_Required__c === 'No') {
                        component.set("v.showCheckingCompleted", false);
                        component.set("v.showNoCheckingReasons", true);
                        component.set("v.showDispatch", true);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.getAdviserEmail");       
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var adviser=response.getReturnValue();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                for (var i = 0; i < data.length; i++) {
                     opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
                component.set("v.emailOptions", opts);
            }
                        
        });
        $A.enqueueAction(action);
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
	lauchInterview : function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.init");       
        var context = {"id": component.get("v.recordId"), "title" : "the title"};
        action.setParams({
            "client": "Wills", "answerSet": "", "context" : context 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();             
            if (state === "SUCCESS" ) {
            	var resp = response.getReturnValue();
               	component.set("v.interviewUrl", resp.url);    
                component.set("v.answerSetId", resp.answerSetId);
                component.set("v.templateId", resp.templateId);
                component.set("v.token", resp.token);
                component.set("v.isOpen", true); 
            } else {
				var toastEvent = this.buildToast("Error!", "Failed to launch the interview, " +  this.errorMessage(response));
                toastEvent.fire();
            }
            component.set("v.showSpinner", false);
        });       
        $A.enqueueAction(action);

	},
       
    updateWorkItem : function(component) {
        console.log("Updating workitem : " + component.get('v.workItemId'));
        var action = component.get("c.saveDocuments");
        action.setParams({
            "token": component.get("v.token"), 
            "workItemId": component.get("v.workItemId"), 
            "answerSetId" : component.get("v.answerSetId"),
            "objectId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();            
            // Display toast message to indicate load status
            component.set("v.isOpen", false);
            component.set("v.showDispatch", true);
            var toastEvent = $A.get("e.force:showToast");
            if (state === 'SUCCESS'){
                toastEvent.setParams({
                    "title": "Success!",
                    "message": " Your will has been drafted successfully."
                });
            }
            else {
                toastEvent.setParams({
                    "title": "Error!",
                    "message": " Something has gone wrong."
                    
                });
            }
            toastEvent.fire();
        });       
        $A.enqueueAction(action);
        console.log("Finished updating workitem : " + component.get('v.workItemId'));
    },
    

   //Retrieves from application object CheckExemptedReasons"
    getCheckExemptedReasons: function(component) {

        var action = component.get("c.getCheckExemptedReasons");
        var opts = [];
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log("allValues" + allValues);
                if (response.getReturnValue() != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- Please select exempted reasons ---",
                        value: ""
                    });
                }
                for (var i = 0; i < response.getReturnValue().length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: response.getReturnValue()[i],
                        value: response.getReturnValue()[i]
                    });
                }
                component.set("v.checkingExemptedReasonsList", opts);
            } else if (state === "INCOMPLETE") {
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        $A.enqueueAction(action);
    },
    
    dispatchDraftedWill : function(component) {
    	if (component.get("v.checkingRequired") === "Yes" && !component.get("v.checkingCompleted")) {
            var toastEvent = this.buildToast("Error!", "Please confirm checking completed!");
            toastEvent.fire();
            return;
        }
    	component.set("v.showSpinner", true);
		var action = component.get("c.dispatchWill");       
        action.setParams({
            "recordId" : component.get("v.recordId"),
            "application": {"Legality_Checking_Required__c" : component.get("v.checkingRequired"),
                            "Legality_Check_Required_Reason__c" : component.get("v.noCheckingReason"),
                            "Legality_Checking_Completed__c": component.get("v.checkingCompleted")
                           },
            "cc"  : component.get("v.alternativeEmail")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            var toast;
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                toast = this.buildToast('Success!', 'Your will has been dispatched successfully!');
            } else {
                toast = this.buildToast('Error!', 'Error dispatching will: ' + this.errorMessage(response));
            }
            component.set("v.showSpinner", false);
            toast.fire();
        });
        $A.enqueueAction(action);
	},
    
    updateApplication: function (component) {
    	component.set("v.showSpinner", true);
        var action = component.get("c.updateApplicationDetails");       
        action.setParams({
            "opportunityId" : component.get("v.recordId"),
            "application": {"Legality_Checking_Required__c" : component.get("v.checkingRequired"),
                            "Legality_Check_Required_Reason__c" : component.get("v.noCheckingReason"),
                            "Legality_Checking_Completed__c": component.get("v.checkingCompleted")
                           }
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log(response.getReturnValue());
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    errorMessage: function(response) {
        var errors = response.getError();
        if (errors && errors[0] && errors[0].message) {
        	return errors[0].message;
        }
        return null;
    },
    
    buildToast: function(title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
                    "title": title,
                    "message": message
                });
        return toastEvent;
    }
 
    
})