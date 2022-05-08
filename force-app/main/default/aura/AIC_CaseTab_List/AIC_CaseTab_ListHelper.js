({
    getCase: function(component, event, helper) {
        let action = component.get("c.findCases");
        let keyForSearch = component.find("searchKey").get("v.value");
        action.setParams({
            "searchKeyWord": keyForSearch
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    console.log(responseData)
                    let caseFromGlobalSearch = responseData
                    caseFromGlobalSearch.forEach(function(caseFromGlobalSearch) {
                        caseFromGlobalSearch.linkName = '/' + caseFromGlobalSearch.Id;
                    });
                    component.set("v.CasesFromGlobalSearch", responseData)
                }else{
                    component.set("v.CasesFromGlobalSearch", []);
                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getCaseFromQueue: function(component, event, helper) {
        let action = component.get("c.getCasFromParticularQueue");
        action.setParams({
            "queueName": this.getTabName(component, event, helper),
            "searchKeyWord": component.get("v.CaseKeyLocalSearch"),
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    console.log(responseData)
                    let caseFromGlobalSearch = responseData
                    caseFromGlobalSearch.forEach(function(caseFromGlobalSearch) {
                        caseFromGlobalSearch.linkName = '/' + caseFromGlobalSearch.Id;
                        caseFromGlobalSearch.recordType = caseFromGlobalSearch.RecordType.Name;
                    });
                    component.set("v.CasesFromLocalSearch", responseData)


                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getArchiveCaseFromQueue: function(component, event, helper) {
        let action = component.get("c.findArchiveCases");
        action.setParams({
            "queueName": this.getTabName(component, event, helper),
            "searchKeyWord": component.get("v.CaseKeyLocalSearch"),
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    console.log(responseData)
                    let caseFromGlobalSearch = responseData
                    caseFromGlobalSearch.forEach(function(caseFromGlobalSearch) {
                        caseFromGlobalSearch.linkName = '/' + caseFromGlobalSearch.Id;
                    });
                    component.set("v.CasesFromLocalSearch", responseData)


                }
                component.set("v.CasesFromLocalSearch", responseData)


            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getTabName: function(component, event, helper) {

        if (component.get("v.selTabId") == 'Prodcut Manager') {
            component.set("v.showProductManager", false);
            return 'Product Manager AIC'
        }    
        if (component.get("v.selTabId") == 'Voice Outbound') {
            component.set("v.showVoiceOutbound", false);
            return 'Voice Outbound AIC'
        }
        if (component.get("v.selTabId") == 'Unassigned') {
            component.set("v.showUnassigned", false);
            return 'Unassigned AIC'
        }
        if (component.get("v.selTabId") == 'Verification') {
            component.set("v.showVerification", false);
            return 'Verification AIC'
        }
        if (component.get("v.selTabId") == 'Junk') {
            component.set("v.showJunk", false);
            return 'Junk AIC'
        }
        if (component.get("v.selTabId") == 'Awaiting documents') {
            component.set("v.showAwaitingDocuments", false);
            return 'Awaiting Documents AIC'
        }
        if (component.get("v.selTabId") == 'Archive') {
            component.set("v.showArchived", false);
            return 'Archive AIC'
        }
        if (component.get("v.selTabId") == 'Assigned') {
            component.set("v.showAssigned", false);
            return 'Assigned AIC'
        }
    },

    checkUser: function(component, event, helper) {
        let action = component.get("c.isSuperUser");

        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();

            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                  if(responseData === true){
                      component.set("v.superUser", true);
                  }

                }

            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})