({
    initPreAdvised: function (component) {
        var preAdvisedObj = [
            { LimitType: "Additional Overdraft Limit", Value: 0.00 },
            { LimitType: "Additional Monthly Loan Repayment", Value: 0.00 },
            { LimitType: "Additional Monthly Repayment", Value: 0.00 },
            { LimitType: "Additional Credit Card Limit", Value: 0.00 },
            { LimitType: "Additional Asset Finance Repayment", Value: 0.00 },
            { LimitType: "Additional Monthly Mortgage Repayment", Value: 0.00 },
            { LimitType: "Maximum Ordinary Credit Exposure Capped", Value: 0.00 }
        ];
        component.set("v.preAdvisedData", preAdvisedObj);
        //component.set("v.lastRefresh", '2020-10-11');
    },

    getTriadPreAdvised: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getApplicationTriadPreAdviced");

        action.setParams({
            "oppID": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                this.loadTriadPreAdvised(component, result);
            }
            else {
                this.showError(response, "getApplicationTriadPreAdviced");
            }
        });
        $A.enqueueAction(action);
    },

    loadTriadPreAdvised: function (component, appTriad) {
        var lastModifiedDate;
        var preAdvisedObj = [];

        if (appTriad != null) {
            for (var i = 0; i < appTriad.length; i++) {
                var isMainApp = appTriad[i].Is_Main_Applicant__c;

                if (isMainApp) {
                    lastModifiedDate = appTriad[i].LastModifiedDate;
                    preAdvisedObj.push({ LimitType: "Additional Overdraft Limit", Value: appTriad[i].Additional_Overdraft_Limit__c });
                    preAdvisedObj.push({ LimitType: "Additional Monthly Loan Repayment", Value: appTriad[i].Additional_Monthly_Loan_Repayment__c });
                    preAdvisedObj.push({ LimitType: "Additional Monthly Repayment", Value: appTriad[i].Additional_Monthly_Repayment__c });
                    preAdvisedObj.push({ LimitType: "Additional Credit Card Limit", Value: appTriad[i].Additional_Credit_Card_Limit__c });
                    preAdvisedObj.push({ LimitType: "Additional Asset Finance Repayment", Value: appTriad[i].Additional_Asset_Finance_Repayment__c });
                    preAdvisedObj.push({ LimitType: "Additional Monthly Mortgage Repayment", Value: appTriad[i].Additional_Monthly_Mortgage_Repayment__c });
                    preAdvisedObj.push({ LimitType: "Maximum Ordinary Credit Exposure Capped", Value: appTriad[i].Maximum_Ordinary_Credit_Exposure_Capped__c });
                    break;
                }
            }

            component.set("v.lastRefresh", lastModifiedDate);
            component.set("v.preAdvisedData", preAdvisedObj);
        }
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