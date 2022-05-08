({
    doInit: function (component, event, helper) {
        helper.doInit(component, event);
        component.set("v.selectedAccountNumber", component.get("v.selectedAccountNumberToFlow"));        
    },
    
    getAccountNumbers: function (component, event, helper) {
        var selectedProdType = component.get("v.selectedProductValue");
        var respObj = component.get("v.responseList");
        var acc = [];
        for (var key in respObj) {
            if (respObj[key].productType == selectedProdType) {
                acc.push(respObj[key].oaccntnbr);
            }
        }
        
        component.set("v.accNumList", acc);
    },
    
    getSelectedAccount : function (component, event, helper) {
        var selectedAccountValue = component.get("v.selectedAccountNumber");
        console.log("selectedAccountValue: " + selectedAccountValue);
        var accBenList = component.find("accBeneficiaryList");
        console.log("+++++selectedAccountValue++++" + selectedAccountValue);
        component.set("v.selectedAccountNumberToFlow", selectedAccountValue);
        
        var respObj = component.get("v.responseList");
        var accBalance;
        for (var key in respObj) {
            if (respObj[key].oaccntnbr == selectedAccountValue) {
                accBalance = respObj[key].availableBalance;
                component.set("v.selectedBranchCode", respObj[key].branch);
            }
        }
        
        console.log("+++++selectedAccountAvailableBalance ++++" + accBalance);
        component.set("v.selectedAccountBalance", accBalance);
        
        //Check the Daily Bank account Limit
        var action = component.get("c.getDailyLimits");
        action.setParams({ selectedCombiNumber: selectedAccountValue });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var getDailyLimitResponse = JSON.parse(response.getReturnValue());
                console.log("message---" + JSON.stringify(getDailyLimitResponse));
                
                if (getDailyLimitResponse != null) {
                    component.set("v.selectedAccountDailyLimit", getDailyLimitResponse.cardTrfLim);
                }
            } else if (state === "ERROR") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message: "Issue with getting Daily limit .",
                    type: "error"
                });
                toastEvent.fire();
            } else {
            }
        });
        $A.enqueueAction(action);
    },
    
    /*call dateUpdate function on onchange event on date field*/
    dateUpdate: function (component, event, helper) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date
        if (dd < 10) {
            dd = "0" + dd;
        }
        // if month is less then 10, then append 0 before date
        if (mm < 10) {
            mm = "0" + mm;
        }
        
        var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
        if (component.get("v.myDate") != "" && component.get("v.myDate") < todayFormattedDate) {
            component.set("v.dateValidationError", true);
            console.log("Inside true mydate" + component.get("v.myDate"));
        } else {
            component.set("v.dateValidationError", false);
            console.log("Inside false mydate" + component.get("v.myDate"));
        }
    },
    
    submit: function (component, event, helper) {
        // get the 'dateValidationError' attribute value
        var isDateError = component.get("v.dateValidationError");
        
        if (isDateError != true) {
            alert("date is valid.. write your more logic here...");
        }
    },
    
    onTargetAccTypeChange: function (component, event, helper) {
        console.log("target chage acc type :" + component.get("v.selectedTargetAccType"));
    },
    
    clearAllBankAttribute: function (component, event, helper) {
        var recordToBeclear = event.getParam("clearBranchName");
        component.set("v.selectedBankName", null);
        var bankname = component.get("v.selectedBankName");
        component.set("v.selectedBranchName", null);
        var branchname = component.get("v.selectedBranchName");
        component.set("v.selectedBranchCode", null);
        var branchcode = component.get("v.selectedBranchCode");
        console.log("Inside DO clearAllBankAttribute func" + recordToBeclear + bankname + branchname + branchcode);
    },
    
    submitPayment: function (component, event, helper) {
        var SourceBankName = component.get("v.selectedAccountNumber");
        var targetBankName = component.get("v.selectedBankName");
        var targetAccNumber = component.find("targetAccNumber").get("v.value");
        var targetAccType = component.find("targetAccType").get("v.value");
        var paymentRefName = component.find("paymentRefName").get("v.value");
        var recipientRefercnce = component.find("recipientRefercnce").get("v.value");
        var recipientRefName = component.find("recipientRefName").get("v.value");
        var amount = component.find("amount").get("v.value");
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment").get("v.checked");
        var futuredateCheckbox = component.find("futureDate").get("v.checked");
        var normalPaymentCheckbox = component.find("normalPayment").get("v.checked");
        var futureDate = component.get("v.myDate");
        var PaymentVerification = component.find("PaymentVerification").get("v.checked");
        
        if(ImmediatePaymentCheckbox == true && component.get("v.selectedBranchCode") == "632005"){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Payment between absa accounts are already immediate,Please select an appropriate payment option.",
                type: "error"
            });
            toastEvent.fire();
            return;
        }
        
        else if (SourceBankName == "" || SourceBankName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Source Bank Name Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (targetAccNumber == "" || targetAccNumber == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Recipient Account Number Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (targetAccType == "" || targetAccType == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Recipient Account Type Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (paymentRefName == "" || paymentRefName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Reference Name Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (recipientRefercnce == "" || recipientRefercnce == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "recipient Refercnce Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (recipientRefName == "" || recipientRefName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Recipient Reference Name Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (amount == "" || amount == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Amount Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        } else if (ImmediatePaymentCheckbox === false && futuredateCheckbox == false && normalPaymentCheckbox === false) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please select a payment type .",
                type: "error"
            });
            toastEvent.fire();
        } else if (PaymentVerification === false) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Please confirm your payment.",
                type: "error"
            });
            toastEvent.fire();
        } else if (futuredateCheckbox === true) {
            if (futureDate == null) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Error!",
                    message: "Future date cannot be blank.",
                    type: "error"
                });
                toastEvent.fire();
            } else {
                helper.futuredatedpayment(component, event, helper);
            }
        } else {
            // call for immediate payment and normal
            var onceOffpaymentCheck = component.find("onceOffpaymentCheck").get("v.checked");
            var payBeneficiaryCheck = component.find("payBeneficiaryCheck").get("v.checked");
            var absaListedBeneficiaryCheck = component.find("absaListedBeneficiaryCheck").get("v.checked");
            
            if (absaListedBeneficiaryCheck === true || onceOffpaymentCheck === true) {
                helper.onceOffPayment(component, event, helper);
            } else if (payBeneficiaryCheck === true) {
                helper.payBeneficiay(component, event, helper);
            }
        }
    },
    
    handleComponentEvent: function (component, event, helper) {
        var selectedAccountNumberGetFromEvent = event.getParam("accountNoEvent");
        var selectedBranchCodeGetFromEvent = event.getParam("branchCodeEvent");
        component.set("v.targetAccountNo", selectedAccountNumberGetFromEvent);
        component.set("v.selectedBranchCode", selectedBranchCodeGetFromEvent);
        component.find("targetAccType").set('v.value', 'Cheque');

    },
    
    handleBrachCodeComponentEvent: function (component, event, helper) {
        //Event handler to get branch code from child comp
        console.log("here now code3: " + pselectedBranchCodeGetFromEvent);
        var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.selectedBranchCode", pselectedBranchCodeGetFromEvent);
    },
    
    onListedBeneficiary: function (component, event, helper) {
        var absaListedBeneficiaryCheck = component.find("absaListedBeneficiaryCheck").get("v.checked");
        var onceOffpaymentCheck = component.find("onceOffpaymentCheck");
        var payBeneficiaryCheck = component.find("payBeneficiaryCheck");
        var updatecancelCheck = component.find("updatecancelCheck");
        
        if (absaListedBeneficiaryCheck === true) {
            component.set("v.showPaymentType", true);
            component.set("v.showAccountSelection", true);
            component.set("v.showAbsaListedBeneficiary", true);
            component.set("v.showReference", true);
            component.set("v.showButton", true);
            component.find("targetAccType").set("v.value", "cheque");
            onceOffpaymentCheck.set("v.disabled", true);
            payBeneficiaryCheck.set("v.disabled", true);
            updatecancelCheck.set("v.disabled", true);
            component.find("targetAccNumber").set("v.disabled", true);
            component.find("branchCodeCheck").set("v.disabled", true);
            helper.clearFieldSelected(component, event);
        } else {
            component.set("v.showListedBeneficiary", false);
            component.set("v.showPaymentType", false);
            component.set("v.showAccountSelection", false);
            component.set("v.showAbsaListedBeneficiary", false);
            component.set("v.showReference", false);
            component.set("v.showButton", false);
            onceOffpaymentCheck.set("v.disabled", false);
            payBeneficiaryCheck.set("v.disabled", false);
            updatecancelCheck.set("v.disabled", false);
            component.find("targetAccNumber").set("v.disabled", false);
            component.find("branchCodeCheck").set("v.disabled", false);
        }
    },
    
    onSelectOptionOnceOff: function (component, event, helper) {
        var onceOffpaymentCheck = component.find("onceOffpaymentCheck").get("v.checked");
        var absaListedBeneficiaryCheck = component.find("absaListedBeneficiaryCheck");
        var payBeneficiaryCheck = component.find("payBeneficiaryCheck");
        var updatecancelCheck = component.find("updatecancelCheck");
        
        // set all components for once off payment
        if (onceOffpaymentCheck === true) {
            component.set("v.showPaymentType", true);
            component.set("v.showOnceOffPayment", true);
            component.set("v.showAccountSelection", true);
            component.set("v.showReference", true);
            component.set("v.showButton", true);
            absaListedBeneficiaryCheck.set("v.disabled", true);
            payBeneficiaryCheck.set("v.disabled", true);
            updatecancelCheck.set("v.disabled", true);
            helper.clearFieldSelected(component, event);
        } else {
            component.set("v.showPaymentType", false);
            component.set("v.showOnceOffPayment", false);
            component.set("v.showAccountSelection", false);
            component.set("v.showReference", false);
            component.set("v.showButton", false);
            absaListedBeneficiaryCheck.set("v.disabled", false);
            payBeneficiaryCheck.set("v.disabled", false);
            updatecancelCheck.set("v.disabled", false);
        }
    },
    
    onImmediatePayment: function (component, event, helper) {
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment").get("v.checked");
        console.log("isPaymentTypeSelected imme" + ImmediatePaymentCheckbox);
        var futuredateCheckbox = component.find("futureDate");
        var normalPaymentCheckbox = component.find("normalPayment");
        
        if (ImmediatePaymentCheckbox === true && component.get("v.isPaymentTypeSelected") === false) {
            component.set("v.isPaymentTypeSelected", true);
            futuredateCheckbox.set("v.disabled", true);
            normalPaymentCheckbox.set("v.disabled", true);
        } else {
            component.set("v.isPaymentTypeSelected", false);
            futuredateCheckbox.set("v.disabled", false);
            normalPaymentCheckbox.set("v.disabled", false);
            normalPaymentCheckbox.set("v.disabled", false);
        }
    },
    
    onSelectFutureDate: function (component, event, helper) {
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment");
        var futuredateCheckbox = component.find("futureDate").get("v.checked");
        var normalPaymentCheckbox = component.find("normalPayment");
        if (component.get("v.isPaymentTypeSelected") === false) {
            component.set("v.showFutureDatePicker", true);
            component.set("v.isPaymentTypeSelected", true);
            ImmediatePaymentCheckbox.set("v.disabled", true);
            normalPaymentCheckbox.set("v.disabled", true);
        } else {
            component.set("v.showFutureDatePicker", false);
            component.set("v.isPaymentTypeSelected", false);
            ImmediatePaymentCheckbox.set("v.disabled", false);
            normalPaymentCheckbox.set("v.disabled", false);
        }
    },
    
    onSelectNormalPayment: function (component, event, helper) {
        var ImmediatePaymentCheckbox = component.find("ImmediatePayment");
        var futuredateCheckbox = component.find("futureDate");
        var normalPaymentCheckbox = component.find("normalPayment").get("v.checked");
        if (normalPaymentCheckbox === true && component.get("v.isPaymentTypeSelected") === false) {
            component.set("v.isPaymentTypeSelected", true);
            ImmediatePaymentCheckbox.set("v.disabled", true);
            futuredateCheckbox.set("v.disabled", true);
        } else {
            component.set("v.isPaymentTypeSelected", false);
            ImmediatePaymentCheckbox.set("v.disabled", false);
            futuredateCheckbox.set("v.disabled", false);
        }
    },
    
    checkAccountNumber: function (component, event, helper) {
        //Check Source Bank Account is blank
        var SourceBankName = component.get("v.selectedAccountNumber");
        //Check targetBankName name is blank
        var targetBankName = component.get("v.selectedBankName");
        if (targetBankName == "" || targetBankName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Target Bank Name Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        }
        if (SourceBankName == "" || SourceBankName == null) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Error!",
                message: "Source Bank Name Cannot Be Blank.",
                type: "error"
            });
            toastEvent.fire();
        }
        
        if (component.get("v.selectedBankName") == "ABSA BANK LIMITED") {
            //Absa bank account validations for target Bank Account
            var action = component.get("c.validateAbsaBankAccount");
            var accountType = component.get("v.selectedProductValue");
            var accountNumber = component.get("v.selectedAccountNumber");
            var branchCode = component.get("v.selectedBranchCode");
            var amount = component.find("amount").get("v.value");
            
            action.setParams({
                accountNumber: accountNumber,
                accountType: accountType,
                branchCode: branchCode,
                amount: amount
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue()) {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Success",
                            message: component.get("v.selectedBankName") + " bank account details validated successfully.",
                            type: "Success"
                        });
                        toastEvent.fire();
                        
                        component.set("v.showPaymentSubmit", true);
                        component.set("v.showValidateButton", false);
                    } else {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: "Error",
                            message: "Invalid bank account details. Please correct before continuing.",
                            type: "Error"
                        });
                        toastEvent.fire();
                        component.set("v.showValidateButton", true);
                        component.set("v.showPaymentSubmit", false);
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            alert("Are you sure you want to submit Payment?");
            //$A.enqueueAction(component.get('c.submitPayment'));
            component.set("v.showPaymentSubmit", true);
            //component.set("v.showValidateButton", false);
        }
    },
    
    onSelectCombiAccount: function (component, event, helper) {
        component.set("v.showSpinner", true);
        helper.clearFieldSelected(component, event);
        component.set("v.selectedRecord", null);
        component.set("v.instructionNumber", null);
        component.set("v.ivrNominate", null);
        component.set("v.beneficiaryDetailsList", null);
        component.find("myBeneficiaryselection").set("v.disabled", true);
        
        helper.getAccountBeneficiariesHelper(component, event, helper);
    },
    
    onSelectOptionPayBeneficiary: function (component, event, helper) {
        var absaListedBeneficiaryCheck = component.find("absaListedBeneficiaryCheck");
        var onceOffpaymentCheck = component.find("onceOffpaymentCheck");
        var payBeneficiaryCheck = component.find("payBeneficiaryCheck").get("v.checked");
        var updatecancelCheck = component.find("updatecancelCheck");
        
        if (payBeneficiaryCheck == true) {
            
            component.set("v.showListedBeneficiary", true);
            component.set("v.showPaymentType", true);
            component.set("v.showAccountSelection", true);
            component.set("v.showReference", true);
            component.set("v.showButton", true);
            component.find("targetAccType").set('v.value', '--None--');
            absaListedBeneficiaryCheck.set("v.disabled", true);
            onceOffpaymentCheck.set("v.disabled", true);
            updatecancelCheck.set("v.disabled", true);
        } else {
            component.set("v.showListedBeneficiary", false);
            component.set("v.showPaymentType", false);
            component.set("v.showAccountSelection", false);
            component.set("v.showReference", false);
            component.set("v.showButton", false);
            absaListedBeneficiaryCheck.set("v.disabled", false);
            onceOffpaymentCheck.set("v.disabled", false);
            updatecancelCheck.set("v.disabled", false);
        }
    },
    
    //Modified: JQUEV & DBOOYSEN 07/11/2020
    //Set attributes values and gets the universal branch code when a beneficiary is selected
    onSelectAccountBeneficiary: function (component, event, helper) {
        var respObj = component.get("v.accBeneficiaryList");
        
        for (var key in respObj) {
            var ref = component.get("v.selectedBeneficiaryValue").split("-")[1];
            if(!ref){
                helper.clearFieldSelected(component, event);
                return;
            }
            if (respObj[key].instrRefName == ref.trim()) {
                helper.getUniversalBranch(component, event, helper, respObj[key].trgInstCode);
                component.set("v.targetAccNumberDisabled", true);
                component.set("v.targetBankName", respObj[key].trgInstCode);
                component.set("v.targetAccountNo", respObj[key].trgAcc);
                component.set("v.paymentRefName", respObj[key].srcStmtRef);
                component.set("v.recipientRefercnce", respObj[key].trgStmtRef);
                component.set("v.recipientRefName", respObj[key].instrRefName);
                component.set("v.selectedRecord", respObj[key].trgInstCode);
                component.set("v.instructionNumber", respObj[key].instrNo);
                component.set("v.selectedTargetAccType", respObj[key].trgAccType);
                component.set("v.ivrNominate", respObj[key].ivrNominate);
            }
        }
    },
    
    onSelectOptionUpdateCancel: function (component, event, helper) {
        var absaListedBeneficiaryCheck = component.find("absaListedBeneficiaryCheck");
        var onceOffpaymentCheck = component.find("onceOffpaymentCheck");
        var payBeneficiaryCheck = component.find("payBeneficiaryCheck");
        var updatecancelCheck = component.find("updatecancelCheck").get("v.checked");
        
        if (updatecancelCheck === true) {
            absaListedBeneficiaryCheck.set("v.disabled", true);
            onceOffpaymentCheck.set("v.disabled", true);
            payBeneficiaryCheck.set("v.disabled", true);
            component.set("v.showUpdatePayment", true);
            component.set("v.showAccountSelection", true);
            component.set("v.showViewDataBtn", true);
            helper.submitRequest(component, event);
        } else {
            absaListedBeneficiaryCheck.set("v.disabled", false);
            onceOffpaymentCheck.set("v.disabled", false);
            payBeneficiaryCheck.set("v.disabled", false);
            component.set("v.showAccountSelection", false);
            component.set("v.showViewDataBtn", false);
            component.set("v.showUpdatePayment", false);
        }
    },
    
    /*call dateUpdate function on onchange event on date field*/
    onUpdateFutureDate: function (component, event, helper) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
        // if date is less then 10, then append 0 before date
        if (dd < 10) {
            dd = "0" + dd;
        }
        // if month is less then 10, then append 0 before date
        if (mm < 10) {
            mm = "0" + mm;
        }
        
        var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
        if (component.get("v.updateFutureDate") != "" && component.get("v.updateFutureDate") < todayFormattedDate) {
            component.set("v.FutureDateValidationError", true);
            console.log("Inside true mydate" + component.get("v.updateFutureDate"));
        } else {
            component.set("v.FutureDateValidationError", false);
            console.log("Inside false mydate" + component.get("v.updateFutureDate"));
        }
    },
    
    onViewData: function (component, event, helper) {
        helper.submitRequest(component, event);
    },
    
    handleClickUpdate: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        component.set("v.updatePaymentModal", true);
        
        component.set("v.amount", selectedRec.amount);
        component.set("v.recipientName", selectedRec.instrRefName);
        component.set("v.accountNumber", selectedRec.trgAcc);
        component.set("v.srcAccType", selectedRec.srcAccType);
        component.set("v.instrNo", selectedRec.instrNo);
        component.set("v.srcClrCode", selectedRec.srcClrCode);
        
        component.set("v.srcStmtRef", selectedRec.srcStmtRef);
        component.set("v.trgAccType", selectedRec.trgAccType);
        component.set("v.reference", selectedRec.trgStmtRef);
        component.set("v.trgClrCode", selectedRec.trgClrCode);
        component.set("v.actDate", selectedRec.actDate);
        
        console.log("srcAccType: " + component.get("v.srcAccType"));
        console.log("srcStmtRef: " + component.get("v.srcStmtRef"));
        console.log("trgAccType: " + component.get("v.trgAccType"));
        console.log("reference: " + component.get("v.reference"));
        console.log("trgClrCode: " + component.get("v.trgClrCode"));
        console.log("instrNo: " + component.get("v.instrNo"));
        console.log("amount: " + component.get("v.amount"));
    },
    
    actionUpdate: function (component, event, helper) {
        var amount = component.find("amountId").get("v.value");
        var name = component.find("recipientNameId").get("v.value");
        var accountNo = component.find("accountNumberId").get("v.value");
        var reference = component.find("referenceId").get("v.value");
        var actDate = component.find("actDateId").get("v.value");
        
        if (amount == "" || amount == null) {
            helper.getToast("Error", "Amount Cannot Be Blank.", "error");
        } else if (name == "" || name == null) {
            helper.getToast("Error", "Recipient name Cannot Be Blank.", "error");
        } else if (accountNo == "" || accountNo == null) {
            helper.getToast("Error", "Account number Cannot Be Blank.", "error");
        } else if (reference == "" || reference == null) {
            helper.getToast("Error", "Reference Cannot Be Blank.", "error");
        } else if (actDate == "" || actDate == null) {
            helper.getToast("Error", "Date Cannot Be Blank.", "error");
        } else {
            helper.actionUpdate(component, event);
        }
        helper.submitRequest(component, event, helper);
    },
    
    actionRemove: function (component, event, helper) {
        helper.actionRemove(component, event);
    },
    
    handleClickRemove: function (component, event, helper) {
        var selectedRec = event.getSource().get("v.value");
        component.set("v.cancelPaymentModal", true);
        component.set("v.instrNo", selectedRec.instrNo);
        console.log("insr: " + component.get("v.instrNo"));
    },
    
    cancel: function (component, event, helper) {
        component.set("v.updatePaymentModal", false);
        component.set("v.cancelPaymentModal", false);
    },
    
    cancelFuturePayment: function (component, event, helper) {
        component.set("v.cancelPaymentModal", false);
    }
});