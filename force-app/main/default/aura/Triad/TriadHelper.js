({
    getTriadData: function (component, event) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getApplicationTriad");
        console.log(component.get("v.recordId"));

        action.setParams({
            oppID: component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                // component.set("v.appTriadData", results);

                if (results[0]) {
                    //  component.set('v.showSpinner', false);
                    // component.set("v.applicationID", results[0].Id);
                }
                setTimeout(
                    $A.getCallback(function () {
                        component.set("v.applicationID", results.Id);
                        component.set("v.showSpinner", false);
                        component.set("v.isTriadLoaded", true);
                    }),
                    9000
                );
            } else {
                component.set("v.showSpinner", false);
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);
    },

    getApplication: function (component, event) {
        //query application record id
        var action = component.get("c.getApplications");
        action.setParams({
            opportunityIdP: component.get("v.recordId") //opp id
        });
        action.setCallback(this, function (response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null && responseValue.Id != null) {
                    component.set("v.applicationID", responseValue.Id);
                    component.set("v.showSpinner", false);
                }
            } else if (response.getState() === "ERROR") {
                var errors = response.getError();
                component.set("v.errorMessage","getApplication: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                component.set("v.errorMessage", "getApplication: Apex error. ");
            }
        });
        $A.enqueueAction(action);
        component.set("v.showSpinner", false);
    }
});