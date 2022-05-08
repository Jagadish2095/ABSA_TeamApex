({
    //JQUEV 2020/10/15
    //List Policy Details (LAListPolicyDetailsByPolicyV7 Service Call)
    getPolicyDetails: function (component, event, helper, selectedAccountNumber) {
        helper.showSpinner(component);
        var action = component.get("c.getPolicyDetailsByPolicyWithBenefits");
        action.setParams({ policyNumberP: selectedAccountNumber });
        action.setCallback(this, function (response) {
            helper.hideSpinner(component);
            var state = response.getState();
            if (state === "SUCCESS") {
                var respBean = response.getReturnValue();
                if (respBean.statusCode == 200) {
                    //Successful Status Code
                    if (respBean.LAlistPolicyDetailsbyPolicyNumberV7Response != null && respBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o != null) {
                        //Check Error Description Tag
                        if (respBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.errorDescription != null) {
                            //Error message in Response
                            component.set(
                                "v.errorMessage",
                                "LAListPolicyDetailsByPolicyV7 Error: " + respBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.errorDescription
                            );
                        } else {
                            //Success
                            component.set("v.data", respBean.LAlistPolicyDetailsbyPolicyNumberV7Response.la950p3o.rolePlayersDetails);
                        }
                    } else {
                        //Error bad response structure
                        component.set("v.errorMessage", "Bad response returned from LAListPolicyDetailsByPolicyV7. " + JSON.stringify(respBean));
                    }
                } else {
                    //Error Status Code
                    component.set(
                        "v.errorMessage",
                        "LAListPolicyDetailsByPolicyV7 Service Error. StatusCode: " + respBean.statusCode + ". Message: " + respBean.message
                    );
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage", "Apex error MemberMaintenance.getPolicyDetailsByPolicyWithBenefits: " + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
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
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
});