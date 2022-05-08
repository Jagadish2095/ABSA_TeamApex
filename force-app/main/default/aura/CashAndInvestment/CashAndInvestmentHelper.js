({
    loadExposuresCashInvestment: function (component, event, helper) {
        var action = component.get("c.getCashAndInvestments");
        action.setParams({
            "oppID": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();

                if (responseValue !== null) {
                    console.log("responseValue::: " + JSON.stringify(responseValue));
                    var countTotal = (responseValue.Total ? Object.keys(responseValue.Total).length : 0) ;
                    var count = (responseValue.appExposuresCashInvest ? Object.keys(responseValue.appExposuresCashInvest).length : 0);

                    if (count > 0 && countTotal > 0) {
                        var LastModifiedDate = null;
                        LastModifiedDate = responseValue.appExposuresCashInvest[0].LastRefreshDate;

                        component.set("v.lastRefresh", LastModifiedDate);
                        component.set('v.total', responseValue.Total[0]);
                        component.set("v.appExposuresCashInvest", responseValue.appExposuresCashInvest);
                    }

                }
            }
        });
        $A.enqueueAction(action);
    },
})