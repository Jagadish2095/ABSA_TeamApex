({
	addUnLimitedGuarantee : function(component, event) {
        var unlimitedGuarlist = component.get("v.newUnLimitedGaurantee");
        if(component.get("v.isunLimited") == 'New'){
        unlimitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Guarantor_name__c' : '',
            'Guarantor_registration_number__c' : '',
            'Include_address__c' : 'Yes',
            'To_be_released__c':'No'
        });
    	}
        if(component.get("v.isunLimited") == 'Existing'){
        unlimitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Guarantor_name__c' : '',
            'Guarantor_registration_number__c' : '',
            'Include_address__c' : 'No',
            'To_be_released__c':'No'

        });
    }
        component.set("v.newUnLimitedGaurantee",unlimitedGuarlist);   
        component.set("v.showSpinner", false);
    },
    InsertUnlimitedSecurityOfferedCpf : function(component, event, helper) {
        
        console.log('newUnLimitedGaurantee=='+JSON.stringify(component.get("v.newUnLimitedGaurantee")));
        var action = component.get("c.InsertUnlimitedSecurityOfferedCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "UnLimitedGauranteelist" : component.get("v.newUnLimitedGaurantee"),
             "secSections" : component.get("v.isunLimited"),
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
    InsertunLimitedforExistingCpf : function(component, event, helper) {
        
        console.log('newUnLimitedGaurantee=='+JSON.stringify(component.get("v.newUnLimitedGaurantee")));
        var action = component.get("c.InsertUnlimitedExistingCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "UnLimitedGauranteelistforExisting" : component.get("v.newUnLimitedGaurantee"),
             "secSectionsforexisting" : component.get("v.isunLimited"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var UnlimitedAppOffRecexisting = response.getReturnValue();
               console.log('UnlimitedAppOffRecexisting---'+JSON.stringify(UnlimitedAppOffRecexisting));
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
     getUnlimSecurityofferedCpfRec :function(component, event, helper) {
        var action = component.get("c.getUnlimitedSecurityofferedRec");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
             "secSectionsfetch" : component.get("v.isunLimited"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
              //  var AppSecforUnlimitedRec = response.getReturnValue();
              //  console.log(": AppSecforUnlimitedRec" + JSON.stringify(AppSecforUnlimitedRec));
                component.set("v.newUnLimitedGaurantee",response.getReturnValue());
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