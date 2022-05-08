({
	addLimitedGuarantee : function(component, event) {
        var limitedGuarlist = component.get("v.newLimitedGaurantee");
        if(component.get("v.isLimited") == 'New'){
        limitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Guarantor_name__c' : '',
            'Include_address__c' :'Yes',
            'To_be_released__c':'No'
            
        });
        }
        if(component.get("v.isLimited") == 'Existing'){
        limitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Guarantor_name__c' : '',
            'Include_address__c' :'No',
            'To_be_released__c':'No'

        });
        }
        component.set("v.newLimitedGaurantee",limitedGuarlist);   
        component.set("v.showSpinner", false);
    },
    
    InsertLimitedSecurityOfferedCpf : function(component, event, helper) {
        
        console.log('newLimitedGaurantee=='+JSON.stringify(component.get("v.newLimitedGaurantee")));
       
        var action = component.get("c.InsertLimitedSecurityOfferedCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "LimitedGauranteelist" : component.get("v.newLimitedGaurantee"),
            "secSections" : component.get("v.isLimited"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
             //  console.log('oppRec---'+JSON.stringify(oppRec[0].Guarantor_name__c));
               // $A.util.isEmpty(oppRec)
                
			
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
   InsertLimitedforExistingCpf : function(component, event, helper) {
        
        console.log('newLimitedGaurantee=='+JSON.stringify(component.get("v.newLimitedGaurantee")));
       
        var action = component.get("c.InsertLimitedExistingCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "LimitedGauranteelistforExisting" : component.get("v.newLimitedGaurantee"),
            "secSectionsforExisting" : component.get("v.isLimited"),
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var AppOffRecforexisting = response.getReturnValue();
               console.log('AppOffRecforexisting---'+JSON.stringify(AppOffRecforexisting));
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
        var action = component.get("c.getSecurityofferedRec");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
             "secSectionsfetch" : component.get("v.isLimited"),
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
               // var securityoffRec = response.getReturnValue();
                component.set("v.newLimitedGaurantee",response.getReturnValue());
            }else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
               // console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
})