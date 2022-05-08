({
    updateAccountDetails : function(component) {
        var action = component.get("c.updateAccount");
        action.setParams({
            'recordId': component.get("v.accId"),
            'emailAddress':component.get("v.altAddress")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.invoketostMessage(component,"success","Record succussfully updated in Accounts. Please re-send the email to Client/Customer!","sticky",true);
            }
            else{
                this.invoketostMessage(component,"error","Record not succussfully updated in Accounts. Please contact system administrator.","sticky",true);
            }
        });
        $A.enqueueAction(action);
    },
    invoketostMessage : function(component,typeText,userMessage,modelMode,closeQuickAction){
        if(closeQuickAction === true){
            $A.get("e.force:closeQuickAction").fire();
        }
        component.find('notifLib').showToast({
            variant: typeText,
            message: userMessage,
            mode: modelMode
        });
    }
})