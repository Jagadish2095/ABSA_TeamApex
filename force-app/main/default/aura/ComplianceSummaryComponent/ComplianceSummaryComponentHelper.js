({  
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getSummaryData");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                    component.set("v.opportunity", data);
                }
                else{
                    component.set("v.dataFound", false);
                }
            }
            else {
                console.log("Failed with state: " + state);
                component.set("v.dataFound", false);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }
})