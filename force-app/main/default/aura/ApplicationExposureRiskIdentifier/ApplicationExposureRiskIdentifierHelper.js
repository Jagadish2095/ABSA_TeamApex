({
    loadApplicationRiskIdentifiers: function (component, event, helper) {
        //component.set("v.showSpinner", true);
        var OpportunityId = component.get("v.oppId");
        var action = component.get("c.getApplicationRiskIdentifiersfromService");
        action.setParams({
            "oppID": OpportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                if (serviceResponse) {
                    this.getWorstRiskIdentifier(component, event, helper);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getWorstRiskIdentifier: function (component, event, helper) {
        //component.set("v.showSpinner", true);
        var action = component.get("c.getWorstRiskIdentifier");
        var OpportunityId = component.get("v.oppId");
        action.setParams({
            "oppID": OpportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                var finalApplicationExposureRisk = serviceResponse['finalApplicationExposureRisk'];
                var ranCount = component.get("v.reLoadCount");
                console.log('getWorstRiskIdentifier::: ' + ranCount);

                if (!$A.util.isEmpty(finalApplicationExposureRisk)) {
                    if (finalApplicationExposureRisk[0].Risk_Identifier__c === true) {
                        var appProfile = serviceResponse['appProfile'];
                        var LastModifiedDate = finalApplicationExposureRisk[0].LastModifiedDate;
                        component.set("v.lastRefresh", LastModifiedDate);
                        component.set("v.finalApplicationExposureRisk", finalApplicationExposureRisk);
                        component.set("v.clientCodesandNames", appProfile);
                        component.set("v.showSpinner", false);
                    }
                    else if (ranCount < 6) {
                        setTimeout(
                            $A.getCallback(function () {
                                ranCount++;
                                helper.reloadAppEx(component, Math.random(), ranCount)
                            }), 15000
                        );
                    }
                    else if (ranCount >= 6) {
                        component.set("v.showSpinner", false);
                    }
                    /*else{
                        setTimeout(
                        $A.getCallback(function () {
                            //ranCount++;
                            helper.reloadAppEx(component, Math.random())
                        }), 5000
                    );}*/
                }
            }
            else {
                var errors = res.getError();
                console.log('errors' + errors[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    reloadAppEx: function (component, random, ranCount) {
        component.set("v.reLoadCount", ranCount);
        component.set("v.reLoad", random);
    },
})