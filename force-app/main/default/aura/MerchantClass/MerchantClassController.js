({
    doInit: function(component, event, helper) {

		var opportunityLineItemId = component.get("v.opportunityLineItemId");
        console.log("opportunityLineItemId : " + opportunityLineItemId);
        if($A.util.isEmpty(opportunityLineItemId)){
            helper.getOpportunityLineItemIdJS(component);
        }
    },

    handleLoad : function(component, event, helper){
		helper.resetFieldValue(component);
    },

    handleSuccess : function(component, event, helper){
		helper.fireToast("Success!", "Merchant Class details saved.", "success");
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantClass';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "Error saving Merchant Class details.", "error");
    }
});