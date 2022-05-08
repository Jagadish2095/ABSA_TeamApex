({
	getPaymentPlans : function(component,event,helper) {
        var caseId=component.get('v.recordId');
        var action = component.get("c.getPaymentDetails");
        action.setParams({
            
            "caseId": caseId
            
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseData = response.getReturnValue();
            if (state === "SUCCESS") {
                if(!$A.util.isEmpty(responseData)){
                component.set('v.paymentplans',responseData);
                var newPaymentPlans=component.get('v.newPaymentPlans');
                newPaymentPlans=responseData.length;
                component.set('v.newPaymentPlans',newPaymentPlans);
                }
                
            } else if (state === "ERROR") {
                var errors = response.getError();
               
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
		
	}
})