({
	 getAppProdRec: function (component,helper) {
        
        component.set("v.showSpinner", true);
        var action = component.get("c.getCaseApplicationProductRecord");
        action.setParams({
            "caseId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var appProdRec = response.getReturnValue();
                if(appProdRec != null){
                    console.log(" ---@@@@@ debitordertype : " + JSON.stringify(appProdRec.Debit_Order_Type__c));
                    component.set("v.appProduct",appProdRec);
                    if(appProdRec.Debit_Order_Type__c == 'Fixed' ){
                    component.set("v.DebitOrderType", 'Fixed');
                }else if(appProdRec.Debit_Order_Type__c == 'Debit' ){
                    component.set("v.DebitOrderType", 'Debit');
                }
                }else {
                    //this.showError(response, "No AppProd Record Found:");
                }
                
            } else {
                //this.showError(response, "Missing AppProd Record :");
            }
            component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    },
})