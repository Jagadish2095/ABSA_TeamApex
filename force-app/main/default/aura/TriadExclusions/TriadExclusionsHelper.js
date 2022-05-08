({
    getTriadList: function (component, event) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getTriadDataList");
        console.log(component.get("v.recordId"));

        action.setParams({
            "appID": component.get("v.appId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var results = response.getReturnValue();
                console.log("appTriadData results::: " + results);
                console.log('results---', results);
                component.set('v.showSpinner', false);
                component.set("v.appTriad", results);
                if (results[0]) {
                    component.set("v.LastRefreshDate", results[0].LastModifiedDate);
                }

                console.log("appId" + component.get("v.applicationID"));

            }
            else {
                component.set('v.showSpinner', false);
                console.log("Failed with state: " + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);

    },
})