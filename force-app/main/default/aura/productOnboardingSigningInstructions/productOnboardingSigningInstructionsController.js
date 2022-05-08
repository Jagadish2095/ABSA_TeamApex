({
    init : function(component, event, helper) {
        helper.fetchOpportunityLineItemId(component, event, helper);
    },
    onload : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },
    handleSuccess : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Success!", "Signing Instructions have been updated successfully.", "success");
    },

    handleError : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Error!", "Signing Instructions have not been updated successfully. Please contact your System Administrator.", "error");
    },
})