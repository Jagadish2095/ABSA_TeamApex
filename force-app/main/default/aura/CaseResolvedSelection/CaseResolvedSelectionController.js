({
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
        component.set("v.options", [
            { label: "I was able to solve the case", value: "solved" },
            { label: "I was not able to solve the case", value: "unsolved" }
        ]);
    },

    handleLoad: function (component, event, helper) {
        helper.hideSpinner(component);
        var caseSubject = component.find("caseSubjectField").get("v.value");
        if (caseSubject.startsWith(component.get("v.appAndDigitalBanking"))) {
            var actionBtn = component.find("actionBtn");
            actionBtn.set("v.label", "Close Case");
            $A.util.removeClass(actionBtn, "slds-hide");
            component.set("v.closeCase", true);
            component.set("v.value", "solved");
            component.set("v.alwaysCloseCase", true);
        }
    },

    handleSubmit: function (component, event, helper) {
        event.preventDefault(); // stop form submission
        var parentCmp = component.get("v.parent");
        //Validation
        if ($A.util.isEmpty(component.get("v.value")) || $A.util.isEmpty(component.find("commentsField").get("v.value")) || (!$A.util.isEmpty(parentCmp) && !parentCmp.isParentValidMethod())) {
            helper.fireToast("Error", "Please complete the required fields. ", "error");
        } else {
            helper.showSpinner(component);
            if (component.get("v.closeCase")) {
                component.set("v.isFormReadOnly", true);
                component.find("statusField").set("v.value", "Closed");
            }
            //Submit to save Comments
            component.find("caseResolvedEditForm").submit();
        }
    },

    handleSuccess: function (component, event, helper) {
        helper.hideSpinner(component);
        //If there is no Parent cmp. handle the close case toast
        //Escalation toast happens in the helper
        var parentCmp = component.get("v.parent");
        var closeCase = component.get("v.closeCase");

        if (!$A.util.isEmpty(parentCmp)) {
            //Has Parent component
            parentCmp.handleActionMethod();
        } else if (closeCase) {
            helper.fireToast("Success!", "The Case was successfully closed. ", "success");
        } else {
            //Escalate to Outbound Consultant - Case is transferred
            helper.transferCase(component, event, helper);
        }
    },

    handleError: function (component, event, helper) {
        helper.hideSpinner(component);
        component.set("v.errorMessage", "Record error: " + JSON.stringify(event.getParams()));
    },

    handleRadioBtnChange: function (component, event, helper) {
        var actionBtn = component.find("actionBtn");
        //Show action btn when option is selected
        $A.util.removeClass(actionBtn, "slds-hide");

        if (event.getParam("value") == "solved") {
            //Has Been Solved
            actionBtn.set("v.label", "Close Case");
            component.set("v.closeCase", true);
        } else {
            //Has not been solved
            actionBtn.set("v.label", "Next");
            component.set("v.closeCase", false);
        }
    }
});