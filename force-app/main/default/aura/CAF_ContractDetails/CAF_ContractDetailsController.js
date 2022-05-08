({
	updatePurchasePrice : function(component, event, helper) {
		var vx = component.get("v.methodFromParentCMP");
        $A.enqueueAction(vx);
	}
})