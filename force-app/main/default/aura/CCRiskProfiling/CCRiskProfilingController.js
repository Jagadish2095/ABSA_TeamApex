({
    riskProfiling : function(component, event, helper) {
         var promise = helper.riskProfiling(component, helper)
        .then(
            $A.getCallback(function(result) {
                var showMou = false;
                if (result == "High" || result == "Very High") {
                    showMou = true;
                }
                if (result.startsWith("Error")) {
                    helper.handleError(component, result);
                } else {
                    component.set("v.riskStatus", result);
                    helper.handleSuccess(component, showMou);
                }
            }),
            $A.getCallback(function(error) {
                helper.handleError(component, error);
            })
        )
    }
})