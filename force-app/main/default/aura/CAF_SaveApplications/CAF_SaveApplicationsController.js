({
    myAction: function (component, event, helper) {},

    handleSubmit: function (component, event, helper) {
        component.set("v.errorMessage", null);
        var sanctioningStatus = component.get("v.opportunityRecord2.CAF_Sanctioning_Status__c");

        if (sanctioningStatus == "Submitted" || sanctioningStatus == "Allocated To Sanctioner") {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: "This opportunity is currently awaiting sanctioning, please wait for the decision before making changes."
            });
            toastEvent.fire();
        } else {
        }
    }
});