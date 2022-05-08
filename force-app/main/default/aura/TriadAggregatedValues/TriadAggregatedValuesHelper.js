({
    handleInit: function (component) {
        var action = component.get("c.getTriadAggregatedValues");
        var applicationId = component.get("v.appId");
        component.set("v.sectionLabel", "Aggregated Values - Loading...");

        action.setParams({
            "applicationId": applicationId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set("v.triadAggregatedValues", responseData);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Triad Aggregated Values: " + errors[0].message);
                    }
                } else {
                    console.log("Triad Aggregated Values: Unknown error");
                }
            }
            component.set("v.sectionLabel", "Aggregated Values");
        });
        $A.enqueueAction(action);
    },

    handleOnRender: function (component) {
        var triadAggregatedValues = component.get("v.triadAggregatedValues");
        var previousName = '';
        var triadAggregatedValuesTableBody = '';
        var rowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var rowSpanValue = 1;
        var lastRefresh;

        if (triadAggregatedValues && triadAggregatedValues != null) {
            for (var i = 0; i < triadAggregatedValues.length; i++) {
                if (lastRefresh == null) {
                    lastRefresh = Date.parse(triadAggregatedValues[i].lastUpdatedDate)
                } else {
                    if (lastRefresh < Date.parse(triadAggregatedValues[i].lastUpdatedDate)) {
                        lastRefresh = Date.parse(triadAggregatedValues[i].lastUpdatedDate);
                    }
                }

                if (triadAggregatedValues[i].clientName == previousName) {
                    //rowSpanValue++;
                    triadAggregatedValuesTableBody += '<tr>';
                                        triadAggregatedValuesTableBody += '<td> ' + triadAggregatedValues[i].clientName + ' </td>';
                    triadAggregatedValuesTableBody += '<td> ' + triadAggregatedValues[i].clientCode + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoMonthlyAvgLast12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoTotalForPeriod).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].totalCreditLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].totalDebitLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoChqMonthlyAvgLast12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].avgCTOLast3To6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].avgCTOLast6To12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].valueChqRDLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].valueSavRDLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '</tr>';
                } else {
                    if (previousName != '') {
                        triadAggregatedValuesTableBody = String(triadAggregatedValuesTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                        rowSpanValue = 1;
                    }

                    previousName = triadAggregatedValues[i].clientName;
                    triadAggregatedValuesTableBody += '<tr>';
                    triadAggregatedValuesTableBody += '<td rowspan="rowSpanPlaceHolder" class="clientNameCodeCols"> ' + triadAggregatedValues[i].clientName + ' </td>';
                    triadAggregatedValuesTableBody += '<td> ' + triadAggregatedValues[i].clientCode + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoMonthlyAvgLast12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoTotalForPeriod).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].totalCreditLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].totalDebitLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].ectoChqMonthlyAvgLast12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].avgCTOLast3To6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].avgCTOLast6To12Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].valueChqRDLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '<td class="currencyValue">' + Number(triadAggregatedValues[i].valueSavRDLast6Mth).toFixed(2) + ' </td>';
                    triadAggregatedValuesTableBody += '</tr>';
                }
            }
            component.set("v.lastRefresh", lastRefresh);

            if (previousName != '') {
                triadAggregatedValuesTableBody = String(triadAggregatedValuesTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                triadAggregatedValuesTableBody = String(triadAggregatedValuesTableBody).replace(/undefined/g, "");
            }

            document.getElementById("triadAggregatedValuesTableBody").innerHTML = triadAggregatedValuesTableBody;
        }
    }
})