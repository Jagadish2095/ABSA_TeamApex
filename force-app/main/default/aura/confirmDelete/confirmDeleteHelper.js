({
	deleteRow : function(cmp, event, helper, recId) {
        console.log('recordId:'+recId);
        var action = cmp.get("c.deteleOpplineItem");
        action.setParams({
            "recId":recId
        });
        
        action.setCallback(this, function (response) {
            var state 		= response.getState();
            if (state === "SUCCESS") {
 
            }   
        });
        $A.enqueueAction(action);
        
        
	}
})