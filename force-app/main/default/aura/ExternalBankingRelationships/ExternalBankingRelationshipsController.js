({
    doInit: function (component, event, helper) {
        helper.initPickLisOptions(component);
        helper.getExtBankRel(component);
    },

    submitExtBankRel: function (component, event, helper) {
        var eventObjValue = event.getParam("deletedExtRelationDet");
        helper.saveExtBankRel(component, eventObjValue);
    },

    addExternalRelation: function (component, event, helper) {
        var target = event.getSource();
        var acText = target.get("v.label");

        helper.setExternalRelation(component, acText);
    },

    onFrequencyChange: function (component, event, helper) {
        var target = event.getSource();
        var acLabel = target.get("v.label");
        var acText = target.get("v.name");

        if (acLabel == 'Reduction Frequency:') {
            var extRelChqAcc = component.get("v.externalChequeAccounts");

            if (extRelChqAcc != null) {

                extRelChqAcc = helper.getRepaymentAmount(extRelChqAcc, acText, true);
                component.set("v.externalChequeAccounts", extRelChqAcc);
            }
        }
        else if (acLabel == 'Repayment Frequency:') {
            var accText = acText.substr(-1);

            if (acText.search("LndBankLn") >= 0) {
                var extRelLndBnkLn = component.get("v.landBankLoan");

                if (extRelLndBnkLn != null) {

                    extRelLndBnkLn = helper.getRepaymentAmount(extRelLndBnkLn, accText, false);
                    component.set("v.landBankLoan", extRelLndBnkLn);
                }
            }
            else if (acText.search("CoOpDebt") >= 0) {
                var extRelCopDebt = component.get("v.coOperativeDebt");

                if (extRelCopDebt != null) {

                    extRelCopDebt = helper.getRepaymentAmount(extRelCopDebt, accText, false);
                    component.set("v.coOperativeDebt", extRelCopDebt);
                }
            }
            else if (acText.search("ExtVhAssFin") >= 0) {
                var extRelVhAssFin = component.get("v.externalAssetAndVehicleFinance");

                if (extRelVhAssFin != null) {

                    extRelVhAssFin = helper.getRepaymentAmount(extRelVhAssFin, accText, false);
                    component.set("v.externalAssetAndVehicleFinance", extRelVhAssFin);
                }
            }
            else if (acText.search("ExtMortLoans") >= 0) {
                var extRelMtln = component.get("v.externalMortgageLoans");

                if (extRelMtln != null) {

                    extRelMtln = helper.getRepaymentAmount(extRelMtln, accText, false);
                    component.set("v.externalMortgageLoans", extRelMtln);
                }
            }
            else if (acText.search("ExtTermLoans") >= 0) {
                var extRelTmLn = component.get("v.externalTermLoan");

                if (extRelTmLn != null) {

                    extRelTmLn = helper.getRepaymentAmount(extRelTmLn, accText, false);
                    component.set("v.externalTermLoan", extRelTmLn);
                }
            }
        }
    },

    onBankNameChange: function (component, event, helper) {
        var target = event.getSource();
        var acLabel = target.get("v.label");
        var acText = target.get("v.value");
        var acName = target.get("v.name");
        if (acLabel.search('Institution Name') >= 0) {
            var selTxt = acText.toLowerCase();
            if (acName.includes("1") && acName.includes("ExternalChequeAccount")) {
                component.set("v.isOtherBankNameReqChq", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("ExternalChequeAccount")) {
                component.set("v.isOtherBankNameReqChq1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("ExternalBankCredit")) {
                component.set("v.isOtherBankNameReqBus", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("ExternalBankCredit")) {
                component.set("v.isOtherBankNameReqBus1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("AssetVehicle")) {
                component.set("v.isOtherBankNameReqVeh", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("AssetVehicle")) {
                component.set("v.isOtherBankNameReqVeh1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("MortgageLoans")) {
                component.set("v.isOtherBankNameReqMLn", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("MortgageLoans")) {
                component.set("v.isOtherBankNameReqMLn1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("3") && acName.includes("MortgageLoans")) {
                component.set("v.isOtherBankNameReqMLn2", (acName.includes("3") && selTxt == "other" ? true : false));
            }
            if (acName.includes("4") && acName.includes("MortgageLoans")) {
                component.set("v.isOtherBankNameReqMLn3", (acName.includes("4") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("SavingAccount")) {
                component.set("v.isOtherBankNameReqSav", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("SavingAccount")) {
                component.set("v.isOtherBankNameReqSav1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("ExternalInvestment")) {
                component.set("v.isOtherBankNameReqInv", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("ExternalInvestment")) {
                component.set("v.isOtherBankNameReqInv1", (acName.includes("2") && selTxt == "other" ? true : false));
            }
            if (acName.includes("1") && acName.includes("ExternalTermLoan")) {
                component.set("v.isOtherBankNameReqTerm", (acName.includes("1") && selTxt == "other" ? true : false));
            }
            if (acName.includes("2") && acName.includes("ExternalTermLoan")) {
                component.set("v.isOtherBankNameReqTerm1", (acName.includes("2") && selTxt == "other" ? true : false));
            }

        }
    }
})