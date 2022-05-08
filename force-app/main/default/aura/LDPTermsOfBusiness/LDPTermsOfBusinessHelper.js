({
	getLDPTobFields: function(component, event) {
		 var action = component.get("c.getTOBFieldsforLDP");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.fieldWrapList",results);
            }
        });
        $A.enqueueAction(action);
    },
	getTOBForLDP : function(component, event){
        var action = component.get("c.getTOBProductsForLDP");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results product---'+JSON.stringify(results));
                if(results){
                    component.set("v.appProdTobList",results);
                    component.set("v.showSpinner",false);
                }
            }
        });
        $A.enqueueAction(action);
    },
})