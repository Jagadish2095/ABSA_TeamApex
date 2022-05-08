({
    handleGenerateSettlementLetter: function (component, event, helper) {
        let accountNumber = component.get("v.SelectedAccNumberFromFlow");
        if ($A.util.isUndefinedOrNull(accountNumber)) {
            helper.showToast("Error!", "error", "Please Select Account Number");
        } else if (!helper.allFieldsValid(component, true)) {
            helper.showToast("Error!", "error", "Required fields missing.");
        } else {
            helper.generateSettlementLetterHelper(component, event, helper);
        }
    },

    handlePreviewDocument: function (component, event, helper) {
        component.set("v.isShowPreview", true);
    },

    handleCloseModal: function (component, event, helper) {
        component.set("v.isShowPreview", false);
    },

    handleSendEmail: function (component, event, helper) {
        component.set("v.isShowPreview", false);
        helper.sendEmailHelper(component, event, helper);
    },

    handleCaseClose: function (component, event, helper) {
        helper.caseCloseHelper(component, event, helper);
    }
});