({
	 getManagedAccountsHelper: function (component){
        component.set("v.showSpinner", true);
        var action = component.get("c.getManagedLDPAccounts");
        var caseId = component.get("v.recordId");
        console.log('caseId'+caseId);

        action.setParams({
            "caseId": caseId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                console.log('responseData'+JSON.stringify(responseData));
                if(responseData && responseData != null){
                    component.set("v.managedAccounts", responseData);
                    console.log('managedAccounts'+JSON.stringify(component.get('v.managedAccounts')));
                    //component.set("v.manageAccounts",true);
                    component.set("v.mngdExistingBankGuarantees", responseData.length);
                    component.set("v.showSpinner", false);
                    //this.checkManagedAccounts(component);
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.showSpinner", false);

                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(' actual error---'+errors[0].message)
                        this.showToast("Error!", "Bank Guarantee: No existing bank guarantee!" , "error");
                    }
                } else {
                    this.showToast("Error!", "Bank Guarantee: unknown error", "error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    showToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            title: title,
            message: msg,
            type: type,
        });

        toastEvent.fire();
    }
})