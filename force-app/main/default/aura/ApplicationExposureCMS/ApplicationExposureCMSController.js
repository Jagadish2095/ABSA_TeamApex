({
    doInit: function (component, event, helper) {
        //Loading the CMS Data from Total Group Exposure Object
        var action = component.get("c.loadExposureCMSRecordID");
        console.log('Opp Id in CMS' + component.get("v.OppId"));
        action.setParams({ oppID: component.get("v.OppId") });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result != null) {
                    component.set("v.TotalGroupRecordId", result);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    }
})