({
    //executes on component initialization to setup data
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
        component.set("v.options", [
            { label: "Detailed Statement", value: "D" },
            { label: "Amortized Statement", value: "A" }
        ]);
    },

    //executes utility function after the recordEditForm has loaded
    handleAccountLoad: function (component, event, helper) {
        helper.hideSpinner(component);
    },

    //when an option on the radio group is selected this function sets a label attribute corresponding to the value of the options
    onRadioOptionSelect: function (component, event, helper) {
        var valueSelected = component.get("v.value");
        var valueSelectedLabel = "AVAF ";
        if (valueSelected == "D") {
            valueSelectedLabel += "Detailed Statement";
        } else if (valueSelected == "A") {
            valueSelectedLabel += "Amortized Statement";
        }
        component.set("v.radioOptionLabel", valueSelectedLabel);
    },

    //function launched from the Send Statement btn to set values and call the helper function to request the AVAF Statement
    sendStatement: function (component, event, helper) {
        var valueSelected = component.get("v.value");
        if (valueSelected) {
            component.set("v.selectedStatementType", valueSelected);
            var clientEmail;
            var accountNameFormatted;
            var accName = component.find("accNameField").get("v.value");
            if (component.get("v.isBusinessAccountFromFlow")) {
                //Business client
                clientEmail = component.find("activeEmailField").get("v.value");
                accountNameFormatted = accName;
            } else {
                //Individual client
                clientEmail = component.find("personEmailField").get("v.value");
                accountNameFormatted = accName.FirstName + " " + accName.LastName;
            }
            component.set("v.clientEmail", clientEmail);

            var newCaseSubject = component.get("v.radioOptionLabel") + " - " + accountNameFormatted;
            component.find("caseSubjectField").set("v.value", newCaseSubject);

            helper.statementRequest(component, event, helper);
        } else {
            helper.fireToast("Error!", "Please select a Statement Type to continue", "error");
        }
    }
});