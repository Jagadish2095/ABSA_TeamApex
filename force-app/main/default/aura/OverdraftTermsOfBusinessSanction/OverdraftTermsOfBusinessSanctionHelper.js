({
	setTobFields: function(component, event) {
        var action = component.get("c.getfWrapperList");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("field wrapper state---"+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.fieldWrapList",results);
                
            }
        });
        $A.enqueueAction(action);
    },
    
    setshowTobFields: function(component, event) {
        var action = component.get("c.getLimitTypeFields");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log("show field wrapper state---"+state);
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                console.log('results fieldWrapList---'+JSON.stringify(results));
                component.set("v.showfieldWrapList",results);
                
            }
        });
        $A.enqueueAction(action);
    },
})