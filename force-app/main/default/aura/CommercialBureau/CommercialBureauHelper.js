({
    handleInit: function (component) {
        console.log('aa');
        return new Promise(function (resolve, reject) {
            component.set("v.showSpinner", true);
            var action = component.get("c.getApplicationProfiles");
            var opportunityId = component.get("v.opportunityId");

            action.setParams({
                "opportunityId": opportunityId
            });

            action.setCallback(this, function (response) {
                var state = response.getState();

                if (state == 'SUCCESS') {
                    resolve.call(this, response.getReturnValue());
                }
                else if (state == 'ERROR') {
                    var errors = response.getError();
                    reject.call(this, errors[0].message);
                }
                component.set("v.showSpinner", false);
            });

            $A.enqueueAction(action);
        });

        /*component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationProfiles");
        var opportunityId = component.get("v.opportunityId");
        var bureauData = component.get("v.commBureauData");
        var bureauDataChanged = component.get("v.commBureauDataChanged");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state = "SUCCESS") {
                var responseData = response.getReturnValue();

                if (responseData && responseData != null && bureauData.length == 0) {
                    component.set("v.commBureauData", responseData);
                }

            } else if (state === "ERROR") {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("error", "Error!", errors[0].message);
                    }
                } else {
                    this.showToast("error", "Error!", "Commercial Bureau unknown error");
                }
            }

            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);*/
    },
    
    handleOnRender: function (component) {
        
        var bureauData = component.get("v.commBureauData");
        console.log('bureauData'+JSON.stringify(bureauData));
        var showSpinner = component.get("v.showSpinner");
        var colspanValue = component.get("v.headerColSpan");
        var opportunityId = component.get("v.opportunityId");

        if (bureauData && bureauData != null) {
            var highestNumberOfRows = this.getHighestNumberOfRows(bureauData);

            for (var i = 0; i < bureauData.length; i++) {
                colspanValue++;

                document.getElementById("pcceId" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].APPPCCEID);
                document.getElementById("clientName" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURCOMMINPBUSNAME);
                document.getElementById("idRegNum" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURCOMMINPREGNUMBER);
                document.getElementById("cifCode" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].CIFCODE);
                document.getElementById("enquiryDate" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDATECALLED);
                //document.getElementById("time" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                document.getElementById("callType" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].CALLTYPE);

                document.getElementById("creditBureauReport" + opportunityId).innerHTML += this.checkForUndefined(this.translateReportValues(bureauData[i].BUREAUREPORT));
                document.getElementById("onRecAtBureau" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMONREC);
                document.getElementById("bureauOffline" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMOFFLINE);
                document.getElementById("bureauName" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURCOMMINPBUSNAME);
                document.getElementById("businessStartDate" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMCOMPDETBUSNSTARTDATE);
                document.getElementById("monthsSinceBusStart" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMCOMPDETMTHSINCEBUSSTARTDATE);
                document.getElementById("tradingName" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMCOMPDETTRADINGNAME);
                document.getElementById("companyStatus" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMCOMPDETSTATUS);

                document.getElementById("numJudgements" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDTOTEVER);
                document.getElementById("totValJudgements" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDTOTVAL);
                document.getElementById("highestJudgementAmt" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDHIGHAMNT);
                document.getElementById("dateSinceHighestJudgement" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDHIGHDATE);
                document.getElementById("mnthsSinceHighestJudgement" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDMTHSNCHIGH);
                document.getElementById("lstJudgementAmt" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETJUDAMOUNT);
                document.getElementById("dateSinceLastJudgement" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDLASTDATE);
                document.getElementById("mnthsSinceLastJudgement" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDMTHSNCLAST);
                document.getElementById("numJudgementLst12Mnths" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDTOTL12M);
                document.getElementById("valJudgementLst12Mnths" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRSUMJUDVALL12M);

                document.getElementById("transactionPeriod" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISTRANSACTPERIOD);
                document.getElementById("numDebtors" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISNODEBTORS);
                document.getElementById("numOverdue" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISNOOVERDUE);
                document.getElementById("totOverdueAmt" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISTOTODAMNT);
                document.getElementById("totOverduePercent" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISTOTPERCENTAGE);
                document.getElementById("withinTermsAmt" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMENRKISTOTWITHINTERMS);
                document.getElementById("totOutstandingAmt" + opportunityId).innerHTML += this.checkForUndefined(parseInt(bureauData[i].BURECOMENRKISTOTWITHINTERMS) + parseInt(bureauData[i].BURECOMDETKISTOTODAMNT));
                document.getElementById("amtOutstandingCurrent" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTSTCURR);
                document.getElementById("amtOutstanding30Days" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTST30D);
                document.getElementById("amtOutstanding60Days" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTST60D);
                document.getElementById("amtOutstanding90Days" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTST90D);
                document.getElementById("amtOutstanding120Days" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTST120D);
                document.getElementById("amtOutstanding150Days" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETKISAMNTOUTST150D);

                document.getElementById("latestBankCode" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMSUMLATESTBNKCDE);
                document.getElementById("lastBankCode" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKCODE);
                document.getElementById("BankCodeDesc" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKCODEDESC);
                document.getElementById("dateBankCodeReportDate" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKDATECODE);
                document.getElementById("accOpenedDate" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKACCDATE);
                document.getElementById("numReturnedItems" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMSUMNORDS);
                document.getElementById("amtLastReturnedItem" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKAMNTLASTRD);
                document.getElementById("dateLastReturnedItem" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKDATELASTRD);
                document.getElementById("mnthsSinceLastReturnedItem" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKMNTHSINCELASTRD);
                document.getElementById("bank" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETBANKBANKERS);

                document.getElementById("auditorName" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETAUDNAME);
                document.getElementById("typeOfAudit" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETAUDTYPE);
                document.getElementById("statusOfAudit" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECOMDETAUDSTATUS);

                //document.getElementById("enqLast3Mnths" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("enqLast12Mnths" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);

                var judgementDetailsBody = document.getElementById("judgementDetailsBody" + opportunityId).innerHTML;
                var judgementDetails = bureauData[i].ECOMDETJUD;

                if (judgementDetails && judgementDetails != null && judgementDetails.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < judgementDetails.length; j++) {
                        var judgementTable = document.getElementById("judgementDate" + j + opportunityId);

                        if (judgementTable) {
                            document.getElementById("judgementDate" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURECOMDETJUDDATE);
                            document.getElementById("judgementAmt" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURECOMDETJUDAMOUNT);
                            document.getElementById("judgementPlaintiff" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURECOMDETJUDPLAINTIFF);
                            document.getElementById("judgementCourt" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURECOMDETJUDCOURT);
                            document.getElementById("judgementCaseNum" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURECOMDETJUDCASENUMBER);
                        } else {
                            var judgementDateBody = "<tr id='judgementDate" + j + opportunityId + "'><td>Judgement Date</td>" + this.checkForUndefined(judgementDetails[j].BURECOMDETJUDDATE) + "</tr>";
                            var judgementAmtBody = "<tr id='judgementAmt" + j + opportunityId + "'><td>Judgement Amount</td>" + this.checkForUndefined(judgementDetails[j].BURECOMDETJUDAMOUNT) + "</tr>";
                            var judgementPlaintiffBody = "<tr id='judgementPlaintiff" + j + opportunityId + "'><td>Plaintiff</td>" + this.checkForUndefined(judgementDetails[j].BURECOMDETJUDPLAINTIFF) + "</tr>";
                            var judgementCourtBody = "<tr id='judgementCourt" + j + opportunityId + "'><td>Court</td>" + this.checkForUndefined(judgementDetails[j].BURECOMDETJUDCOURT) + "</tr>";
                            var judgementCaseNumBody = "<tr id='judgementCaseNum" + j + opportunityId + "'><td>Case Number</td>" + this.checkForUndefined(judgementDetails[j].BURECOMDETJUDCASENUMBER) + "</tr>";
                            var emptyRow = "<tr id='emptyRow" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("judgementDetailsBody" + opportunityId).innerHTML += judgementDateBody + judgementAmtBody + judgementPlaintiffBody + judgementCourtBody + judgementCaseNumBody + emptyRow;
                        }
                    }

                    if (highestNumberOfRows > judgementDetails.length) {
                        emptyRows += this.generateEmptyDataBlocks(judgementDetails.length, highestNumberOfRows, i);
                    }

                    document.getElementById("judgementDetailsBody" + opportunityId).innerHTML += emptyRows;
                }
            }

            component.set("v.headerColSpan", colspanValue);
        }
    },
    checkForUndefined: function (valueToCheck) {
        if (String(valueToCheck) == 'undefined') {
            return "<td>" + '' + "</td>";
        } else {
            return "<td>" + valueToCheck + "</td>";
        }
    },
    translateReportValues: function (valueToTranslate) {
        var translatedValue = '';

        if (String(valueToTranslate) == 'undefined') {
            translatedValue = '';
        } else if (valueToTranslate == 'I') {
            translatedValue = 'ID Verified Only';
        } else if (valueToTranslate == 'F') {
            translatedValue = 'Offline';
        } else if (valueToTranslate == 'X') {
            translatedValue = 'No Search';
        } else if (valueToTranslate == 'D') {
            translatedValue = 'Small/Old Defaults';
        } else if (valueToTranslate == 'O') {
            translatedValue = 'Poor CB Report';
        } else if (valueToTranslate == 'Z') {
            translatedValue = 'No Hit';
        } else if (valueToTranslate == 'S') {
            translatedValue = 'Serious CB Report';
        } else if (valueToTranslate == 'N') {
            translatedValue = 'Clear CB Report';
        } else if (valueToTranslate == 'C') {
            translatedValue = 'Client Dispute';
        }

        return translatedValue;
    },
    generateEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration) {
        var dataBlocks = '';

        for (var i = startNum; i < highestNumberOfRows; i++) {
            if (iteration == 0) {
                dataBlocks += "<tr id='judgementDate" + i + opportunityId + "'><td>Judgement Date</td><td>&nbsp;</td></tr>";
                dataBlocks += "<tr id='judgementAmt" + i + opportunityId + "'><td>Judgement Amount</td><td>&nbsp;</td></tr>";
                dataBlocks += "<tr id='judgementPlaintiff" + i + opportunityId + "'><td>Plaintiff</td><td>&nbsp;</td></tr>";
                dataBlocks += "<tr id='judgementCourt" + i + opportunityId + "'><td>Court</td><td>&nbsp;</td></tr>";
                dataBlocks += "<tr id='judgementCaseNum" + i + opportunityId + "'><td>Case Number</td><td>&nbsp;</td></tr>";
                dataBlocks += "<tr id='emptyRow" + i + opportunityId + "'><td>&nbsp;</td></tr>";
            } else {
                document.getElementById("judgementDate" + i + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("judgementAmt" + i + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("judgementPlaintiff" + i + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("judgementCourt" + i + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("judgementCaseNum" + i + opportunityId).innerHTML += "<td>&nbsp;</td>";
            }
        }

        return dataBlocks;
    },
    getHighestNumberOfRows: function (data) {
        var highestNumber = 0;

        for (var i = 0; i < data.length; i++) {
            var currentNumber = 0;
            if (data[i].ECOMDETJUD) {
                for (var j = 0; j < data[i].ECOMDETJUD.length; j++) {
                    currentNumber++;
                }

                if (currentNumber > highestNumber) {
                    highestNumber = currentNumber;
                }
            }
        }

        return highestNumber;
    },

    showToast: function (type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    }
})