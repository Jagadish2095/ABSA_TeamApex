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
    
    calculate : function(component, event, helper) {
       // alert('Service Call'); 
       helper.calculate(component,event,helper);
    },
})