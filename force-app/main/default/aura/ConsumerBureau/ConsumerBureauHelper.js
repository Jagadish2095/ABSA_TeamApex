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
                    console.log('errorComm'+errors);
                    reject.call(this, errors[0].message);
                }
                component.set("v.showSpinner", false);
            });

            $A.enqueueAction(action);
        });

        /*component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationProfiles");
        var opportunityId = component.get("v.opportunityId");
        var bureauData = component.get("v.consBureauData");

        action.setParams({
            "opportunityId": opportunityId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state = "SUCCESS") {
                var responseData = response.getReturnValue();

                if (responseData && responseData != null && bureauData.length == 0) {
                    component.set("v.consBureauData", responseData);
                }

            } else if (state === "ERROR") {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast("error", "Consumer Bureau Error!", errors[0].message);
                    }
                } else {
                    this.showToast("error", "Error!", "Consumer Bureau unknown error");
                }
            }

            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);*/
    },
    handleOnRender: function (component) {
        var bureauData = component.get("v.consBureauData");
        var colspanValue = component.get("v.headerColSpan");
        var opportunityId = component.get("v.opportunityId");

        if (bureauData && bureauData != null) {
            var highestNumberOfRowsPayProfAssetFin = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSASSETFIN');
            var highestNumberOfRowsPayProfMrtgBonds = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSBONDMRTG');
            var highestNumberOfRowsPayProfCrdtCrds = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSCREDITCARD');
            var highestNumberOfRowsPayProfEdu = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSEDUCATION');
            var highestNumberOfRowsPayProfIns = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSINSURANCE');
            var highestNumberOfRowsPayProfLoanOD = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSLOANOVDRT');
            var highestNumberOfRowsPayProfDbtRepay = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSOTHDEBTREPAY');
            var highestNumberOfRowsPayProfRetAcc = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSRETACCOUNTS');
            var highestNumberOfRowsPayProfScrty = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSSECURITY');
            var highestNumberOfRowsPayProfTelecom = this.getHighestNumberOfRows(bureauData, 'TENRDETPPSTELECOMM');
            var highestNumberOfRowsFrdIndi = this.getHighestNumberOfRows(bureauData, 'TDETFPS');
            var highestNumberOfRowsNoticeDetail = this.getHighestNumberOfRows(bureauData, 'TDETNOT');
            var highestNumberOfRowsJudgeDetail = this.getHighestNumberOfRows(bureauData, 'TDETJUD');
            var highestNumberOfRowsEnquiryDetails = this.getHighestNumberOfRows(bureauData, 'TDETENQCPAALL');
            var highestNumberOfRowsTraceDetails = this.getHighestNumberOfRows(bureauData, 'TDETTRA');
            //var highestNumberOfRowsWriteOff = this.getHighestNumberOfRows(bureauData,'');
            //var highestNumberOfRowsColDetail = this.getHighestNumberOfRows(bureauData,'EDETCOL');

            for (var i = 0; i < bureauData.length; i++) {
                colspanValue++;

                document.getElementById("pcceIdConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].APPPCCEID);
                if (bureauData[i].BURTCONDETINFSURNAME && bureauData[i].BURTCONDETINFFNAME1) {
                    document.getElementById("clientNameConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONDETINFSURNAME + ' ' + bureauData[i].BURTCONDETINFFNAME1);
                } else if (bureauData[i].CLIENTNAME) {
                    document.getElementById("clientNameConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].CLIENTNAME);
                }

                document.getElementById("idRegNumConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONDETINFID1);
                document.getElementById("cifCodeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].CIFCODE);
                document.getElementById("enquiryDateConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].APPDATE);
                document.getElementById("timeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].APPTIME);
                document.getElementById("callTypeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].CALLTYPE);

                document.getElementById("creditBureauReport1Consumer" + opportunityId).innerHTML += this.checkForUndefined(this.translateReportValues(bureauData[i].BUREAUREPORT1));
                document.getElementById("creditBureauReport2Consumer" + opportunityId).innerHTML += this.checkForUndefined(this.translateReportValues(bureauData[i].BUREAUREPORT2));
                document.getElementById("worstReportConsumer" + opportunityId).innerHTML += this.checkForUndefined(this.translateReportValues(bureauData[i].WORSTREPORT));
                document.getElementById("everBeenInsolventConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMEVERINSOLVENT);
                document.getElementById("debtCounsellingCodeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMDMGRDEBTREVIEWIND);
                document.getElementById("disputeIndicatorConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONDETDSPDISPUTEIND);
                document.getElementById("deceasedIndicatorConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONDETIDVDECEASEIND);
                document.getElementById("idVerifiedConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONDETIDVIDVERIFIEDIND);

                document.getElementById("payProfSummary" + opportunityId).innerHTML += "<th>CPA</th><th>NLR</th><th>All</th>";
                document.getElementById("currentBalActiveAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAOWNCURBALACTIVE);
                document.getElementById("currentBalActiveAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLROWNCURBALACTIVE);
                document.getElementById("currentBalActiveAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLOWNCURBALACTIVE);
                document.getElementById("currentBalActiveNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAOTHCURBALACTIVE);
                document.getElementById("currentBalActiveNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLROTHCURBALACTIVE);
                document.getElementById("currentBalActiveNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLOTHCURBALACTIVE);
                document.getElementById("currentBalActiveAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPACURRBAL);
                document.getElementById("currentBalActiveAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRCURRBAL);
                document.getElementById("currentBalActiveAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(parseInt(this.checkForNaN(bureauData[i].BURTCONSUMPPSCPACURRBAL)) + parseInt(this.checkForNaN(bureauData[i].BURTCONSUMPPSNLRCURRBAL)));

                document.getElementById("totInstalmentsAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAOWNVALINSTAL);
                document.getElementById("totInstalmentsAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLROWNVALINSTAL);
                document.getElementById("totInstalmentsAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLOWNVALINSTALMENTS);
                document.getElementById("totInstalmentsNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAOTHVALINSTAL);
                document.getElementById("totInstalmentsNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLROTHVALINSTAL);
                document.getElementById("totInstalmentsNonAbsaConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLOTHVALINSTALMENTS);
                document.getElementById("totInstalmentsAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPACURRMNTHINSTAL);
                document.getElementById("totInstalmentsAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRCURRMNTHINSTAL);
                document.getElementById("totInstalmentsAllConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(parseInt(this.checkForNaN(bureauData[i].BURTCONSUMPPSCPACURRMNTHINSTAL)) + parseInt(this.checkForNaN(bureauData[i].BURTCONSUMPPSNLRCURRMNTHINSTAL)));

                document.getElementById("worstArrearsLevelLast3MnthsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td><td>&nbsp;</td>" + this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLWSTARRLEVELL90D);
                document.getElementById("worstArrearsLevelLast6MnthsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td><td>&nbsp;</td>" + this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLWSTARRLEVELL180D);
                document.getElementById("worstArrearsLevelLast12MnthsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td><td>&nbsp;</td>" + this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLWSTARRLEVELL1Y);
                document.getElementById("worstEverArrearsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURECONSUMPPSCPAALLWSTARREVER);
                document.getElementById("worstEverArrearsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURECONSUMPPSNLRALLWSTARREVER);
                document.getElementById("worstEverArrearsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLWSTARREVER);
                document.getElementById("worstEverArrearsOpenPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLWSTARROPEVER);
                document.getElementById("worstEverArrearsOpenPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURECONSUMPPSNLRALLWSTARROPEVER);
                document.getElementById("worstEverArrearsOpenPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLWSTARROPEVER);
                document.getElementById("worstEverArrearsClosedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLWSTARRCLSDEVER);
                document.getElementById("worstEverArrearsClosedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLWSTARRCLSDEVER);
                document.getElementById("worstEverArrearsClosedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BLANKVALUE);
                document.getElementById("worstStatusActiveAccLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL180D);
                document.getElementById("worstStatusActiveAccLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL180D);
                document.getElementById("worstStatusActiveAccLast6MnthsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("worstStatusActiveAccLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLWSTSTATUSACTVACCL1Y);
                document.getElementById("worstStatusActiveAccLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLWSTSTATUSACTVACCL1Y);
                document.getElementById("worstStatusActiveAccLast12MnthsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("numTimes3PlusArrearsConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLNOTIMES3SARRL2Y);
                document.getElementById("numTimes3PlusArrearsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("numTimes3PlusArrearsConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";

                document.getElementById("ageMostRecentFacilityRevokedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEI);
                document.getElementById("ageMostRecentFacilityRevokedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEI);
                document.getElementById("ageMostRecentFacilityRevokedPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMAGEMRECREVOKEDFACILITY);
                document.getElementById("ageMostRecentHandedOverPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEL);
                document.getElementById("ageMostRecentHandedOverPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEL);
                document.getElementById("ageMostRecentHandedOverPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMAGEMRECLEGALACTION);
                document.getElementById("ageMostRecentRepoPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEJ);
                document.getElementById("ageMostRecentRepoPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEJ);
                document.getElementById("ageMostRecentRepoPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMAGEMRECWOFFORREPOS);
                document.getElementById("ageMostRecentWrittenOffPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSCPAALLAGEMRECSTATUSCODEW);
                document.getElementById("ageMostRecentWrittenOffPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMPPSNLRALLAGEMRECSTATUSCODEW);
                document.getElementById("ageMostRecentWrittenOffPayProfConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONSUMAGEMRECWOFFORREPOS);

                document.getElementById("dateMostRecentPaymentProfileOpenedConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURECONSUMPPSCPAALLMNTHSMOSTRECOP);
                document.getElementById("dateMostRecentPaymentProfileOpenedConsumer" + opportunityId).innerHTML += "<td></td>";
                document.getElementById("dateMostRecentPaymentProfileOpenedConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLDAYSSINCEMOSTRECOP);
                document.getElementById("numClosedPaymentProfilesConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("numClosedPaymentProfilesConsumer" + opportunityId).innerHTML += "<td>&nbsp;</td>";
                document.getElementById("numClosedPaymentProfilesConsumer" + opportunityId).innerHTML += this.checkForUndefinedNoColspan(bureauData[i].BURTCONENRSUMPPSALLCLSPPS);

                document.getElementById("totAssetFinRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTVAFINSTL);
                document.getElementById("totMortgageBondsRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTBNDINSTL);
                document.getElementById("totCreditCardRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTCCINSTL);
                document.getElementById("totEduRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTEDUINSTL);
                document.getElementById("totInsurancePremConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTINSINSTL);
                document.getElementById("totOverdraftLoanRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTODLINSTL);
                document.getElementById("totOtherDebtRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTODBTINSTL);
                document.getElementById("totRetailAccRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTRETINSTL);
                document.getElementById("totSecurityRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTSECINSTL);
                document.getElementById("totalTelRepaymentsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLTOTTELINSTL);

                //document.getElementById("dateSinceMostRecentNoticeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURECONSUMNOTMOSTRECDATE); - removed for now as per requirement
                document.getElementById("dateSinceMostRecentNoticeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BLANKVALUE);
                document.getElementById("mostRecentNoticeAmtConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTMRECAMT);
                document.getElementById("numNoticesConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTTOTEVER);
                document.getElementById("numNoticesLast3MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTTOT90D);
                document.getElementById("numNoticesLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTTOT180D);
                document.getElementById("numNoticesLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTTOTL1Y);
                document.getElementById("numNoticesLast24MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTTOTL2Y);
                document.getElementById("worstNoticeTypeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMNOTWRSTTYPE);
                document.getElementById("mostRecentNoticeTypeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMNOTMRECTYPE);
                document.getElementById("mntshSinceLastWorstNoticeTypeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMMNTHSWRSTTYPE);
                document.getElementById("mnthsSinceMostRecentNoticeTypeConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMMNTHSMRECTYPE);
                document.getElementById("numRehabConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMREHABTYPE);
                document.getElementById("numAdminOrderConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMADMORDTYPE);
                document.getElementById("numAdminOrderAbandonmentConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMADMORDABANDTYPE);
                document.getElementById("numIntentToSurrenderConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMINTENTSURRENDTYPE);
                document.getElementById("numFinalSequestrationConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMFINALSEQUESTRTYPE);
                document.getElementById("numProvisionalSequestrationConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMNOTNUMPROVISIONALSEQUESTRTYPE);

                document.getElementById("numJudgementsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTEVER);
                document.getElementById("totValueJudgementsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTAMNT);
                document.getElementById("highestJudgementAmtConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDHIGHESTVAL);
                document.getElementById("dateSinceMostRecentJudgementConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDDATEMREC);
                document.getElementById("mostRecentJudgementAmtConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDVALMREC);
                document.getElementById("mnthsSinceMostRecentJudgementConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDMNTHSMREC);
                document.getElementById("numJudgementsLast3MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL90D);
                document.getElementById("numJudgementsLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL180D);
                document.getElementById("numJudgementsLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL1Y);
                document.getElementById("numJudgementsLast24MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL2Y);
                document.getElementById("numJudgementsLast36MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL3Y);
                document.getElementById("numJudgementsLast48MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL4Y);
                document.getElementById("numJudgementsLast60MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTL5Y);
                //document.getElementById("valJudgementsLast3MntshConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("valJudgementsLast6MntshConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("valJudgementsLast12MntshConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("valJudgementsLast24MntshConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                document.getElementById("totJudgement6To18MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOT6TO18M);
                document.getElementById("totJudgement18To24MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOT18TO24M);
                document.getElementById("totJudgement18To36MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOT18TO36M);
                document.getElementById("totJudgement24To36MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOT24TO36M);
                document.getElementById("totJudgementGrantedLast36MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMJUDTOTGT36M);

                document.getElementById("numEnquiriesEverConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMENQALLTOTEVER);
                document.getElementById("numEnquiriesOverLast3MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMENQALLL90D);
                document.getElementById("numEnquiriesOverLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMENQALLL180D);
                //document.getElementById("numEnquiriesOverLast9MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BUR_TCON_ENR_SUM_ENQ_ALL_L180D);
                document.getElementById("numEnquiriesOverLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMENQALLL1Y);

                document.getElementById("numOfWriteupsAllConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLNUMWOFF);
                document.getElementById("numMostRecentWriteOffsAllConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLNUMMRECWOFF);
                document.getElementById("numMostRecentWriteOffsOtherCPAConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMPPSCPAOTHNUMMRECSTATUSWROFF);
                document.getElementById("numMostRecentWriteOffsOtherNLRConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMPPSNLROTHNUMMRECSTATUSWROFF);
                document.getElementById("totValueOfWriteOffsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLVALWOFF);
                document.getElementById("highestWriteOffAmountConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLVALHIGHWOFF);
                //document.getElementById("dateSinceHighestWriteOffConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("mntshSinceHighestWriteOffConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                document.getElementById("mostRecentWriteOffConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONENRSUMPPSALLVALMRECWOFF);
                //document.getElementById("dateSinceMostRecentWriteOffConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);
                //document.getElementById("mnthsSinceMostRecentWriteOffConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].);

                document.getElementById("numAdverseRecordsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVTOTEVER);
                document.getElementById("totValueAdverseRecordsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVTOTVAL);
                document.getElementById("highestAdverseRecordsAmtConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVHIGHESTVAL);
                document.getElementById("daysSinceHighestAdverseRecordsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVDATEHIGHEST);
                document.getElementById("mnthsSinceHighestAdverseRecordsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVMNTHSHIGHEST);
                document.getElementById("mnthsSinceMostRecentAdverseRecordConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVMNTHSMREC);
                document.getElementById("mostRecentAdverseRecordAmountConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVVALMREC);
                document.getElementById("dateSinceMostRecentAdverseRecordConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVDATEMREC);
                document.getElementById("numAdverseRecordLast3MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVTOTL90D);
                document.getElementById("numAdverseRecordLast6MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVTOTL180D);
                document.getElementById("numAdverseRecordLast12MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVALLL1Y);
                document.getElementById("numAdverseRecordLast24MnthsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMADVALLL2Y);

                document.getElementById("traceAlertTotEverConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMTRATOTEVER);
                document.getElementById("traceAlertLast90DaysConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMTRATOTL90D);
                document.getElementById("traceAlertLast180DaysConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMTRATOTL180D);
                document.getElementById("traceAlertLast1YearConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMTRAALLL1Y);
                document.getElementById("traceAlertLast2YearsConsumer" + opportunityId).innerHTML += this.checkForUndefined(bureauData[i].BURTCONSUMTRAALLL2Y);

                var payProfAssetFin = bureauData[i].TENRDETPPSASSETFIN;
                if (payProfAssetFin && payProfAssetFin != null && payProfAssetFin.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfAssetFin.length; j++) {
                        var payProfData = [payProfAssetFin[j].BURTCONENRDETVAFPPSOTHSUPPLNAME,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHACCTYPCDE,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHINST,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHCURBAL,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHNOPRTJNTLN,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHINDSTRCDE,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHACCNUM,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHOPDATE,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHOPBAL,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHOVDAMT,
                        payProfAssetFin[j].BURTCONENRDETVAFPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'AssetFin', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfAssetFin > payProfAssetFin.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfAssetFin.length, highestNumberOfRowsPayProfAssetFin, i, 'AssetFin', 'payProfDetailsOtherAssetFinConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfAssetFin, i, 'AssetFin', 'payProfDetailsOtherAssetFinConsumer', opportunityId);
                }

                var payProfMrtgBonds = bureauData[i].TENRDETPPSBONDMRTG;
                if (payProfMrtgBonds && payProfMrtgBonds != null && payProfMrtgBonds.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfMrtgBonds.length; j++) {
                        var payProfData = [payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHSUPPLNAME,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHACCTYPCDE,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHINST,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHCURBAL,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHNOPRTJNTLN,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHINDSTRCDE,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHACCNUM,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHOPDATE,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHOPBAL,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHOVDAMT,
                        payProfMrtgBonds[j].BURTCONENRDETBNDPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'MrtgBonds', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfMrtgBonds > payProfMrtgBonds.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfMrtgBonds.length, highestNumberOfRowsPayProfMrtgBonds, i, 'MrtgBonds', 'payProfDetailsOtherMrtgBondsConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfMrtgBonds, i, 'MrtgBonds', 'payProfDetailsOtherMrtgBondsConsumer', opportunityId);
                }

                var payProfCrdtCrds = bureauData[i].TENRDETPPSCREDITCARD;
                if (payProfCrdtCrds && payProfCrdtCrds != null && payProfCrdtCrds.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfCrdtCrds.length; j++) {
                        var payProfData = [payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHSUPPLNAME,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHACCTYPCDE,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHINST,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHCURBAL,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHNOPRTJNTLN,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHINDSTRCDE,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHACCNUM,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHOPDATE,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHOPBAL,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHOVDAMT,
                        payProfCrdtCrds[j].BURTCONENRDETCCPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'CrdtCrds', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfCrdtCrds > payProfCrdtCrds.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfCrdtCrds.length, highestNumberOfRowsPayProfCrdtCrds, i, 'CrdtCrds', 'payProfDetailsOtherCrdtCrdsConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfCrdtCrds, i, 'CrdtCrds', 'payProfDetailsOtherCrdtCrdsConsumer', opportunityId);
                }

                var payProfEdu = bureauData[i].TENRDETPPSEDUCATION;
                if (payProfEdu && payProfEdu != null && payProfEdu.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfEdu.length; j++) {
                        var payProfData = [payProfEdu[j].BURTCONENRDETEDUPPSOTHSUPPLNAME,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHACCTYPCDE,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHINST,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHCURBAL,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHNOPRTJNTLN,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHINDSTRCDE,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHACCNUM,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHOPDATE,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHOPBAL,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHOVDAMT,
                        payProfEdu[j].BURTCONENRDETEDUPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'Edu', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfEdu > payProfEdu.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfEdu.length, highestNumberOfRowsPayProfEdu, i, 'Edu', 'payProfDetailsOtherEduConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfEdu, i, 'Edu', 'payProfDetailsOtherEduConsumer', opportunityId);
                }

                var payProfIns = bureauData[i].TENRDETPPSINSURANCE;
                if (payProfIns && payProfIns != null && payProfIns.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfIns.length; j++) {
                        var payProfData = [payProfIns[j].BURTCONENRDETINSPPSOTHSUPPLNAME,
                        payProfIns[j].BURTCONENRDETINSPPSOTHACCTYPCDE,
                        payProfIns[j].BURTCONENRDETINSPPSOTHINST,
                        payProfIns[j].BURTCONENRDETINSPPSOTHCURBAL,
                        payProfIns[j].BURTCONENRDETINSPPSOTHNOPRTJNTLN,
                        payProfIns[j].BURTCONENRDETINSPPSOTHINDSTRCDE,
                        payProfIns[j].BURTCONENRDETINSPPSOTHACCNUM,
                        payProfIns[j].BURTCONENRDETINSPPSOTHOPDATE,
                        payProfIns[j].BURTCONENRDETINSPPSOTHOPBAL,
                        payProfIns[j].BURTCONENRDETINSPPSOTHOVDAMT,
                        payProfIns[j].BURTCONENRDETINSPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'Ins', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfIns > payProfIns.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfIns.length, highestNumberOfRowsPayProfIns, i, 'Ins', 'payProfDetailsOtherInsConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfIns, i, 'Ins', 'payProfDetailsOtherInsConsumer', opportunityId);
                }

                var payProfLoanOD = bureauData[i].TENRDETPPSLOANOVDRT;
                if (payProfLoanOD && payProfLoanOD != null && payProfLoanOD.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfLoanOD.length; j++) {
                        var payProfData = [payProfLoanOD[j].BURTCONENRDETODLPPSOTHSUPPLNAME,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHACCTYPCDE,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHINST,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHCURBAL,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHNOPRTJNTLN,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHINDSTRCDE,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHACCNUM,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHOPDATE,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHOPBAL,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHOVDAMT,
                        payProfLoanOD[j].BURTCONENRDETODLPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'LoanOD', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfLoanOD > payProfLoanOD.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfLoanOD.length, highestNumberOfRowsPayProfLoanOD, i, 'LoanOD', 'payProfDetailsOtherLoanODConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfLoanOD, i, 'LoanOD', 'payProfDetailsOtherLoanODConsumer', opportunityId);
                }

                var payProfDbtRepay = bureauData[i].TENRDETPPSOTHDEBTREPAY;
                if (payProfDbtRepay && payProfDbtRepay != null && payProfDbtRepay.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfDbtRepay.length; j++) {
                        var payProfData = [payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHSUPPLNAME,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHACCTYPCDE,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHINST,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHCURBAL,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHNOPRTJNTLN,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHINDSTRCDE,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHACCNUM,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHOPDATE,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHOPBAL,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHOVDAMT,
                        payProfDbtRepay[j].BURTCONENRDETODBTPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'DbtRepay', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfDbtRepay > payProfDbtRepay.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfDbtRepay.length, highestNumberOfRowsPayProfDbtRepay, i, 'DbtRepay', 'payProfDetailsOtherDbtRepayConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfDbtRepay, i, 'DbtRepay', 'payProfDetailsOtherDbtRepayConsumer', opportunityId);
                }

                var payProfRetAcc = bureauData[i].TENRDETPPSRETACCOUNTS;
                if (payProfRetAcc && payProfRetAcc != null && payProfRetAcc.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfRetAcc.length; j++) {
                        var payProfData = [payProfRetAcc[j].BURTCONENRDETRETPPSOTHSUPPLNAME,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHACCTYPCDE,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHINST,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHCURBAL,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHNOPRTJNTLN,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHINDSTRCDE,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHACCNUM,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHOPDATE,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHOPBAL,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHOVDAMT,
                        payProfRetAcc[j].BURTCONENRDETRETPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'RetAcc', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfRetAcc > payProfRetAcc.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfRetAcc.length, highestNumberOfRowsPayProfRetAcc, i, 'RetAcc', 'payProfDetailsOtherRetAccConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfRetAcc, i, 'RetAcc', 'payProfDetailsOtherRetAccConsumer', opportunityId);
                }

                var payProfScrty = bureauData[i].TENRDETPPSSECURITY;
                if (payProfScrty && payProfScrty != null && payProfScrty.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfScrty.length; j++) {
                        var payProfData = [payProfScrty[j].BURTCONENRDETSECPPSOTHSUPPLNAME,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHACCTYPCDE,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHINST,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHCURBAL,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHNOPRTJNTLN,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHINDSTRCDE,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHACCNUM,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHOPDATE,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHOPBAL,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHOVDAMT,
                        payProfScrty[j].BURTCONENRDETSECPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'Scrty', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfScrty > payProfScrty.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfScrty.length, highestNumberOfRowsPayProfScrty, i, 'Scrty', 'payProfDetailsOtherScrtyConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfScrty, i, 'Scrty', 'payProfDetailsOtherScrtyConsumer', opportunityId);
                }

                var payProfTelecom = bureauData[i].TENRDETPPSTELECOMM;
                if (payProfTelecom && payProfTelecom != null && payProfTelecom.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < payProfTelecom.length; j++) {
                        var payProfData = [payProfTelecom[j].BURTCONENRDETTELPPSOTHSUPPLNAME,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHACCTYPCDE,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHINST,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHCURBAL,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHNOPRTJNTLN,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHINDSTRCDE,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHACCNUM,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHOPDATE,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHOPBAL,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHOVDAMT,
                        payProfTelecom[j].BURTCONENRDETTELPPSOTHREPPAY];
                        this.generatePayProfTables(j, 'Telecom', payProfData, opportunityId);
                    }

                    if (highestNumberOfRowsPayProfTelecom > payProfTelecom.length) {
                        this.generateEmptyDataBlocksPaymentProfile(payProfTelecom.length, highestNumberOfRowsPayProfTelecom, i, 'Telecom', 'payProfDetailsOtherTelecomConsumer', opportunityId);
                    }
                } else {
                    this.generateEmptyDataBlocksPaymentProfile(0, highestNumberOfRowsPayProfTelecom, i, 'Telecom', 'payProfDetailsOtherTelecomConsumer', opportunityId);
                }

                var fraudIndDetails = bureauData[i].TDETFPS;
                if (fraudIndDetails && fraudIndDetails != null && fraudIndDetails.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < fraudIndDetails.length; j++) {
                        var fraudIndDetailsTable = document.getElementById("fraudCategory" + j + opportunityId);

                        if (fraudIndDetailsTable) {
                            document.getElementById("fraudCategory" + j + opportunityId).innerHTML += this.checkForUndefined(fraudIndDetails[j].BURTCONDETFPSFRDCAT);
                            document.getElementById("fraudCaseDate" + j + opportunityId).innerHTML += this.checkForUndefined(fraudIndDetails[j].BURTCONDETFPSFRDCASEDATE);
                        } else {
                            var table = "<tr id='fraudCategory" + j + opportunityId + "'><td>Fraud Category</td>" + this.checkForUndefined(fraudIndDetails[j].BURTCONDETFPSFRDCAT) + "</tr>";
                            table += "<tr id='fraudCaseDate" + j + opportunityId + "'><td>Fraud Case Date</td>" + this.checkForUndefined(fraudIndDetails[j].BURTCONDETFPSFRDCASEDATE) + "</tr>";
                            table += "<tr id='emptyRowFraud" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("fraudIndicatorDetailsConsumer" + opportunityId).innerHTML += table;
                        }
                    }

                    if (highestNumberOfRowsFrdIndi > fraudIndDetails.length) {
                        this.generateFraudIndiDataEmptyDataBlocks(fraudIndDetails.length, highestNumberOfRowsFrdIndi, i, 'fraudIndicatorDetailsConsumer', opportunityId);
                    }

                    document.getElementById("fraudIndicatorDetailsConsumer" + opportunityId).innerHTML += emptyRows;
                } else {
                    this.generateFraudIndiDataEmptyDataBlocks(0, highestNumberOfRowsFrdIndi, i, 'fraudIndicatorDetailsConsumer', opportunityId);
                }

                var noticeDetails = bureauData[i].TDETNOT;
                if (noticeDetails && noticeDetails != null && noticeDetails.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < noticeDetails.length; j++) {
                        var noticeDetailsTable = document.getElementById("noticeDate" + j + opportunityId);

                        if (noticeDetailsTable) {
                            document.getElementById("noticeDate" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTDATE);
                            document.getElementById("noticeAmount" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTAMT);
                            document.getElementById("noticeTypeCode" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTTYPECODE);
                            document.getElementById("noticeType" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTTYPE);
                            document.getElementById("noticeCaptureDate" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCAPTDATE);
                            document.getElementById("plaintiff" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTAPPLICANT);
                            document.getElementById("courtNameCode" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTNAMECODE);
                            document.getElementById("courtName" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTNAME);
                            document.getElementById("typeOfCourt" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTTYPE);
                            document.getElementById("caseNumber" + j + opportunityId).innerHTML += this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCSENUM);
                        } else {
                            var table = "<tr id='noticeDate" + j + opportunityId + "'><td>Notice date</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTDATE) + "</tr>";
                            table += "<tr id='noticeAmount" + j + opportunityId + "'><td>Notice amount</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTAMT) + "</tr>";
                            table += "<tr id='noticeTypeCode" + j + opportunityId + "'><td>Notice Type Code</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTTYPECODE) + "</tr>";
                            table += "<tr id='noticeType" + j + opportunityId + "'><td>Notice Type</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTTYPE) + "</tr>";
                            table += "<tr id='noticeCaptureDate" + j + opportunityId + "'><td>Notice Capture Date</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCAPTDATE) + "</tr>";
                            table += "<tr id='plaintiff" + j + opportunityId + "'><td>Plaintiff</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTAPPLICANT) + "</tr>";
                            table += "<tr id='courtNameCode" + j + opportunityId + "'><td>Court Name Code</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTNAMECODE) + "</tr>";
                            table += "<tr id='courtName" + j + opportunityId + "'><td>Court Name</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTNAME) + "</tr>";
                            table += "<tr id='typeOfCourt" + j + opportunityId + "'><td>Type of Court</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCRTTYPE) + "</tr>";
                            table += "<tr id='caseNumber" + j + opportunityId + "'><td>Case number</td>" + this.checkForUndefined(noticeDetails[j].BURTCONDETNOTCSENUM) + "</tr>";
                            table += "<tr id='emptyRowNoticeDetail" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("noticesDetailConsumer" + opportunityId).innerHTML += table;
                        }
                    }

                    if (highestNumberOfRowsNoticeDetail > noticeDetails.length) {
                        this.generateNoticeDetailEmptyDataBlocks(noticeDetails.length, highestNumberOfRowsNoticeDetail, i, "noticesDetailConsumer", opportunityId);
                    }

                    document.getElementById("noticesDetailConsumer" + opportunityId).innerHTML += emptyRows;
                } else {
                    this.generateNoticeDetailEmptyDataBlocks(0, highestNumberOfRowsNoticeDetail, i, "noticesDetailConsumer", opportunityId);
                }

                var judgementDetails = bureauData[i].TDETJUD;
                if (judgementDetails && judgementDetails != null && judgementDetails.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < judgementDetails.length; j++) {
                        var judgementDetailsTable = document.getElementById("caseNumberJud" + j + opportunityId);

                        if (judgementDetailsTable) {
                            document.getElementById("caseNumberJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCASENUM);
                            document.getElementById("judgementDateJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGDATE);
                            document.getElementById("judgementTypeCodeJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGTYPECODE);
                            document.getElementById("natureOfDebtCodeJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGNATUREDEBTCODE);
                            document.getElementById("natureOfDebtJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGNATUREDEBT);
                            document.getElementById("judgementAmountJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGAMT);
                            document.getElementById("judgementReasonJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGTYPEDESC);
                            document.getElementById("plaintiffJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGPLAINTIFF);
                            document.getElementById("courtNameCodeJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTNAMECODE);
                            document.getElementById("courtNameJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTNAME);
                            document.getElementById("typeOfCourtJud" + j + opportunityId).innerHTML += this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTTYPE);
                        } else {
                            var table = "<tr id='caseNumberJud" + j + opportunityId + "'><td>Case number</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCASENUM) + "</tr>";
                            table += "<tr id='judgementDateJud" + j + opportunityId + "'><td>Judgement date</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGDATE) + "</tr>";
                            table += "<tr id='judgementTypeCodeJud" + j + opportunityId + "'><td>Judgement Type Code</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGTYPECODE) + "</tr>";
                            table += "<tr id='natureOfDebtCodeJud" + j + opportunityId + "'><td>Nature of Debt Code</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGNATUREDEBTCODE) + "</tr>";
                            table += "<tr id='natureOfDebtJud" + j + opportunityId + "'><td>Nature of Debt </td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGNATUREDEBT) + "</tr>";
                            table += "<tr id='judgementAmountJud" + j + opportunityId + "'><td>Judgement amount</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGAMT) + "</tr>";
                            table += "<tr id='judgementReasonJud" + j + opportunityId + "'><td>Judgement Reason</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGTYPEDESC) + "</tr>";
                            table += "<tr id='plaintiffJud" + j + opportunityId + "'><td>Plaintiff</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGPLAINTIFF) + "</tr>";
                            table += "<tr id='courtNameCodeJud" + j + opportunityId + "'><td>Court Name Code</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTNAMECODE) + "</tr>";
                            table += "<tr id='courtNameJud" + j + opportunityId + "'><td>Court Name</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTNAME) + "</tr>";
                            table += "<tr id='typeOfCourtJud" + j + opportunityId + "'><td>Type of Court</td>" + this.checkForUndefined(judgementDetails[j].BURTCONDETJDGCRTTYPE) + "</tr>";
                            table += "<tr id='emptyRowJudgementDetailConsumer" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("judgementDetailConsumer" + opportunityId).innerHTML += table;
                        }
                    }

                    if (highestNumberOfRowsJudgeDetail > judgementDetails.length) {
                        this.generateJudgementDetailsDataEmptyDataBlocks(judgementDetails.length, highestNumberOfRowsJudgeDetail, i, "judgementDetailConsumer", opportunityId);
                    }

                    document.getElementById("judgementDetailConsumer" + opportunityId).innerHTML += emptyRows;
                } else {
                    this.generateJudgementDetailsDataEmptyDataBlocks(0, highestNumberOfRowsJudgeDetail, i, "judgementDetailConsumer", opportunityId);
                }

                var enquiryDetails = bureauData[i].TDETENQCPAALL;
                if (enquiryDetails && enquiryDetails != null && enquiryDetails.length > 0) {
                    var emptyRows = '';

                    for (var j = 0; j < enquiryDetails.length; j++) {
                        var enquiryDetailsTable = document.getElementById("enquiryDataCPA" + j + opportunityId);

                        if (enquiryDetailsTable) {
                            document.getElementById("enquiryDataCPA" + j + opportunityId).innerHTML += this.checkForUndefined(enquiryDetails[j].BURTCONDETENQCPAALLDATE);
                            document.getElementById("subsNameCPA" + j + opportunityId).innerHTML += this.checkForUndefined(enquiryDetails[j].BURTCONDETENQCPAALLSUBNAME);
                        } else {
                            var table = "<tr id='enquiryDataCPA" + j + opportunityId + "'><td>Enquiry Date CPA : All</td>" + this.checkForUndefined(enquiryDetails[j].BURTCONDETENQCPAALLDATE) + "</tr>";
                            table += "<tr id='subsNameCPA" + j + opportunityId + "'><td>Subscriber Name CPA: All</td>" + this.checkForUndefined(enquiryDetails[j].BURTCONDETENQCPAALLSUBNAME) + "</tr>";
                            table += "<tr id='emptyRowEnqDetails" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("enquiryDetailConsumer" + opportunityId).innerHTML += table;
                        }
                    }

                    if (highestNumberOfRowsEnquiryDetails > enquiryDetails.length) {
                        this.generateEnquiryDataEmptyDataBlocks(enquiryDetails.length, highestNumberOfRowsEnquiryDetails, i, "enquiryDetailConsumer", opportunityId);
                    }
                    document.getElementById("enquiryDetailConsumer" + opportunityId).innerHTML += emptyRows;
                } else {
                    this.generateEnquiryDataEmptyDataBlocks(0, highestNumberOfRowsEnquiryDetails, i, "enquiryDetailConsumer", opportunityId);
                }

                var traceAlertDetails = bureauData[i].TDETTRA;
                if (traceAlertDetails && traceAlertDetails != null && traceAlertDetails.length > 0) {

                    for (var j = 0; j < traceAlertDetails.length; j++) {
                        var traceDetailsTable = document.getElementById("traceTypeCodeConsumer" + j + opportunityId);

                        if (traceDetailsTable) {
                            document.getElementById("traceTypeCodeConsumer" + j + opportunityId).innerHTML += this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRATYPECDE);
                            document.getElementById("traceTypeConsumer" + j + opportunityId).innerHTML += this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRATYPE);
                            document.getElementById("traceSubscriberNameConsumer" + j + opportunityId).innerHTML += this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRASUBNAME);
                        } else {
                            var table = "<tr id='traceTypeCodeConsumer" + j + opportunityId + "'><td>Trace Type Code</td>" + this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRATYPECDE) + "</tr>";
                            table += "<tr id='traceTypeConsumer" + j + opportunityId + "'><td>Trace Type</td>" + this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRATYPE) + "</tr>";
                            table += "<tr id='traceSubscriberNameConsumer" + j + opportunityId + "'><td>Trace Subscriber Name</td>" + this.checkForUndefined(traceAlertDetails[j].BURTCONDETTRASUBNAME) + "</tr>";
                            table += "<tr id='emptyRowTraceDetails" + j + opportunityId + "'><td>&nbsp;</td></tr>";
                            document.getElementById("traceAlertsConsumer" + opportunityId).innerHTML += table;
                        }
                    }

                    if (highestNumberOfRowsTraceDetails > traceAlertDetails.length) {
                        this.generateTraceDataEmptyDataBlocks(traceAlertDetails.length, highestNumberOfRowsTraceDetails, i, "traceAlertsConsumer", opportunityId);
                    }

                    document.getElementById("traceAlertsConsumer" + opportunityId).innerHTML += emptyRows;
                } else {
                    this.generateTraceDataEmptyDataBlocks(0, highestNumberOfRowsTraceDetails, i, "traceAlertsConsumer", opportunityId);
                }
            }

            component.set("v.headerColSpan", colspanValue);
        }
    },
    checkForNaN: function (valueToCheck) {
        if (isNaN(valueToCheck)) {
            return 0;
        } else {
            return valueToCheck;
        }
    },
    checkForUndefined: function (valueToCheck) {
        if (String(valueToCheck) == 'undefined') {
            return "<td colspan='3'></td>";
        } else {
            return "<td colspan='3'>" + valueToCheck + "</td>";
        }
    },
    checkForUndefinedNoColspan: function (valueToCheck) {
        if (String(valueToCheck) == 'undefined') {
            return "<td></td>";
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
        } else {
            translatedValue = valueToTranslate;
        }

        return translatedValue;
    },
    generatePayProfTables: function (iterator, suffix, data, opportunityId) {
        var payProfTable = document.getElementById("subName" + opportunityId + suffix + iterator);

        if (payProfTable) {
            document.getElementById("subName" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[0]);
            document.getElementById("accType" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[1]);
            document.getElementById("instal" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[2]);
            document.getElementById("curBal" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[3]);
            document.getElementById("numParts" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[4]);
            document.getElementById("indCode" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[5]);
            document.getElementById("accNum" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[6]);
            document.getElementById("openDate" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[7]);
            document.getElementById("openBal" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[8]);
            document.getElementById("ovdrwnAmt" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[9]);
            document.getElementById("repay" + opportunityId + suffix + iterator).innerHTML += this.checkForUndefined(data[10]);
        } else {
            var table = "<tr id='subName" + opportunityId + suffix + iterator + "'><td>Subscriber Name</td>" + this.checkForUndefined(data[0]) + "</tr>";
            table += "<tr id='accType" + opportunityId + suffix + iterator + "'><td>Account Type</td>" + this.checkForUndefined(data[1]) + "</tr>";
            table += "<tr id='instal" + opportunityId + suffix + iterator + "'><td>Instalments</td>" + this.checkForUndefined(data[2]) + "</tr>";
            table += "<tr id='curBal" + opportunityId + suffix + iterator + "'><td>Current Balance</td>" + this.checkForUndefined(data[3]) + "</tr>";
            table += "<tr id='numParts" + opportunityId + suffix + iterator + "'><td>Number Participants Joint Loans</td>" + this.checkForUndefined(data[4]) + "</tr>";
            table += "<tr id='indCode" + opportunityId + suffix + iterator + "'><td>Industry Code</td>" + this.checkForUndefined(data[5]) + "</tr>";
            table += "<tr id='accNum" + opportunityId + suffix + iterator + "'><td>Account Number</td>" + this.checkForUndefined(data[6]) + "</tr>";
            table += "<tr id='openDate" + opportunityId + suffix + iterator + "'><td>Opening Date</td>" + this.checkForUndefined(data[7]) + "</tr>";
            table += "<tr id='openBal" + opportunityId + suffix + iterator + "'><td>Opening Balance</td>" + this.checkForUndefined(data[8]) + "</tr>";
            table += "<tr id='ovdrwnAmt" + opportunityId + suffix + iterator + "'><td>Overdrawn Amount</td>" + this.checkForUndefined(data[9]) + "</tr>";
            table += "<tr id='repay" + opportunityId + suffix + iterator + "'><td>Repayment</td>" + this.checkForUndefined(data[10]) + "</tr>";
            table += "<tr id='emptyRow" + opportunityId + suffix + iterator + "'><td>&nbsp;</td></tr>";
            document.getElementById("payProfDetailsOther" + suffix + "Consumer" + opportunityId).innerHTML += table;
        }
    },
    generateEmptyDataBlocksPaymentProfile: function (startNum, highestNumberOfRows, iteration, suffix, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("subName" + opportunityId + suffix + i);

            if (!existingTable) {
                var table = '';
                table += "<tr id='subName" + opportunityId + suffix + i + "'><td>Subscriber Name</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='accType" + opportunityId + suffix + i + "'><td>Account Type</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='instal" + opportunityId + suffix + i + "'><td>Instalments</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='curBal" + opportunityId + suffix + i + "'><td>Current Balance</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='numParts" + opportunityId + suffix + i + "'><td>Number Participants Joint Loans</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='indCode" + opportunityId + suffix + i + "'><td>Industry Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='accNum" + opportunityId + suffix + i + "'><td>Account Number</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='openDate" + opportunityId + suffix + i + "'><td>Opening Date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='openBal" + opportunityId + suffix + i + "'><td>Opening Balance</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='ovdrwnAmt" + opportunityId + suffix + i + "'><td>Overdrawn Amount</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='repay" + opportunityId + suffix + i + "'><td>Repayment</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRow" + opportunityId + suffix + i + "'></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("subName" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("accType" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("instal" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("curBal" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("numParts" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("indCode" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("accNum" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("openDate" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("openBal" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("ovdrwnAmt" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("repay" + opportunityId + suffix + i).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateFraudIndiDataEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("fraudCategory" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='fraudCategory" + i + opportunityId + "'><td>Fraud Category</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='fraudCaseDate" + i + opportunityId + "'><td>Fraud Case Date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowFraud" + i + opportunityId + "'><td>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("fraudCategory" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("fraudCaseDate" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateNoticeDetailEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("noticeDate" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='noticeDate" + i + opportunityId + "'><td>Notice date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='noticeAmount" + i + opportunityId + "'><td>Notice amount</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='noticeTypeCode" + i + opportunityId + "'><td>Notice Type Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='noticeType" + i + opportunityId + "'><td>Notice Type</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='noticeCaptureDate" + i + opportunityId + "'><td>Notice Capture Date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='plaintiff" + i + opportunityId + "'><td>Plaintiff</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='courtNameCode" + i + opportunityId + "'><td>Court Name Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='courtName" + i + opportunityId + "'><td>Court Name</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='typeOfCourt" + i + opportunityId + "'><td>Type of Court</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='caseNumber" + i + opportunityId + "'><td>Case number</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowNoticeDetail" + i + opportunityId + "'><td>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("noticeDate" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("noticeAmount" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("noticeTypeCode" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("noticeType" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("noticeCaptureDate" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("plaintiff" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("courtNameCode" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("courtName" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("typeOfCourt" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("caseNumber" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateJudgementDetailsDataEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("caseNumberJud" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='caseNumberJud" + i + opportunityId + "'><td>Case number</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='judgementDateJud" + i + opportunityId + "'><td>Judgement date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='judgementTypeCodeJud" + i + opportunityId + "'><td>Judgement Type Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='natureOfDebtCodeJud" + i + opportunityId + "'><td>Nature of Debt Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='natureOfDebtJud" + i + opportunityId + "'><td>Nature of Debt</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='judgementAmountJud" + i + opportunityId + "'><td>Judgement amount</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='judgementReasonJud" + i + opportunityId + "'><td>Judgement Reason</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='plaintiffJud" + i + opportunityId + "'><td>Plaintiff</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='courtNameCodeJud" + i + opportunityId + "'><td>Court Name Code</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='courtNameJud" + i + opportunityId + "'><td>Court Name</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='typeOfCourtJud" + i + opportunityId + "'><td>Type of Court</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowJudgementDetailConsumer" + i + opportunityId + "'><td colspan='3'>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("caseNumberJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("judgementDateJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("judgementTypeCodeJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("natureOfDebtCodeJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("natureOfDebtJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("judgementAmountJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("judgementReasonJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("plaintiffJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("courtNameCodeJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("courtNameJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("typeOfCourtJud" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateWriteOffDataEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("subscriber" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='subscriber" + i + opportunityId + "'><td>Subscriber</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='accountType" + i + opportunityId + "'><td>Account  Type</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='accountNumber" + i + opportunityId + "'><td>Account  Number</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='openDate" + i + opportunityId + "'><td>Open Date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='writeOffDate" + i + opportunityId + "'><td>Write-off date</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='writeOffAmount" + i + opportunityId + "'><td>Write-off amount</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowWriteOff" + i + opportunityId + "'><td>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("subscriber" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("accountType" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("accountNumber" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("openDate" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("writeOffDate" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("writeOffAmount" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateEnquiryDataEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("enquiryDataCPA" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='enquiryDataCPA" + i + opportunityId + "'><td>Enquiry Date CPA : All</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='subsNameCPA" + i + opportunityId + "'><td>Subscriber Name CPA: All</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowEnqDetails" + i + opportunityId + "'><td>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("enquiryDataCPA" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("subsNameCPA" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    generateTraceDataEmptyDataBlocks: function (startNum, highestNumberOfRows, iteration, tableName, opportunityId) {
        for (var i = startNum; i < highestNumberOfRows; i++) {
            var existingTable = document.getElementById("traceTypeCodeConsumer" + i + opportunityId);

            if (!existingTable) {
                var table = '';
                table += "<tr id='traceTypeCodeConsumer" + i + opportunityId + "'><td>Enquiry Date CPA : All</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='traceTypeConsumer" + i + opportunityId + "'><td>Subscriber Name CPA: All</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='traceSubscriberNameConsumer" + i + opportunityId + "'><td>Subscriber Name CPA: All</td><td colspan='3'>&nbsp;</td></tr>";
                table += "<tr id='emptyRowTraceDetails" + i + opportunityId + "'><td>&nbsp;</td></tr>";
                document.getElementById(tableName + opportunityId).innerHTML += table;
            } else {
                document.getElementById("traceTypeCodeConsumer" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("traceTypeConsumer" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
                document.getElementById("traceSubscriberNameConsumer" + i + opportunityId).innerHTML += "<td colspan='3'>&nbsp;</td>";
            }
        }
    },
    getHighestNumberOfRows: function (data, key) {
        var highestNumber = 0;

        for (var i = 0; i < data.length; i++) {
            var currentNumber = 0;
            if (data[i][key]) {
                for (var j = 0; j < data[i][key].length; j++) {
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