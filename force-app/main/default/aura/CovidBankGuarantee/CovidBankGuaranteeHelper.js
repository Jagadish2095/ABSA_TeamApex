({
	 linkAccountToClient: function (component, event) {
       // this.showSpinner(component);
        var action2 = component.get("c.linkStockNumberToCIF");

        action2.setParams({
            "oppId": component.get("v.recordId")
        });
        action2.setCallback(this, function (response) {
            var state = response.getState();
            var toastEvent;

            if (state == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue.toUpperCase() == 'SUCCESS') {
                   // toastEvent = this.getToast("Success!", responseValue, "success");
                }
                else {
                    //toastEvent = this.getToast("Info!", responseValue, "info");
                }
            }
        });

        $A.enqueueAction(action2);
    },
    getAppProdRec: function (component,helper) {
        
       // component.set("v.showSpinner", true);
        var action = component.get("c.getAppProductdetails");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });    
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var appProdRec = response.getReturnValue();
                if(appProdRec != null){
                    component.set("v.stockNumber",appProdRec.Account_Number__c);
                }else {
                }
                
            } else {
            }
         //   component.set("v.showSpinner", false);
        });
        
        $A.enqueueAction(action);
        
    },
})