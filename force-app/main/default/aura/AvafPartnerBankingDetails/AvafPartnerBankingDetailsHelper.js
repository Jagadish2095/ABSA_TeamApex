({
    //JQUEV 2020/11/19
    //Get Partner Banking Details (AvafGetBankDetails Service)
    getPartnerBankingDetails: function (component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.getPartnerBankingDetails");
        action.setParams({
            businessPartnerNumber: component.get("v.partnerNumberFromFlow")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("getPartnerBankingDetails: " + JSON.stringify(resp));
                if(resp){
                    if (resp.statusCode == 200) {
                        if (resp.BAPI_BUPA_BANKDETAILS_GET && resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS && resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS.length > 0) {
                            //Success
                            component.set("v.data", resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS);
                            component.set("v.avafGetBankDetailsRespFromFlow", JSON.stringify(resp));
                        } else {
                            //Error No List Returned
                            component.set("v.errorMessage", "No Banking Details found for Partner Number: " + component.get("v.partnerNumberFromFlow") + " Using AvafGetBankDetails Service. ");
                        }
                    } else {
                        //Error statusCode not 200
                        component.set("v.errorMessage", "AvafGetBankDetails Service Response: " + JSON.stringify(resp));
                    }
                }else{
                    component.set("v.errorMessage", "Apex error AvafDebitOrderDetailsController.getPartnerBankingDetails returned a null Response. ");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error AvafDebitOrderDetailsController.getPartnerBankingDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.getPartnerBankingDetails state returned: " + state);
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    //JQUEV 2020/11/19
    //Validate New Banking Details (CheckDigitVerification Service)
    validateNewBankDetails: function (component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.validateBankingDetails");
        action.setParams({
            accountNumber: component.get("v.bankAccNumber"),
            branchNumber: component.get("v.branchNumber"),
            accountType: component.get("v.selectedAccTypeValue")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("CheckDigitVerification: " + JSON.stringify(resp));
                if(resp){
                    if (resp.statusCode == 200 && resp.rc == "0") {
                        //Success - Call Add Banking Details
                        component.set("v.modalErrorMessage", null);
                        this.addPartnerBankingDetails(component, event, helper);
                    } else {
                        //Error statusCode not 200 OR Not RC 0
                        if (!$A.util.isEmpty(resp.message)) {
                            component.set("v.modalErrorMessage", "CheckDigitVerification Service Response: " + JSON.stringify(resp));
                        } else {
                            component.set("v.modalErrorMessage", "Invalid Banking Details. ");
                        }
                    }
                }else{
                    component.set("v.modalErrorMessage", "Apex error AvafDebitOrderDetailsController.validateBankingDetails returned a null Response. ");
                }
            } else if (state === "ERROR") {
                //Display Error
                var errors = response.getError();
                component.set("v.modalErrorMessage", "Apex error AvafDebitOrderDetailsController.validateBankingDetails: " + JSON.stringify(errors));
            } else {
                //Display Error
                component.set("v.modalErrorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.validateBankingDetails state returned: " + state);
            }
            if(!$A.util.isEmpty(component.get("v.modalErrorMessage"))){
                helper.hideSpinner(component);
                //Re-enable Form and Button
                component.set("v.isFormReadOnly", false);
                component.find("addPartnerBtn").set("v.disabled", false);
            }
        });
        $A.enqueueAction(action);
    },

    //JQUEV 2020/11/19
    //Add New Banking Details Service Call (AvafAddBankDetails)
    addPartnerBankingDetails: function (component, event, helper) {
        helper.showSpinner(component);
        var action = component.get("c.addPartnerBankingDetails");
        action.setParams({
            businessPartnerNumber: component.get("v.partnerNumberFromFlow"),
            accountNumber: component.get("v.bankAccNumber"),
            branchNumber: component.get("v.branchNumber"),
            accountType: component.get("v.selectedAccTypeValue")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resp = response.getReturnValue();
                console.log("AvafAddBankDetails: " + JSON.stringify(resp));
                if(resp){
                    if (resp.statusCode == 200) {
                        if (resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD && resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKDETAILIDOUT && resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKDETAILIDOUT != "{}") {
                            //Success
                            var bankDetailID = resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKDETAILIDOUT.replace("{", "").replace("}", "");
                            helper.fireToast("Success!", "New Bank Details have been added, Bank Detail ID: " + bankDetailID, "success");
                            this.getPartnerBankingDetails(component, event, helper);
                            this.closeModalHelper(component);
                        } else {
                            //Error No Id Returned
                            if (resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.RETURN_z && resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.RETURN_z.length > 0) {
                                component.set("v.modalErrorMessage", "Service Response: " + resp.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.RETURN_z[0].MESSAGE);
                            } else {
                                component.set("v.modalErrorMessage", "No Banking Details ID Returned for the Partner Number: " + component.get("v.partnerNumberFromFlow") + " Using AvafAddBankDetails Service. ");
                            }
                        }
                    } else {
                        //Error statusCode not 200
                        component.set("v.modalErrorMessage", "AvafAddBankDetails Service Response: " + JSON.stringify(resp));
                    }
                }else{
                    component.set("v.modalErrorMessage", "Apex error AvafDebitOrderDetailsController.addPartnerBankingDetails returned a null Response. ");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.modalErrorMessage", "Apex error AvafDebitOrderDetailsController.addPartnerBankingDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.modalErrorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.addPartnerBankingDetails state returned: " + state);
            }
            helper.hideSpinner(component);
            component.set("v.isFormReadOnly", false);
            component.find("addPartnerBtn").set("v.disabled", false);
        });
        $A.enqueueAction(action);
    },

    //Open Modal
    openModalHelper: function (component) {
        $A.util.addClass(component.find("addPartnerBankingDetailsModal"), "slds-fade-in-open");
        $A.util.addClass(component.find("Modalbackdrop"), "slds-backdrop--open");
    },

    //Close Modal
    closeModalHelper: function (component) {
        component.set("v.modalErrorMessage", null);
        component.find("openModalBtn").set("v.disabled", false);
        $A.util.removeClass(component.find("Modalbackdrop"), "slds-backdrop--open");
        $A.util.removeClass(component.find("addPartnerBankingDetailsModal"), "slds-fade-in-open");
    },

    //Navigate Next
    navigateNextScreen: function (component) {
        //Navigate to next Screen (Send Email)
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    },

    //Show Spinner
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },

    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.isSpinner", false);
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
});