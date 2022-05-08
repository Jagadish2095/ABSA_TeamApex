({
	getPickListValues : function(component) {
		var action = component.get("c.getPickListValuesUsingObjectName");
        action.setParams({
            objectName: component.get("v.ObjectType"),
            selectedField: component.get("v.FieldAPIName")
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var options = [];
            if (state === "SUCCESS") {
                var returnValue = response.getReturnValue();
                if (returnValue != null){
                    options.push({label:'choose one...', value:'',selected:false});
                    for(var i=0; i<returnValue.length;i++){
                        var isSelectd = component.get("v.selectedValue") == returnValue[i]?true:false;
                        options.push({label:returnValue[i], value:returnValue[i],selected:isSelectd});
                    }                    
                   component.set('v.options',options);
                }
            }
            if(state == "ERROR")
            {
                
            }
        });
        $A.enqueueAction(action);
	}
})