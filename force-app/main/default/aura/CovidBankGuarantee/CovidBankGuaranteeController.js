({
    doInit: function (component, event, helper) {
        helper.getAppProdRec(component,helper);
	},
    callToAllocateStock : function(component, event, helper) {
        var action = component.get("c.callToAllocateStockNo");
        
        action.setParams({
            oppId: component.get("v.recordId")
        });
        
        action.setCallback(this, function (response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                var Stocknum = response.getReturnValue();
                component.set("v.stockNumber",Stocknum);
                helper.linkAccountToClient(component,event);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    showBtn : function(component, event, helper) {
        var iTermsAndConditionsField = component.find("iTermsAndConditions");
        var iTermsAndConditionsValue =  iTermsAndConditionsField.get("v.value");
        
        component.set("v.agreeToTerms", iTermsAndConditionsValue);
    },
    
    submit : function(component, event, helper) {
        helper.submitD(component, event, helper);
    }
})