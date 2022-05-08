({
    doInit: function (component, event, helper) {
        var targetAccTypeOptions = [
            { value: "", label: "--Choose type--" },
            { value: "01", label: "Savings" },
            { value: "02", label: "Current/Cheque" }
        ];
        component.set("v.targetAccTypeOptions", targetAccTypeOptions);
        
         var respFromCIGetAccLink = component.get("v.respFromCIGetAccLink");
        var respObj = JSON.parse(respFromCIGetAccLink);
        for (var key in respObj) {
            if (respObj[key].productType === "CO" && respObj[key].status === "ACTIVE") {
                component.set("v.accAccountNumber", respObj[key].oaccntnbr);
                break;
            }
        }
    },

    //Check if required fields are not empty
    checkFields: function (component, event, helper) {
        var targetBankName = component.get("v.selectedBankName");
        var accountType = component.get("v.selectedTargetAccType");
        var accountNumber = component.get("v.selectedAccountNumberToFlow");
        var branchCode = component.get("v.branchCode");
        var beneficiaryName = component.get("v.beneficiaryName");
        var beneficiaryReference = component.get("v.beneficiaryReference");
        var ownReference = component.get("v.ownReference");
        var accountTypeP = component.get("v.selectedProductTypeFromFlow");
        var accessAccountP = component.get("v.accAccountNumber");
        var errorExist = false;

        if ((accountTypeP == "" || accountTypeP == null  || accountTypeP == undefined) && (accountNumber == "" || accountNumber == null  || accountNumber == undefined)) {
            helper.fireToastEvent("Error!", "Source Product Type and Account Number cannot be blank! Make sure Product Type and Account Number is selected on previous screen", "error");
            errorExist = true;
        }

        if (targetBankName == "" || targetBankName == null  || targetBankName == undefined) {
            helper.fireToastEvent("Error!", "Recipient Bank Name Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (accountNumber == "" || accountNumber == null  || accountNumber == undefined) {
            helper.fireToastEvent("Error!", "Recipient Account Number Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (branchCode == "" || branchCode == null  || branchCode == undefined) {
            helper.fireToastEvent("Error!", "Branch Code Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (beneficiaryName == "" || beneficiaryName == null  || beneficiaryName == undefined) {
            helper.fireToastEvent("Error!", "Beneficiary Name Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (beneficiaryReference == "" || beneficiaryReference == null  || beneficiaryReference == undefined) {
            helper.fireToastEvent("Error!", "Beneficiary Reference Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (ownReference == "" || ownReference == null  || ownReference == undefined) {
            helper.fireToastEvent("Error!", "Own Reference Name Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (accountType == "" || accountType == null || accountType == undefined) {
            helper.fireToastEvent("Error!", "Account Type Cannot Be Blank.", "error");
            errorExist = true;
        }

        if (accessAccountP == "" || accessAccountP == null || accessAccountP == undefined) {
            helper.fireToastEvent("Error!", "Selected Account does not have an active combi card", "error");
            errorExist = true;
        }

        if (errorExist) {
            component.set("v.showForm", true);
        } else {
            component.set("v.showForm", false);
        }
    },

    handleBrachCodeComponentEvent: function (component, event, helper) {
        var selectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.branchCode", selectedBranchCodeGetFromEvent);
    },

    editForm: function (component, event, helper) {
        component.set("v.showForm", true);
        component.set("v.showBeneficiaryStatusError", false);
    },

    addBeneficiaryJS: function (component, event, helper) {
        component.set("v.showSubmitButton", true);
        console.log('accAccountNumbervalue ==> '+component.get("v.accAccountNumber"));

        var accountNumberP = component.get("v.selectedAccountNumberToFlow");
        var accountTypeP = component.get("v.selectedProductTypeFromFlow");
        var accessAccountP = component.get("v.accAccountNumber");
        var productTypeP = component.get("v.selectedTargetAccType");
        var beneficiaryNameP = component.get("v.beneficiaryName");
        var branchCodeP = component.get("v.branchCode");
        var targetAccP = component.get("v.accountNumber");
        var beneficiaryReferenceP = component.get("v.beneficiaryReference");
        var ownReferenceP = component.get("v.ownReference");

        if(productTypeP =="Cheque"){
            productTypeP ="02";
        }else if(productTypeP =="Savings"){
            productTypeP ="01";
        }

        var action = component.get("c.addBeneficiary");
        action.setParams({
            productTypeP: productTypeP,
            beneficiaryNameP: beneficiaryNameP,
            targetAccP: targetAccP,
            branchCodeP: branchCodeP,
            accessAccountP: accessAccountP,
            accountNumberP: accountNumberP,
            accountTypeP: accountTypeP,
            beneficiaryReferenceP: beneficiaryReferenceP,
            ownReferenceP: ownReferenceP
        });

        action.setCallback(this, function (resp) {
            var state = resp.getState();
            var msgString = "";
            if (state === "SUCCESS") {
                var resResults = resp.getReturnValue();
                if (resResults === "SUCCESSFUL PROCESS") {
                    component.set("v.showSubmitButton", false);
                    component.set("v.showBeneficiaryStatusSuccess", true);
                } else {
                    helper.fireToastEvent("Error!", "Adding beneficiary Unsuccessful: " + resResults, "error");
                    msgString = resResults;
                    component.set("v.showBeneficiaryStatusError", true);
                    component.set("v.showBeneficiaryStatusErrorMsg", msgString);
                }
            } else if (state === "ERROR") {
                component.set("v.showBeneficiaryStatusSuccess", false);
                component.set("v.showBeneficiaryStatusError", true);
                var errors = resp.getError();
                component.set("v.errorMessage", "Error received in addBeneficiaryJS method. Error: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unknown error in addBeneficiaryJS method. State: " + state);
            }
        });
        $A.enqueueAction(action);
    }
});