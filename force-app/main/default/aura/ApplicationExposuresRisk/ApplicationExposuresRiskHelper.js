({
    
    loadApplicationRiskExposures: function (component, event, helper) {
        //component.set("v.showSpinner", true);
        var OpportunityId = component.get("v.oppId");

        var action = component.get("c.getApplicationRiskExposuresfromService");
        action.setParams({
            "oppID": OpportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                this.getWorstRiskGrade(component, event, helper);
            }

            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    getWorstRiskGrade: function (component, event, helper) {
        component.set("v.showSpinner", false);
        var action = component.get("c.getWorstRiskGrade");
        var OpportunityId = component.get("v.oppId");

        action.setParams({
            "oppID": OpportunityId
        });
        action.setCallback(this, function (res) {
            var state = res.getState();
            if (state === "SUCCESS") {
                var serviceResponse = res.getReturnValue();
                var ranCount = component.get("v.reLoadCount");
                console.log('getWorstRiskGrade::: ' + ranCount);

                if (!$A.util.isEmpty(serviceResponse['appRisk'])) {
                    component.set('v.riskCreated', true);
                    var appRisk = serviceResponse['appRisk'];
                    var appProfile = serviceResponse['appProfile'];
                    var LastModifiedDate = appRisk[0].LastModifiedDate;
                    component.set("v.lastRefresh", LastModifiedDate);
                    component.set("v.ApplicantExposuresRiskData", appRisk);
                    component.set("v.clientCodesandNames", appProfile);
                    component.set("v.showSpinner", false);
                    component.set("v.isReloaded", false);
                }
                /*
                else{
                    component.set("v.showSpinner", false);
                    setTimeout(
                        $A.getCallback(function () {
                            helper.reloadAppEx(component, Math.random())
                        }), 5000
                    );
                }
                */
                else if (ranCount < 6) {
                    setTimeout(
                        $A.getCallback(function () {
                            ranCount++;
                            helper.reloadAppEx(component, Math.random(), ranCount)
                        }), 10000
                    );
                }
                else if (ranCount >= 6) {
                    component.set("v.showSpinner", false);
                }
            }
            else {
                var errors = res.getError();
                console.log('errors' + errors[0].message);
            }

            //component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    reloadAppEx: function (component, random, ranCount) {
        component.set("v.isReloaded", true);
        component.set("v.reLoadCount", ranCount);
        component.set("v.reLoad", random);
    },
})