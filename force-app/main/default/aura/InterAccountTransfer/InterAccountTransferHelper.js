({
    doInit: function (component, event, helper) {
        this.showSpinner(component, event, helper);
        component.set("v.selectedAccountNumberFrom", component.get("v.selectedAccountNumberToFlow"));
        var action = component.get("c.getAccountDetails");
        action.setParams({
            clientAccountId: component.get("v.clientAccountId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseBean = response.getReturnValue();
                if ($A.util.isUndefinedOrNull(responseBean)) {
                    // error
                    component.set("v.errorMessage", "Error: Blank response received from service.");
                }
                if (!$A.util.isUndefinedOrNull(responseBean.nbsmsgo3) && !$A.util.isUndefinedOrNull(responseBean.nbsmsgo3.msgEntry)) {
                    component.set("v.errorMessage", "Error: " + responseBean.nbsmsgo3.msgEntry.msgTxt);
                }
                
                if (responseBean.statusCode != 200) {
                    component.set("v.errorMessage", "Error: " + responseBean.message);
                }
                
                if ($A.util.isUndefinedOrNull(responseBean.cip047o.outputTable)) {
                    component.set("v.errorMessage", "Error: Unexpected response received. Service Response: " + JSON.stringify(response));
                } else {
                    // success
                    var accList = [];
                    var respObj = responseBean.cip047o.outputTable;
                    component.set("v.accountsFromResponse", respObj);
                    //Changes added by chandra to show only active combi card dated 29/11/2021
                    // Updated by Innocent to filter out combi accounts
                    for (var key in respObj) {
                        if (respObj[key].product != "COMBI") {
                            if (respObj[key].productType != "CO") {
                                accList.push(respObj[key].oaccntnbr.replace(/^0+/, ""));
                            }
                            else if (respObj[key].productType == "CO" && respObj[key].status == "ACTIVE"){
                                accList.push(respObj[key].oaccntnbr.replace(/^0+/, ""));
                            }
                        }

                    }
                    
                    component.set("v.accountTo", accList);
                    var sourceAccount = component.get("v.selectedAccountNumberFrom");
                    component.set("v.sourceBalance", this.getAccountBalance(component, sourceAccount));
                    //Added by Chandra
                    var srcAccType = helper.getAccountTypeTranslatedValue(component, component.get("v.selectedAccountNumberFrom"));
                    component.set("v.selectedAccountNumberFromType", srcAccType);
                    //Change end by chandra
                }
            } else if (state === "ERROR") {
                var errors = responseBean.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "InterAccountTransferHelper.doInit - unknown error");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    getAccountBalance: function (component, accNumber) {
        var accList = component.get("v.accountsFromResponse");
        for (var key in accList) {
            if (accList[key].oaccntnbr.replace(/^0+/, "") == accNumber) {
                return accList[key].availableBalance;
            }
        }
    },
    
    disableInterAccountButtons: function (component) {
        component.find("tbSourceAcc").set("v.disabled", true);
        component.find("tbTargetAcc").set("v.disabled", true);
        component.find("tbTargetBalance").set("v.disabled", true);
        component.find("tbSourceBalance").set("v.disabled", true);
    },
    
    disableNonInterAccountButtons: function (component) {
        component.find("targetBalance").set("v.disabled", true);
        component.find("sourceBalance").set("v.disabled", true);
        component.find("sourceAcc").set("v.disabled", true);
    },
    
    nullifyNonInterAccountFields: function (component) {
        component.set("v.errorMessage", null);
        component.set("v.selectedAccountNumberTo", null);
        component.set("v.selectedCombiValue", null);
        component.set("v.targetBalance", null);
        component.set("v.amount", null);
        component.set("v.reference", null);
    },
    
    nullifyInterAccountFields: function (component) {
        component.set("v.sourceBalance", null);
        component.set("v.targetBalance", null);
        component.set("v.tbSourceAccount", null);
        component.set("v.amount", null);
        component.set("v.reference", null);
        component.set("v.errorMessage", null);
        component.set("v.selectedAccountNumberTo", null);
    },
    
    getAccountType: function (component, accNumber) {
        var accList = component.get("v.accountsFromResponse");
        for (var key in accList) {
            if (accList[key].oaccntnbr.replace(/^0+/, "") == accNumber) {
                return accList[key].productType;
            }
        }
    },
    
    //Added by chandra
    getAccountTypeTranslatedValue: function (component, accNumber) {
        var accList = component.get("v.accountsFromResponse");
        for (var key in accList) {
            if (accList[key].oaccntnbr.replace(/^0+/, "") == accNumber) {
                return accList[key].productTypeTranslated;
            }
        }
    },
    //Feeds combi account options for telephone banking enhancement
    getCombiAccounts: function (component, event, helper) {
        this.showSpinner(component);
        var accounts = component.get("v.accountsFromResponse");
        if (accounts) {
            // success
            var accList = [];
            for (var key in accounts) {
                if (accounts[key].productType == "CO" && accounts[key].status == "ACTIVE") {
                    accList.push(accounts[key].oaccntnbr);
                }
            }
            component.set("v.combiAccList", accList);
        } else {
            // error
            component.set("v.errorMessage", "No accounts found against client profile");
        }
        
        this.hideSpinner(component);
    },
    
    //Feeds source and target account fields for telephone banking enhancement
    getCombiLinkedAccounts: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getAccountsLinkedToCombi");
        action.setParams({ selectedCombi: component.get("v.selectedCombiValue") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseBean = response.getReturnValue();
                if (responseBean.statusCode != 200) {
                    // error
                    component.set("v.errorMessage", JSON.stringify(responseBean.message));
                }
                
                if (responseBean === null || responseBean === undefined) {
                    component.set("v.errorMessage", "unexpected error, service returned null response");
                }
                
                if (responseBean.CClistAccsLinkedToACombiCardV1Response.ccp308o.lnkAccntLst) {
                    // success
                    var combiLinkedList = [];
                    
                    var responseList = responseBean.CClistAccsLinkedToACombiCardV1Response.ccp308o.lnkAccntLst;
                    
                    for (var key in responseList) {
                        combiLinkedList.push(responseList[key].accntNbr);
                    }
                    
                    component.set("v.accountTo", combiLinkedList);
                    component.set("v.accountFrom", combiLinkedList);
                    
                    component.find("tbSourceAcc").set("v.disabled", false);
                    component.find("tbTargetAcc").set("v.disabled", false);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error PaymentRequestController.getAccountDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    //Submit payment for inter account transfer
    submit: function (component) {
        this.showSpinner(component);
        var amount = component.get("v.amount");
        var reference = component.get("v.reference");
        var sourceAccount = component.get("v.selectedAccountNumberFrom");
        var targetAccount = component.get("v.selectedAccountNumberTo");
        var trgAccType;
        var srcAccType;
        var instrRefName;
        
        if (!component.get("v.useLinkedAccounts")) {
            trgAccType = this.getAccountType(component, targetAccount);
            srcAccType = this.getAccountType(component, sourceAccount);
        } else {
            srcAccType = "";
            trgAccType = "";
        }
        // sweep set off
        if(component.get("v.IsEBServiceGroupSweepServiceType")){
            instrRefName="EB COL Sweep";
            var targetAccount = component.get("v.selectedAccountNumberFrom");
            var sourceAccount = component.get("v.selectedAccountNumberTo");
            trgAccType = this.getAccountType(component, targetAccount);
            srcAccType = this.getAccountType(component, sourceAccount);
        } else if(component.get("v.IsEBServiceGroupSetOffServiceType")){
            instrRefName="EB COL Setoff";
            var targetAccount = component.get("v.selectedAccountNumberFrom");
            var sourceAccount = component.get("v.selectedAccountNumberTo");
            trgAccType = this.getAccountType(component, targetAccount);
            srcAccType = this.getAccountType(component, sourceAccount);
        }
        
        //get current date and time
        var today = new Date();
        var month = today.getMonth() + 1;
        var payDate = "" + today.getFullYear() + (month < 10 ? "0" + month : month) + (today.getDate() < 10 ? "0" + today.getDate() : today.getDate());
        var payTime = "" + today.getHours() + today.getMinutes() + today.getSeconds() + today.getMilliseconds();
        
        var action = component.get("c.initiatePayment");
        action.setParams({
            payTime: payTime,
            actDate: payDate,
            amount: amount,
            srcAcc: sourceAccount,
            srcAccType: srcAccType,
            trgAcc: targetAccount,
            trgAccType: trgAccType,
            trgStmtRef: reference,
            instrRefName : instrRefName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var msgString = "";
                if (response.getReturnValue().statusCode != "200") {
                    msgString = response.getReturnValue().StatusMessage;
                } else if (!$A.util.isUndefinedOrNull(response.getReturnValue().MBinitiatePaymentV10Response.nbsmsgo3.msgEntry)) {
                    msgString = response.getReturnValue().MBinitiatePaymentV10Response.nbsmsgo3.msgEntry.msgTxt;
                } else {
                    msgString = response.getReturnValue().MBinitiatePaymentV10Response.mbn301o.respDesc;
                }
                if (response.getReturnValue().statusCode == "200" && msgString.includes("SUCCESSFUL")) {
                    component.set("v.statusSuccess", true);
                    component.set("v.statusPending", false);
                    component.set("v.errorMessage", null);
                    component.set("v.showButton", false);
                    this.fireToastEvent("Success", msgString, "Success");
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", false);
                    //added by Koketso - set the message text
                    var messageText;
                    var accTypeText;
                    var cif = component.find("cifField").get("v.value");
                    var serviceGroup = component.find("serviceGroupField").get("v.value");
                    var serviceGroupsLabel = $A.get("$Label.c.SMS_Applicable_Service_Groups");
                    var serviceGroupsList = serviceGroupsLabel.split(";");
                    
                    var responseObj = response.getReturnValue();
                    var transactionAmount = responseObj.MBinitiatePaymentV10Response.mbn301o.lastPaymAmnt;
                    var transactionDate = responseObj.MBinitiatePaymentV10Response.mbn301o.todaysDate;
                    var accountType = responseObj.MBinitiatePaymentV10Response.mbn301o.trgAccType;
                    var availableBalance = responseObj.MBinitiatePaymentV10Response.mbn301o.avbl;
                    //get the translated account type for the message text
                    var translateAction = component.get("c.getOutboundTranslation");
                    translateAction.setParams({
                        systemName: "EB SMS",
                        valueType: "Account Type",
                        valueString: accountType
                    });
                    
                    translateAction.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            accTypeText = response.getReturnValue();
                        } else {
                            accTypeText = accountType;
                        }
                        
                        if (serviceGroupsList.includes(serviceGroup)) {
                            messageText = "Absa: Per instruction payment from related account, Inter account transfer, R" + transactionAmount;
                            messageText +=
                                " on " + transactionDate + " to " + accTypeText + ", Total Avail Bal R" + availableBalance + ". Help 0860008600; " + cif;
                            component.set("v.smsMessageTextToFlow", messageText);
                        }
                    });
                    
                    $A.enqueueAction(translateAction);
                } else {
                    this.fireToastEvent("Error", msgString + ": Payment Unsuccessful..  Please try again..", "Error");
                    component.set("v.statusSuccess", false);
                    component.set("v.statusPending", true);
                    component.set("v.errorMessage", msgString);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    this.fireToastEvent("Error", errors[0].message, "Error");
                }
            }
            
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },
    
    allFieldsValid: function (component) {
        var idsToValidate = component.get("v.idsToValidate");
        var arrayFields = [];
        for (var i = 0; i < idsToValidate.length; i++) {
            var inputCmp = component.find(idsToValidate[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }
        var allValid = arrayFields.reduce(function (validFields, inputCmp) {
            var inputCmpValue = inputCmp.get("v.value");
            var inputCmpRequired = inputCmp.get("v.required");
            var inputCmpValid = true;
            if (inputCmpRequired && $A.util.isEmpty(inputCmpValue)) {
                inputCmpValid = false;
            }
            return validFields && inputCmpValid;
        }, true);
        
        return allValid;
    },
    
    fireToastEvent: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },
    
    showSpinner: function (component) {
        component.set("v.showSpinner", true);
    },
    
    hideSpinner: function (component) {
        component.set("v.showSpinner", false);
    },
    // InterAccount Sweep w-013364 starts
    getCollectionPhaseAndCycle: function (component, event, helper) {
         var selectedAccountNumberFrom;
        if(component.get("v.selectedProductValue") === 'CA'){
            let accountNumber = component.get("v.selectedAccountNumberFrom")
            selectedAccountNumberFrom = accountNumber.slice(0, -2) + '00';
        }else{
            selectedAccountNumberFrom= component.get("v.selectedAccountNumberFrom");
        }
       
        this.showSpinner(component, event, helper);
        while (selectedAccountNumberFrom.length < 16) selectedAccountNumberFrom = "0" + selectedAccountNumberFrom;
        
        var action = component.get("c.getAccountCollectionPhaseAndCycle");
        action.setParams({
            clientAccountNum: selectedAccountNumberFrom
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseBean =response.getReturnValue();
                if (!$A.util.isUndefinedOrNull(responseBean.Error)) {
                    component.set("v.errorMessage",responseBean.Error);
                }
                else{
                    if(responseBean.businessArea.includes('Pre-legal')){
                        component.set("v.collectionPhase",'Pre-legal');
                    } else if(responseBean.businessArea.includes('Legal')){
                        component.set("v.collectionPhase",'Legal');
                    }
                        else if(responseBean.businessArea.includes('OBS')){
                            component.set("v.collectionPhase",'OBS');
                        }else{
                            component.set("v.errorMessage","No Collection phase value returned by Service.Please try again");
                        }
                    if(component.get("v.collectionPhase")){
                        component.set("v.customerOnPTP",responseBean.customerOnPTP);
                        component.set("v.collectionCycle",responseBean.collectionCycle);
                        component.set("v.arrearAmount",responseBean.arrearAmount);  
                    }
                    
                    var showModalWindow = component.find("loadingSnip");
                    $A.util.addClass(showModalWindow,'slds-hide');
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in fetching Collection Phase");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    submitForApproval : function (component, event, helper,jobType) {
        console.log('submitForApproval');
         this.showSpinner(component);
        var amount = component.get("v.amount");
        var reference = component.get("v.reference");
        var targetAccount = component.get("v.selectedAccountNumberFrom");
        var sourceAccount = component.get("v.selectedAccountNumberTo");
        var caseID = component.get("v.caseIdFromFlow");
        var reason = component.get("v.reason");
        var otherReasonComment = component.get("v.otherReasonComment");
        var collectionPhase = component.get("v.collectionPhase");
        var trgAccType;
        var srcAccType;
        var queueName;
        
        
        if (!component.get("v.useLinkedAccounts")) {
            trgAccType = this.getAccountType(component, targetAccount);
            srcAccType = this.getAccountType(component, sourceAccount);
        } 
        // Filter queue
        var approvalMandateQueues = JSON.parse(component.get("v.approvalMandateQueues"));
        for (var key in approvalMandateQueues[trgAccType+'-'+collectionPhase]) {
            console.log('Sour'+approvalMandateQueues[trgAccType+'-'+collectionPhase][key].queueName);
            if((parseInt(approvalMandateQueues[trgAccType+'-'+collectionPhase][key].lowerRange) < parseInt(amount) && parseInt(approvalMandateQueues[trgAccType+'-'+collectionPhase][key].higherRange) > parseInt(amount)) || parseInt(approvalMandateQueues[trgAccType+'-'+collectionPhase][key].higherRange) == parseInt(amount) ){
                queueName=approvalMandateQueues[trgAccType+'-'+collectionPhase][key].queueName;
                break;
            }
        }
        
        var action = component.get("c.createCaseTransactionRecord");
        action.setParams({
            caseTransactionDataMap: { 
                'amount' : amount,
                'reference' : reference,
                'sourceAccount' : sourceAccount,
                'targetAccount': targetAccount,
                'trgAccType' : trgAccType,
                'srcAccType' : srcAccType,
                'reason' : reason,
                'collectionPhase' : collectionPhase,
                'otherReasonComment' : otherReasonComment,
                'caseID' : caseID,
                'queueName' : queueName,
                'jobType' : jobType
            }
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res =response.getReturnValue();
                this.fireToastEvent("Success", res, "Success");
                component.set("v.approvalStatus",'Pending');
                if(jobType=="Inter-Account Transfer (Sweep)"){
                    component.set("v.approvalStatusMessage",' Sweep details have been sent for approval');
                }else{
                    component.set("v.approvalStatusMessage",' Set OFF details have been sent for approval');
                }
                
                var submitButton = component.find("submitButton");
                submitButton.set("v.disabled", true);
                var cancelClickBoxButton = component.find("cancelSweep");
                cancelClickBoxButton.set("v.disabled", true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Submiting for approval.");
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
        
    },
    getStaticResource: function (component, event, helper ,jobType) {
        const url = new URL(window.location.href);
         var resourceRelPath ;
        if(jobType=="Inter-Account Transfer (Sweep)"){
             resourceRelPath = $A.get("$Resource.Sweep_Approval_mandate_queues");  
        } else{
             resourceRelPath = $A.get("$Resource.Set_Off_Approval_mandate_queues");
        }
        
        const resourceUrl = `${url.origin}${resourceRelPath}`;
        window
        .fetch(resourceUrl)
        .then(
            $A.getCallback((response) => {
                if (!response.ok) {
                throw new Error(`HTTP error, status = ${response.status}`);
            }
            response.json().then(
            $A.getCallback((data) => {
                component.set("v.approvalMandateQueues", JSON.stringify(data));
                
            })
                );
                
            })
                )
                .catch(
                $A.getCallback((error) => {
                console.error("Fetch Error :-S", error);
            })
                );
            },
                // InterAccount Sweep w-013364 ends
                
                
            });