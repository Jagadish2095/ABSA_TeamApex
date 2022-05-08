({
	    //get Picklist Value
    getpickListValue: function(component, event) {
        var action = component.get("c.getpickListValue");
        action.setParams({
            "objectName": component.get("v.objectName"),
            "fieldName": component.get("v.picklistfieldName"),

        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result'+result);
                var pickListValue = [];
                console.log('pickListValue array' +pickListValue)
                for(var key in result){
                    pickListValue.push({label: result[key], value: key});
                }
                component.set("v.options", pickListValue);
                console.log('pickListValue'+JSON.stringify(pickListValue));
            }
        });
        $A.enqueueAction(action);
    },

})