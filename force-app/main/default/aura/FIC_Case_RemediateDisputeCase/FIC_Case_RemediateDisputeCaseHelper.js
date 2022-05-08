({
    getCase: function(component, event, helper) {
        let action = component.get("c.getCase");
        action.setParams({
            "caseId":component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.Case', responseData);
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

    
    handleDispute: function(component, event, helper) {
       let reason = component.find("disputeCommentsID");       
       let action = component.get("c.updateDisputeCase");
       let caseToPass = component.get("v.Case");
       caseToPass.FIC_Dispute_Comments__c = reason.get("v.value")       
       caseToPass.Status = 'Re-Open'
        action.setParams({
            "caseToAssign": caseToPass
        });
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.Case', responseData);
                }
                component.set("v.openDispute", false);

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
    
    handleRemediate: function(component, event, helper) {
       let action = component.get("c.enrouteCase");
       let caseToPass = component.get("v.Case");
       var now  =  new Date();
       //caseToPass.FIC_Dispute_Comments__c = reason.get("v.value")       
       //caseToPass.Status = 'Re-Open';
        if (caseToPass.Previous_Owner__c = 'FIC_New_to_Bank_NTB' && ( $A.localizationService.formatDate(now)- caseToPass.FIC_DateTimeMovedToRemediationQueue__c  < 6 )){ 
            console.log('Time difference is '+$A.localizationService.formatDate(now)- caseToPass.FIC_DateTimeMovedToRemediationQueue__c);
            action.setParams({
                "caseToAssign"  : caseToPass,
                "NameofQueue" : caseToPass.FIC_New_to_Bank_NTB
            });
            }
            
                else if (caseToPass.Previous_Owner__c = 'FIC_New_to_Product_NTP' && ( $A.localizationService.formatDate(now)- caseToPass.FIC_DateTimeMovedToRemediationQueue__c  < 6 )){ 
                action.setParams({
                    "caseToAssign"  : caseToPass,
                    "NameofQueue" : caseToPass.FIC_New_to_Product_NTP
                });
                }
                    else {
                        action.setParams({
                        "caseToAssign"  : caseToPass,
                        "NameofQueue" : caseToPass.FIC_Maintenance
                    });
                        
                    }
        action.setCallback(this, function(response) {
            let state = response.getState();
            let responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(responseData)) {
                    component.set('v.Case', responseData);
                }
                component.set("v.openDispute", false);

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