({
	addNewSecurityCessions : function(component, event) {
        var securitycessionslist = component.get("v.newSecurityCessions");
        securitycessionslist.push({
            'sobjectType' : 'Application_Security_CPF__c',
            'Revenues_in_respect_of_property__c':'No',
            'Book_debts_and_other_debt_claims__c':'No',
            'VAT_reimbursement_and_payments__c':'No',
            'Investments_and_or_other_deposits__c':'No',
            'Lease_and_rentals_of_property__c':'Yes',
            'Proceeds_in_respect_of_sale_or_transfer__c':'Yes',
            'Claims_in_respect_of_insurance__c':'Yes',
            /*'CPA_document_version__c':'FULL CPA',
            'Loan_accounts_by__c':'Member(s)', */
            
        });
        component.set("v.newSecurityCessions",securitycessionslist);   
        component.set("v.showSpinner", false);
    },
    
    InsertNewSecurityCessionRecCpf : function(component, event, helper) {
        
        console.log('newSecurityCessions=='+JSON.stringify(component.get("v.newSecurityCessions")));
       
        var action = component.get("c.InsertNewSecurityCessionsCpfRec");
       action.setParams({
            "recId" : component.get("v.recordId"),
            "securitycessionslst" : component.get("v.newSecurityCessions"),
         /*   "leaseandrentalsofproperty":component.get("v.leaseandrentalsofproperty"),
           "proceedsinrespectofsaleortransfer":component.get("v.proceedsinrespectofsaleortransfer"),
           "revenuesinrespectofproperty":component.get("v.revenuesinrespectofproperty"),
           "claimsinrespectofinsurance":component.get("v.claimsinrespectofinsurance"),
           "bookdebtsandotherdebtclaims":component.get("v.bookdebtsandotherdebtclaims"),
           "VATreimbursementandpayments":component.get("v.VATreimbursementandpayments"),
           "investmentsandorotherdeposits":component.get("v.investmentsandorotherdeposits"), */
             
        });
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS"){
                var oppRec = response.getReturnValue();
               console.log('oppRec---'+JSON.stringify(oppRec));
                if($A.util.isEmpty(oppRec)){
                    
                    var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please Click on Add Security Cessions and give the Data before Save"
                });
                toastEvent.fire();
                }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "Application Security CPF record updated Successfully"
                });
                    toastEvent.fire();}
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
             
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var securityoffRec = response.getReturnValue();
                console.log("12345 security cesssion: " + JSON.stringify(securityoffRec));
                component.set("v.newSecurityCessions",response.getReturnValue());
            }else {
                console.log("Failed with state: " + JSON.stringify(securityoffRec));
            }
        });
        
        $A.enqueueAction(action);
    },
})