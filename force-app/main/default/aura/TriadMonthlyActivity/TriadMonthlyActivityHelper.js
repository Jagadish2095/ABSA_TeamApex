({
    fetchRecords: function (component, event, helper) {
        var action = component.get('c.getApplicationTriadMonthlyActivities');

        action.setParams({
            "oppID": component.get("v.recordId")
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();

                this.loadTriadMonthlyActivity(component, result);
                component.set('v.mActivityData', result);
                component.set('v.showSpinner', false);

            } else if (state === "ERROR") {
                this.showError(response, "getApplicationTriadMonthlyActivities");
            }
        }));
        $A.enqueueAction(action);
    },

    loadTriadMonthlyActivity: function (component, appMActivity) {
        var lastModifiedDate;
        var mActivityObj = [];

        if (appMActivity != null) {
            for (var i = 0; i < appMActivity.length; i++) {
                var isMainApp = appMActivity[i].Is_Main_Applicant__c;

                if (isMainApp) {
                    lastModifiedDate = appMActivity[i].LastModifiedDate;
                    mActivityObj.push({ ActivityType: "Month", Value: appMActivity[i].Month__c });
                    mActivityObj.push({ ActivityType: "No Of Cheque Accounts", Value: appMActivity[i].Number_of_Cheque_Accounts__c });
                    mActivityObj.push({ ActivityType: "Days In Credit", Value: appMActivity[i].Days_in_Credit__c });
                    mActivityObj.push({ ActivityType: "Days In Debit", Value: appMActivity[i].Days_in_Debit__c });
                    mActivityObj.push({ ActivityType: "Days In Excess", Value: appMActivity[i].Days_In_Excess__c });
                    mActivityObj.push({ ActivityType: "Number Of Cheque RD Events", Value: appMActivity[i].Number_of_Cheque_RD_Events__c });
                    mActivityObj.push({ ActivityType: "Number Of Savings RD Events", Value: appMActivity[i].Number_of_Savings_RD_Events__c });
                    mActivityObj.push({ ActivityType: "Number Of Debits - Cheques", Value: appMActivity[i].Number_of_Debits_Cheques__c });
                    mActivityObj.push({ ActivityType: "Number Of Debits - Deposits", Value: appMActivity[i].Number_of_Debits_Deposits__c });
                    break;
                }
            }

            component.set("v.lastRefresh", lastModifiedDate);
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
        var toastEvent = this.getToast("Error: Triad " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})