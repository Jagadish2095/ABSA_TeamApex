({
    getApplicationFinancialsDocuments: function (component) {
        var recordAccId = component.get("v.recordAccId");
        var action = component.get("c.getApplicationFinancialsDocuments");

        action.setParams({
            recordAccId: recordAccId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null && result.length > 0) {
                    component.set("v.ContentDoc", result);
                    component.set("v.DocSize", result.length);
                }
            }
            else if (state == "ERROR") {
                this.showError(response, "getApplicationFinancialsDocuments");
            }
        });
        $A.enqueueAction(action);
    },

    getApplicationClientDetails: function (component, event, helper) {
        return new Promise(function (resolve, reject) {
            component.set("v.showSpinner", true);
            var recordAccId = component.get("v.recordAccId");
            var recordId = component.get("v.recordId");
            var action = component.get("c.getApplicationClientDetails");

            action.setParams({
                "finRecId": recordId,
                "accId": recordAccId
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    var result = response.getReturnValue();
                    resolve(result);
                }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError()[0];
                    reject(errors);
                }
                component.set("v.showSpinner", false);
            });
            $A.enqueueAction(action);
        });
    },

    setValidationFields: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.oppId");
        var action = component.get("c.setValidationFields");

        action.setParams({
            OppId: oppId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result != null) {
                    var toastEvent = this.getToast("Success", "Validation Fields Set Successfully!", "Success!");
                    toastEvent.fire();
                }
            }
            else if (state == "ERROR") {
                this.showError(response, "setValidationFields");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    sumTotalAssets: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("TotalAssets");
        //var totalFieldLiab = component.find("TotalLiabilities");

        var total = appFinData["Non_Current_Assets__c"].value + appFinData["Total_Current_Assets__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Total_Assets__c"].value = parseFloat(total);
        //totalFieldLiab.set("v.value", parseFloat(total));
        //appFinData["Total_Liabilities__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        this.isBalanceSheetBalanced(component);
    },

    sumTotalLoansfromInsideParties: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("TotalLoansfromInsideParties");

        var total = appFinData["Loans_from_Principals_Non_Ceded__c"].value + appFinData["Loans_from_Principals_Ceded__c"].value + appFinData["Loans_from_Associates__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Total_Loans_from_Inside_Parties__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    sumShareFunCapAcc: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("ShareholdersFundsCapitalAccount");

        var total = appFinData["Total_Liabilities__c"].value - appFinData["Total_Current_Liabilities__c"].value - appFinData["Long_Term_Debt__c"].value - appFinData["Total_Loans_from_Inside_Parties__c"].value - appFinData["Revaluation_Of_Assets__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Shareholders_Funds_Capital_Account__c"].value = parseFloat(total);
        component.set("v.shareholdersFundsCapitalAccountVal", parseFloat(total));
        component.set("v.currentRecord", appFinData);
        this.sumNetShareholdersFunds(component);
    },

    sumTotalLiabilities: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("TotalLiabilities");

        var total = appFinData["Shareholders_Funds_Capital_Account__c"].value + appFinData["Revaluation_Of_Assets__c"].value + appFinData["Total_Loans_from_Inside_Parties__c"].value + appFinData["Long_Term_Debt__c"].value + appFinData["Total_Current_Liabilities__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Total_Liabilities__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        this.isBalanceSheetBalanced(component);
    },

    sumNetShareholdersFunds: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("NetShareholdersFunds");

        var total = appFinData["Shareholders_Funds_Capital_Account__c"].value + appFinData["Revaluation_Of_Assets__c"].value + appFinData["Loans_from_Principals_Ceded__c"].value - appFinData["Intangible_Assets__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Net_Shareholders_Funds__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        this.isBalanceSheetBalanced(component);
    },

    sumIncomeFromOperation: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("IncomeFromOperations");

        var total = appFinData["Gross_Profit__c"].value - appFinData["Operating_Expenses_Total__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Income_From_Operations__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
        this.sumEarningsBeforeIntTaxDeprAndAmortfunction(component);
    },

    sumProfitBeforeTax: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("ProfitBeforeTax");

        var total = appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value - appFinData["Gross_Interest_Expenses__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Profit_Before_Tax__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    sumEarningsBeforeIntTaxDeprAndAmortfunction: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField = component.find("EarningsBeforeInterestTaxDepreciationAndAmortisation");

        var total = appFinData["Amortisation__c"].value + appFinData["Depreciation__c"].value + appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value;

        totalField.set("v.value", parseFloat(total));
        appFinData["Earnings_Before_Interest_Tax_Dep_Amort__c"].value = parseFloat(total);
        component.set("v.currentRecord", appFinData);
    },

    isBalanceSheetBalanced: function (component) {
        var appFinData = component.get("v.appFinData");
        var boolField = component.find("BalanceSheetBalanced");

        var isBalancesheetBalanced = (appFinData["Total_Assets__c"].value == appFinData["Total_Liabilities__c"].value ? "YES" : "NO");
        boolField.set("v.value", isBalancesheetBalanced);
        appFinData["Balance_Sheet_Balanced__c"].value = isBalancesheetBalanced;
        component.set("v.isBalancesheetBalanced", (isBalancesheetBalanced == "YES" ? true : false));
        component.set("v.currentRecord", appFinData);
    },

    sumProfitOperAndDebtRatios: function (component) {
        var appFinData = component.get("v.appFinData");
        var totalField1 = component.find("SalesGrowth");
        var totalField2 = component.find("GrossProfitRatio");
        var totalField3 = component.find("NetProfitRaio");
        var totalField4 = component.find("CurrentRatio");
        var totalField5 = component.find("AcidTestExclStock");
        var totalField6 = component.find("CreditTurnoverDays");
        var totalField7 = component.find("DebtorTurnoverDays");
        var totalField8 = component.find("StockTurnoverDays");
        var totalField9 = component.find("InterestCover");
        var totalField10 = component.find("NetWorthOrEquity");
        var totalField11 = component.find("NetGearing");
        var totalField12 = component.find("TotalLiabilitiesExclNetworth");
        var totalField13 = component.find("NetCurrentAssets");
        var totalField14 = component.find("LiquidSurplusVariation");
        var totalField15 = component.find("InterestBearingDebtEquity");
        var totalField16 = component.find("IBDEBITDA");
        var totalField17 = component.find("LongTermDebtEBITDA");
        var totalField18 = component.find("InterestCoverRatioEBITIntPaid");
        var totalField19 = component.find("TotalAssetTurnover");
        var totalField20 = component.find("OperatingProfitMargin");
        var yearSelection = component.find("YearSelection").get("v.value");
        var noOfDays = component.find("NoOfDays").get("v.value");
        var recordYear1NetSales = component.get("v.recordYear1NetSales");
        var recordYear2NetSales = component.get("v.recordYear2NetSales");
        var recordYear3NetSales = component.get("v.recordYear3NetSales");
        var recordYear1NetCurAssets = component.get("v.recordYear1NetCurAssets");
        var recordYear2NetCurAssets = component.get("v.recordYear2NetCurAssets");
        var recordYear3NetCurAssets = component.get("v.recordYear3NetCurAssets");

        var total1 = 0, total14 = 0;
        if (yearSelection == "Forecast") {
            total1 = (recordYear3NetSales == 0.00 ? 0.00 : ((appFinData["Net_Sales__c"].value - recordYear3NetSales) / recordYear3NetSales) * 100);
            total14 = (recordYear3NetCurAssets == 0.00 ? 0.00 : (appFinData["Net_Current_Assets__c"].value - recordYear3NetCurAssets));
        }
        else if (yearSelection == "Year3") {
            total1 = (recordYear2NetSales == 0.00 ? 0.00 : ((appFinData["Net_Sales__c"].value - recordYear2NetSales) / recordYear2NetSales) * 100);
            total14 = (recordYear2NetCurAssets == 0.00 ? 0.00 : (appFinData["Net_Current_Assets__c"].value - recordYear2NetCurAssets));
        }
        else if (yearSelection == "Year2") {
            total1 = (recordYear1NetSales == 0.00 ? 0.00 : ((appFinData["Net_Sales__c"].value - recordYear1NetSales) / recordYear1NetSales) * 100);
            total14 = (recordYear1NetCurAssets == 0.00 ? 0.00 : (appFinData["Net_Current_Assets__c"].value - recordYear1NetCurAssets));
        }
        else if (yearSelection == "Year1") {
            total1 = 0.00;
            total14 = 0.00;
        }

        var total2 = ((appFinData["Net_Sales__c"].value == 0 || appFinData["Net_Sales__c"].value == null) ? 0.00 : ((appFinData["Gross_Profit__c"].value / appFinData["Net_Sales__c"].value) * 100));
        var total3 = ((appFinData["Net_Sales__c"].value == 0 || appFinData["Net_Sales__c"].value == null) ? 0.00 : ((appFinData["Profit_Before_Tax__c"].value / appFinData["Net_Sales__c"].value) * 100));
        var total4 = ((appFinData["Total_Current_Liabilities__c"].value == 0 || appFinData["Total_Current_Liabilities__c"].value == null) ? 0.00 : (appFinData["Total_Current_Assets__c"].value / appFinData["Total_Current_Liabilities__c"].value));
        var total5 = ((appFinData["Total_Current_Liabilities__c"].value == 0 || appFinData["Total_Current_Liabilities__c"].value == null) ? 0.00 : ((appFinData["Total_Current_Assets__c"].value - appFinData["Stock__c"].value) / appFinData["Total_Current_Liabilities__c"].value));
        var total6 = ((appFinData["Cost_of_Goods_Sold__c"].value == 0 || appFinData["Cost_of_Goods_Sold__c"].value == null) ? 0.00 : ((appFinData["Trade_Creditors__c"].value / appFinData["Cost_of_Goods_Sold__c"].value) * noOfDays));
        var total7 = ((appFinData["Net_Sales__c"].value == 0 || appFinData["Net_Sales__c"].value == null) ? 0.00 : ((appFinData["Trade_Debtors__c"].value / appFinData["Net_Sales__c"].value) * noOfDays));
        var total8 = ((appFinData["Cost_of_Goods_Sold__c"].value == 0 || appFinData["Cost_of_Goods_Sold__c"].value == null) ? 0.00 : ((appFinData["Stock__c"].value / appFinData["Cost_of_Goods_Sold__c"].value) * noOfDays));
        var total9 = ((appFinData["Gross_Interest_Expenses__c"].value == 0 || appFinData["Gross_Interest_Expenses__c"].value == null) ? 0.00 : ((appFinData["Profit_Before_Tax__c"].value + appFinData["Gross_Interest_Expenses__c"].value) / appFinData["Gross_Interest_Expenses__c"].value));
        var total10 = (appFinData["Net_Shareholders_Funds__c"].value - appFinData["Loans_from_Principals_Non_Ceded__c"].value);
        var total11 = ((appFinData["Total_Current_Liabilities__c"].value == 0 || appFinData["Total_Current_Liabilities__c"].value == null) ? 0.00 : (appFinData["Total_Current_Liabilities__c"].value + appFinData["Long_Term_Debt__c"].value + appFinData["Total_Loans_from_Inside_Parties__c"].value) / (appFinData["Net_Shareholders_Funds__c"].value - appFinData["Loans_from_Principals_Ceded__c"].value));
        var total12 = ((appFinData["Total_Liabilities__c"].value == 0 || appFinData["Total_Liabilities__c"].value == null) ? 0.00 : (appFinData["Total_Liabilities__c"].value - (appFinData["Net_Shareholders_Funds__c"].value - appFinData["Loans_from_Principals_Ceded__c"].value)) / appFinData["Total_Assets__c"].value);
        var total13 = (appFinData["Total_Current_Assets__c"].value - appFinData["Total_Current_Liabilities__c"].value);
        //var total14 = ((appFinData["Gross_Profit__c"].value == 0 || appFinData["Gross_Profit__c"].value == null) ? 0.00 : ((appFinData["Gross_Profit__c"].value / appFinData["Net_Sales__c"].value) * 100));
        var total15 = (((appFinData["Long_Term_Debt__c"].value == null && appFinData["Bank_And_Short_Term_Loans__c"].value == null) || appFinData["Long_Term_Debt__c"].value + appFinData["Bank_And_Short_Term_Loans__c"].value == 0) ? 0.00 : ((appFinData["Long_Term_Debt__c"].value + appFinData["Bank_And_Short_Term_Loans__c"].value) / ((appFinData["Net_Shareholders_Funds__c"].value - appFinData["Loans_from_Principals_Ceded__c"].value)) - appFinData["Net_Profit__c"].value + (appFinData["Net_Profit__c"].value * 365 / noOfDays)));
        var total16 = (((appFinData["Long_Term_Debt__c"].value == null && appFinData["Bank_And_Short_Term_Loans__c"].value == null) || appFinData["Long_Term_Debt__c"].value + appFinData["Bank_And_Short_Term_Loans__c"].value == 0) ? 0.00 : ((appFinData["Long_Term_Debt__c"].value + appFinData["Bank_And_Short_Term_Loans__c"].value) / (appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value + appFinData["Depreciation__c"].value + appFinData["Amortisation__c"].value)));
        var total17 = (((appFinData["Depreciation__c"].value == null && appFinData["Amortisation__c"].value == null && appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value == null) || (appFinData["Depreciation__c"].value + appFinData["Amortisation__c"].value + appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value) == 0) ? 0.00 : (appFinData["Long_Term_Debt__c"].value / (appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value + appFinData["Depreciation__c"].value + appFinData["Amortisation__c"].value)));
        var total18 = ((appFinData["Gross_Interest_Expenses__c"].value == 0 || appFinData["Gross_Interest_Expenses__c"].value == null) ? 0.00 : (appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value / appFinData["Gross_Interest_Expenses__c"].value));
        var total19 = ((appFinData["Total_Assets__c"].value == 0 || appFinData["Total_Assets__c"].value == null) ? 0.00 : ((appFinData["Net_Sales__c"].value * 365 / noOfDays) / (appFinData["Total_Assets__c"].value - appFinData["Intangible_Assets__c"].value)));
        var total20 = ((appFinData["Net_Sales__c"].value == 0 || appFinData["Net_Sales__c"].value == null) ? 0.00 : ((appFinData["Profit_Before_Interest_And_Tax_EBIT__c"].value / appFinData["Net_Sales__c"].value * 365 / noOfDays) * 100));

        if (yearSelection != "Forecast") {
            totalField1.set("v.value", parseFloat(total1).toFixed(2));
            totalField2.set("v.value", parseFloat(total2).toFixed(2));
            totalField3.set("v.value", parseFloat(total3).toFixed(2));
            totalField4.set("v.value", parseFloat(total4).toFixed(2));
            totalField5.set("v.value", parseFloat(total5).toFixed(2));
            totalField6.set("v.value", parseFloat(total6).toFixed(2));
            totalField7.set("v.value", parseFloat(total7).toFixed(2));
            totalField8.set("v.value", parseFloat(total8).toFixed(2));
            totalField9.set("v.value", parseFloat(total9).toFixed(2));
            totalField10.set("v.value", parseFloat(total10).toFixed(2));
            totalField11.set("v.value", parseFloat(total11).toFixed(2));
            totalField12.set("v.value", parseFloat(total12).toFixed(2));
            totalField13.set("v.value", parseFloat(total13).toFixed(2));
            totalField14.set("v.value", parseFloat(total14).toFixed(2));
            totalField15.set("v.value", parseFloat(total15).toFixed(2));
            totalField16.set("v.value", parseFloat(total16).toFixed(2));
            totalField17.set("v.value", parseFloat(total17).toFixed(2));
            totalField18.set("v.value", parseFloat(total18).toFixed(2));
            totalField19.set("v.value", parseFloat(total19).toFixed(2));
            totalField20.set("v.value", parseFloat(total20).toFixed(2));

            appFinData["Sales_Growth__c"].value = parseFloat(total1).toFixed(2);
            appFinData["Gross_Profit_Ratio__c"].value = parseFloat(total2).toFixed(2);
            appFinData["Net_Profit_Profit_before_Tax_Net_Sale__c"].value = parseFloat(total3).toFixed(2);
            appFinData["Current_Ratio__c"].value = parseFloat(total4).toFixed(2);
            appFinData["Acid_Test_Excl_Stock__c"].value = parseFloat(total5).toFixed(2);
            appFinData["Credit_Turnover_Days__c"].value = parseFloat(total6).toFixed(2);
            appFinData["Debtor_Turnover_Days__c"].value = parseFloat(total7).toFixed(2);
            appFinData["Stock_Turnover_Days__c"].value = parseFloat(total8).toFixed(2);
            appFinData["Interest_Cover__c"].value = parseFloat(total9).toFixed(2);
            appFinData["Net_Worth_or_Equity__c"].value = parseFloat(total10).toFixed(2);
            appFinData["Net_Gearing__c"].value = parseFloat(total11).toFixed(2);
            appFinData["Total_Liabilities_Total_Assets__c"].value = parseFloat(total12).toFixed(2);
            appFinData["Net_Current_Assets__c"].value = parseFloat(total13).toFixed(2);
            appFinData["Liquid_Surplus_Variation__c"].value = parseFloat(total14).toFixed(2);
            appFinData["Interest_Bearing_Debt_Equity__c"].value = parseFloat(total15).toFixed(2);
            appFinData["IBD_EBITDA__c"].value = parseFloat(total16).toFixed(2);
            appFinData["Long_Term_Debt_EBITDA__c"].value = parseFloat(total17).toFixed(2);
            appFinData["Interest_Cover_Ratio__c"].value = parseFloat(total18).toFixed(2);
            appFinData["Total_Asset_Turnover__c"].value = parseFloat(total19).toFixed(2);
            appFinData["Operating_Profit_Margin__c"].value = parseFloat(total20).toFixed(2);
            component.set("v.currentRecord", appFinData);

            component.set("v.shareholdersFundsCapitalAccountVal", appFinData["Shareholders_Funds_Capital_Account__c"].value);
            component.set("v.salesGrowthVal", appFinData["Sales_Growth__c"].value);
            component.set("v.grossProfitRatioVal", appFinData["Gross_Profit_Ratio__c"].value);
            component.set("v.liquidSurplusVariationVal", appFinData["Liquid_Surplus_Variation__c"].value);
            component.set("v.netProfitProfitbeforeTaxNetSaleVal", appFinData["Net_Profit_Profit_before_Tax_Net_Sale__c"].value);
            component.set("v.currentRatioVal", appFinData["Current_Ratio__c"].value);
            component.set("v.acidTestExclStockVal", appFinData["Acid_Test_Excl_Stock__c"].value);
            component.set("v.creditTurnoverDaysVal", appFinData["Credit_Turnover_Days__c"].value);
            component.set("v.debtorTurnoverDaysVal", appFinData["Debtor_Turnover_Days__c"].value);
            component.set("v.stockTurnoverDaysVal", appFinData["Stock_Turnover_Days__c"].value);
            component.set("v.interestCoverVal", appFinData["Interest_Cover__c"].value);
            component.set("v.netWorthorEquityVal", appFinData["Net_Worth_or_Equity__c"].value);
            component.set("v.netGearingVal", appFinData["Net_Gearing__c"].value);
            component.set("v.totalLiabilitiesTotalAssetsVal", appFinData["Total_Liabilities_Total_Assets__c"].value);
            component.set("v.netCurrentAssetsVal", appFinData["Net_Current_Assets__c"].value);
            component.set("v.interestBearingDebtEquityVal", appFinData["Interest_Bearing_Debt_Equity__c"].value);
            component.set("v.iBDEBITDAVal", appFinData["IBD_EBITDA__c"].value);
            component.set("v.longTermDebtEBITDAVal", appFinData["Long_Term_Debt_EBITDA__c"].value);
            component.set("v.interestCoverRatioVal", appFinData["Interest_Cover_Ratio__c"].value);
            component.set("v.totalAssetTurnoverVal", appFinData["Total_Asset_Turnover__c"].value);
            component.set("v.operatingProfitMarginVal", appFinData["Operating_Profit_Margin__c"].value);
        }
    },

    loadValues: function (component) {
        this.isBalanceSheetBalanced(component);
        this.sumProfitOperAndDebtRatios(component);
    },

    precise: function (num) {
        var numb = Number.parseFloat(num).toPrecision(4)
        return ((numb == null || num == NaN) ? 0.000 : numb);
    },

    getFieldLabelsByApiName: function (recordUi, invalidFields) {
        if (recordUi && recordUi.objectInfo && recordUi.objectInfo.fields) {
            invalidFields = invalidFields.map(function (value) {
                var field = recordUi.objectInfo.fields[value];
                if (field) {
                    return field.label;
                }
                else {
                    return value;
                }
            })
        }
        return invalidFields;
    },

    getBlankFields: function (fields) {
        if (!fields) {
            return [];
        }
        else {
            if (!$A.util.isArray(fields)) {
                fields = [fields];
            }
        }
        return fields.filter(function (i) {
            var value = i.get("v.value");
            return (!value || value < 0);
        }).map(function (i) {
            console.log(i.get("v.fieldName") + ' ' + i.get("v.value"));
            return i.get("v.fieldName");
        });
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            duration: 10000,
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
        var toastEvent = this.getToast("Error: ApplicationFinancialCapture " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    }
})