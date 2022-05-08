({  
    getProductDetails : function(component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.getProductDetails");    
        
        action.setParams({
            oppId: oppId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("Result Product Details: " + JSON.stringify(data));
                //component.set("v.prodData", data);
                component.set("v.SelectedProduct", data.Product2.Name);
                component.set("v.inActiveSelectedProduct", true);
            }
            else {
                console.log("Failed with state: " + JSON.stringify(response));
            }
            
            component.set("v.showSpinner", false);
        });

        $A.enqueueAction(action);
    },

    viewProductDetails : function(component){

    }
})