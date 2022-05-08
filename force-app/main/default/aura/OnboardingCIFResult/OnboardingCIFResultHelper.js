({
	createCIFHelper : function(component, event, helper) {
        component.set("v.accRecordId",component.get("v.flowAccountRecId"));
        var action = component.get("c.callToCrateCIF"); 
        action.setParams({
            "accountId" : component.get("v.flowAccountRecId"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var cmpTarget = component.find('resultDiv');
                $A.util.removeClass(cmpTarget, "slds-hide");
                var respObj = JSON.parse(response.getReturnValue());
                component.set("v.cifKey",respObj[0].outputCkey);
            } else{
                
            }
        });
        $A.enqueueAction(action);
    }
})