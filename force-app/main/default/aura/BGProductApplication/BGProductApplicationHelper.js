({
	returnProductId : function(component, event, helper,selectedValue) {
        
       var action = component.get("c.returnProdId");
        action.setParams({
            "oppId" : component.get("v.recordId"),
            "selectedValue": selectedValue
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('results quote generation---'+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('appProdId'+JSON.stringify(results));
                component.set("v.appProdId",results);
                this.getList(component, event, helper);
            }
        });
        $A.enqueueAction(action);
        
       
    },
    getList : function(component, event, helper) {
    var action = component.get("c.getCountriesList");
       action.setParams({
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var countries = response.getReturnValue();
                console.log('countries'+JSON.stringify(countries));
                component.set("v.countriesList",countries);
               
            }
        });
        $A.enqueueAction(action);
    }
})