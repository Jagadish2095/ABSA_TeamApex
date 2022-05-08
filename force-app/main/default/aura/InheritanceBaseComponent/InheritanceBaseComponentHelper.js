({
    /*
     * A sub component's helper inherits the methods from the helper of its super component.
     * A sub component can override a super component's helper method by defining a method with 
     * the same name as an inherited method.
     */
    loadRecord : function(component) {
        var stdFields = component.get("v.standardFields");
        var extFields = component.get("v.fields");
        var fields = stdFields + (extFields != null ? ','+ extFields : "");
        
        var action = component.get("c.getObject");
        action.setParams({
            recordId: component.get("v.recordId"),
            sObjectType: component.get("v.sObjectType"),
            fields: fields
        });
        
        action.setCallback(this, function(a) {
            console.log("Using base component loadRecord");
            console.log(a.getReturnValue());
            component.set("v.record", a.getReturnValue());
        });
        
        $A.enqueueAction(action); 
    }
})