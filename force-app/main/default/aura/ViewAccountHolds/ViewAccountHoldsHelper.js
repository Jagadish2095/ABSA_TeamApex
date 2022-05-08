({
    getSavingHolds : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedAccountNumber = component.get("v.selectedAccountNumberToFlow");
        var action = component.get("c.svgetaccountholdsdetail");
        action.setParams({
            accountNo:selectedAccountNumber
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state :' +state)
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                var result= JSON.parse(response.getReturnValue());
                console.log('result: ' + result);
                if(result != null){
                    component.set("v.savingList", result);
                    component.set("v.dormant", result.dormantInd);
                    component.set("v.blockedAccount", result.blockedInd);
                    component.set("v.courtOrder", result.courtOrderInd);
                    component.set("v.semiDormant", result.semiDormantInd);
                    component.set("v.exclEstate", result.exclEstateInd);
                    component.set("v.exclInslvnt", result.exclInslvntInd);
                    component.set("v.rbaEddHold", result.rbaEddHold);
                    component.set("v.frozenInd", result.frozenInd);
                    component.set("v.stoppedInd", result.stoppedInd);
                    component.set("v.signingAuthInd", result.signingAuthInd);
                    component.set("v.monitorActivityInd", result.monitorActivityInd);
                    component.set("v.potBadDebtInd", result.potBadDebtInd);
                    component.set("v.legalActionInd", result.legalActionInd);
                    component.set("v.nonResidentInd",result.nonResidentInd);
                    component.set("v.lostBookInd",result.lostBookInd);
                    component.set("v.offlineEnqInd",result.offlineEnqInd);
                    component.set("v.securityMessageInd",result.securityMessageInd);
                    component.set("v.restricHoldInd",result.restricHoldInd);
                    component.set("v.exceedMaxBalInd",result.exceedMaxBalInd);
                    component.set("v.wtiCountry",result.wtiCountry);
                }
                console.log('wtiCountry value: ' +component.get("v.wtiCountry"));
                console.log('exceedMaxBalInd value: ' +component.get("v.exceedMaxBalInd"));
            } else if(state === "ERROR"){
                helper.fireToast("Error!", "SVgetAccountHoldsDetailV4 Service Issue. Please try again: " + JSON.stringify(response.getError()), "error");
            } else{
                helper.fireToast("Error!", "Unexpected error occurred on ViewAccountHoldsController.svgetaccountholdsdetail, state returned: " + state, "error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    updateSavingHolds : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedAccountNumber = component.get("v.selectedAccountNumberToFlow");
        var action = component.get("c.svUpdateaccountholds");
        action.setParams({
            accountNumber:selectedAccountNumber,
            frozenInd:component.get("v.frozenInd"),
            stoppedInd:component.get("v.stoppedInd"),
            dormantInd: component.get("v.dormant"),
            semiDormantInd: component.get("v.semiDormant"),
            exclEstateInd: component.get("v.exclEstate"),
            exclInslvntInd:  component.get("v.exclInslvnt"),
            courtOrderInd: component.get("v.courtOrder"),
            signingAuthInd: component.get("v.signingAuthInd"),
            monitorActivityInd: component.get("v.monitorActivityInd"),
            potBadDebtInd: component.get("v.potBadDebtInd"),
            legalActionInd: component.get("v.legalActionInd"),
            nonResidentInd:component.get("v.nonResidentInd"),
            lostBookInd:component.get("v.lostBookInd"),
            blockedInd:component.get("v.blockedAccount"),
            offlineEnqInd:component.get("v.offlineEnqInd"),
            securityMessageInd:component.get("v.securityMessageInd"),
            restricHoldInd:component.get("v.restricHoldInd"),
            exceedMaxBalInd:component.get("v.exceedMaxBalInd"),
            wtiCountry: component.get("v.wtiCountry"),
            rbaEddHold:component.get("v.rbaEddHold")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state :' +state)
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('return:' + result);
                if(result == 'IMPOSE' || result == 'RELEASE'){
                    helper.fireToast("Success!", "SUCCESSFULLY " + result, "success");
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", true);
                    component.set("v.updateSavingHolds", false);
                } else{
                    helper.fireToast("Error!", result, "error");
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", false);
                }
            } else if(state === "ERROR"){
                helper.fireToast("Error!", "SVupdateAccountHoldsV4 Service Issue. Please try again: " + JSON.stringify(response.getError()), "error");
            } else{
                helper.fireToast("Error!", "Unexpected error occurred on ViewAccountHoldsController.svUpdateaccountholds, state returned: " + state, "error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    getChequeHolds : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedAccountNumber = component.get("v.selectedAccountNumberToFlow");
        var action = component.get("c.cqgetaccountholdsdetail");
        action.setParams({
            accountNumber:selectedAccountNumber
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var obj = response.getReturnValue();
                var result= JSON.parse(response.getReturnValue());
                if(result != null){
                    console.log('result' + obj);
                    component.set("v.blockedCQ", result.blocked);
                    component.set("v.courtOrderCQ", result.courtOrder);
                    component.set("v.mandateRequiredCQ", result.mandateRequired);
                    component.set("v.dormantCQ", result.dormant);
                    component.set("v.semiDormantCQ", result.semiDormant);
                    component.set("v.confiscatedCQ", result.confiscated);
                    component.set("v.externalTransferCQ", result.externalTransfer);
                    component.set("v.staffCQ", result.staff);
                    component.set("v.creditAccountCQ", result.blocked);
                    component.set("v.excludeFromEstateCQ", result.excludeFromEstate);
                    component.set("v.blockAdhocDbtCQ", result.blockAdhocDbt);
                    component.set("v.blockAdhocCrdCQ", result.blockAdhocCrd);
                    component.set("v.specialRqpRedirectCQ", result.specialRqpRedirect);
                    component.set("v.commercialPropFinCQ", result.commercialPropFin);
                    component.set("v.misHoldCQ", result.misHold);
                    component.set("v.genSecMsgCQ", result.genSecMsg);
                    component.set("v.exclFromInsolventCQ", result.exclFromInsolvent);
                    component.set("v.digitalHoldCQ", result.digitalHold);
                   component.set("v.odSwitchIndCQ", result.odSwitchInd);
                   component.set("v.wapWildAccPickupCQ", result.wapWildAccPickup);
                }
            } else if(state === "ERROR"){
                helper.fireToast("Error!", "CQgetAcctHoldsMaintV4 Service Issue. Please try again: " + JSON.stringify(response.getError()), "error");
            } else{
                helper.fireToast("Error!", "Unexpected error occurred on ViewAccountHoldsController.cqgetaccountholdsdetail, state returned: " + state, "error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

     updateChequeHolds : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedAccountNumber = component.get('v.selectedAccountNumberToFlow');
        var action = component.get("c.validateChequeHolds");
        action.setParams({
            accountNumber:selectedAccountNumber,
            blocked:component.get("v.blockedCQ"),
            courtOrder:component.get("v.courtOrderCQ"),
            mandateRequired: component.get("v.mandateRequiredCQ"),
            dormant: component.get("v.dormantCQ"),
            semiDormant: component.get("v.semiDormantCQ"),
            confiscated:  component.get("v.confiscatedCQ"),
            externalTransfer: component.get("v.externalTransferCQ"),
            staff: component.get("v.staffCQ"),
            creditAccount: component.get("v.creditAccountCQ"),
            excludeFromEstate: component.get("v.excludeFromEstateCQ"),
            blockAdhocDbt: component.get("v.blockAdhocDbtCQ"),
            blockAdhocCrd:component.get("v.blockAdhocCrdCQ"),
            specialRqpRedirect:component.get("v.specialRqpRedirectCQ"),
            commercialPropFin:component.get("v.commercialPropFinCQ"),
            misHold:component.get("v.misHoldCQ"),
            genSecMsg:component.get("v.genSecMsgCQ"),
            wapWildAccPickup:component.get("v.wapWildAccPickupCQ"),
            exclFromInsolvent:component.get("v.exclFromInsolventCQ"),
            digitalHold: component.get("v.digitalHoldCQ"),
            odSwitchInd:component.get("v.odSwitchIndCQ")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state :' +state)
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('return:' + result);
                if(result.includes('RELEASED') || result.includes('IMPOSE')){
                    helper.fireToast("Success!", "SUCCESSFULLY " + result, "success");
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", true);
                    component.set("v.updateChequeHolds", false);
                } else{
                    helper.fireToast("Error!", result, "error");
                    var submitButton = component.find("submitButton");
                    submitButton.set("v.disabled", false);
                }
            } else if(state === "ERROR"){
                helper.fireToast("Error!", "CQupdAcctHoldsV4 Service Issue. Please try again: " + JSON.stringify(response.getError()), "error");
            } else{
                helper.fireToast("Error!", "Unexpected error occurred on ViewAccountHoldsController.validateChequeHolds, state returned: " + state, "error");
            }
            helper.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },

    //Lightning toastie
    fireToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    }
})