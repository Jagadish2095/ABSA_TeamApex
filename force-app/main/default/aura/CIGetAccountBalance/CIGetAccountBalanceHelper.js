({
    initMethod: function (component, event, helper) {
        var clientAccountId = component.get("v.clientAccountIdViewBalFromFlow");
        var selectedAccNumber = component.get("v.SelectedAccNumberFromFlow");
        var maskedAccountNumber = "";
        var accountBalance = "";
        var action = component.get("c.getAccountDetails");
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
                    component.set("v.accountWrapperMap", responseValue);
                    var respObj = JSON.parse(responseValue);

                    for (var key in respObj) {
                        if (respObj[key].oaccntnbr == selectedAccNumber) {
                            component.set("v.fullAccMap", respObj[key]);
                            maskedAccountNumber = respObj[key].oaccntnbr;
                            accountBalance = respObj[key].balance;
                        }
                    }
                    maskedAccountNumber = maskedAccountNumber.replace(
                        maskedAccountNumber.substring(0, maskedAccountNumber.length - 4),
                        "*".repeat(maskedAccountNumber.length - 4)
                    );
                    component.set("v.maskedAccountNumberToFlow", maskedAccountNumber);
                    component.set("v.accountBalanceToFlow", accountBalance);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error CIGetAccountLinkedToClientCodeController.getAccountDetails: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    }
});