({
	setTobFields: function(component, event, helper) {
      var action = component.get("c.getfWrapperList");
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
})