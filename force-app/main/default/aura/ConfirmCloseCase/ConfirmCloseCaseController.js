({
    //executes on component initialization
    doInit: function (component, event, helper) {
        helper.showSpinner(component);
    },

    //Load - Case
    handleLoad: function (component, event, helper) {
        helper.hideSpinner(component);
    },

    //Save  - Case
    handleSubmit: function (component, event, helper) {
        helper.showSpinner(component);
        event.preventDefault(); // stop form submission
        component.find("statusField").set("v.value", "Closed");
        //Submit to Close Case
        component.find("caseCloseEditForm").submit();
    },

    //Success - Case
    handleSuccess: function (component, event, helper) {
        helper.hideSpinner(component);
        helper.fireToast("Success!", "Case successfully closed. ", "success");
        component.set("v.isFormReadOnly", true);
    },

    //Error - Case
    handleError: function (component, event, helper) {
        helper.hideSpinner(component);
        helper.fireToast("Error!", "There has been an error closing the case. ", "error");
        component.set("v.errorMessage", "There has been an error closing the case: " + JSON.stringify(event.getParams()));
    }
});