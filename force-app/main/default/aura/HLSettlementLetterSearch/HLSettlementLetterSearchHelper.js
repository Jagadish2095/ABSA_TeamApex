({
    generateSettlementLetterHelper: function (component, event, helper) {
        var button = event.getSource();
        button.set("v.disabled", true);
        component.set("v.isShowSpinner", true);
        component.set("v.pdfData", null);

        var action = component.get("c.fetchHLSettlementLetter");
        var effectiveDate = new Date();
        effectiveDate.setDate(effectiveDate.getDate() + 5);
        action.setParams({
            accountId: component.get("v.CaseAccountIdFromFlow"),
            mortgageLoanNo: parseInt(component.get("v.SelectedAccNumberFromFlow")),
            payAllAcc: component.get("v.payAllAccount"),
            effectiveDate: $A.localizationService.formatDate(effectiveDate, "yyyyMMdd"),
            includeCommit: component.get("v.includeCommit"),
            documentTemplateName: component.get("v.documentTemplateName")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (!returnResponse.startsWith("Error")) {
                    component.set("v.pdfData", returnResponse);
                    helper.showToast("Success!", "success", "Home Loan settlement letter generated successfully! You may preview or send the document.");
                } else {
                    component.set("v.errorMessage", "Error in fetchHLSettlementLetter method. Service Response: " + returnResponse);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in fetchHLSettlementLetter method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in fetchHLSettlementLetter method. State: " + state);
            }
            button.set("v.disabled", false);
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },

    sendEmailHelper: function (component, event, helper) {
        var button = event.getSource();
        button.set("v.disabled", true);
        component.set("v.isShowSpinner", true);
        var action = component.get("c.sendEmail");
        var effectiveDate = new Date();
        effectiveDate.setDate(effectiveDate.getDate() + 5);
        action.setParams({
            caseId: component.get("v.caseId"),
            emailTemplate: component.get("v.emailTemplate"),
            emailAddress: component.get("v.email"),
            fileName: component.get("v.documentTemplateName") + '_' + $A.localizationService.formatDate(effectiveDate, "yyyyMMdd"),
            pdfData: component.get("v.pdfData")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                helper.showToast("Success!", "success", "Home Loan settlement letter emailed successfully!");
                component.set("v.pdfData", null);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
            }

            button.set("v.disabled", false);
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },

    caseCloseHelper: function (component, event, helper) {
        var button = event.getSource();
        button.set("v.disabled", true);
        component.set("v.isShowSpinner", true);
        var action = component.get("c.caseStatusUpdate");
        action.setParams({
            caseId: component.get("v.caseId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var returnResponse = response.getReturnValue();
                if (returnResponse == "success") {
                    helper.showToast("Success!", "success", "Case has been successfully closed!");
               		$A.get('e.force:refreshView').fire();
                } else {
                    component.set("v.errorMessage", "Case could not be closed. Error: " + returnResponse);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Error in caseCloseHelper method. Error message: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in caseCloseHelper method. State: " + state);
            }

            button.set("v.disabled", false);
            component.set("v.isShowSpinner", false);
        });
        $A.enqueueAction(action);
    },

    // PJAIN: 20200505
    // Method to validate all fields
    // showErrorFlag - Boolean value to display errors on the field
    // Use case 1:  showErrorFlag would be true when calling this method from save as you would want to display errors
    // Use case 2:  showErrorFlag would be false when calling this method on load to check if the fields are complete to mark the form as ValidToSubmit
    // This version of the method validates lightning:input
    allFieldsValid: function(component, showErrorFlag) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var arrayFields = [];

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {
            var inputCmp = component.find(arrayAuraIdsToBeValidated[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }

        // Show error messages if required fields are blank
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {
            if (showErrorFlag) {
                inputCmp.showHelpMessageIfInvalid();
            }

            return validFields && inputCmp.get('v.validity').valid;
        }, true);

        return allValid;
    },

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