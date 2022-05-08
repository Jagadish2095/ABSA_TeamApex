({
	doInit : function(component, event, helper) {
       helper.getUnlimSecurityofferedCpfRec(component, event, helper);
    },
    addNewUnLimitedGuarantee: function (component, event, helper) {
        component.set("v.showSpinner", true);
            helper.addUnLimitedGuarantee(component, event);
        },
    handleApplicationEvent : function(component, event,helper) {
        var appPrdctCpfRecId = event.getParam("appPrdctCpfRecId");
        var unlimitedrowinex =event.getParam("UnlimitedRowIndex");
        var unlimitedGauranteelist=component.get("v.newUnLimitedGaurantee");
        unlimitedGauranteelist.splice(unlimitedrowinex,1);
         component.set("v.newUnLimitedGaurantee",unlimitedGauranteelist);
    },
    handleUnlimitedSubmit : function(component, event, helper) {
         component.set("v.showSpinner", true);
         var itemsToPass=component.get("v.newUnLimitedGaurantee");
         var item;
         var checkStatus = false;
        var securitiessections=component.get("v.isunLimited");
        // $A.util.isEmpty(oppRec)
        console.log('itemsToPass==='+itemsToPass);
        
        if(securitiessections =='Existing'){
        for (var i=0; i< itemsToPass.length; i++)
        {
          
             item = itemsToPass[i];
             if(item.Suretyship_name__c=='' || item.Suretyship_name__c==undefined || item.Suretyship_registration_number__c=='' || item.Suretyship_registration_number__c==undefined ||
              item.Session_of_claims_and_loans_accounts__c==''  || item.Date_registered__c=='' || item.Date_registered__c==undefined  || item.Include_address__c=='' || item.Include_address__c==undefined){ //|| item.Session_of_claims_and_loans_accounts__c==undefined
                checkStatus = true;
            }
            if(item.To_be_released__c=='Yes'){
                 if(item.When_to_release_months__c=='' || item.When_to_release_months__c==undefined || item.Release_condition__c==''){
                     checkStatus = true;}
            }
           /* if(item.Include_address__c=='Yes'){
                 if(item.Suretyship_email_address_for_notices__c=='' || item.Suretyship_email_address_for_notices__c==undefined || item.Address_line_1__c=='' || item.Address_line_1__c==undefined || item.Suburb__c=='' || item.Suburb__c==undefined || item.City__c=='' || item.City__c==undefined || item.Postal_Code__c=='' || item.Postal_Code__c==undefined || item.Country__c=='' || item.Country__c==undefined){
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
            helper.InsertunLimitedforExistingCpf(component, event, helper);
        }
    }
    },
})