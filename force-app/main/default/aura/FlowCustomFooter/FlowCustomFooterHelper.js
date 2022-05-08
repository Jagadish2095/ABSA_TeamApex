({
    sendEmailToadvisor: function(cmp, event, helper, actionClicked) {
        
        var action = cmp.get("c.finishButton");
        action.setParams({ CaseId : cmp.get("v.recordId") });
        
        action.setCallback(this, function(response) {
            
            cmp.set("v.isLoading", false);
            var state = response.getState();
            if (state === "SUCCESS") {               
               console.log('Success');
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log('In error condition');
                } else {
                    console.log("Unknown error");
                }
            }
            console.log("this is VA finish response");
            var evt = $A.get("e.c:FinishButtonNotification");
            evt.fire();
            
            var navigate = cmp.get('v.navigateFlow');
            navigate(actionClicked);
        });
        
        
        $A.enqueueAction(action);
        cmp.set("v.isLoading", true);
    }
})