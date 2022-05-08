({
    doInit: function (component, event) {
        var opts = [];
        opts.push({
            class: "optionClass",
            label: "Current/Cheque",
            value: "Cheque"
        });
        opts.push({
            class: "optionClass",
            label: "Savings",
            value: "Savings"
        });

        opts.push({
            class: "optionClass",
            label: "Credit Card",
            value: "CA"
        });

        opts.push({
            class: "optionClass",
            label: "--None--",
            value: "--None--"
        });
        component.set("v.targetAccTypeoptions", opts);

        //Humbelani Denge - 20201/01/06
        component.set("v.selectedTargetAccType", "--None--");
        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        action.setParams({ clientAccountId: clientAccountId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.startsWith("Error: ")) {
                    // error
                    component.set("v.errorMessage", responseValue);
                } else {
                    // success
                    var accList = [];
                    var respObj = JSON.parse(responseValue);
                    var accBalance;
                    var selectedAccountValue = component.get("v.selectedAccountNumber");
                    component.set("v.responseList",respObj);
                    for (var key in respObj) {
                        if (respObj[key].productType == "CO") {
                            accList.push(respObj[key].oaccntnbr);
                        }
                        if (respObj[key].oaccntnbr == selectedAccountValue) {
                            accBalance = respObj[key].availableBalance;
                            component.set("v.selectedBranchCode", respObj[key].branch);

                        }
                        component.set("v.selectedAccountBalance", accBalance);

                        component.set("v.combiAccList", accList);
                    }
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error PaymentRequestController.getAccountDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    // call MBInitiate to make a payment
    onceOffPayment: function (component, event, helper) {
        helper.showSpinner(component);
        var today = new Date();
        var month = today.getMonth() + 1;
        var dateformate = "" + today.getFullYear() + (month < 10 ? "0" + month : month) + (today.getDate() < 10 ? "0" + today.getDate() : today.getDate());
        var action = component.get("c.intiatePayment");
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment").get("v.checked");
        var normalPayment = component.find("normalPayment").get("v.checked");
        var payTime = "" + today.getHours() + today.getMinutes() + today.getSeconds() + today.getMilliseconds();
        var paymIipInd;
        var uniqueEFT;

        if (ImmediatePaymentCheckbox === true) {
            paymIipInd = "D";
        } else {
            paymIipInd = "";
        }

        action.setParams({
            payTime: "" + payTime,
            actDate: dateformate,
            amount: component.find("amount").get("v.value"),
            srcAcc: component.get("v.selectedAccountNumber"),
            srcAccType: component.get("v.selectedProductValue"),
            srcStmtRef: component.find("paymentRefName").get("v.value"),
            trgAcc: component.find("targetAccNumber").get("v.value"),
            trgClrCode: component.get("v.selectedBranchCode"),
            trgAccType: component.get("v.selectedTargetAccType"),
            trgStmtRef: component.get("v.recipientRefercnce"),
            paymIipInd: paymIipInd,
            instrRefName: component.find("recipientRefName").get("v.value")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("instructionNumber " + component.get("v.instructionNumber"));
            if (state === "SUCCESS" && paymIipInd != "D") {
                var msgString = "";
                if (response.getReturnValue() != null) {
                    msgString = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.respDesc;
                    if (response.getReturnValue().statusCode == "200" && msgString.includes("SUCCESSFUL")) {

                        component.set("v.showPaymentStatusSuccess", true);
                        component.set("v.showPaymentStatusError", false);
                        helper.getToast("Success", msgString, "Success");
                        console.log(JSON.stringify(response.getReturnValue()));
                        var submitButton = component.find("submitButton");
                        submitButton.set("v.disabled", true);
                        console.log("EFT: " + response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.uniqueEft);
                        //added by Danie Booysen 08/02/2021
                        helper.setProofOfPaymentAttributes(component, response.getReturnValue());
                    } else {
                        helper.getToast("Error", "Payment Unsuccessful..  Please try again.." + msgString, "Error");
                        var submitButton = component.find("submitButton");
                        submitButton.set("v.disabled", false);
                        component.set("v.showPaymentStatusError", true);
                        component.set("v.showPaymentStatusErrorMsg", msgString);
                    }
                } else {
                    console.log("Error");
                    helper.getToast("Application Error", "Bad Request", "Error");
                }
            }

            // MBCOmplete payment Call
            else if (state === "SUCCESS" && paymIipInd == "D") {
                var uniqueEFT;
                if (response.getReturnValue() != null) {
                    helper.setProofOfPaymentAttributes(component, response.getReturnValue());//added by Danie Booysen 08/02/2021*
                    uniqueEFT = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.uniqueEft;
                    var actionComp = component.get("c.completePayment");
                    actionComp.setParams({
                        uniqueEft: uniqueEFT
                    });
                    console.log("unique eft: " + uniqueEFT);

                    actionComp.setCallback(this, function (response) {
                        var stateResp = response.getState();
                        if (stateResp === "SUCCESS") {
                            var results = response.getReturnValue();
                            if (results === "SUCCESSFUL PROCESS") {
                                component.set("v.showPaymentStatusSuccess", true);
                                component.set("v.showPaymentStatusError", false);

                                helper.getToast("Success!", results, "Success");
                                console.log("results: " + results);
                                var submitButton = component.find("submitButton");
                                submitButton.set("v.disabled", true);
                            } else {
                                helper.getToast("Error!", "Payment Unsuccessful: " + results, "Error");
                                var submitButton = component.find("submitButton");
                                submitButton.set("v.disabled", false);
                                component.set("v.showPaymentStatusError", true);
                                component.set("v.showPaymentStatusErrorMsg", results);
                            }
                        } else if (stateResp === "ERROR") {
                            helper.getToast("Error!", "Payment Unsuccessful..  Please try again..", "Error");
                            var errors = response.getError();
                            console.log("Errors: " + errors);
                        }
                    });
                    $A.enqueueAction(actionComp);
                } else {

                    helper.getToast("Application Error!", "Bad Request", "Error");
                }
            } else if (state === "ERROR") {
                helper.getToast("Error!", "Service Issue .... Please try again later", "Error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    payBeneficiay: function (component, event, helper) {
        helper.showSpinner(component);
        var today = new Date();
        var month = today.getMonth() + 1;
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        var dateformate = "" + today.getFullYear() + (month < 10 ? "0" + month : month) + (today.getDate() < 10 ? "0" + today.getDate() : today.getDate());
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment").get("v.checked");
        var normalPayment = component.find("normalPayment").get("v.checked");
        var payTime = "" + today.getHours() + today.getMinutes() + today.getSeconds() + today.getMilliseconds();
        var paymIipInd;
        var uniqueEFT;
        var action = component.get("c.payBeneficiary");

        if (ImmediatePaymentCheckbox === true) {
            paymIipInd = "D";
        } else {
            paymIipInd = "";
        }

        action.setParams({
            clientAccountId: clientAccountId,
            paymTime: payTime,
            accessAcc: component.get("v.accessAcc"),
            instrRefName: component.find("recipientRefName").get("v.value"),
            actDate: dateformate,
            amount: component.find("amount").get("v.value"),
            instrNo: component.get("v.instructionNumber"),
            srcAcc: component.get("v.selectedAccountNumber"),
            srcAccType: component.get("v.selectedProductValue"),
            srcStmtRef: component.find("paymentRefName").get("v.value"),
            trgAcc: component.find("targetAccNumber").get("v.value"),
            trgClrCode: component.get("v.selectedBranchCode"),
            trgAccType: component.get("v.selectedTargetAccType"),
            trgStmtRef: component.get("v.recipientRefercnce"),
            paymIipInd: paymIipInd,
            tieb: ''
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("instructionNumber " + component.get("v.instructionNumber"));
            if (state === "SUCCESS" && paymIipInd != "D") {
                var msgString = "";
                if (response.getReturnValue() != null) {
                    msgString = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.respDesc;
                    if (response.getReturnValue().statusCode == "200" && msgString.includes("SUCCESSFUL")) {
                        console.log("succes res" + response.getReturnValue());
                        component.set("v.showPaymentStatusSuccess", true);
                        component.set("v.showPaymentStatusError", false);
                        helper.getToast("Success!", msgString, "Success");
                        console.log(JSON.stringify(response.getReturnValue()));
                        var submitButton = component.find("submitButton");
                        submitButton.set("v.disabled", true);
                        console.log("EFT: " + response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.uniqueEft);
                        //added by Danie Booysen 08/02/2021
                        helper.setProofOfPaymentAttributes(component, response.getReturnValue());
                    } else {
                        helper.getToast("Error!", "Payment Unsuccessful..  Please try again.." + msgString, "Error");
                        var submitButton = component.find("submitButton");
                        submitButton.set("v.disabled", false);
                        component.set("v.showPaymentStatusError", true);
                        component.set("v.showPaymentStatusErrorMsg", msgString);
                    }
                } else {
                    console.log("Error");
                    helper.getToast("Application Error!", "Bad Request", "Error");
                }
            }

            // MBCOmplete payment Call
            else if (state === "SUCCESS" && paymIipInd == "D") {
                var uniqueEFT;
                if (response.getReturnValue() != null) {
                    helper.setProofOfPaymentAttributes(component, response.getReturnValue());//added by Danie Booysen 08/02/2021*
                    var uniqueEFT = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.uniqueEft;
                    var paymNo = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.paymNo;
                    console.log("unique: " + uniqueEFT);
                    var actionComp = component.get("c.completeBeneficiaryPayment");
                    actionComp.setParams({
                        uniqueEft: uniqueEFT,
                        paymNo: paymNo
                    });

                    actionComp.setCallback(this, function (response) {
                        var stateResp = response.getState();
                        if (stateResp === "SUCCESS") {
                            var results = response.getReturnValue();
                            if (results === "SUCCESSFUL PROCESS") {
                                component.set("v.showPaymentStatusSuccess", true);
                                component.set("v.showPaymentStatusError", false);

                                helper.getToast("Success!", results, "Success");
                                console.log("results: " + results);
                                var submitButton = component.find("submitButton");
                                submitButton.set("v.disabled", true);
                            } else {
                                helper.getToast("Error!", "Payment Unsuccessful: " + results, "Error");
                                var submitButton = component.find("submitButton");
                                submitButton.set("v.disabled", false);
                                component.set("v.showPaymentStatusError", true);
                                component.set("v.showPaymentStatusErrorMsg", results);
                            }
                        } else if (stateResp === "ERROR") {
                            helper.getToast("Error!", "Payment Unsuccessful..  Please try again..", "Error");
                            var errors = response.getError();
                            console.log("Errors: " + errors);
                        }
                    });
                    $A.enqueueAction(actionComp);
                } else {

                    helper.getToast("Application Error!", "Bad Request", "Error");
                }
            } else if (state === "ERROR") {
                helper.getToast("Error!", "Service Issue .... Please try again later", "Error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },


    futuredatedpayment: function (component, event, helper) {
        component.set("v.showPaymentStatusError", false);
        var today = new Date();
        var month = today.getMonth() + 1;
        var dateformate = "" + today.getFullYear() + (month < 10 ? "0" + month : month) + (today.getDate() < 10 ? "0" + today.getDate() : today.getDate());
        var selectedAccountNumber = component.get("v.selectedAccountNumber");
        var selectedProductValue = component.get("v.selectedProductValue");
        var amount = component.find("amount").get("v.value");
        var targetAccNumber = component.find("targetAccNumber").get("v.value");
        var selectedBranchCode = component.get("v.selectedBranchCode");
        var recipientReference = component.find("recipientRefercnce").get("v.value");
        var selectedTargetAccType = component.get("v.selectedTargetAccType");
        var myDate = component.get("v.myDate");
        var paymentRefName = component.find("paymentRefName").get("v.value");
        var accessAccount = component.get("v.accessAcc");

        var action = component.get("c.intiatefuturePayment");
        action.setParams({
            srcAccountNumber: selectedAccountNumber,
            srcAccountType: selectedProductValue,
            amount: amount,
            trgAccNumberP: targetAccNumber,
            trgBranchCodeP: selectedBranchCode,
            trgAccReferenceP: recipientReference,
            trgAccTypeP: selectedTargetAccType,
            futureDateP: myDate,
            futureSourceRef: paymentRefName,
            accessAcc: accessAccount
        });

        console.log("accessAccount" + accessAccount);

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("state" + state);
                var serviceResponse = response.getReturnValue();
                console.log("respObj" + response.getReturnValue());

                if (serviceResponse == "SUCCESSFUL PROCESS") {

                    helper.getToast("Success!", JSON.stringify(serviceResponse), "Success");
                    component.set("v.showPaymentStatusSuccess", true);
                    console.log(JSON.stringify(serviceResponse));
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", true);
                } else {
                    helper.getToast("Error!", "Payment Unsuccessful..  Please try again.." + serviceResponse, "Error");
                    console.log(JSON.stringify(serviceResponse));
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", false);
                    component.set("v.showPaymentStatusError", true);
                    component.set("v.showPaymentStatusErrorMsg", serviceResponse);
                }
            } else if (state === "ERROR") {
                helper.getToast("Error!", "Service Issue .... Please try again later", "Error");
            }
        });
        $A.enqueueAction(action);
    },

    //Author: JQUEV & DBOOYSEN 07/11/2020
    //Get the list of beneficiaries from the mblistinstrpersourceaccv1 service
    getAccountBeneficiariesHelper: function (component, event, helper) {
        var action = component.get("c.getBeneficiariesList");
        var cifKeyVal = component.find("cifKeyField").get("v.value");
        var selectedAccountNumberVal = component.get("v.selectedAccountNumber");
        var activeCombiNumber = component.get("v.selectedCombiValue");

        if (!activeCombiNumber) {
            component.find("myBeneficiaryselection").set("v.disabled", true);
            helper.getToast("Error", "Error: No active combi card to retrieve beneficaries from", "error");
            component.set("v.showSpinner", false);
            return;
        }

        action.setParams({
            cifKey: cifKeyVal,
            selectedAccount: activeCombiNumber
        });

        action.setCallback(this, function (response) {
            var respObj = response.getReturnValue();
            var state = response.getState();
            if (state == "SUCCESS") {
                if (
                    respObj &&
                    respObj.MBlistInstructionsPerSourceAccV1Response &&
                    respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o &&
                    respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction &&
                    respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction.length > 0 &&
                    respObj.MBlistInstructionsPerSourceAccV1Response.nbsmsgo3.nbrUserMsgs == "0"
                ) {
                    //Success
                    var beneficiaryNameList = [];
                    for (var key in respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction) {
                        beneficiaryNameList.push(
                            respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction[key].ivrNominate +
                            " " +
                            "-" +
                            " " +
                            respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction[key].instrRefName
                        );
                    }
                    component.set("v.beneficiaryDetailsList", beneficiaryNameList);
                    component.set("v.accBeneficiaryList", respObj.MBlistInstructionsPerSourceAccV1Response.mbs326o.instruction);
                    component.find("myBeneficiaryselection").set("v.disabled", false);
                } else {
                    //Fire Error Toast
                    helper.getToast("Error","Error no beneficiaries found for CIF key: " + cifKeyVal + " on account: " + activeCombiNumber,"error");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                //Fire Error Toast
                helper.getToast("Error", "Error: " + JSON.stringify(errors), "error");
            } else {
                //Fire State Error Toast
                helper.getToast("Error", "Error state: " + state, "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    clearFieldSelected: function (component, event) {
        component.set("v.targetAccNumberDisabled", false);
        component.set("v.targetBankName", null);
        component.set("v.targetAccountNo", null);
        component.set("v.paymentRefName", null);
        component.set("v.recipientRefercnce", null);
        component.set("v.recipientRefName", null);
        component.set("v.selectedBeneficiaryValue", null);
        component.set("v.selectedTargetAccType", "--None--");
        component.set("v.instructionNumber", null);
        component.set("v.ivrNominate", null);
    },

    getUniversalBranch: function (component, event, helper, bankName) {
        var action = component.get("c.getBankBranchCode");
        action.setParams({
            bankName: bankName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var respObj = response.getReturnValue();
            if (state === "SUCCESS") {
                if (response.getReturnValue()) {
                    component.set("v.selectedBranchCode", respObj);
                } else {
                    helper.getToast("Error!", "Universal Branch not found for " + bankName, "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    submitRequest: function (component, event, helper) {
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        var selectedAccountValue = component.get("v.selectedAccountNumber");
        var action = component.get("c.getIntsructionList");
        action.setParams({
            clientAccountId: clientAccountId,
            srcAcc: selectedAccountValue
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var respObj = JSON.parse(response.getReturnValue());
                if (respObj != null) {

                    if (respObj.respDesc == "SUCCESSFUL PROCESS") {
                        var paginationList = [];
                        var amount = [];
                        for (var key in respObj.instruction) {
                            paginationList.push(respObj.instruction[key]);
                        }

                        component.set("v.instructionList", paginationList);
                        console.log("paginationList: " + paginationList);

                        helper.getToast("Success!", "Service Response Success", "Success");
                    } else {
                        helper.getToast("Error!",  "UNSUCCESSFUL " + respObj.respDesc, "error");
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    actionUpdate: function (component, event, helper) {
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        var instrNo = component.get("v.instrNo");
        var selectedAccountValue = component.get("v.selectedAccountNumber");

        var action = component.get("c.updateFuturePayment");
        action.setParams({
            clientAccountId: clientAccountId,
            instrNo: instrNo,
            amount: component.get("v.amount"),
            instrRefName: component.get("v.recipientName"),
            srcAccNumber: selectedAccountValue,
            srcAccType: component.get("v.srcAccType"),
            srcBranchCode: component.get("v.srcClrCode"),
            srcRef: component.get("v.srcStmtRef"),
            trgAccNumber: component.get("v.accountNumber"),
            trgAccType: component.get("v.trgAccType"),
            trgBranchCode: component.get("v.trgClrCode"),
            trgRef: component.get("v.reference"),
            actDate: component.get("v.updateFutureDate")
        });

        console.log("here");
        // Add callback behavior for when response is received
        action.setCallback(this, function (response) {
            var state = response.getState();
            var message = "";

            if (component.isValid() && state === "SUCCESS") {
                var reponse = response.getReturnValue();
                console.log("rsxs" + reponse);
                component.set("v.updatePaymentModal", false);

                helper.getToast("Success!", reponse, "Success");

            } else if (state === "ERROR") {
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

                helper.getToast("Error!", message, "Error");

            } else {
                helper.getToast("Error!", message, "Error");
            }
        });

        // Send action off to be executed
        $A.enqueueAction(action);
    },

    actionRemove: function (component, event, helper) {
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        var actionRemoveBeneficiary = component.get("c.removePayment");
        var instrNr = component.get("v.instrNo");
        actionRemoveBeneficiary.setParams({
            clientAccountId: clientAccountId,
            instrNo: instrNr
        });

        console.log("no: " + instrNr);
        // Add callback behavior for when response is received
        actionRemoveBeneficiary.setCallback(this, function (response) {
            var state = response.getState();
            var message = "";

            if (component.isValid() && state === "SUCCESS") {
                var reponseRemove = response.getReturnValue();
                component.set("v.cancelPaymentModal", false);

                helper.getToast("Success!", reponseRemove, "Success");

            } else if (state === "ERROR") {
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

                helper.getToast("Error!", message,"Error");

            } else {
                helper.getToast("Error!", message, "Error" );

            }
        });

        // Send action off to be executed
        $A.enqueueAction(actionRemoveBeneficiary);
    },

    //Utility helper function to set Attribute values on the component
    //to be used in the Payment Request flow
    //added by Danie Booysen 08/02/2021
    setProofOfPaymentAttributes: function (component, initiatePaymentResp) {
        var uiFieldsForPOP = {
            "YourReference": component.find("paymentRefName").get("v.value"),
            "Amount": component.find("amount").get("v.value"),
            "ImmediatePayment": component.find("ImmediatePayment").get("v.checked"),
            "RecipientRef": component.find("recipientRefercnce").get("v.value"),
            "RecipientName": component.find("recipientRefName").get("v.value")
        };
        component.set("v.uiFieldsForProofOfPaymentToFlow", JSON.stringify(uiFieldsForPOP));
        component.set("v.sendProofOfPaymentToFlow", component.find("ProofOfPayment").get("v.checked"));
        component.set("v.mbInitiateRespToFlow", JSON.stringify(initiatePaymentResp));
    },

    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },

    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    },

    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
});