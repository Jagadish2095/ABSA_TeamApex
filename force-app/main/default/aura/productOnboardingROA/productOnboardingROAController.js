({
    init : function(component, event, helper) {
        helper.fetchApplicationId(component, event, helper);
    },
    onload : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },
    handleSuccess : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Success!", "SApplication been updated successfully.", "success");
    },

    handleError : function(component, event, helper){
        //hide spinner
        $A.enqueueAction(component.get('c.onload'));
        // Show toast
        helper.fireToast("Error!", "Application not been updated successfully. Please contact your System Administrator.", "error");
    },

    isUnderSupervision : function(component, event, helper)
    {
        var underSupervision = event.getParam("value");
        component.find("underSuper").set("v.value",underSupervision);
        if (underSupervision != component.get("v.underSupervisionValue")) {
            component.set("v.underSupervisionValue",underSupervision);
        }
    },
    isAdviceGiven : function(component, event, helper)
    {
        var adviseGiven = event.getParam("value");
        component.find("advice").set("v.value",adviseGiven);
        if (adviseGiven != component.get("v.adviceGivenValue")) {
            component.set("v.adviceGivenValue",adviseGiven);
        }
    },

    replacingProduct : function(component, event, helper) {
        var isReplacingProduct = event.getParam("value");
        component.find("productReplacement").set("v.value",isReplacingProduct);
        if (isReplacingProduct != component.get("v.productReplacementValue")) {
            component.set("v.productReplacementValue",isReplacingProduct);
        }
    },
})