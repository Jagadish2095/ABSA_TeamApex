({
    doInit: function (component, event, helper) {
        var action = component.get("c.getAccountDetails");
        var clientAccountId = component.get("v.clientAccountIdFromFlow");
        action.setParams({ clientAccountId: clientAccountId });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.startsWith("Error: ")) {
                    //error
                    component.set("v.errorMessage", responseValue);
                } else {
                    //success
                    var respObj = JSON.parse(responseValue);
                    component.set("v.responseList", respObj);
                    var combiAccountList = [];
                    var accSet = new Set();

                    for (var key in respObj) {
                        if (!combiAccountList.includes(respObj[key].oaccntnbr) && respObj[key].productType == "CO") {
                            combiAccountList.push(respObj[key].oaccntnbr);
                        }
                    }
                    component.set("v.combiCardsAccounts", combiAccountList);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error CIGetAccountLinkedToClientCodeController.getAccountDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    showTransactionLimit: function (component, event, helper) {
        var combiAccountList = component.get("v.combiCardsAccounts");
        var indexvar = event.getSource().get("v.value");
        var cashLim = event.getParam("inpcardCshLim");

        for (var index in combiAccountList) {
            if (combiAccountList[index] == indexvar) {
                var showLimitsDiv = document.getElementById("TransactionLimit " + indexvar);
                $A.util.removeClass(showLimitsDiv, "slds-hide");
            } else {
                var showLimitsDiv = document.getElementById("TransactionLimit " + combiAccountList[index]);
                $A.util.addClass(showLimitsDiv, "slds-hide");
            }
        }
    }
});