({
    doInit: function (component, event, helper) {
        var appProductId = component.get("v.appProductId");
        var action = component.get("c.getApplicationDetails");

        action.setParams({
            "applicationProductId": appProductId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var response = JSON.parse(res.getReturnValue());
                response.doNotIncreaseCreditLimitsOnceaYear = 'Yes';
                response.doNotIncreaseCreditLimitsOnceaYearSubjectToCreditAssessment = 'No';
                component.set("v.applicationProduct", response);
            }
        });
        $A.enqueueAction(action);
    },

    addRecord: function (component, event, helper) {
        var sourceOfFundsList = component.get("v.applicationProduct.sourceOfFundsList") == null ? [] : component.get("v.applicationProduct.sourceOfFundsList");
        //alert('sourceOfFundsList '+JSON.stringify(sourceOfFundsList));
        sourceOfFundsList.push({
            'accountNumber': '',
            'accountType': '',
            'sourceOfFunds': '',
            'wasExplanationSatisfactory': '',
            'comments': ''
        });
        component.set("v.applicationProduct.sourceOfFundsList", sourceOfFundsList);
    },

    save: function (component, event, helper) {
        var applicationProduct = component.get("v.applicationProduct");
        var appProductId = component.get("v.appProductId");
        var action = component.get("c.saveApplicationDetails");
        action.setParams({
            "applicationDetails": JSON.stringify(applicationProduct),
            "applicationProductId": appProductId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                alert('Application Details Saved Successfully.');
                //helper.fireToast("Success", "Application Details Saved Successfully.", "success");
            }
            else {
                //helper.fireToast("Error", "Error in Saving Application Details.", "error");
            }
        });
        $A.enqueueAction(action);
    },

    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },
})