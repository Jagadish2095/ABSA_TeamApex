({
    
    handleInit: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationExposure");
        var opportunityId = component.get("v.opportunityId");

        action.setParams({
            "opportunityId": opportunityId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                component.set("v.appExposureFacilities", responseData);
                component.set("v.showSpinner", false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("ApplicationEx Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    handleOnRender: function (component) {
        var appClientExpFacilities = component.get("v.appExposureFacilities");
        var previousName = '';
        var innerExposureTableBody = '';
        var innerInstallmentTableBody = '';
        var rowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var rowSpanValue = 1;
        var lastRefresh;

        if (appClientExpFacilities && appClientExpFacilities != null) {
            for (var i = 0; i < appClientExpFacilities.length; i++) {
                if (appClientExpFacilities[i].approvedFacility != 'Approved Facilities Total') {
                    if (lastRefresh == null) {
                        lastRefresh = Date.parse(appClientExpFacilities[i].lastUpdatedDate)
                    } else {
                        if (lastRefresh < Date.parse(appClientExpFacilities[i].lastUpdatedDate)) {
                            lastRefresh = Date.parse(appClientExpFacilities[i].lastUpdatedDate);
                        }
                    }
                }

                if (appClientExpFacilities[i].clientName == previousName) {
                    rowSpanValue++;
                    innerExposureTableBody += '<tr>';
                    innerExposureTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData" >' : ' >') + appClientExpFacilities[i].approvedFacility + ' </td>';
                    innerExposureTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].exposureNonScored).toFixed(2) + ' </td>';
                    innerExposureTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].exposureScored).toFixed(2) + ' </td>';
                    innerExposureTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].exposureTotal).toFixed(2) + ' </td>';
                    innerExposureTableBody += '</tr>';

                    innerInstallmentTableBody += '<tr>';
                    innerInstallmentTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData" >' : ' >') + appClientExpFacilities[i].approvedFacility + ' </td>';
                    innerInstallmentTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].installmentNonScored).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].installmentScored).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '<td' + (appClientExpFacilities[i].approvedFacility == 'Approved Facilities Total' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appClientExpFacilities[i].installmentTotal).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '</tr>';
                }
                else {

                    if (previousName != '') {
                        innerExposureTableBody = String(innerExposureTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                        innerInstallmentTableBody = String(innerInstallmentTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                        rowSpanValue = 1;
                    }

                    previousName = appClientExpFacilities[i].clientName;

                    innerExposureTableBody += '<tr>';
                    innerExposureTableBody += '<td rowspan="rowSpanPlaceHolder" class="clientNameColumn"> ' + appClientExpFacilities[i].clientName + ' </td>';
                    innerExposureTableBody += '<td> ' + appClientExpFacilities[i].approvedFacility + ' </td>';
                    innerExposureTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].exposureNonScored).toFixed(2) + ' </td>';
                    innerExposureTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].exposureScored).toFixed(2) + ' </td>';
                    innerExposureTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].exposureTotal).toFixed(2) + ' </td>';
                    innerExposureTableBody += '</tr>';

                    innerInstallmentTableBody += '<tr>';
                    innerInstallmentTableBody += '<td rowspan="rowSpanPlaceHolder" class="clientNameColumn"> ' + appClientExpFacilities[i].clientName + ' </td>';
                    innerInstallmentTableBody += '<td> ' + appClientExpFacilities[i].approvedFacility + ' </td>';
                    innerInstallmentTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].installmentNonScored).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].installmentScored).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '<td class="currencyValue">' + Number(appClientExpFacilities[i].installmentTotal).toFixed(2) + ' </td>';
                    innerInstallmentTableBody += '</tr>';
                }
            }

            component.set("v.lastRefresh", lastRefresh);

            if (previousName != '') {
                innerExposureTableBody = String(innerExposureTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
                innerInstallmentTableBody = String(innerInstallmentTableBody).replace("rowSpanPlaceHolder", rowSpanValue);
            }

            document.getElementById("exposureTableBody").innerHTML = innerExposureTableBody;
            document.getElementById("installmentTableBody").innerHTML = innerInstallmentTableBody;
        }
    }
})