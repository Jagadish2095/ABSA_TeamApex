({
	//Lightning toastie
    getToast : function(title, msg, type) {
		 var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        return toastEvent;
	},
    
    fetchClientGroupValues: function(component, fieldName, elementId) {
        var action = component.get("c.getClientGroupPickListValues");
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('Client Group values: '+JSON.stringify(allValues));
                component.set("v.clientGroupValues",allValues);
            }
        });
        $A.enqueueAction(action);
    },
    
     fetchClientTypeValues: function(component, fieldName, elementId) {
         var action = component.get("c.getClientTypePickListValues");
         var clientTypeValue = component.find("clientTypeId").get("v.value");
         var clientGroupValue = component.find("clientGroupId").get("v.value");
         
         console.log('clientGroupValue ' + clientGroupValue);
         
         action.setParams({
             "clientGroupSelected" : clientGroupValue
         });
         
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                console.log('Client Type values: '+JSON.stringify(allValues));
                component.set("v.clientTypeValues",allValues);
            }
        });
        $A.enqueueAction(action);
    },
})