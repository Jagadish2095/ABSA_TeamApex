({
    doInit : function(component, event, helper) {
       helper.getAppProdRec(component,helper);
    },
	save : function(component, event, helper) {
     
      var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": " details saved successfully!",
            "type": "success",
            "duration": 1500
        });
        toastEvent.fire();
         
        $A.get("e.force:refreshView").fire();
	},
    decisionChanged : function(component, event, helper) {
        var OrderType = event.getParam("value");
        if(OrderType == 'Fixed'){
            component.set("v.DebitOrderType", 'Fixed');
        } else if(OrderType == 'Debit'){
            component.set("v.DebitOrderType", 'Debit');
        }
    },
      
})