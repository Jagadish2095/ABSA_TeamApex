({
    initPickLisOptions: function (component) {
        // Initialize input select options
        var institutionNames = [
            { class: "optionClass", label: "--Please Select--", value: "None", selected: "true" },
            { class: "optionClass", label: "- FNB", value: "FNB" },
            { class: "optionClass", label: "- Capitec Bank", value: "Capitec Bank" },
            { class: "optionClass", label: "- Nedbank", value: "Nedbank" },
            { class: "optionClass", label: "- Standard Bank", value: "Standard Bank" },
            { class: "optionClass", label: "- African Bank", value: "African Bank" },
            { class: "optionClass", label: "- Investec Bank", value: "Investec Bank" },
            { class: "optionClass", label: "- Other", value: "Other" }
        ];

        var redFrequency = [
            { class: "optionClass", label: "--Please Select--", value: "None", selected: "true" },
            { class: "optionClass", label: "Monthly", value: "M" },
            { class: "optionClass", label: "Quartely", value: "Q" },
            { class: "optionClass", label: "B-Annual", value: "B" },
            { class: "optionClass", label: "Annually", value: "A" }
        ];

        component.set("v.selInstitution", institutionNames);
        component.set("v.selFrequency", redFrequency);

        var minDate = new Date();
        minDate = minDate.getFullYear() + "-" + (minDate.getMonth() + 1) + "-" + minDate.getDate();

        component.set("v.minDate", minDate);
    },

    landCoOpVisible: function (component) {
        var oppRecord = component.get("v.oppRecord");
        var isVisibleLandBank = ((oppRecord.Account != null && oppRecord.Account.Client_Type__c == "Farmer") ? true : false);
        var isVisibleCoOp = ((oppRecord.Account != null && oppRecord.Account.Client_Type__c == "Co-operative") ? true : false);
        component.set("v.isActiveLandBank", isVisibleLandBank);
        component.set("v.isActiveCoOp", isVisibleCoOp);
    },

    getExtBankRel: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getAllExtBankRelations");

        action.setParams({
            "oppId": oppId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == "SUCCESS") {
                var result = response.getReturnValue();

                if (result != null) {
                    this.landCoOpVisible(component);
                    this.populateExtBankRel(component, result);
                }
            }
            else {
                this.showError(response, "getAllExtBankRelations");
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    saveExtBankRel: function (component, eventObjValue) {
        var oppId = component.get("v.recordId");
        this.buildExtBankRelObj(component, eventObjValue);

        var isDeleted = (eventObjValue != null ? true : false);
        var extBankRelObj = component.get("v.extBankRelData");

        if (extBankRelObj != null && this.isAnySectionWithData(extBankRelObj)) {

            var allValid = component.find("inputExt").reduce(function (validSoFar, inputFld) {
                // Displays error messages for invalid fields
                inputFld.showHelpMessageIfInvalid();
                return validSoFar && inputFld.get("v.validity").valid;
            }, true);

            if (allValid) {
                component.set("v.showSpinner", true);
                var cleanExtBankRelObj = this.removeNullProperties(extBankRelObj);
                var action = component.get("c.saveAllExtBankRelations");

                action.setParams({
                    "oppId": oppId,
                    "jsonObj": JSON.stringify(cleanExtBankRelObj),
                    "isDelete": isDeleted
                });

                action.setCallback(this, function (response) {
                    var state = response.getState();

                    if (state == "SUCCESS") {
                        var result = response.getReturnValue();

                        if (result != null) {
                            this.getExtBankRel(component);
                            var toastEvent = this.getToast("Success!", result.Status, "Success");
                            toastEvent.fire();
                        }
                    }
                    else {
                        this.showError(response, "saveAllExtBankRelations");
                    }
                    //component.set("v.showSpinner", false);
                });

                $A.enqueueAction(action);
            }
        }
    },

    populateExtBankRel: function (component, objectData) {
        component.set("v.landBankLoan", objectData.LandBankLoan);
        component.set("v.coOperativeDebt", objectData.CoOperativeDebt);
        component.set("v.externalChequeAccounts", objectData.ExternalChequeAccount);
        component.set("v.externalBusinessCreditCard", objectData.BusinessCreditCard);
        component.set("v.externalTermLoan", objectData.ExternalTermLoan);
        component.set("v.externalAssetAndVehicleFinance", objectData.ExternalAssetAndVehicleFinance);
        component.set("v.externalMortgageLoans", objectData.ExternalMortgageLoans);
        component.set("v.externalSavingsAccount", objectData.ExternalSavingsAccount);
        component.set("v.externalInvestment", objectData.ExternalInvestment);
        component.set("v.externalRetailCommitments", objectData.RetailAndOtherExternalCommitments);
    },

    buildExtBankRelObj: function (component, eventObjValue) {

        var extRelLndBnkLn = component.get("v.landBankLoan");
        var extRelCopDebt = component.get("v.coOperativeDebt");
        var extRelChqacc = component.get("v.externalChequeAccounts");
        var extRelBusCc = component.get("v.externalBusinessCreditCard");
        var extRelTmLn = component.get("v.externalTermLoan");
        var extRelAsVeFin = component.get("v.externalAssetAndVehicleFinance");
        var extRelMoLn = component.get("v.externalMortgageLoans");
        var extRelSavAcc = component.get("v.externalSavingsAccount");
        var extRelInvt = component.get("v.externalInvestment");
        var extRelRetcom = component.get("v.externalRetailCommitments");
        var extBankRelObj = [];

        extBankRelObj.push({ "LandBankLoan": (eventObjValue != null ? (eventObjValue[0].Section == "Land Bank Loan" ? eventObjValue : null) : extRelLndBnkLn) });
        extBankRelObj.push({ "CoOperativeDebt": (eventObjValue != null ? (eventObjValue[0].Section == "Co-Operative Debt" ? eventObjValue : null) : extRelCopDebt) });
        extBankRelObj.push({ "ExternalChequeAccounts": (eventObjValue != null ? (eventObjValue[0].Section == "External Cheque Account" ? eventObjValue : null) : extRelChqacc) });
        extBankRelObj.push({ "BusinessCreditCard": (eventObjValue != null ? (eventObjValue[0].Section == "Business Credit Card" ? eventObjValue : null) : extRelBusCc) });
        extBankRelObj.push({ "ExternalTermLoan": (eventObjValue != null ? (eventObjValue[0].Section == "External Term Loan" ? eventObjValue : null) : extRelTmLn) });
        extBankRelObj.push({ "ExternalAssetAndVehicleFinance": (eventObjValue != null ? (eventObjValue[0].Section == "External Asset And Vehicle Finance" ? eventObjValue : null) : extRelAsVeFin) });
        extBankRelObj.push({ "ExternalMortgageLoans": (eventObjValue != null ? (eventObjValue[0].Section == "External Mortgage Loan" ? eventObjValue : null) : extRelMoLn) });
        extBankRelObj.push({ "ExternalSavingsAccount": (eventObjValue != null ? (eventObjValue[0].Section == "External Savings Account" ? eventObjValue : null) : extRelSavAcc) });
        extBankRelObj.push({ "ExternalInvestment": (eventObjValue != null ? (eventObjValue[0].Section == "External Investment" ? eventObjValue : null) : extRelInvt) });
        extBankRelObj.push({ "RetailAndOtherExternalCommitments": (eventObjValue != null ? (eventObjValue[0].Section == "Retail And Other External Commitment" ? eventObjValue : null) : extRelRetcom) });

        component.set("v.extBankRelData", extBankRelObj);
    },

    setExternalRelation: function (component, acText) {
        var iterNum, iterItems;

        switch (acText) {
            case "Add Land Bank Loan":
                iterItems = component.get("v.landBankLoan");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.landBankLoan", iterItems);

                break;
            case "Add Co-Operative Debt":
                iterItems = component.get("v.coOperativeDebt");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.coOperativeDebt", iterItems);

                break;
            case "Add External Cheque Account":
                iterItems = component.get("v.externalChequeAccounts");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalChequeAccounts", iterItems);

                break;
            case "Add Business Credit Card":
                iterItems = component.get("v.externalBusinessCreditCard");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalBusinessCreditCard", iterItems);

                break;
            case "Add External Term Loan":
                iterItems = component.get("v.externalTermLoan");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalTermLoan", iterItems);

                break;
            case "Add External Asset And Vehicle Finance":
                iterItems = component.get("v.externalAssetAndVehicleFinance");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalAssetAndVehicleFinance", iterItems);

                break;
            case "Add External Mortgage Loan":
                iterItems = component.get("v.externalMortgageLoans");

                this.populateAttribute(iterNum, iterItems, acText, 4);
                component.set("v.externalMortgageLoans", iterItems);

                break;
            case "Add External Savings Account":
                iterItems = component.get("v.externalSavingsAccount");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalSavingsAccount", iterItems);

                break;
            case "Add External Investment":
                iterItems = component.get("v.externalInvestment");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.externalInvestment", iterItems);

                break;
            case "Add Retail And Other External Commitment":
                iterItems = component.get("v.externalRetailCommitments");

                this.populateAttribute(iterNum, iterItems, acText, 5);
                component.set("v.externalRetailCommitments", iterItems);

                break;
            /*case "Add Under Debt Counseling - External":
                iterItems = component.get("v.underDebtCounselingExternal");

                this.populateAttribute(iterNum, iterItems, acText, 2);
                component.set("v.underDebtCounselingExternal", iterItems);
                break;*/
        }
    },

    populateAttribute: function (iterNum, iterItems, acText, repeatNum) {

        iterNum = (iterItems == null ? 0 : iterItems.length);
        if (iterNum < repeatNum) {
            iterNum++;
            iterItems.push({
                UqId: iterNum,
                Section: acText.replace("Add ", ""),
                AccountLimit: null,
                AccountNumber: null,
                ArrearsAmount: null,
                Balance: null,
                CreditCardLimit: null,
                CreditorName: null,
                CurrentBalance: null,
                ExpiryDate: null,
                Instalment: null,
                InstitutionName: null,
                LastPaymentDate: null,
                MaximumDebitBalance: null,
                MaximumOverdraftLimit: null,
                MonthlyInterestAndDividendsEarned: null,
                MonthlyInterestEarned: null,
                MonthlyReduction: null,
                MonthlyRepayment: null,
                NumberOfReturnedItems: null,
                OtherBankName: null,
                OutstandingBalance: null,
                OverdraftLimit: null,
                PeriodOfTheBankStatements: null,
                Recalculate: null,
                ReductionAmount: null,
                ReductionFrequency: null,
                RepaymentFrequency: null,
                TermOfFinance: null,
                TurnoverForThePeriod: null
            });
        }
    },

    getRepaymentAmount: function (itemsObject, accText, isReduction) {
        var itemsObjectRet = [];

        for (var i = 0; i < itemsObject.length; i++) {
            var child = itemsObject[i];

            if (child.UqId == accText) {
                var freq = child.RepaymentFrequency;
                var inst = (child.Instalment == null ? child.RepaymentAmount : child.Instalment);
                var monthlyAmount;

                if (isReduction) {
                    freq = child.ReductionFrequency;
                    inst = child.ReductionAmount;
                }

                if (freq != null) {
                    console.log("freq: " + freq);

                    if (freq == "A") {
                        monthlyAmount = inst / 12;
                    }
                    else if (freq == "B") {
                        monthlyAmount = inst / 6;
                    }
                    else if (freq == "Q") {
                        monthlyAmount = inst / 3;
                    }
                    else if (freq == "M") {
                        monthlyAmount = inst / 1;
                    }
                }

                if (!isReduction) {
                    itemsObject[i].MonthlyRepayment = monthlyAmount.toFixed(2);
                }
                else {
                    itemsObject[i].MonthlyReduction = monthlyAmount.toFixed(2);
                }
            }

            itemsObjectRet.push(itemsObject[i])
        }

        return itemsObjectRet;
    },

    removeNullProperties: function (obj) {
        Object.keys(obj).forEach(key => {
            let value = obj[key];
            let hasProperties = value && Object.keys(value).length > 0;
            if (value === null) {
                delete obj[key];
            }
            else if ((typeof value !== "string") && hasProperties) {
                this.removeNullProperties(value);
            }
        });
        return obj;
    },

    isAnySectionWithData: function (obj) {
        var isWithData = false;
        Object.keys(obj).forEach(key => {
            let value = obj[key];

            Object.keys(value).forEach(ckey => {
                let cValue = value[ckey];
                let hasProperties = (cValue && cValue.length > 0);

                if (hasProperties) {
                    isWithData = true;
                }
            });
        });
        console.log("isWithData: " + isWithData);
        return isWithData;
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });

        return toastEvent;
    },

    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }

        // show error notification
        var toastEvent = this.getToast("Error: ExternalBankingRelations " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})