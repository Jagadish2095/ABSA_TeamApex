({
    //JQUEV 2020-11-12
    doInit: function (component, event, helper) {
        //Validate required inputs are not null
        if ($A.util.isEmpty(component.get("v.avafGetBankDetailsRespFromFlow")) || $A.util.isEmpty(component.get("v.partnerNumberFromFlow"))) {
            component.set("v.errorMessage", "Partner Number & Get Bank Details Response are required to perform this action. Partner Number: " + component.get("v.partnerNumberFromFlow"));
        } else {
            //Set Columns
            component.set("v.columns", [
                { label: "Bank Detail ID", fieldName: "BANKDETAILID", type: "text" },
                { label: "Bank Country", fieldName: "BANK_CTRY", type: "text" },
                { label: "Account Type", fieldName: "CTRL_KEY", type: "text" },
                { label: "Bank Account Number", fieldName: "BANK_ACCT", type: "text" }
            ]);
            //Set Data with Response from Flow
            var bankDetailResponseObj = JSON.parse(component.get("v.avafGetBankDetailsRespFromFlow"));
            if(
                bankDetailResponseObj &&
                bankDetailResponseObj.statusCode == 200 &&
                bankDetailResponseObj.BAPI_BUPA_BANKDETAILS_GET &&
                bankDetailResponseObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS &&
                bankDetailResponseObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS.length > 0
            ){
                component.set("v.data", bankDetailResponseObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS);
            }else{
                component.set("v.errorMessage", "AVAFGetBankingDetails: No Banking Details Found: " + component.get("v.avafGetBankDetailsRespFromFlow"));
            }
        }
    },

    //Add Partner Banking Details
    handleAddPartnerBankingDetails: function (component, event, helper) {
        //Validate Add new Banking Details modal
        if (
            $A.util.isEmpty(component.get("v.bankAccNumber")) ||
            $A.util.isEmpty(component.get("v.selectedAccTypeValue")) ||
            component.get("v.selectedAccTypeValue") == "0" ||
            $A.util.isEmpty(component.get("v.branchNumber"))
        ) {
            helper.fireToast("Error!", "Please complete the required fields. ", "error");
        } else {
            //Disable Form and Add Button
            component.set("v.isFormReadOnly", true);
            component.find("addPartnerBtn").set("v.disabled", true);
            component.set("v.modalErrorMessage", null);
            //Call Check Digit Verification Service
            //helper.validateNewBankDetails(component, event, helper);
            //Skipping the Check Digit Verification Service for now. Just calling Add (Change requested by Nyandane & Pfunzo)
            helper.addPartnerBankingDetails(component, event, helper);
        }
    },

    //Open Modal
    openModal: function (component, event, helper) {
        helper.openModalHelper(component);
    },

    //Close Modal
    closeModal: function (component, event, helper) {
        helper.closeModalHelper(component);
    },

    //Navigate Next
    navigateNext: function (component, event, helper) {
        helper.navigateNextScreen(component);
    }
});