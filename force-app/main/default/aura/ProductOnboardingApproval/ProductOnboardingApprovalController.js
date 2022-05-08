({
	recordUpdated : function(component, event, helper) {
        component.set("v.showSpinner", false);
    },
    onSubmit : function(component, event, helper) {
        //W-008562
        var opportunity = component.get("v.opportunityRecord");
        if(opportunity.StageName == 'Closed'){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"error",
                "title": "Error!",
                "message": "You are not allowed to submit for Approval as it is associated with closed opportunity"
            });
            toastEvent.fire();
        }else{
             component.set("v.showSpinner", true);
             helper.submit(component, event, helper);
        }
       
    },
    
    onCancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
    }
})