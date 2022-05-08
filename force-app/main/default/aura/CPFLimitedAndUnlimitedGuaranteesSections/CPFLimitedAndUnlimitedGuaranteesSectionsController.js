({
	doInit : function(component, event, helper) {
       helper.getSecurityofferedCpfRec(component, event, helper);
    },
    addNewLimitedGuarantee: function (component, event, helper) {
        component.set("v.showSpinner", true);
       // component.set("v.isLimited", true);
            helper.addLimitedGuarantee(component, event);
        },
    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
         var rowinex =event.getParam("RowIndex");
        var limitedGauranteelist=component.get("v.newLimitedGaurantee");
       limitedGauranteelist.splice(rowinex,1);
         component.set("v.newLimitedGaurantee",limitedGauranteelist);
       },
    handleSubmit : function(component, event, helper) {
        debugger;
         component.set("v.showSpinner", true);
        var itemsToPass=component.get("v.newLimitedGaurantee");
        var item;
        var checkStatus = false;
        console.log('itemsToPass==='+JSON.stringify(itemsToPass));
        var securitiessections=component.get("v.isLimited");
        if(securitiessections =='New'){
        for (var i=0; i< itemsToPass.length; i++)
        {
          
             item = itemsToPass[i];
                     
            if(item.Guarantor_name__c=='' || item.Guarantor_name__c==undefined || item.Guarantor_registration_number__c=='' || item.Guarantor_registration_number__c==undefined ||
              item.Session_of_claims_and_loans_accounts__c==''  || item.CPA_document_version__c==''  || item.Include_address__c=='' || item.Include_address__c==undefined || item.Amount__c=='' || item.Amount__c==undefined){//|| item.Session_of_claims_and_loans_accounts__c==undefined
                checkStatus = true;
            }
             if(item.To_be_released__c=='Yes'){
                 if(item.When_to_release_months__c=='' || item.When_to_release_months__c==undefined || item.Release_condition__c==''){
                     checkStatus = true;}
            }
        /*    if(item.Include_address__c=='Yes'){
                 if( item.Address_line_1__c=='' || item.Address_line_1__c==undefined || item.Suburb__c=='' || item.Suburb__c==undefined || item.City__c=='' || item.City__c==undefined || item.Postal_Code__c=='' || item.Postal_Code__c==undefined || item.Country__c=='' || item.Country__c==undefined){
                     checkStatus = true;}
            }*/
        }
        if(checkStatus ==true){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                    toastEvent.fire();
            component.set("v.showSpinner", false);
        }else{
            helper.InsertLimitedSecurityOfferedCpf(component, event, helper);
        }
    }
        if(securitiessections =='Existing'){
        for (var i=0; i< itemsToPass.length; i++)
        {
          
             item = itemsToPass[i];
            
            if(item.Guarantor_name__c=='' || item.Guarantor_name__c==undefined || item.Guarantor_registration_number__c=='' || item.Guarantor_registration_number__c==undefined ||
              item.Session_of_claims_and_loans_accounts__c=='' || item.Date_registered__c==''  || item.Amount__c=='' || item.Amount__c==undefined || item.Include_address__c=='' ){ //|| item.Date_registered__c==undefined|| item.Include_address__c==undefined  || item.Session_of_claims_and_loans_accounts__c==undefined
                checkStatus = true;
            }
            if(item.To_be_released__c=='Yes'){
                 if(item.When_to_release_months__c=='' || item.When_to_release_months__c==undefined || item.Release_condition__c==''){
                     checkStatus = true;}
            }
        /*    if(item.Include_address__c=='Yes'){
                 if( item.Address_line_1__c=='' || item.Address_line_1__c==undefined || item.Suburb__c=='' || item.Suburb__c==undefined || item.City__c=='' || item.City__c==undefined || item.Postal_Code__c=='' || item.Postal_Code__c==undefined ){ //|| item.Country__c==undefined || item.Country__c=='' 
                     checkStatus = true;} //item.Guarantor_email_address_for_notices__c=='' || item.Guarantor_email_address_for_notices__c==undefined ||
            }*/
        }
        if(checkStatus ==true){
            var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                    toastEvent.fire();
            component.set("v.showSpinner", false);
        }else{
            helper.InsertLimitedforExistingCpf(component, event, helper);
        }
    }
     },
    
})