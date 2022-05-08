({
	setTobFields: function(component, event) {
        var action = component.get("c.getfWrapperListOrigination");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("field wrapper state---"+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.fieldWrapList",results);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    getAcceptedTOB : function(component,event){
        var action = component.get("c.getProductTOBOrigination");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results---'+JSON.stringify(results));
                component.set("v.appProdTobList",results);
                component.set("v.showSpinner",false);
            }
        });
        $A.enqueueAction(action);
    },
    
    getSelProduct: function(component, event) {
        var action = component.get("c.getSelectedProduct");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var SelectedProduct = response.getReturnValue();
                console.log('TOBSelectedProduct'+ JSON.stringify(SelectedProduct));
                var i;
                for (i=0; i < SelectedProduct.length; i++) {
                    console.log('product Name '+ SelectedProduct[i].Product_Name__c);
                    if(SelectedProduct[i].Product_Name__c !=null && SelectedProduct[i].Product_Name__c=='Overdraft'){
                        component.set("v.showChequeNOverdraft",true);
                        console.log('Cheque&Overdraft selected');
                    }else if(SelectedProduct[i].Product_Name__c !=null && SelectedProduct[i].Product_Name__c =='Credit Card'){
                        component.set("v.showCC",true);
                        console.log('Credit card selected');
                    }else if(SelectedProduct[i].Product_Name__c !=null && SelectedProduct[i].Product_Name__c == 'Term loan'){
                        component.set("v.showTL",true);
                        console.log('Term loans selected');
                    }else if(SelectedProduct[i].Product_Name__c !=null && SelectedProduct[i].Product_Name__c =='Bank Guarantee'){
                        component.set("v.showLDP",true);
                        console.log('LDP selected');
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
    },
})