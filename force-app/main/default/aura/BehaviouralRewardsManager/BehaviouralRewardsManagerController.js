({
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
    },

    //Load - Case
    handleCaseLoad: function (component, event, helper) {
        helper.hideSpinner(component);
        var caseSubject = component.find("caseSubjectField").get("v.value");
        console.log("handleCaseLoad: " + caseSubject + " " + component.find("voucherNumberField").get("v.value"));

        if(component.get("v.isEscalatedFromFlow")){
            //Is Escalated
            component.set("v.closeCase", true); //If escalated to Benefits Team then only action is to Close Case
            if (caseSubject.startsWith(component.get("v.appAndDigitalBanking")) || caseSubject.startsWith(component.get("v.eventDiscrepancy"))) {
                $A.util.addClass(component.find("voucherNumber"), "slds-hide");
                $A.util.addClass(component.find("voucherPartner"), "slds-hide");
                $A.util.addClass(component.find("phone"), "slds-hide");
                $A.util.addClass(component.find("dateIssued"), "slds-hide");

            } else if (caseSubject.startsWith(component.get("v.voucherReissuing"))) {
                //Add Fields to be Validated
                component.find("reissueVoucherField").set("v.required", true);
                component.find("reissueVoucherReasonField").set("v.required", true);
                //Show Fields
                $A.util.removeClass(component.find("reissueStatus"), "slds-hide");
                $A.util.removeClass(component.find("reissueReason"), "slds-hide");
            }
            //Sets the current Approval Status for Display
            var approvalStatusField = component.find("approvalStatusField").get("v.value");
            component.set("v.approvalStatus", approvalStatusField);
            //If Approved or Rejected - Disable form
            if (approvalStatusField == "Approved" || approvalStatusField == "Rejected") {
                component.set("v.isFormReadOnly", true);
            } else if (approvalStatusField == "Pending") {
                //Disable form and hide Close Case Btn while Approval status is pending
                component.set("v.isFormReadOnly", true);
                $A.util.addClass(component.find("closeCaseBtn"), "slds-hide");
            }

        }else{
            //Not Escalated
            component.find("voucherNumberField").set("v.required", true);
            component.find("voucherPartnerField").set("v.required", true);
            component.find("phoneField").set("v.required", true);
            component.find("dateIssuedField").set("v.required", true);
        }
    },

    //Success - Case
    handleCaseSuccess: function (component, event, helper) {
        helper.hideSpinner(component);
        if (component.get("v.closeCase")) {
            helper.fireToast("Success!", "Case successfully closed. ", "success");
        } else if (component.get("v.isEscalatedFromFlow")) {
            helper.fireToast("Success!", "Case have been submitted for Approval. ", "success");
            component.find("reqApprovalBtn").set("v.disabled", true);
            component.set("v.approvalStatus", "Pending");
        }
    },

    //Error - Case
    handleCaseError: function (component, event, helper) {
        helper.hideSpinner(component);
        helper.fireToast("Error!", "There has been an error saving the data. ", "error");
        component.set("v.errorMessage", "There has been an error saving the data: " + JSON.stringify(event.getParams()));
    },

    //Handles button action
    handleAction: function (component, event, helper) {
        helper.showSpinner(component);
        var closeCase = component.get("v.closeCase");
        if (helper.allFieldsValid(component)) {
            //validation success
            //If closeCase OR If case is escalated always close case with this action
            if (closeCase || component.get("v.isEscalatedFromFlow")) {
                component.set("v.isFormReadOnly", true);
                component.find("statusField").set("v.value", "Closed");
            } else {
                //Escalate to Outbound Consultant - Case is transferred
                helper.transferCase(component, event, helper);
            }
            component.find("caseEditForm").submit();
        } else {
            helper.hideSpinner(component);
            helper.fireToast("Error", "Please complete the required fields. ", "error");
            component.set("v.isFormReadOnly", false);
        }
    },

    //Method to show/hide 'Close Case' and 'Request Approval' buttons
    //Based on the Case.Reissue_Voucher__c field value
    reissueOnChangeAction: function (component, event, helper) {
        var reqApprovalBtn = component.find("reqApprovalBtn");
        var closeCaseBtn = component.find("closeCaseBtn");
        if (event.getSource().get("v.value") == "Approved") {
            //Show Request Approval Btn
            $A.util.removeClass(reqApprovalBtn, "slds-hide");
            $A.util.addClass(closeCaseBtn, "slds-hide");
            component.set("v.closeCase", false);
        } else {
            //Show Close Case Btn
            $A.util.addClass(reqApprovalBtn, "slds-hide");
            $A.util.removeClass(closeCaseBtn, "slds-hide");
            component.set("v.closeCase", true);
        }
    },

    //Method used for Request Approval
    //Validates and Saves the form. Based on values user entered it will launch an approval process
    handleSave: function (component, event, helper) {
        helper.showSpinner(component);
        event.preventDefault();
        if (helper.allFieldsValid(component)) {
            component.find("caseEditForm").submit();
        }
    },

    //Method called from Child cmp to Validate the parent fields
    isParentValid: function (component, event, helper) {
        return helper.allFieldsValid(component);
    }
});