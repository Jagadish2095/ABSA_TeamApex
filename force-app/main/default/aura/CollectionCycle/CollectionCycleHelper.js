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

    cacheResponseData: function(component, event, helper) {
        component.set("v.isShowSpinnerSetOff", true);
        let action = component.get("c.handleClientFinancialResponses");
        var selectedAccountNumberFrom = component.get("v.selectedAccountNumberFromFlow");
        while (selectedAccountNumberFrom.length < 16) selectedAccountNumberFrom = "0" + selectedAccountNumberFrom;
        action.setParams({
            clientAccountNum: selectedAccountNumberFrom,
            caseId: component.get("v.caseIdFromFlow"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().startsWith('Error:')) {
                    component.set("v.errorMessage", response.getReturnValue());
                    component.set("v.showSpinner", false)
                } else {
                    component.set("v.jsonWithData", response.getReturnValue());
                    let jsonFromApex = JSON.parse(response.getReturnValue());
                    let beanFromResponse = component.get("v.cyclePhaseResponse");
                    beanFromResponse.push(jsonFromApex.arrearAmount)
                    beanFromResponse.push(jsonFromApex.customerOnPTP)
                    beanFromResponse.push(jsonFromApex.collectionCycle)
                    beanFromResponse.push(jsonFromApex.businessArea)
                    component.set("v.cyclePhaseResponse", beanFromResponse);
                    component.set("v.ptpResponse", jsonFromApex.PTP);
                    component.set("v.showSpinner", false)

                    this.getCollectionPhaseAndCycle(component, event);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {

                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                        component.set("v.showSpinner", false)
                    }
                } else {
                    component.set("v.showSpinner", false)
                    component.set("v.errorMessage", "Error in Cycle phase case");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getJson: function(component, event) {
        let action = component.get("c.getCachedFinancialResponse");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue().startsWith('Error:')) {

                    component.set("v.errorMessage", response.getReturnValue());
                    component.set("v.showSpinner", false)
                } else {

                    component.set("v.jsonWithData", response.getReturnValue());
                    let jsonFromApex = JSON.parse(response.getReturnValue());
                    let beanFromResponse = component.get("v.cyclePhaseResponse");

                    beanFromResponse.push(jsonFromApex.arrearAmount)
                    beanFromResponse.push(jsonFromApex.customerOnPTP)
                    beanFromResponse.push(jsonFromApex.collectionCycle)
                    beanFromResponse.push(jsonFromApex.businessArea)
                    component.set("v.cyclePhaseResponse", beanFromResponse);
                    component.set("v.ptpResponse", jsonFromApex.PTP);
                    component.set("v.showSpinner", false)
                    this.getCollectionPhaseAndCycle(component, event);
                }
            } else if (state === "ERROR") {
                component.get("v.showSpinner", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", response.getReturnValue());
                        this.fireToastEvent("Error!", errors[0].message, "Error");
                    }
                } else {
                    component.set("v.errorMessage", "Error in Cycle phase case");
                }
            }

        });
        $A.enqueueAction(action);
    },
    showSpinner: function(component) {
        component.set("v.showSpinner", true);
    },

    hideSpinner: function(component) {
        component.set("v.showSpinner", false);
    },

    getCollectionPhaseAndCycle: function(component, event) {
    component.set("v.getCycleResponse", true)
        var responseBean = component.get("v.cyclePhaseResponse");
        if (responseBean[3] == null) {
            component.set("v.errorMessage", "No collection phase");
        }
        if (responseBean[3].includes('Pre-legal')) {
            component.set("v.collectionPhase", 'Pre-legal');
        } else if (responseBean[3].includes('Legal')) {
            component.set("v.collectionPhase", 'Legal');
        } else if (responseBean[3].includes('OBS')) {
            component.set("v.collectionPhase", 'OBS');
        } else {
            component.set("v.errorMessage", "No Collection phase value returned by Service.Please try again");
        }
        if (responseBean[1] == null) {
            component.set("v.errorMessage", "No customer on PTP information");
        }
        if (responseBean[2] == null) {
            component.set("v.errorMessage", "No collection Cycle information");
        }
        if (responseBean[0] == null) {
            component.set("v.errorMessage", "No arrear Amount information");
        }
        if(component.get("v.errorMessage") != null){
               component.set("v.collectionCycleisSuccess", false);
            }else{
        component.set("v.collectionCycleisSuccess", true);
        }

        component.set("v.customerOnPTP", responseBean[1]);
        component.set("v.collectionCycle", responseBean[2]);
        component.set("v.arrearAmount", responseBean[0]);
        var showModalWindow = component.find("loadingSnip");

        $A.util.addClass(showModalWindow, 'slds-hide');
    },

    openModal: function(component, event, helper) {
        component.set("v.isModalOpen", true);
        component.set("v.isShowSpinnerSetOff", true);
        if (!component.get("v.errorMessage")) {
            var result = component.get("v.ptpResponse");
            if (!result.includes('Empty')) {
                var jsonResult = JSON.parse(result);
                if (jsonResult != null && jsonResult.data != null && jsonResult.statusCode == '200') {
                    var data = jsonResult.data;
                    data.forEach(function(dataItem) {
                        component.set("v.paymentFrequency", dataItem.paymentScheduleFrequencyReference.valueText);
                        component.set("v.initialPaymentAmount", dataItem.downPaymentAmount);
                        component.set("v.initialPaymentDate", dataItem.downPaymentYMDDate);
                        component.set("v.scheduledStartDate", dataItem.startYMDDateInput);
                        component.set("v.scheduledNumberOfPayments", dataItem.numOfPayments);
                        component.set("v.scheduledPaymentAmount", dataItem.regularPaymentAmount.amount);
                        component.set("v.paymentFrequencyMonths", dataItem.frequencyRate);
                        component.set("v.paymentFrequencyLabel",'Payment frequency ' + dataItem.paymentScheduleFrequencyReference.valueText.toLowerCase());

                    });
                }
            } else {
                component.set("v.ptpIsEmpty", true)
            }
        }
    },
});