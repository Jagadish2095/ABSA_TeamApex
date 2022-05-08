({
    getIds : function(component) {
        var action = component.get("c.getIdsMap");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var responseValue =  response.getReturnValue();
            if (response.getState() == "SUCCESS") {
                if(responseValue){
                    var applicationId = responseValue['applicationId'];
                    var appProdMerchId = responseValue['applicationProductMerchantId'];
                    if (applicationId) {
                        component.set("v.applicationId", applicationId);
                        component.find('applicationEditor').reloadRecord();
                    }
                    if (appProdMerchId) {
                        component.set("v.appProdMerchId", appProdMerchId);
                        component.find('appProdMerchEditor').reloadRecord();
                    }
                    component.set('v.isAutoRefresh', true);
                }
            }else if (response.getState() === "INCOMPLETE") {
                component.set("v.errorMessage", "INCOMPLETE");
            } else if (response.getState() === "ERROR") {
                component.set("v.errorMessage", JSON.stringify(response.getError()));
            } else {
                component.set("v.errorMessage", response.getState() + ', error: ' + JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    },

    createMASSAccount : function(component) {
        component.set("v.isSpinner", true);
        component.set('v.isAutoRefresh', false);

        component.set("v.appProdMerchRecord.Status_MASS_Account__c", null);
        component.set("v.appProdMerchRecord.Status_Message_MASS_Account__c", null);
        component.set("v.appProdMerchRecord.Status_Merchant_Plan__c", null);
        component.set("v.appProdMerchRecord.Status_Message_Merchant_Plan__c", null);
        component.set("v.appProdMerchRecord.Status_POSH_Merchant__c", null);
        component.set("v.appProdMerchRecord.Status_Message_POSH_Merchant__c", null);

        var action = component.get("c.createMASSAccount");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                // DO NOTHING
            }else if (response.getState() === "INCOMPLETE") {
                component.set("v.errorMessage", "INCOMPLETE");
            } else if (response.getState() === "ERROR") {
                component.set("v.errorMessage", JSON.stringify(response.getError()));
            } else {
                component.set("v.errorMessage", response.getState() + ', error: ' + JSON.stringify(response.getError()));
            }
            component.set("v.isSpinner", false);
            component.set('v.isAutoRefresh', true);
        });
        $A.enqueueAction(action);
    },

    reviseApplication: function(component, event, helper) {
        var currentUserId = $A.get("$SObjectType.CurrentUser.Id");
        var currentDateTime = new Date().toISOString();

        component.set('v.applicationRecord.Application_Status__c', 'Pending');
        component.set('v.applicationRecord.Application_Generation_Date__c', null);
        component.set('v.applicationRecord.Application_Correctness_Consent__c', false);
        component.set('v.applicationRecord.QA_Status__c', 'Not Started');
        component.set('v.applicationRecord.QA_Status_Updated_By__c', currentUserId);
        component.set('v.applicationRecord.QA_Status_Updated_On__c', currentDateTime);

        component.find("applicationEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                helper.fireToast("Success!", "Application revised successfully", "success");
            } else if (saveResult.state === "INCOMPLETE") {
                component.set("v.errorMessage", "User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                component.set("v.errorMessage", 'Problem saving record, error: ' + JSON.stringify(saveResult.error));
            } else {
                component.set("v.errorMessage", 'Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));
    },

    turnOnAutoRefresh : function(component) {
        // Interval duration to refresh the form after every timeoutDuration
        var timeoutDuration = 4000; // in milliseconds

        var setIntervalId = component.get('v.setIntervalId');

        if (setIntervalId) {
            clearInterval(setIntervalId);
        }

        setIntervalId = setInterval(function(){
            var applicationEditor = component.find('applicationEditor');
            var merchantIdEditor = component.find('merchantIdEditor');
            var appProdMerchEditor = component.find('appProdMerchEditor');

            if (!applicationEditor || !merchantIdEditor || !appProdMerchEditor || !component.get('v.isAutoRefresh')) {
                clearInterval(component.get("v.setIntervalId"));
                component.set('v.isAutoRefresh', false);
            }

            if (component.get('v.isAutoRefresh')) {
                applicationEditor.reloadRecord();
                merchantIdEditor.reloadRecord();
                appProdMerchEditor.reloadRecord();
            }
        }, timeoutDuration);

        component.set('v.setIntervalId', setIntervalId);
    },

    //Fire Lightning toast
    fireToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})