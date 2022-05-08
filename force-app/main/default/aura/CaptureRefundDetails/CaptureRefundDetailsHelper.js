({
    fireToastEvent: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },
    transferCase: function(component, event, helper) {
        component.set("v.showSpinner", true);
        var action = component.get("c.transferCase");
        action.setParams({
            serviceGroupName:'Everyday Banking -Awaiting Request Refunds',
            serviceTypeName:  'Awaiting Request Refunds',
            caseId: component.get("v.caseIdFromFlow")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
                window.location.reload(true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                } else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getStaticResource: function(component, event, helper) {
        const url = new URL(window.location.href);
        var resourceRelPath;
        resourceRelPath = $A.get("$Resource.Reqest_Refund_mandate_queues");
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

    callApprovalProcess: function(component, event) {
        var amount = component.get("v.amountValue");
        var trgAccType = component.get("v.product");
        var queueName;
         var collectionPhase = component.get("v.collectionPhase");
        var approvalMandateQueues = JSON.parse(component.get("v.approvalMandateQueues"));
        for (var key in approvalMandateQueues[trgAccType + '-' + collectionPhase]) {
            if ((parseInt(approvalMandateQueues[trgAccType + '-' + collectionPhase][key].lowerRange) < parseInt(amount) && parseInt(approvalMandateQueues[trgAccType + '-' + collectionPhase][key].higherRange) > parseInt(amount)) || parseInt(approvalMandateQueues[trgAccType + '-' + collectionPhase][key].higherRange) == parseInt(amount)) {
                queueName = approvalMandateQueues[trgAccType + '-' + collectionPhase][key].queueName;
                break;
            }
        }
        component.set("v.showSpinner", true);
        var action = component.get("c.submitForApproval");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            queueName: queueName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               this.fireToastEvent("Success", 'Refund details have been sent for approval', "Success");
                component.set("v.showSpinner", false);
                window.location.reload(true);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);

                          this.fireToastEvent("Error", errors[0].message, "Error");
                    }
                } else {
                     this.fireToastEvent("Error", errors[0].message, "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getAccountDetail: function(component, event, helper) {

        component.set("v.showSpinner", true);
        var action = component.get("c.getAccountDetails");
        action.setParams({
            clientAccountId: component.get("v.clientAccountId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.showSpinner", false);
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
                    var accountObjList = [];
                    var respObj = responseBean.cip047o.outputTable;
                    component.set("v.accountsFromResponse", respObj);
                    console.log(respObj)

                    for (var key in respObj) {
                        if(respObj[key].productType ==='CQ' || respObj[key].productType ==='SA'){
                               let accountObj ={};
                            console.log(respObj[key].oaccntnbr);
                            accountObj.status = respObj[key].status;
                            accountObj.number =respObj[key].oaccntnbr.replace(/^0+/, "");
                              accountObjList.push(accountObj);
                        }
                    }
                    component.set("v.accountTo", accountObjList);
                }
            } else if (state === "ERROR") {
                var errors = responseBean.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                        component.set("v.showSpinner", false);
                    }
                } else {
                    component.set("v.showSpinner", false);
                    component.set("v.errorMessage", "unknown error");
                }
            }

        });
        $A.enqueueAction(action);
    },
    getAccountType: function(component, accNumber) {
        var accList = component.get("v.accountsFromResponse");
                 let accObj ={};
        for (var key in accList) {
            if (accList[key].oaccntnbr.replace(/^0+/, "") == accNumber) {
                accObj.status=accList[key].status;
                accObj.productType=accList[key].productType;
                return accObj;
            }
        }
    },


    allFieldsValid: function(component) {
        var idsToValidate = component.get("v.idsToValidate");
        var arrayFields = [];
        for (var i = 0; i < idsToValidate.length; i++) {
            var inputCmp = component.find(idsToValidate[i]);
            if (inputCmp) {
                Array.isArray(inputCmp) ? arrayFields.push.apply(arrayFields, inputCmp) : arrayFields.push(inputCmp);
            }
        }
        var allValid = arrayFields.reduce(function(validFields, inputCmp) {
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
  changeAccountTypeOnChange: function(component, event, helper) {
      let argetacc={};
      component.set("v.targetAccountType", argetacc)
      let accountTypeStr = component.get("v.accountType")
             let accountType;
             if (accountTypeStr == 'Cheque') {
                 component.set("v.targetAccountType.productType", "CQ")
             } else if (accountTypeStr == 'Savings') {
                component.set("v.targetAccountType.productType", "SA")
             }
    },
    verifyAccount: function(component, event, helper) {
        component.set("v.showSpinner", true);
        let argetacc={};
          component.set("v.targetAccountType", argetacc)
        let action = component.get("c.verifyAccount");
        let accountTypeStr = component.get("v.accountType")
        let accountType;
        if (accountTypeStr == 'Cheque') {
            component.set("v.targetAccountType.productType", "CQ")
            accountType = '01';
        } else if (accountTypeStr == 'Savings') {
           component.set("v.targetAccountType.productType", "SA")
            accountType = '02';
        }
        action.setParams({
            accountNumber: component.get("v.accountNumber"),
            branchCode:component.get("v.branchCode"),
            accountType: accountType

        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result === '0') {
                    this.fireToastEvent("Success!", "Account verified successfully", "Success");
                    component.set("v.showBankSector", true);
                        $A.util.removeClass(component.find("fteError"), "show");
                    component.set("v.showVerificationAccountButton", false);
                    component.set("v.showSummaryButtom", true);
                } else {
                    if (component.get("v.verifyAccountSecondTime") === true) {
                        this.fireToastEvent("Error!", "Failed to verify account details. We were unable to verify the account details provided", "Error");
                        component.set("v.showSummaryButtom", false)
                        component.set("v.showAwaitingBankingDetailsButtom", true)
                        component.set("v.showBankSector", false)
                        component.set("v.showSectionAfterVerificationFailed", true)
                    } else {
                        this.fireToastEvent("Error!", "Failed to verify account details. Please try again", "Error");
                        component.set("v.verifyAccountSecondTime", true);
                        $A.util.addClass(component.find("fteError"), "show");
                    }
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", JSON.stringify(errors[0].message));
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    setValuesForSummary: function(component, event, helper) {
        if(component.get("v.showVerificationSector") ===false &&
        (component.find("serviceGroupField").get("v.value") != 'Everyday Banking -Awaiting Request Refunds' && component.find("serviceGroupField").get("v.value") != 'Request Refund Escalations')){
            component.set("v.accountNumberForSummary",component.get("v.accountFromFlow"));
        }
        var today = new Date();
        var date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();
        component.set("v.effectiveDate", date);
        component.set("v.bankNameFrom", 'Absa');
        component.set("v.textForSummaryDebit", component.get("v.product") + '\n' + component.get("v.debitFrom"));
        component.set("v.textForSummaryCredit", component.get("v.targetAccountType.productType") + '\n' + component.get("v.accountNumberForSummary"));
   component.set("v.branchCodeFrom", '632005');
         if (component.get("v.showVerificationSector") === false && component.find("serviceGroupField").get("v.value") != 'Everyday Banking -Awaiting Request Refunds') {
            component.set("v.bankNameFrom", 'Absa');
            component.set("v.bankName", 'Absa');

            component.set("v.branchCode", '');
            component.set("v.accountNumberTo", component.get("v.selectedAccountNumberFromFlow"));
        }
    },
    saveJson: function(component, event) {

        let newJson = component.find("extendedRequestData").get("v.value");
        newJson = newJson.slice(0, -1);
        newJson = newJson + ',"debitFrom":"' + component.get("v.debitFrom") +
            '","amount":"' + component.get("v.amountValue") +
            '","collPhase":"' +component.get("v.collectionPhase") +
            '","targetAccountType":"' + component.get("v.targetAccountType.productType") +
           '","debitFrom":"' + component.get("v.debitFrom") +
           '","bankNameFrom":"' + component.get("v.bankName") +
            '","bankNameTo":"' + component.get("v.bankNameFrom") +
            '","refundType":"' + component.get("v.refundTypeValue") +
           '","reason":"' + component.get("v.reasonForDebitValue") +
           '","product":"' + component.get("v.product") +
           '","accountNumberFromFlow":"' + component.get("v.accountNumberFromFlow") +
           '","selectedAccountNumberFromFlow":"' + component.get("v.selectedAccountNumberFromFlow") +
           '","accountNumberForSummary":"' + component.get("v.accountNumberForSummary") +
            '","date":"' + component.get("v.effectiveDate") + ' "}'
        component.set("v.showSpinner", true);
        var action = component.get("c.saveNewJson");

         action.setParams({
             caseId: component.get("v.caseIdFromFlow"),
             newJson: newJson
         });
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 component.set("v.showSpinner", false);
                /* window.location.reload(true);*/
             } else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         component.set("v.errorMessage", errors[0].message);
                     }
                 } else {
                     component.set("v.errorMessage", "Error in Routing case");
                 }
             }
         });
         $A.enqueueAction(action);
    },
    replaceValuesInJson: function(component, event) {

        let newJson  = JSON.parse(component.find("extendedRequestData").get("v.value"));
        newJson.targetAccountType = component.get("v.targetAccountType.productType");
        newJson.targetAccountType = component.get("v.targetAccountType.productType");

        component.set("v.showSpinner", true);
        var action = component.get("c.saveNewJson");

         action.setParams({
             caseId: component.get("v.caseIdFromFlow"),
             newJson: newJson
         });
         action.setCallback(this, function(response) {
             var state = response.getState();
             if (state === "SUCCESS") {
                 component.set("v.showSpinner", false);

             } else if (state === "ERROR") {
                 var errors = response.getError();
                 if (errors) {
                     if (errors[0] && errors[0].message) {
                         component.set("v.errorMessage", errors[0].message);
                     }
                 } else {
                     component.set("v.errorMessage", "Error in Routing case");
                 }
             }
         });
         $A.enqueueAction(action);
    },
})