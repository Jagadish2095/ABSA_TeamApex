({
    doInit: function(component, event, helper) {
        console.log('doint....');
        component.set("v.showSpinner",true);
        helper.checkUserAccess(component);
    },
    onLoad: function(component, event, helper) {
        console.log('onload caling..');    
        helper.checkFieldValidations(component,event);
    },
    handleOnSubmit : function(component, event, helper) {
        var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);        
        var picklists = component.find('selectField');
        for(var i=0;i<picklists.length;i++){
            picklists[i].validationDR();
        }
        if(allValid
           && component.get("v.oppLineItem.appProduct.Term_Of_Investment__c") != undefined
           && component.get("v.oppLineItem.appProduct.Discretionary_Money_Voluntary__c") != undefined
           && component.get("v.oppLineItem.appProduct.Income_Source__c") != undefined
           && component.get("v.oppLineItem.financialProduct.Source_of_Funds__c") != undefined
          ){
            console.log('valid..');
            component.set("v.showSpinner",true);
            component.set("v.oppLineItem.opportunity.Sys_BypassValidation__c",true);
            component.set("v.oppLineItem.opportunity.Sub_Status__c","Recommendation Stage");
            console.log(component.get("v.oppLineItem.appProduct.Reduction_Amount__c"));
            if(component.get("v.oppLineItem.appProduct.Reduction_Amount__c") === 0){
                console.log('is true');
                component.set("v.oppLineItem.appProduct.Reduction_Amount__c",null);
            }
            helper.updateOpportunityLineItem(component);
        } 
        
    },
    SaveProduct : function(component, event, helper) {
        component.set("v.showSpinner",true);
        var product = component.get("v.selectedProductRecord");
        if(product != null && product != undefined){
            var newProduct = component.get("v.selectedProductRecord").Id;
            var oldProduct = component.get("v.oppLineItem.lineItem.Product2Id");
            console.log('Selected Product is'+newProduct);
            console.log('Previous Prod: ',oldProduct);
            if(newProduct != oldProduct){
                helper.saveSelectedProduct(component, event, helper);
            }
            else{
                component.set("v.showSpinner",false);
            	helper.invoketostMessage(component,"warning","Please Select different Product Before Saving!","sticky",false);
            }                        
        }
        else{
            component.set("v.showSpinner",false);
            helper.invoketostMessage(component,"warning","Please Select a Product Before Saving!","sticky",false);
        }        
    },
    handleComponentEvent : function(component, event, helper) {
        var type = event.getParam("selectedValue");
        if(type === 'Recurring / Lump Sum'){
            component.set("v.visibleField",'slds-show');
            component.set("v.oppLineItem.appProduct.Reduction_Amount__c",'');
        }
        else{
            component.set("v.visibleField",'slds-hide');
            component.set("v.oppLineItem.appProduct.Reduction_Amount__c",0);
        }
    }
})