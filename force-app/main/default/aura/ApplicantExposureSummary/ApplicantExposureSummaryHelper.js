({
    loadApplicantExposures: function (component, event, helper) {
        var opportunityId = component.get("v.recordId");
        var action = component.get("c.getApplicationExposureSummary");

        component.set("v.accordionLabel", "Applicant Exposure Summary - Loading");
        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (res) {
            var state = res.getState();

            if (state === "SUCCESS") {
                var appExposureSummaries = res.getReturnValue();
                
                if(appExposureSummaries[0]){
                    component.set("v.lastRefresh", (appExposureSummaries[0] != null ? appExposureSummaries[0].lastUpdatedDate : ''));
                }
                
                component.set("v.appExposureSummaries", appExposureSummaries);
                component.set("v.accordionLabel", "Applicant Exposure Summary");
                console.log('appExposureSummaries::2:'+JSON.stringify(appExposureSummaries));
            }
        });
        $A.enqueueAction(action);
    },

    handleOnRender: function (component) {
        var appExposureSummaries = component.get("v.appExposureSummaries");
        console.log('appExposureSummaries::1:'+JSON.stringify(appExposureSummaries));
        var previousName = '';
        var previousCode = '';
        var innerExposureTableBody = '';
        var nameRowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var codeRowSpanPlaceHolder = 'rowSpanPlaceHolder';
        var nameRowSpanValue = 1;
        var codeRowSpanValue = 1;
        var lastRefresh;

        if (appExposureSummaries && appExposureSummaries != null) {

            for (var i = 0; i < appExposureSummaries.length; i++) {
                if (appExposureSummaries[i].product != 'Product') {
                    if (appExposureSummaries[i].clientName == previousName) {
                        nameRowSpanValue++;

                        if (appExposureSummaries[i].clientCode == previousCode) {
                            codeRowSpanValue++;
                            innerExposureTableBody += '<tr>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData" >' : ' >') + appExposureSummaries[i].product + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].liability).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].exposure).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].limit).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].arrears).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].excess).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td' + (appExposureSummaries[i].product == 'Ordinary Credit - Total' || appExposureSummaries[i].product == 'Total Exposure' ? ' class="totalsData currencyValue" >' : ' class="currencyValue">') + Number(appExposureSummaries[i].installment).toFixed(2) + '</td>';
                            innerExposureTableBody += '</tr>';
                        } else {
                            if (previousCode != '') {
                                innerExposureTableBody = String(innerExposureTableBody).replace('codeRowSpanPlaceholder', codeRowSpanValue);
                                codeRowSpanValue = 1;
                            }

                            previousCode = appExposureSummaries[i].clientCode;

                            innerExposureTableBody += '<tr>';
                            innerExposureTableBody += '<td rowspan="codeRowSpanPlaceholder" class="clientNameCodeCols">' + appExposureSummaries[i].clientCode + '</td>';
                            innerExposureTableBody += '<td>' + appExposureSummaries[i].product + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].liability).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].exposure).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].limit).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].arrears).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].excess).toFixed(2) + '</td>';
                            innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].installment).toFixed(2) + '</td>';
                            innerExposureTableBody += '</tr>';
                        }
                    } else {
                        if (previousName != '') {
                            innerExposureTableBody = String(innerExposureTableBody).replace("nameRowSpanPlaceHolder", nameRowSpanValue);
                            nameRowSpanValue = 1;
                        }

                        if (previousCode != '') {
                            innerExposureTableBody = String(innerExposureTableBody).replace('codeRowSpanPlaceholder', codeRowSpanValue);
                            codeRowSpanValue = 1;
                            previousCode = '';
                        }

                        previousName = appExposureSummaries[i].clientName;
                        previousCode = appExposureSummaries[i].clientCode;

                        innerExposureTableBody += '<tr>';
                        innerExposureTableBody += '<td rowspan="nameRowSpanPlaceHolder" class="clientNameCodeCols">' + appExposureSummaries[i].clientName + '</td>';
                        innerExposureTableBody += '<td rowspan="codeRowSpanPlaceholder" class="clientNameCodeCols">' + appExposureSummaries[i].clientCode + '</td>';
                        innerExposureTableBody += '<td>' + appExposureSummaries[i].product + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].liability).toFixed(2) + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].exposure).toFixed(2) + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].limit).toFixed(2) + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].arrears).toFixed(2) + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].excess).toFixed(2) + '</td>';
                        innerExposureTableBody += '<td class="currencyValue">' + Number(appExposureSummaries[i].installment).toFixed(2) + '</td>';
                        innerExposureTableBody += '</tr>';
                    }
                }
            }

            if (previousName != '') {
                innerExposureTableBody = String(innerExposureTableBody).replace("nameRowSpanPlaceHolder", nameRowSpanValue);
            }
            if (previousCode != '') {
                innerExposureTableBody = String(innerExposureTableBody).replace('codeRowSpanPlaceholder', codeRowSpanValue);
            }
            document.getElementById("exposureSummaryTableBody").innerHTML = innerExposureTableBody;
        }

    }
})