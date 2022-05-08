({
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
        var AppAndDigitalBanking = $A.get("$Label.c.Behavioural_Rewards_App_And_Digital_Banking");
        var EventDiscrepancy = $A.get("$Label.c.Behavioural_Rewards_Event_Discrepancy");
        var RedeemingVoucher = $A.get("$Label.c.Behavioural_Rewards_Redeeming_Voucher");
        var VoucherReissuing = $A.get("$Label.c.Behavioural_Rewards_Voucher_Reissuing");
        component.set("v.options", [
            { label: AppAndDigitalBanking, value: AppAndDigitalBanking },
            { label: EventDiscrepancy, value: EventDiscrepancy },
            { label: RedeemingVoucher, value: RedeemingVoucher },
            { label: VoucherReissuing, value: VoucherReissuing }
        ]);
    },

    handleAccountLoad: function (component, event, helper) {
        helper.hideSpinner(component);
    },

    nextAction: function (component, event, helper) {
        var valueSelected = component.get("v.value");
        if (valueSelected) {
            component.set("v.selectedRewardsJob", valueSelected);
            var accName = component.find("accNameField").get("v.value");
            var accountNameFormatted;
            if(component.get("v.isBusinessAccountFromFlow")){
                accountNameFormatted = accName;
            }else{
                accountNameFormatted = accName.FirstName + " " + accName.LastName;
            }
            var newCaseSubject = valueSelected + " - " + accountNameFormatted;
            component.find("caseSubjectField").set("v.value", newCaseSubject);
            component.find("caseEditForm").submit();
            //Navigate Next
            var navigate = component.get("v.navigateFlow");
            navigate("NEXT");
        } else {
            helper.fireToast("Error!", "Please select a Behavioural Rewards option to continue", "error");
        }
    }
});