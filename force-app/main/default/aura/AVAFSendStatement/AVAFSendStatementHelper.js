({
    //Apex aura method to send the statement request
    statementRequest: function (component, event, helper) {
        helper.showSpinner(component);
        var avafAccountNum = component.get("v.selectedAVAFAccountFromFlow");
        var emailAddress = component.get("v.clientEmail");
        var avafStatementType = component.get("v.selectedStatementType");
        var action = component.get("c.statementRequest");
        action.setParams({
            avafAccNum: avafAccountNum,
            email: emailAddress,
            statementType: avafStatementType
        });
        action.setCallback(this, function (response) {
            helper.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var respBean = response.getReturnValue();
                if (respBean && respBean.statusCode == 200 && respBean.BAPI_SF_STMT_REQ != null) {
                    if (respBean.BAPI_SF_STMT_REQ[0].E_RESPONSE == "000") {
                        component.find("caseEditForm").submit();
                        helper.fireToast("Success!", "AVAF Statement Request sent successfully, Click Next to Continue", "success");
                    } else {
                        //Error Description Response Code
                        component.set(
                            "v.errorMessage",
                            "AVAFStatementRequest_IH_v1 Service Error. BAPI_SF_STMT_REQ.E_RESPONSE: " +
                                respBean.BAPI_SF_STMT_REQ[0].E_RESPONSE +
                                ". BAPI_SF_STMT_REQ.E_RESPONSE_DESC: " +
                                respBean.BAPI_SF_STMT_REQ[0].E_RESPONSE_DESC
                        );
                    }
                } else {
                    //Error Status Code
                    component.set("v.errorMessage", "AVAFStatementRequest_IH_v1 Service Error. Service Response: " + JSON.stringify(respBean));
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error AVAFSendStatementController.statementRequest: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred in AVAFSendStatementController.statementRequest method, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    //Show Spinner
    showSpinner: function (component) {
        component.set("v.isSpinner", true);
    },

    //Hide Spinner
    hideSpinner: function (component) {
        component.set("v.isSpinner", false);
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
});