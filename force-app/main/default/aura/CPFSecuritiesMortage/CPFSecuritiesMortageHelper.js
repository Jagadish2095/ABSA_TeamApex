({
	addUnLimitedGuarantee : function(component, event) {
        var unlimitedGuarlist = component.get("v.newUnLimitedGaurantee");
        unlimitedGuarlist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Mortgage_bond_type__c':'Registration of mortgage bond by borrower'

        });
        component.set("v.newUnLimitedGaurantee",unlimitedGuarlist);
        component.set("v.showSpinner", false);
    },
    InsertUnlimitedSecurityOfferedCpf : function(component, event, helper) {
        var bankConvrContactDetail = component.get("v.bankConvrContactDetail");
        var bankConvrContactPerson = component.get("v.bankConvrContactPerson");
        var bankConvrFirmDetails = component.get("v.bankConvrFirmDetails");
        console.log('newUnLimitedGaurantee=='+JSON.stringify(component.get("v.newUnLimitedGaurantee")));
        var action = component.get("c.InsertUnlimitedSecurityOfferedCpfRec");
        action.setParams({
            "recId" : component.get("v.recordId"),
            "UnLimitedGauranteelist" : component.get("v.newUnLimitedGaurantee"),
            "secSections" : component.get("v.isunLimited"),
            "bankConvrContactDetail":bankConvrContactDetail,
            "bankConvrContactPerson":bankConvrContactPerson,
            "bankConvrFirmDetails":bankConvrFirmDetails
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
                var AppSecforUnlimitedRec = response.getReturnValue();
                console.log(":getUnlimitedSecurityofferedRec " + JSON.stringify(AppSecforUnlimitedRec));
                component.set("v.newUnLimitedGaurantee",AppSecforUnlimitedRec.APPSECURITYCPF);
                if(AppSecforUnlimitedRec != null && AppSecforUnlimitedRec != '' && AppSecforUnlimitedRec.APPPRODUCTCPF !=null && AppSecforUnlimitedRec.APPPRODUCTCPF !='' ){
                if(AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_details__c != null && AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_details__c != '')
                {component.set("v.bankConvrContactDetail",AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_details__c);
                 component.set("v.isShowAppCPFFields",true);}
                if(AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_person__c != null && AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_person__c != '')
                {component.set("v.bankConvrContactPerson",AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_contact_person__c);
                component.set("v.isShowAppCPFFields",true);}
                if(AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_firm_details__c != null && AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_firm_details__c != '')
                { component.set("v.bankConvrFirmDetails",AppSecforUnlimitedRec.APPPRODUCTCPF.Bank_conveyancer_firm_details__c);
                  component.set("v.isShowAppCPFFields",true);}
                }
            }else {
                console.log("Failed with state: " + JSON.stringify(AppSecforUnlimitedRec));
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": "Please select CPF product."
                });
                    toastEvent.fire();
            }
        });

        $A.enqueueAction(action);
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);

            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });

        $A.enqueueAction(action);
    },
    getopplineitemRec :function(component, event, helper) {
        var action = component.get("c.getprodName");
        var oppRecId=component.get("v.recordId");
        action.setParams({
            "oppId": component.get("v.recordId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var getprodNamelst = response.getReturnValue();
                console.log(":getprodName " + JSON.stringify(getprodNamelst));
                component.set("v.prodName",getprodNamelst[0].Product_Name__c);
                
            }else {
                console.log("Failed with state: " + JSON.stringify(getprodNamelst));
            }
        });
        
        $A.enqueueAction(action);
    },
})