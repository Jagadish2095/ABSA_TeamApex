({
    doInit : function(component, event, helper) {
        helper.getUnlimSecurityofferedCpfRec(component, event, helper);
        helper.getopplineitemRec(component, event, helper);
    },
    addNewUnLimitedGuarantee: function (component, event, helper) {
        component.set("v.showSpinner", true);
        component.set("v.isShowAppCPFFields",true);
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
        if(securitiessections =='New'){
            for (var i=0; i< itemsToPass.length; i++)
            {
                item = itemsToPass[i];
                if(item.Mortgage_bond_type__c=='' || item.Mortgage_bond_type__c==undefined){
                    checkStatus = true;
                }
                if(item.Mortgage_bond_type__c =='Registration of mortgage bond by borrower'){
                    if(item.CPA_document_version__c=='' || item.Property_description__c=='' || item.Property_description__c==undefined ||
                       item.Property_ranking__c=='' || item.Property_ranking__c==undefined || item.Mortgage_bond_amount__c=='' || item.Mortgage_bond_amount__c==undefined){
                        checkStatus = true;}
                }
            }
            if(checkStatus ==true){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"Error",
                    "message": "Please complete all required fields"
                });
                toastEvent.fire();
                component.set("v.showSpinner", false);
            }else{
                helper.InsertUnlimitedSecurityOfferedCpf(component, event, helper);
            }
        }
        if(securitiessections =='Existing'){
            for (var i=0; i< itemsToPass.length; i++)
            {
                
                item = itemsToPass[i];
                if(item.Mortgage_bond_type__c=='' || item.Mortgage_bond_type__c==undefined){
                    checkStatus = true;
                }
                if(item.Mortgage_bond_type__c =='Registration of mortgage bond by borrower'){
                    if(item.Date_registered__c=='' || item.Date_registered__c==undefined || item.Property_description__c=='' || item.Property_description__c==undefined ||
                       item.Property_ranking__c=='' || item.Property_ranking__c==undefined || item.Mortgage_bond_amount__c=='' || item.Mortgage_bond_amount__c==undefined){
                        checkStatus = true;}
                }
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