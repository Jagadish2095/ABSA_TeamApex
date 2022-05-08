({
	EnableFinishButton : function(component, event, helper) {
     var evt = $A.get("e.c:BNGenerationNCrossSellEvent");
            evt.setParams({"check" : false , "VA" : true}); 
            evt.fire();
    }
})