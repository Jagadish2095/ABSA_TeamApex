({
    doInit : function(component, event, helper) {
        var action = component.get("c.getInFlightApplications");
        var account = component.get("v.accountId");
        
        action.setParams({
            "accountId" : account
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if(state == "SUCCESS"){
                var opporunityData = response.getReturnValue();
                component.set('v.opporunityData', opporunityData);
            }
        });
        $A.enqueueAction(action);
    },
    
    handleFulfill: function(component, event, helper){
        let target = event.getSource();
        let opportunityId = target.get("v.value");
        
        if(opportunityId == "0")
        {
            component.set("v.isRoaCompleted", false);
        }
        else
        {
            component.set("v.isRoaCompleted", true);
            component.set("v.opportunityId",opportunityId);
            component.set("v.initialAnswerId", 'SAVINGS_OR_INVESTMENT');

        }
        
        let navigate = component.get("v.navigateFlow"); 
        navigate("NEXT");
    }
})