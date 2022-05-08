({
	addNewSecurityCessions : function(component, event) {
        var securitycessionslist = component.get("v.newOtherSecurities");
        securitycessionslist.push({
            'sobjectType' : 'Application_Security_CPF__c',
        });
        component.set("v.newOtherSecurities",securitycessionslist);
        component.set("v.showSpinner", false);
    },

    InsertOtherSecurityOfferedCpf : function(component, event, helper) {
        console.log('newUnLimitedGaurantee=='+JSON.stringify(component.get("v.newOtherSecurities")));
        var action = component.get("c.InsertExistingSecurityCessionsCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "securitycessionslst" : component.get("v.newOtherSecurities"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS"){
                var UnlimitedSecOffRec = response.getReturnValue();
               console.log('UnlimitedSecOffRec---'+JSON.stringify(UnlimitedSecOffRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Security offered CPF record updated Successfully"
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
           // this.hideSpinner(component);
           component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

     getSecurityofferedCpfRec :function(component, event, helper) {
        var action = component.get("c.getSecurityofferedRec");

        action.setParams({
            "oppId": component.get("v.recordId"),
            "securityclass":'Existing'
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var securityoffRec = response.getReturnValue();
                console.log(": " + JSON.stringify(securityoffRec));
                component.set("v.newOtherSecurities",response.getReturnValue());
            }else {
                console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        $A.enqueueAction(action);
    },
})