({
    getAppPrdctCpfRec :function(component, event, helper) {
        var action = component.get("c.getAppProdctCpfRec");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var appPrdctCpfRec = response.getReturnValue();
                console.log("appPrdctCpfRec: " + JSON.stringify(appPrdctCpfRec));
                if(appPrdctCpfRec != undefined && appPrdctCpfRec != ''){
                    component.set("v.appPrdctCpfRec", appPrdctCpfRec);
                    }
                if(appPrdctCpfRec.Late_bond_registration_penalty__c != undefined && appPrdctCpfRec.Late_bond_registration_penalty__c != ''){
                    component.set("v.latebondreg", appPrdctCpfRec.Late_bond_registration_penalty__c);
                }
                if(appPrdctCpfRec.Cancellation_after_acceptance_clause__c != undefined && appPrdctCpfRec.Cancellation_after_acceptance_clause__c != ''){
                    component.set("v.cancellationacceptclause", appPrdctCpfRec.Cancellation_after_acceptance_clause__c);
                }
                if(appPrdctCpfRec.Are_breakage_costs_applicable__c != undefined && appPrdctCpfRec.Are_breakage_costs_applicable__c != ''){
                    component.set("v.breakagecost", appPrdctCpfRec.Are_breakage_costs_applicable__c);
                }
                if(appPrdctCpfRec.Was_a_desktop_valuation_done__c != undefined && appPrdctCpfRec.Was_a_desktop_valuation_done__c == 'No'){
                    component.set("v.renderfield",true);
                }

            }else {
                console.log("Failed with state: " + JSON.stringify(appPrdctCpfRec));
            }
        });
        $A.enqueueAction(action);
    },
    updateAppPrdctcpf : function(component, event, helper) {
        var action = component.get("c.updateAppPrdctcpfPhase");
        action.setParams({
        "oppId": component.get("v.recordId"),
        "earlytermfees":component.find("earlytermfees").get("v.value"),
        "latebondreg":component.get("v.latebondreg"),
        "cancellationacceptclause":component.get("v.cancellationacceptclause"),
        "breakagecost":component.get("v.breakagecost")
        });
        action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS"){
        var appcpfrec = response.getReturnValue();
        console.log('appcpfrec---'+JSON.stringify(appcpfrec));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
        "title": "Success!",
        "type":"success",
        "message": "Application Product CPF record updated Successfully"
        });
        toastEvent.fire();
        } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
        if (errors[0] && errors[0].message) {
        console.log("Error message: " +errors[0].message);
        }
        }else{
        console.log("Unknown error");
        }
        }
        });
        $A.enqueueAction(action);

    },

})