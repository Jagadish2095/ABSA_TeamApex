({
    doInit: function (component, event, helper) {
        var action = component.get("c.FetchproductList");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            //console.log('results success or error---'+JSON.stringify(results));
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---' + JSON.stringify(results));
                component.set("v.prodrecList", results);

            }
        });
        $A.enqueueAction(action);
    },
})