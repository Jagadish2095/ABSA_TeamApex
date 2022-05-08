({
	doinit: function (component, event, helper) {
        var caseId=component.get("v.recordId");
        var action = component.get("c.updateSecurities");
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                console.log('serviceResponse'+serviceResponse);
                component.set('v.securityId',serviceResponse.SecurityId__c);
            }
                });
        $A.enqueueAction(action);
    },
})