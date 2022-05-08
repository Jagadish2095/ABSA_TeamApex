({
    doInit: function (component, event, helper) {
        var workspaceAPI = component.find("workspace");
        var recordId = component.get("v.recordId");

        if (!$A.util.isEmpty(recordId)) {
            component.set("v.invokedFromAccount", true);
            component.set("v.isFinancialRecordEdit", true);
            workspaceAPI.getFocusedTabInfo().then(function (response) {
                var focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: 'Edit Statement',
                    setTabIcon: 'utility:moneybag',
                    setTabHighlighted: focusedTabId
                });
            })
        }
        else {
            workspaceAPI.getFocusedTabInfo().then(function (response) {
                var focusedTabId = response.tabId;
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: 'New Statement',
                    setTabIcon: 'utility:moneybag',
                    setTabHighlighted: focusedTabId
                });
            })
        }
        Promise.all([helper.getApplicationClientDetails(component)]).then(function (results) {
            var p1Results = results[0];
            if (p1Results != null) {
                component.set("v.recordAccId", results[0].recordAccId);
                component.set("v.recordClientName", results[0].recordClientName);
                component.set("v.recordYear1NetSales", results[0].recordYear1NetSales);
                component.set("v.recordYear2NetSales", results[0].recordYear2NetSales);
                component.set("v.recordYear3NetSales", results[0].recordYear3NetSales);
                component.set("v.recordYear1NetCurAssets", results[0].recordYear1NetCurAssets);
                component.set("v.recordYear12NetCurAssets", results[0].recordYear12NetCurAssets);
                component.set("v.recordYear3NetCurAssets", results[0].recordYear3NetCurAssets);

                helper.getApplicationFinancialsDocuments(component);

                if (component.get("v.invokedFromAccount")) {
                    setTimeout(function () {
                        var workspaceAPI = component.find("workspace");
                        workspaceAPI.getFocusedTabInfo().then(function (response) {
                            var focusedTabId = response.tabId;
                            workspaceAPI.setTabLabel({
                                tabId: focusedTabId,
                                icon: "action:approval",
                                iconAlt: "Approval",
                                label: "New Statement"
                            });
                            component.set("v.showSpinner", false);
                        }).catch(function (error) {
                            console.log(error);
                        });
                    }, 500);
                }
            }
        }).catch(function (err) {
            var toastEvent = helper.getToast("Error getApplicationClientDetails!", JSON.stringify(err), "Error");
            toastEvent.fire();
        });
    },

    onLoad: function (component, event, helper) {
        if (event.getParam("recordUi").record) {
            component.set("v.recordUiCache", event.getParam("recordUi"));
            component.set("v.appFinData", JSON.parse(JSON.stringify(event.getParam("recordUi").record.fields)));
            component.find("consentCheck").set("v.value", false);
            var appFinData = component.get("v.appFinData");
            if(appFinData) {
                helper.loadValues(component);
            }
        }
    },

    onFinDetailChange: function (component, event, helper) {
        var target = event.getSource();
        var fieldName = target.get("v.fieldName");
        var fieldVal = target.get("v.value");
        if(fieldName) {
            if(fieldName == "Financial_Statement_Type__c") {
                component.set("v.isFinStatTypeAudited", (fieldVal == "Audited - Qualified" ? true : false));
            }
            if(fieldName == "Year_Selection__c") {
                component.set("v.isFinancingNeedsVisible", (fieldVal == "Forecast" ? true : false));
            }
            if(fieldName == "Financial_Statement_Qualified_Issue__c") {
                component.set("v.isFinStatQualIssue", (fieldVal == "YES" ? true : false));
            }
        }
    },

    sumNonCurrentAssets: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("NonCurrentAssets");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Property_Plant_Equipment__c"].value + appFinData["Total_Fixed_Investments_Cash_and_Market__c"].value + appFinData["Intangible_Assets__c"].value + appFinData["Loans_to_Principals_Associates__c"].value + appFinData["Other_Assets__c"].value;

        totalField.set("v.value", parseFloat(total));

        appFinData["Non_Current_Assets__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumTotalAssets(component);
        //if(fieldName=="Intangible_Assets__c"){
            //helper.sumShareFunCapAcc(component);
        //}
    },

    sumTotalCurrentAssets: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("TotalCurrentAssets");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Cash_Marketable_Securities__c"].value + appFinData["Stock__c"].value + appFinData["Trade_Debtors__c"].value + appFinData["Other_Current_Assets__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Total_Current_Assets__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumTotalAssets(component);
    },

    sumTotalCurrentLiabilities: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("TotalCurrentLiabilities");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Bank_And_Short_Term_Loans__c"].value + appFinData["Trade_Creditors__c"].value + appFinData["Taxes_PAYE_VAT_Company_Tax__c"].value + appFinData["Co_Operative_Production_Loans__c"].value + appFinData["Other_Current_Liabilities__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Total_Current_Liabilities__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumTotalLiabilities(component);
    },

    sumTotalLoansfromInsideParties: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");

        appFinData[fieldName].value = parseFloat(amount);

        component.set("v.currentRecord", appFinData);
        helper.sumTotalLoansfromInsideParties(component);
    },

    sumLongTermDebt: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("LongTermDebt");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Land_Bank__c"].value + appFinData["Other__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Long_Term_Debt__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    sumRevaluationOfAssets: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");

        appFinData[fieldName].value = parseFloat(amount);

        component.set("v.currentRecord", appFinData);
        if(fieldName == "Loans_from_Principals_Ceded__c") {
            helper.sumTotalLoansfromInsideParties(component);
        }
        helper.sumNetShareholdersFunds(component);
    },

    sumGrossProfit: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("GrossProfit");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Net_Sales__c"].value - appFinData["Cost_of_Goods_Sold__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Gross_Profit__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    sumOperatingExpenses: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("OperatingExpensesTotal");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Depreciation__c"].value + appFinData["Amortisation__c"].value + appFinData["Capital_Ordinary_Credit_Payments__c"].value
            + appFinData["Capital_Payments_On_Asset_Finance__c"].value + appFinData["Purchase_Capital_Payments_On_Fixed_Prop__c"].value + appFinData["Salaries__c"].value
            + appFinData["Other_Expenses__c"].value;// + appFinData["VAT__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Operating_Expenses_Total__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumIncomeFromOperation(component);
    },

    sumProfitBeforeInterestTax: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("ProfitBeforeInterestAndTaxEBIT");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Income_From_Operations__c"].value + appFinData["Extraordinary_Income_e_g_Sale_of_Asset__c"].value + appFinData["Other_Income__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumEarningsBeforeIntTaxDeprAndAmortfunction(component);
    },

    sumGrossInterestExpenses: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("GrossInterestExpenses");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Interest_Asset_Finance__c"].value + appFinData["Interest_Loans_and_Other_Finance__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Gross_Interest_Expenses__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumProfitBeforeTax(component)
    },

    sumNetProfit: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("NetProfit");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Profit_Before_Tax__c"].value - appFinData["Income_Tax__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Net_Profit__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    sumRetainedEarnings: function (component, event, helper) {
        var appFinData = component.get("v.appFinData");
        var amount = event.getSource().get("v.value");
        var fieldName = event.getSource().get("v.fieldName");
        var totalField = component.find("RetainedEarningsDeficit");

        appFinData[fieldName].value = parseFloat(amount);
        var total = appFinData["Net_Profit__c"].value - appFinData["Dividends__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Retained_Earnings_Deficit__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        helper.sumProfitOperAndDebtRatios(component);
    },

    navigateFinancialStatement: function (component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id_str
        });
        navEvt.fire();
    },

    navigateAccount: function (component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id_str
        });
        navEvt.fire();
    },

    // ## Added for W-008188
    saveStatement: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var invoked = component.get("v.invokedFromAccount")

        if (invoked) {
            var fields = component.get("v.appFinData");
            var invalidFields = helper.getFieldLabelsByApiName(component.get("v.recordUiCache"),helper.getBlankFields(component.find('inputNewFin')));

            if (invalidFields && invalidFields.length > 0) {
                var toastEvent = helper.getToast("Please complete all required fields: ", invalidFields.join(' | '), "Error");
                toastEvent.fire();
                component.set("v.showSpinner", false);
                event.preventDefault();
                return;
            }

            if(invalidFields) {
                var fields = event.getParam("fields");
                component.find('recordEditForm').submit(fields);
                event.getParam("id")
                component.set("v.showSpinner", false);
            }
        }
    },

    handleError: function (component, event, helper) {
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    },

    openModal: function (component, event, helper) {
        component.set("v.showRelatedDocuments", true);
    },

    closeModal: function (component, event, helper) {
        component.set("v.showRelatedDocuments", false);
    },

    checkConsent: function (component, event, helper) {
        var checkCmp = component.find("consentCheck");
        var isAllowedSave = (checkCmp.get("v.value") && component.get("v.isBalancesheetBalanced"));
        if(!isAllowedSave) {
            let message = "Balance Sheet not balanced, please verify data captured!";
            var toastEvent = helper.getToast("Error!", message, "Error");
            toastEvent.fire();
        }
        component.set("v.showSaveBtn", isAllowedSave);
    },

    handleSuccess: function (component, event, helper) {
        var record = event.getParam("response");
        var workspaceAPI = component.find("workspace");
        if (record != null) {
            component.set("v.recordAppFinId", record.id);
            let newRecordId = record.id;

            workspaceAPI.getEnclosingTabId().then(function (tabId) {
                workspaceAPI.openSubtab({
                    parentTabId: tabId,
                    recordId: newRecordId,
                    focus: true
                });
            }).catch(function (error) {
                console.log(error);
            });

            let message = "The record has been saved successfully.";
            var toastEvent = helper.getToast("Success!", message, "Success");
            toastEvent.fire();

            workspaceAPI.getFocusedTabInfo().then(function (response) {
                var focusedTabId = response.tabId;
                workspaceAPI.closeTab({ tabId: focusedTabId });
            }).catch(function (error) {
                console.log(error);
            });
        }
    }
})