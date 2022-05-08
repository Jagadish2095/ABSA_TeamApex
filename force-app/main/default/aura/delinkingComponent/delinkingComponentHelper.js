({
    getChequeAccountNumbers: function(component) {
        component.set('v.showSpinner', true);
        let action = component.get('c.getChequeAccountNumbers');

        action.setParams({
            clientKey: component.get('v.clientKey')
        });

        action.setCallback(this, function(response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                let accountsNumbers = [];

                let outputTable = response.getReturnValue();

                outputTable.forEach(item => {
                    let number = item.oaccntnbr;
                    let maskedNumber = number.replace(/.(?=.{4,}$)/g, '*');
                    accountsNumbers.push({
                        label: item.product + ' (' + maskedNumber + ')',
                        value: item.oaccntnbr
                    });
                });

                component.set('v.chequeAccounts', accountsNumbers);

                component.set('v.isAccountNumbersFetched', true);
                if (component.get('v.isValueBundleOptionsFetched')) {
                    component.set('v.showSpinner', false);
                }

            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    //getValueBundleOptions
    getAccountCharges : function(component) {
        component.set("v.showSpinner", true);

        let action = component.get("c.cqGetValueBandleOptions");

        action.setParams({
            clientKey: component.get('v.clientKey')
        });

        action.setCallback(this, function(response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);

                let optionsResponse = response.getReturnValue();

                let chequeAccountCharges = [];
                let newPriceSchemeOptions = [];

                if (!optionsResponse.length) {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error",
                        "message": "There are no available New Price Scheme options for current Client",
                        "mode": "sticky",
                        "type": "error"
                    });
                    toastEvent.fire();

                    return;
                }

                const spousalConstants = component.get("v.spousalConstants");

                optionsResponse.forEach(function(option) {
                    if (option.PRICING_SCHEME_INDICATOR || option.CBP_SCHEME_DESCRIPTION || option.CBP_PRICING_SCHEME_CODE) {

                        //if scheme is not spousal
                        if (!spousalConstants.some( item => option.CBP_SCHEME_DESCRIPTION.toLowerCase().includes(item))) {

                            let schemeCode = option.CBP_PRICING_SCHEME_CODE;

                            chequeAccountCharges.push({
                                label: option.CBP_SCHEME_DESCRIPTION + ' - ' + schemeCode,
                                value: schemeCode
                            });

                            newPriceSchemeOptions.push({
                                label: schemeCode,
                                value: schemeCode,
                                desc: option.CBP_SCHEME_DESCRIPTION
                            });
                        }
                    }
                });

                component.set('v.chequeAccountCharges', chequeAccountCharges);
                component.set('v.newPriceSchemeOptions', newPriceSchemeOptions);

                component.set('v.isValueBundleOptionsFetched', true);
                if (component.get('v.isAccountNumbersFetched')) {
                    component.set('v.showSpinner', false);
                }

            } else if (state === "ERROR") {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": response.getError()[0].message,
                    "mode": "sticky",
                    "type": "error"
                });
                toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },

    getChargesDetails : function (component) {
        component.set("v.showSpinner", true);
        const action = component.get("c.cqGetChargesDetails");
        console.log('account number -----> ' + component.get("v.accountNumber"));

        action.setParams({
            accountNumber : component.get("v.accountNumber")
        });

        action.setCallback(this, function(response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);

                let responseBean = response.getReturnValue();
                //console.log('response--------> ' + JSON.stringify(responseBean));

                if (responseBean.statusCode == 200) {
                    //let responseObj = responseBean.CQgetChargesDetailsMaintV9Response;
                    // console.log('responseObj----> ' + JSON.stringify(responseObj));
                    // let cqh445o = responseObj.cqh445o;
                    let cqs445o_output_area = responseBean.CQS445O.CQS445O_OUTPUT_AREA;
                    component.set('v.cqs445o_output_area', cqs445o_output_area);

                    // let schemeDescription = cqh445o.cbpSchemeDesc;
                    let schemeDescription = cqs445o_output_area.CQS445O_CBP_SCHEME_DESC;



                    if (schemeDescription) {
                        if (schemeDescription.toUpperCase().includes('Package'.toUpperCase())) {

                            //cashDep for updateChargeDetailsCall
                            // component.set('v.cashDeps', cqh445o.cshdep);
                            component.set('v.cashDeps', cqs445o_output_area.CQS445O_CSHDEP);

                            //let cashCharges = cqh445o.cshcrg;
                            //Cash charges required for updateChargesDetails call
                            // component.set('v.cashCharges', cqh445o.cshcrg);
                            component.set('v.cashCharges', cqs445o_output_area.CQS445O_CSHCRG);

                            //mgtcrgBariers for updateChargesDetailsCall
                            component.set('v.mgtcrgBariers', cqs445o_output_area.CQS445O_MGTCRG_BARRIER);

                            //Charge cap frequency
                            // this.handleCapFrequency(component, cqh445o.dCrgCapFreq);
                            this.handleCapFrequency(component, cqs445o_output_area.CQS445O_D_CRG_CAP_FREQ);
                            //component.set('v.chargeCapFrequencyValue', cqh445o.dCrgCapFreq);

                            //Charge expiry date
                            // component.set('v.chargeExpiryDate', this.parseDate(cqh445o.chargeExpiryDate));
                            component.set('v.chargeExpiryDate', this.parseDate(cqs445o_output_area.CQS445O_CHARGE_EXPIRY_DATE));
                            // this.handleChargeExpiryDate(component, cqh445o.chargeExpiryDate);

                            //Current price scheme code
                            // component.set('v.currentPriceScheme', (cqh445o.cbpSchemeCode + ' - ' + cqh445o.cbpSchemeDesc));
                            component.set('v.currentPriceScheme', (cqs445o_output_area.CQS445O_CBP_SCHEME_CODE + ' - ' + cqs445o_output_area.CQS445O_CBP_SCHEME_DESC));


                            //Pricing scheme date
                            // component.set('v.pricingSchemeDate', cqh445o.cbpSchemeDateRsetA);
                            // component.set('v.pricingSchemeDate', cqs445o_output_area.CQS445O_CBP_SCHEME_DATE_RSET_A);
                            component.set('v.pricingSchemeDate', cqs445o_output_area.CQS445O_CBP_SCHEME_START);

                            //Cap date
                            // component.set('v.capDate', this.parseDate(cqh445o.nextChrgCapDate));
                            component.set('v.capDate', this.parseDate(cqs445o_output_area.CQS445O_NEXT_CHRG_CAP_DATE));

                            //CBP charge statement
                            // component.set('v.cbpChargeStatementValue', cqh445o.cbpCrgstmtReq);
                            component.set('v.cbpChargeStatementValue', cqs445o_output_area.CQS445O_CBP_CRGSTMT_REQ);///??????????

                            component.set('v.showChequeAccountCharge', true);
                            component.set("v.showPricingScheme", true);

                        } else {
                            //show toast message if account number is not part of package
                            if (!schemeDescription.toUpperCase().includes('Package'.toUpperCase())) {
                                let toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "No packages found",
                                    "message": "The selected cheque account is not a part of a package.",
                                    "mode": "sticky",
                                    "type": "error"
                                });
                                toastEvent.fire();

                                return;
                            }
                        }

                    } else {
                        //console.log(responseBean.NBSMSGO3.NBSMSGO3);

                        let responseMessage = '';

                        // if (responseObj.nbsmsgo3.msgEntry) {
                        //     responseMessage = responseObj.nbsmsgo3.msgEntry.msgTxt;
                        // }
                        let messageEntries = responseBean.NBSMSGO3.NBSMSGO3.NBNMSGO3_MSG_ENTRY;

                        if (messageEntries) {
                            messageEntries.forEach(entry => {
                                if (entry.NBNMSGO3_MSG_TXT) {
                                    responseMessage += entry.NBNMSGO3_MSG_TXT + '\n';
                                }
                            });
                            //responseMessage = responseObj.nbsmsgo3.msgEntry.msgTxt;
                        }

                        if (!responseMessage) {
                            responseMessage = 'Unhandled error';
                        }

                        let toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error from server",
                            "message": responseMessage,
                            "type": "error"
                        });
                        toastEvent.fire();
                    }

                } else {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        // message: responseBean.CQgetChargesDetailsMaintV9Response.nbsmsgo3.sysErrTxt
                        message: responseBean.NBSMSGO3.NBSMSGO3.NBNMSGO3_SYS_ERR_TXT
                    });

                    toastEvent.fire();
                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log('Error in doInit.cqGetChargesDetails: ' + errors[0].message);
            }
        });

        $A.enqueueAction(action);
    },

    handleDelink: function(component) {

        if (!this.checkValidity(component)) {
            console.log('not valid');
            return;
        }

        component.set('v.showSpinner', true);
        let newPriceSchemeCode = component.find("newPriceSchemeCombobox").get('v.value');
        let newPriceSchemeDescription = component.get('v.newPriceSchemeOptions').find(el => el.value === newPriceSchemeCode).desc;
        component.set('v.newPackageDesc', newPriceSchemeDescription);
        component.set('v.newPriceSchemeCode', newPriceSchemeCode);

        // console.log('schemeStart: ' + component.find("pricingSchemeDate").get('v.value'));
        // console.log('nextChargeCapDate: ' + component.find("capDate").get('v.value'));

        let schemeStart = component.find("pricingSchemeDate").get('v.value') + '';
        let nextChargeCapDate = component.find("capDate").get('v.value') + '';

        schemeStart = schemeStart.split("/").join("").split("-").join("");
        nextChargeCapDate = nextChargeCapDate.split("/").join("").split("-").join("");

        let requestFieldsValues = {
            CQS446I_ACCOUNT_NBR: component.get('v.accountNumber'),
            CQS446I_MANDATE_NUMBER: component.get('v.mandateNumber'),
            CQS446I_CBP_SCHEME_CODE: newPriceSchemeCode,
            CQS446I_CBP_SCHEME_START: schemeStart,
            //external service returns error if description is longer than 22 chars
            CQS446I_SCHEME_RSET_DESC: newPriceSchemeDescription.slice(0, 22),
            CQS446I_NEXT_CHRG_CAP_DATE: nextChargeCapDate,
            CQS446I_CSHCRG: component.get('v.cashCharges'),//
            CQS446I_CSHDEP_DETAIL: component.get('v.cashDeps'),//
            CQS446I_MGTCRG_BARRIER: component.get('v.mgtcrgBariers'),//
            CQS446I_CHARGE_FREQ: component.get('v.chargeCapFrequencyValue'),
            CQS445O_OUTPUT_AREA: component.get('v.cqs445o_output_area')
        };
        //console.log('requestFieldsValues=====> \n' + JSON.stringify(requestFieldsValues));

        const action = component.get('c.updateChargesDetails');

        action.setParams({
            requestFieldsValues: requestFieldsValues
        });

        action.setCallback(this, function(response) {
            let state = response.getState();

            if (state === "SUCCESS") {
                let responseBean = response.getReturnValue();
                // console.log('response--------> ' + JSON.stringify(responseBean));
                if (responseBean.statusCode == 200) {
                    let updateMessages = [];

                    let responseMessagesObj = responseBean.NBSMSGO3.NBSMSGO3;
                    let reponseMessages = responseMessagesObj.NBNMSGO3_MSG_ENTRY;

                    if (responseMessagesObj.NBNMSGO3_NBR_USER_ERRS == 0) {
                        component.set('v.updateSuccessfull', true);
                    }

                    reponseMessages.forEach(mes => {
                        if (mes.NBNMSGO3_MSG_TXT) {
                            updateMessages.push(mes.NBNMSGO3_MSG_TXT);
                        }
                    });

                    component.set('v.updateMessages', updateMessages);
                    component.set('v.showDelinkResult', true);

                }
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.log(errors[0].message);

                let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title: "Error",
                        type: 'error',
                        mode: 'sticky',
                        message: "An unexpected error occurred processing service CQupdateChargesDetailsV12"
                    });

                    toastEvent.fire();
            }

            component.set('v.showSpinner', false);
        });

        $A.enqueueAction(action);
    },

    handleCapFrequency : function(component, response) {
        let chargeCapFrequencyOptions = [];

        response.includes('D') ? chargeCapFrequencyOptions.push({label: 'Daily', value: 'D'}) : null;
        response.includes('W') ? chargeCapFrequencyOptions.push({label: 'Weekly', value: 'W'}) : null;
        response.includes('M') ? chargeCapFrequencyOptions.push({label: 'Monthly', value: 'M'}) : null;
        response.includes('Y') ? chargeCapFrequencyOptions.push({label: 'Yearly', value: 'Y'}) : null;

        component.set('v.chargeCapFrequencyOptions', chargeCapFrequencyOptions);
    },

    parseDate: function(rawDate) {
        if (rawDate.length === 8) {
            let resultDate = rawDate.slice(0, 4) + '-' + rawDate.slice(4, 6) + '-' + rawDate.slice(6, 8);

            return resultDate;

        } else {
            return rawDate;
        }
    },

    checkValidity: function(component) {
        let isValid = true;

        //cap date
        let capDate = component.find('capDate');
        let cdValidity = capDate.get('v.validity').valid;
        capDate.reportValidity();
        if (!cdValidity) {
            isValid = false;
        }

        //new price scheme
        let newPriceScheme = component.find('newPriceSchemeCombobox');
        let schemeValidity = newPriceScheme.get('v.validity').valid;
        newPriceScheme.reportValidity();
        if (!schemeValidity) {
            isValid = false;
        }

        //pricing scheme date
        let schemeDate = component.find('pricingSchemeDate');
        let sdValidity = schemeDate.get('v.validity').valid;
        schemeDate.reportValidity();
        if (!sdValidity) {
            isValid = false;
        }

        //mandate number
        let mandateNumber = component.find('mandateNumber');
        let mnValidity = mandateNumber.get('v.validity').valid;
        mandateNumber.reportValidity();
        if (!mnValidity) {
            isValid = false;
        }

        return isValid;
    },

    handleNavigate : function(component) {
        //navigate to main page
        let navService = component.find("navService");

        let pageReference  = {
            "type": "standard__namedPage",
            "attributes": {
                "pageName": "home"
            }
        }

        navService.navigate(pageReference);
    }
})