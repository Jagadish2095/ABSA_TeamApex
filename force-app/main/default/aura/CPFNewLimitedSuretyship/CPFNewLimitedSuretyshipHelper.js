({
    addLimitedGuarantee : function(component, event) {
        var limitedGuarlist = component.get("v.newLimitedGaurantee");
        limitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Suretyship_name__c' : '',
            'Include_address__c':'No',
            'To_be_released__c':'No'
            
            
        });
        component.set("v.newLimitedGaurantee",limitedGuarlist);   
        component.set("v.showSpinner", false);
    },
    
    InsertLimitedforNewCpf : function(component, event, helper,changeValue) {
        
        console.log('newLimitedGaurantee=='+JSON.stringify(component.get("v.newLimitedGaurantee")));
        //alert(component.get("v.isLimited"));
        var action = component.get("c.InsertLimitedNewCpfRec");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "LimitedSuretylistforNew" : component.get("v.newLimitedGaurantee"),
            "secSectionsforNew" : component.get("v.isLimited"),
            "istheSecurityProvideratrust":changeValue  //component.get("v.istheSecurityProvideratrust")
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var AppOffRecforNew = response.getReturnValue();
                console.log('AppOffRecforexisting---'+JSON.stringify(AppOffRecforNew));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Security CPF record updated Successfully"
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
        //alert(component.get("v.isLimited"));
        var action = component.get("c.getSecurityofferedRec");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
            "secSectionsfetch" : component.get("v.isLimited"),
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var securityoffRec = response.getReturnValue();
                console.log(":76666 " + JSON.stringify(securityoffRec));
                component.set("v.newLimitedGaurantee",response.getReturnValue());
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                toastEvent.fire();
                //console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
})