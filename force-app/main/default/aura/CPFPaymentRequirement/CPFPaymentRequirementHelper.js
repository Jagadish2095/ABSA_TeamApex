({
    getAppPrdctCpfRec: function (component) {
        var action = component.get("c.getApplicationProductCPFId");
        action.setParams({
            opportunityId: component.get("v.recordId")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var appProductCPFId = response.getReturnValue();
                if(appProductCPFId){
                    component.set("v.appProductCPFId", appProductCPFId);
                } else{
                    this.showToast("Error!", "Payment Requirement: No Application Product CPF Record Found", "error");
                }
            } else {
                var errors = response.getError();

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if(String(errors[0].message).includes('List has no rows for assignment to SObject')){
                            this.showToast("Error!", "Payment Requirement: Please capture a product", "error");
                        } else {
                            this.showToast("Error!", "Payment Requirement " + errors[0].message, "error");
                        }
                    }
                } else {
                    this.showToast("Error!", "Payment Requirement unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleSaveSuccess: function (component) {
        this.showToast("Success!", "Record saved successfully!", "success");
    },

    handleSaveError: function (component, event) {
        this.showToast("Something has gone wrong!", event.getParam("message"), "error");
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            type: type
        });
        toastEvent.fire();
    }
});