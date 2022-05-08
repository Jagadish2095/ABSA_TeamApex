({
    getAppRec: function (component, event) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.GetApplication");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var appRec = response.getReturnValue();
            console.log('AppRec' + JSON.stringify(appRec));
            if (state == 'SUCCESS') {
                component.set("v.application", appRec);
                if (appRec.Credit_Application_Accepted__c == true) {
                    console.log('Inside Application');
                    component.set("v.disableAccept", true);
                    component.set("v.isAppAccepted", true);
                    //  component.set("v.isAcceptedDecision",false);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getOppRec: function (component, event) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.GetOpportunity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var oppRec = response.getReturnValue();
            console.log('oppRec' + JSON.stringify(oppRec));
            if (state == 'SUCCESS') {
                component.set("v.opportunity", oppRec);

                if (oppRec.Is_Submitted_Sanctioning__c == true) {
                    console.log('Inside oppo');
                    component.set("v.disableAccept", true);
                    component.set("v.disableAmend", true);
                    component.set("v.disableRefer", true);
                    component.set("v.isAppRefferded", true);
                }
                if (oppRec.More_Info_Decision__c == true) {
                    component.set("v.disableAccept", true);
                    component.set("v.disableAmend", false);
                    component.set("v.disableRefer", false);
                    component.set("v.isMoreInfoRefferded", true);
                }
                if (oppRec.Is_Referred_Pricing__c == true) {
                    component.set("v.disableAccept", true);
                    component.set("v.disableAmend", true);
                    component.set("v.disableRefer", true);
                    component.set("v.isPricingRefferded", true);
                    component.set("v.isMoreInfoRefferded", false);
                } if (oppRec.Is_Submitted_FulFilment__c == true) {
                    component.set("v.disableAccept", true);
                    component.set("v.disableAmend", true);
                    component.set("v.disableRefer", true);
                    component.set("v.isPricingRefferded", false);
                    component.set("v.isMoreInfoRefferded", false);
                }
                //check if Sanction Region is not empty
                if (oppRec.Sanction_Region__c) {
                    component.set("v.enableDisableRegion", true);
                    component.set("v.regionval", oppRec.Sanction_Region__c);
                }
            }
        });
        $A.enqueueAction(action);
    },

    //Added By Himani
    getApplicationRecord: function (component, event) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.GetUpdatedApplication");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == 'SUCCESS') {
                var appRec = response.getReturnValue();
                console.log('ApplicationRecord' + JSON.stringify(appRec));
                component.set("v.applicationUpdated", appRec);

                //Added By Himani Joshi
                console.log('NoOfDaysSinceBureau__c' + component.get('v.applicationUpdated.NoOfDaysSinceBureauDate__c'));
                console.log('appRec.Lookup_Period__c' + appRec.Lookup_Period__c);
                console.log('appRec.Enforce_Rework__c' + appRec.Enforce_Rework__c);
                console.log('appRec.IsAmendmentRequired__c' + appRec.IsAmendmentRequired__c);
                var sysDecision = component.get('v.dataDecisionSum[0].SYST_Decision__c');
                if (appRec.NoOfDaysSinceBureauDate__c >= appRec.Lookup_Period__c && appRec.Enforce_Rework__c === 'Y') {
                    console.log('appRec.IsAmendmentRequired__c' + appRec.IsAmendmentRequired__c);
                    if (!appRec.IsAmendmentRequired__c && $A.util.isEmpty(appRec.acceptedProductsCount__c) && sysDecision === 'Accepted') {
                        component.set("v.errorMessage", "The Credit Bureau Report is no longer valid. Re-process the application ");
                        component.set("v.disableAccept", true);
                        component.set('v.disableRefer', true);
                        component.set('v.isVisible', true);
                    }
                    else if (appRec.acceptedProductsCount__c === 'F') {

                        component.set("v.showError", true);
                        component.set("v.errorMessage", "The Credit Bureau Report is no longer valid. Re-process the application ");
                        component.set("v.disableAccept", true);
                        component.set('v.disableRefer', true);
                        component.set('v.isVisible', false);
                    }
                }


            }
            else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                }
            } else {
                console.log("Unknown error");
            }

        });
        $A.enqueueAction(action);


    },

    updateApplication: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.UpdateApplication");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result == 'Success') {
                    component.set("v.disableAccept", true);
                    component.set("v.isAppAccepted", true);
                    component.set("v.isAcceptedDecision", false);
                    console.log("updateApplication:::: " + JSON.stringify(result));

                    var toastEvent = this.getToast("Success!", 'Credit Application Accepted ', "Success");
                    toastEvent.fire();

                    this.refreshReqProd(component, event, helper);

                } else {
                    this.showError(response, "Error confirming Application");
                }
            }
            else if (state == 'ERROR') {
                this.showError(response, "Error in Updating the Application");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    getReqProd: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.getRequestedProduct");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            if (state === "SUCCESS") {

                console.log('respRequested Product : ' + JSON.stringify(respDecison));
                component.set("v.dataReqProd", respDecison);

                var checkProdStatus = respDecison;
                if (checkProdStatus != null) {
                    var listLength = checkProdStatus.length;
                    // loop through the list of records and stop once you are at the list length
                    for (var i = 0; i < listLength; i++) {
                        //console.log('checkProdStatus[i]: ' + JSON.stringify(checkProdStatus[i]));
                        //check is atleast one product accepted
                        if (checkProdStatus[i].finalDecision == 'Accepted' && checkProdStatus[i].productStatus == 'Accepted') {
                            component.set("v.isOneProdAccepted", true);
                        }
                    }

                    var isOneAcceptedProd = component.get("v.isOneProdAccepted");
                    if (isOneAcceptedProd) {
                        component.set("v.disableAccept", false);
                    } else {
                        component.set("v.disableAccept", true);
                    }
                }

            } else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("CreditDecisionSummary Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In Getting Decision Summary: " + response,
                    "type": "error"
                });
                toastEvent.fire();

            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    getReasonsAndException: function (component, event, helper) {

        var oppId = component.get("v.recordId");
        var action = component.get("c.GetReasonsAndExceptions");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            //console.log('getReasonsAndException'+ JSON.stringify(respDecison));
            if (state === "SUCCESS") {
                component.set("v.ReasonList", respDecison['ReasonList']);
                component.set("v.ReasonDescriptionList", respDecison['ReasonDescriptionList']);
                component.set("v.ExceptionList", respDecison['ExceptionList']);
                component.set("v.ExceptionDescriptionList", respDecison['ExceptionDescriptionList']);
            } else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                }


            }

        });

        $A.enqueueAction(action);
    },

    getPotTotalGrpExp: function (component, event, helper) {
        var oppId = component.get("v.recordId");
        var action = component.get("c.getPotTotalGrpExps");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            //console.log('getPotTotalGrpExp'+ JSON.stringify(respDecison));
            if (state === "SUCCESS") {
                component.set("v.RequestedExpList", respDecison['RequestedExpList']);
                component.set("v.OfferedExpList", respDecison['OfferedExpList']);
                component.set("v.FinalExpnList", respDecison['FinalExpnList']);
            } else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                }


            }

        });

        $A.enqueueAction(action);
    },

    getSubmissionHist: function (component, event, helper) {

        var oppId = component.get("v.recordId");
        var action = component.get("c.GetSubmissionHistory");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respHist = response.getReturnValue();
            if (!$A.util.isEmpty(respHist)) {
                component.set("v.dataHistory", respHist);
            }

        });

        $A.enqueueAction(action);
    },

    getActivityHist: function (component, event, helper) {

        var oppId = component.get("v.recordId");
        var action = component.get("c.GetActivityHistory");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var actHist = response.getReturnValue();
            console.log('Activity History :' + JSON.stringify(actHist));
            if (!$A.util.isEmpty(actHist)) {
                component.set("v.dataActHist", actHist);
            }

        });

        $A.enqueueAction(action);
    },

    getUserInfo: function (component, event, helper) {
        var action = component.get("c.fetchUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.userInfo", storeResponse);
            }
        });
        $A.enqueueAction(action);

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

    getDecisionSum: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.GetDecisionSummary");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respDecison = response.getReturnValue();
            console.log('DecSumm: ' + JSON.stringify(respDecison));
            if (state === "SUCCESS") {
                if (respDecison != null) {
                    if (respDecison[0].SYST_Decision__c == 'A') {
                        respDecison[0].SYST_Decision__c = 'Accepted';
                    } else if (respDecison[0].SYST_Decision__c == 'D') {
                        respDecison[0].SYST_Decision__c = 'Declined';
                    } else if (respDecison[0].SYST_Decision__c == 'R') {
                        respDecison[0].SYST_Decision__c = 'Credit Refer';
                    } else if (respDecison[0].SYST_Decision__c == 'C') {
                        respDecison[0].SYST_Decision__c = 'Compliance Decline';
                    } else if (respDecison[0].SYST_Decision__c == 'O') {
                        respDecison[0].SYST_Decision__c = 'Decline Override';
                    } else if (respDecison[0].SYST_Decision__c == 'M') {
                        respDecison[0].SYST_Decision__c = 'Manual Refer';
                    }
                    component.set("v.dataDecisionSum", respDecison);
                    console.log('after respDecisonSummary: ' + JSON.stringify(component.get("v.dataDecisionSum")));
                }
            } else if (state === "ERROR") {

                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error In Getting Decision Summary: " + response,
                    "type": "error"
                });
                toastEvent.fire();

            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    getDecTime: function (component, event, helper) {

        var oppId = component.get("v.recordId");
        var action = component.get("c.getDecisionTime");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respDecisonTime = response.getReturnValue();
            console.log('respDecisonTime: ' + JSON.stringify(respDecisonTime));
            component.set("v.decisionTime", respDecisonTime);
        });
        $A.enqueueAction(action);
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
        var toastEvent = this.getToast("Error: Decision Summary " + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },

    getRowActions: function (component, row, doneCallback) {

        var actions = [];
        if (row.finalDecision == 'Accepted' && row.productStatus == 'Accepted') {
            actions.push({
                'label': 'Not Taken Up',
                'iconName': 'utility:warning',
                'name': 'Not Taken Up'
            });
        }
        else if (row.finalDecision == 'Pending' && row.productStatus == 'Pending') {
            actions.push({
                'label': 'Withdraw',
                'iconName': 'utility:error',
                'name': 'Withdraw'
            });
        }

        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },

    confirmNTU: function (component, event, helper) {
        // component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var appProd = component.get("v.rowToNTU");
        var ntucomment = component.find("iNTUComment").get("v.value");
        var ntuReason = component.get("v.ntuReason");
        console.log("appProd:::: " + JSON.stringify(appProd));
        console.log("ntuReason:::: " + JSON.stringify(ntuReason));

        var action = component.get("c.updateNTUStatus");

        action.setParams({
            "oppId": oppId,
            "parentAppProdId": appProd.Id,
            "NTUComment": ntucomment,
            "NTUReason": ntuReason
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result == 'Success') {

                    component.set("v.showNotTakenUp", false);
                    console.log("confirmNTU C1 :::: " + JSON.stringify(result));
                    var toastEvent = this.getToast("Success!", 'Success: Not Taken Up Status Updated on C1.', "Success");
                    toastEvent.fire();

                    this.refreshReqProd(component, event, helper);
                    this.productStatusUpdateCall(component, event, helper);

                } else if (result == null) {
                    this.showError(response, " No product Found to Update NTU on C1");

                } else {
                    this.showError(response, "Error Update NTU on C1");

                }

            }
            else if (state == 'ERROR') {
                this.showError(response, "Error Update NTU");
                component.set("v.showNotTakenUp", false);
            }
            // component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    confirmWithdrawal: function (component, event, helper) {
        // component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var appProd = component.get("v.rowToNTU");
        var ntucomment = component.find("iNTUComment").get("v.value");
        var ntuReason = component.get("v.ntuReason");
        console.log("appProd:::: " + JSON.stringify(appProd));
        console.log("ntuReason:::: " + JSON.stringify(ntuReason));

        var action = component.get("c.updateWithdrawalStatus");

        action.setParams({
            "oppId": oppId,
            "parentAppProdId": appProd.Id,
            "NTUComment": ntucomment,
            "NTUReason": ntuReason
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result == 'Success') {

                    component.set("v.showWithdraw", false);
                    console.log("confirmNTU C1 :::: " + JSON.stringify(result));
                    var toastEvent = this.getToast("Success!", 'Success: Withdrawal Status Updated on C1.', "Success");
                    toastEvent.fire();

                    this.refreshReqProd(component, event, helper);
                    this.productStatusUpdateCall(component, event, helper);

                } else if (result == null) {
                    this.showError(response, " No product Found to Update NTU on C1");

                } else {
                    this.showError(response, "Error Update NTU on C1");

                }

            }
            else if (state == 'ERROR') {
                this.showError(response, "Error Update NTU");
                component.set("v.showWithdraw", false);
            }
            // component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    refreshReqProd: function (component, event, helper) {

        this.getReqProd(component, event, helper);
        this.getAppRec(component, event, helper);
        this.getOppRec(component, event, helper);
    },

    productStatusUpdateCall: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.powerCurveStatusUpdateCall");

        action.setParams({
            "oppId": oppId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result == 'Success') {

                    component.set("v.showNotTakenUp", false);
                    console.log("PowerCurveStatusUpdate Service :::: " + JSON.stringify(result));
                    var toastEvent = this.getToast("Success!", 'PowerCurveStatusUpdate Successfully ', "Success");
                    toastEvent.fire();


                } else {
                    console.log("PowerCurveStatusUpdate Service :::: " + JSON.stringify(result));
                    this.showError(response, "Error PowerCurveStatusUpdate Service");
                }
            }
            else if (state == 'ERROR') {
                this.showError(response, "PowerCurveStatusUpdate Service Issue ... Please try again");
                component.set("v.showNotTakenUp", false);
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    startAmendmentProcess: function (component, event, helper) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var action = component.get("c.AmendmentProcess");
        action.setParams({
            "oppId": oppId,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var result = response.getReturnValue();
                if (result == 'Success') {
                    console.log("Amendment Process Response :::: " + JSON.stringify(result));
                    var toastEvent = this.getToast("Success!", 'Amended, Kindly reprocess the application', "Success");
                    toastEvent.fire();
                    component.set("v.disableAccept", true);
                    component.set("v.disableRefer", true);
                    component.set("v.completedTabs", "[]");
                    location.reload();
                } else {
                    console.log("Amendment Process Response :::: " + JSON.stringify(result));
                    this.showError(response, "Amendment Process Failed");
                }
            }
            else if (state == 'ERROR') {
                this.showError(response, "Amendment Process");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    /*checkRegion: function(component, event, helper) {
        var sanctionRegion = component.get("v.oppRecord.Sanction_Region__c");
        console.log ('Sanction Region : ' + sanctionRegion);
        if (sanctionRegion!=null || sanctionRegion!=''){
            component.set("v.enableDisableRegion", true);
        }

    },*/

    startSanctioning: function (component, event) {
        if (!component.get("v.regionval") || component.get("v.regionval") == '') {
            var toastEvent = this.getToast("Error!", 'Please fill the region', "error");
            toastEvent.fire();
        } else {
            this.showSpinner(component);
            var oppId = component.get("v.recordId");
            var action = component.get("c.startSanctioningProcess");
            action.setParams({
                "oppId": oppId,
                "region": component.get("v.regionval")
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state == 'SUCCESS') {
                    this.hideSpinner(component);
                    component.set("v.enableDisableRegion", true);
                    var toastEvent = this.getToast("Success!", 'Submitted For Sanctioning!', "Success");
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else if (state == 'ERROR') {
                    this.showError(response, "Error for submtting for sanctioning!");
                }
            });

            $A.enqueueAction(action);
        }
    },

    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})