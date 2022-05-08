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

        if (component.get("v.selTabId") == "New To Bank") {
            component.set("v.showNTB", false);
            return 'FIC New to Bank (NTB)'
        }
        if (component.get("v.selTabId") == 'New To Product') {
            component.set("v.showNTP", false);
            return 'FIC New to Product (NTP)'
        }
        if (component.get("v.selTabId") == 'Maintenance') {
            component.set("v.showMaintenance", false);
            return 'FIC Maintenance'
        }
        if (component.get("v.selTabId") == 'Referral') {
            component.set("v.showReferral", false);
            return 'FIC Referral'
        }
        if (component.get("v.selTabId") == 'Dispute') {
            component.set("v.showDispute", false);
            return 'FIC Dispute'
        }
        if (component.get("v.selTabId") == 'Remediation') {
            component.set("v.showRemediation", false);
            return 'FIC Remediation'
        }
        if (component.get("v.selTabId") == 'New Request') {
            component.set("v.showNewRequest", false);
            return 'New Request'
        }
        if (component.get("v.selTabId") == 'Unassigned') {
            component.set("v.showUnassigned", false);
            return 'Unassigned'
        }
        if (component.get("v.selTabId") == 'Awaiting documents') {
            component.set("v.showAwaitingDocuments", false);
            return 'Awaiting Documents'
        }
        if (component.get("v.selTabId") == 'Archive') {
            component.set("v.showArchived", false);
            return 'Archive'
        }
        if (component.get("v.selTabId") == 'Assigned') {
            component.set("v.showAssigned", false);
            return 'Assigned'
        }
         if (component.get("v.selTabId") == 'My Cases') {
              component.set("v.showUserCases", false);
             return 'My Cases'
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