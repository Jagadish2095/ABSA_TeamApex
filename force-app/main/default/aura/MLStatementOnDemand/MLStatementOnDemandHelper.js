({
    /****************@ Author: Chandra*********************************************
     ****************@ Date: 03/12/2020********************************************
     ****************@ Work Id: W-*************************************************
     ***@ Description: Method Added by chandra to get on Demand Statement********/
    getStatementOnDemandHelper: function (component, event, helper) {
        component.find("send").set("v.disabled", true);
        component.set("v.isShowSpinner", true);
        var emailAddress;
        if (component.get("v.isBusinessAccountFromFlow")) {
            emailAddress = component.find("activeEmailField").get("v.value");
        } else {
            emailAddress = component.find("personEmailField").get("v.value");
        }
        var action = component.get("c.getStatementOnDemand");
        action.setParams({
            numberOfMonths: component.get("v.selectedNoOfMonth"),
            accountType: 3, //need to confirm
            accountNumber: component.get("v.SelectedAccNumberFromFlow"),
            emailAddress: emailAddress,
            caseId: component.get("v.caseId"),
            emailTemplate: component.get("v.templateName"),
            fileName: component.get("v.attachmentFilename")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (returnResponse == "success") {
                    helper.showToast("Success!", "success", "On Demand Statement emailed successfully!");
                } else {
                    component.set("v.errorMessage", "Error sending On Demand Statement. " + returnResponse);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in getStatementOnDemand method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in getStatementOnDemand method. State: " + state);
            }
            component.set("v.isCaseCloseShow", true);
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },

    /****************@ Author: Chandra**************************************
     ****************@ Date: 03/12/2020*************************************
     ****************@ Work Id: W-******************************************
     ***@ Description: Method Added by chandra to validate the field********/
    allFieldsValid: function (component) {
        component.set("v.isShowSpinner", true);
        var allValid = true;
        var isBusinessAccount = component.get("v.isBusinessAccountFromFlow");
        if (isBusinessAccount) {
            if (!component.find("activeEmailField").get("v.value")) {
                allValid = false;
            }
        } else {
            if (!component.find("personEmailField").get("v.value")) {
                allValid = false;
            }
        }
        component.set("v.isShowSpinner", false);
        return allValid;
    },

    /****************@ Author: Chandra**************************************
     ****************@ Date: 03/12/2020*************************************
     ****************@ Work Id: W-************************************
     ***@ Description: Method Added by chandra to close the case***********/
    caseCloseHelper: function (component, event, helper) {
        component.find("close").set("v.disabled", true);
        component.set("v.isShowSpinner", true);
        var caseStatusUpdate = component.get("c.caseStatusUpdate");
        caseStatusUpdate.setParams({
            caseId: component.get("v.caseId")
        });

        caseStatusUpdate.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (returnResponse == "success") {
                    helper.showToast("Success!", "success", "Case has been successfully closed!");
                    $A.get("e.force:refreshView").fire();
                } else {
                    component.set("v.errorMessage", "Case could not be closed. Error: " + returnResponse);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
            }

            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(caseStatusUpdate);
    },

    /****************@ Author: Chandra*********************************************
     ****************@ Date: 04/12/2020********************************************
     ****************@ Work Id: W-*************************************************
     ***@ Description: Method Added by chandra to show toast message**************/
    showToast: function (title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            type: type,
            message: message
        });
        toastEvent.fire();
    }
});