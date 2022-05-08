({
    doInit : function(component, event, helper) { 
      
        helper.getApplication(component);
        var apcId = component.get("v.apcId");
      },
    onSubmit : function(component, event, helper) {
        var assetValue = component.find('assetValue');
        var assetVal = assetValue.get("v.value");
        var annualTurnover = component.find('annualTurnover');
        var annualTurnoverVal = annualTurnover.get("v.value");
        
        if(!annualTurnoverVal)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please fill in Annual Turnover!"
            });
            toastEvent.fire();
        }
        else if(!assetVal)
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Please fill in Asset Value!"
            });
            toastEvent.fire();
        }
            else
            {
                helper.updateNCA(component, event, helper);
            }
        
    }                                              
})