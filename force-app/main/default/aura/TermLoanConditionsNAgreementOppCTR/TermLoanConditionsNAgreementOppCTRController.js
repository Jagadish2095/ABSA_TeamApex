({
    doInit : function(component, event, helper) {
        //call apex method to query appProdID from opportunity
        var action = component.get("c.getAppProduct");
        action.setParams({
            "oppId" : component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("response.getReturnValue()----"+response.getReturnValue());
            if (state == "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.appProdID",result.Id);
            }
        });
        $A.enqueueAction(action);
        
        helper.initPickLisOptions(component);
    },
    calculateConditions : function(component, event, helper) {
        // call out to service and get response
        helper.updateConditions(component);
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
})