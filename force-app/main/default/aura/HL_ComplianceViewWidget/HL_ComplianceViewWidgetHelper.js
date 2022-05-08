({
    fetchData: function (component) {
        component.set("v.showSpinner", true);
        
        var objectId = component.get("v.recordId");
        var action = component.get("c.getData");
        action.setParams({
            "objectId": objectId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null && data.message == null){
                    component.set("v.healthStatus", data.complianceStatus);
                    component.set("v.lastRefreshDate", data.lastRefreshDate);
                    component.set("v.nextRefreshDate", data.nextRefreshDate);
                }else if(data != null && data.message != null){
                    component.set("v.dataFound", false);
                    var errors = data.message;                       
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }else{
                    component.set("v.dataFound", false);
                    var errors = 'There is no data found for this Account';                       
                    component.set("v.showError",true);
                    component.set("v.errorMessage",errors);
                }
            }else {
                console.log("Failed with state: " + state);
                component.set("v.dataFound", false);
                var errors = 'There is no data found for this Account';                       
                component.set("v.showError",true);
                component.set("v.errorMessage",errors);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    helperMethod : function() {
        
    }
})