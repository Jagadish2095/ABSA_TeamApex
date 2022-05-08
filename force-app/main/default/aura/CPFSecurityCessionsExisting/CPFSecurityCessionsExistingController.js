({
    doInit : function(component, event, helper) {
        helper.getSecurityofferedCpfRec(component, event, helper);
    },
    addNewSecurityCessions: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isLimited", true);
        helper.addNewSecurityCessions(component, event);
    },
    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var rowinex =event.getParam("RowIndex");
        var newSecurityCessionlist=component.get("v.newSecurityCessions");
        newSecurityCessionlist.splice(rowinex,1);
        component.set("v.newSecurityCessions",newSecurityCessionlist);
    },
    handleSubmit : function(component, event, helper) {
        component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newSecurityCessions");
        var item;
        var checkStatus = false;
        console.log('itemsToPass=== scuritycession'+JSON.stringify(itemsToPass));
        /* var securitiessections=component.get("v.isLimited");
        if(securitiessections =='New'){ */
      /*  for (var i=0; i< itemsToPass.length; i++)
        {
            
            item = itemsToPass[i];
            
            if(item.Type__c=='Single date Borrower cession' || item.Type__c=='Single date other cedent cession'){
                if(item.Lease_and_rentals_of_property__c=='' || item.Lease_and_rentals_of_property__c==undefined ||
                   item.Proceeds_in_respect_of_sale_or_transfer__c=='' || item.Proceeds_in_respect_of_sale_or_transfer__c==undefined || item.Revenues_in_respect_of_property__c=='' || item.Revenues_in_respect_of_property__c==undefined || item.Claims_in_respect_of_insurance__c=='' || item.Claims_in_respect_of_insurance__c==undefined ||
                   item.Book_debts_and_other_debt_claims__c=='' || item.Book_debts_and_other_debt_claims__c==undefined || item.VAT_reimbursement_and_payments__c=='' || item.VAT_reimbursement_and_payments__c==undefined ||
                   item.Investments_and_or_other_deposits__c=='' || item.Investments_and_or_other_deposits__c==undefined ){
                    checkStatus = true;console.log("Borrowe "+checkStatus);}
            }
            if(item.Type__c=='Multiple dates other cedent cession' || item.Type__c=='Multiple dates Borrower cession'){
                if(item.Lease_and_rentals_Property__c=='' || item.Lease_and_rentals_Property__c	==undefined ||
                   item.Proceeds_in_respect_sale_or_transfer__c=='' || item.Proceeds_in_respect_sale_or_transfer__c==undefined || item.Proceeds_in_respect_sale_or_transfer__c==null || item.Revenues_in_respect_property__c=='' || item.Revenues_in_respect_property__c==undefined || item.Revenues_in_respect_property__c==null || item.Claims_in_respect_insurance__c==null || item.Claims_in_respect_insurance__c=='' || item.Claims_in_respect_insurance__c==undefined ||
                   item.Book_debts_and_other_debt_claim__c=='' || item.Book_debts_and_other_debt_claim__c==undefined || item.Book_debts_and_other_debt_claim__c==null || item.VAT_reimbursement_and_payment__c=='' ||item.VAT_reimbursement_and_payment__c==null || item.VAT_reimbursement_and_payment__c==undefined ||
                   item.Investments_and_or_other_deposit__c=='' || item.Investments_and_or_other_deposit__c==undefined || item.Investments_and_or_other_deposit__c==null ){
                    checkStatus = true;console.log("Borrowe "+checkStatus);} 
            }
            if(item.Type__c=='Shareholders / members cessions' || item.Type__c=='Other cedent cession' || item.Type__c=='Pledges and cession' || item.Type__c=='Single date other cedent cession' || item.Type__c=='Multiple dates other cedent cession'){
                if(item.Cedent_name__c=='' || item.Cedent_name__c==undefined || item.Cedent_registration_number__c=='' || item.Cedent_registration_number__c==undefined){
                    checkStatus = true;}
            }
            if( item.Type__c=='Pledges and cession' || item.Type__c=='Single date other cedent cession'){
                if(item.Pledge_and_cession_of__c==''  || item.Date_registered__c=='' || item.Date_registered__c==undefined){
                    checkStatus = true;}
            }
            if( item.Type__c=='Pledges and cession' || item.Type__c=='Shareholders / members cessions' ){
                if(item.Entity_name__c=='' || item.Entity_name__c==undefined || item.Entity_registration_Identification_num__c=='' || item.Entity_registration_Identification_num__c==undefined){
                    checkStatus = true;}
            }
            if(  item.Type__c=='Shareholders / members cessions' ){
                if(item.Loan_accounts_by__c==''  || item.Date_registered__c=='' || item.Date_registered__c==undefined){
                    checkStatus = true;}
            }
            if(  item.Type__c=='Other cession' ){
                if(item.Details__c=='' || item.Details__c==undefined){
                    checkStatus = true;}
            }
            
        }
        if(checkStatus ==true){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "error!",
                "type":"Error",
                "message": "Please select at least 2 options"
            });
            toastEvent.fire();
            component.set("v.showSpinner", false);
        }else{
            helper.InsertNewSecurityCessionRecCpf(component, event, helper);
        }
        // } */
                    helper.InsertNewSecurityCessionRecCpf(component, event, helper);

    },
    
})