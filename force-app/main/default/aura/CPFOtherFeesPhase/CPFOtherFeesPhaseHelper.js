({
    removeotherfees: function (component) {
        component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
        var appOtherFeesId= component.get("v.appOtherFeesIdFaci");

        console.log('appOtherFeesId'+appOtherFeesId);
        var action = component.get("c.delAppFeesRec");
        action.setParams({
            "appOtherFeesId": appOtherFeesId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
            }
            else if (state == 'ERROR') {
                var errors = response.getError();
            }
        });
        $A.enqueueAction(action);
        
    },
    
    
    
})