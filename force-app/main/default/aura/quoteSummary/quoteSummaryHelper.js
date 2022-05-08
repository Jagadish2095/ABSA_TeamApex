({
    showToast : function (type, title, message)
    {
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toastEvent.fire();
        } else {
            alert(message);
        }
    },
    fetchDependantData: function (component)
    {
        var oppId = component.get("v.selectedOppIdFromFlow");
        var product = component.get('v.selectedProductFromFlow');
        
        if(oppId === undefined)
        {
            oppId = component.get('v.recordId');
        }
        
        var action = component.get("c.getDependantData");
        action.setParams({
            "opportunityId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if(data != null){
                	component.set("v.dataDependants", data);
                    
                    if(product === undefined
                       || product != component.get("v.productFlexiFuneral"))
                    {
                        component.set("v.showDependents", false);
                    }
                    else
                    {
                        component.set("v.showDependents", true);
                    }
                }
                else{
                    component.set("v.showDependents", false);
                }
            }
        });
        $A.enqueueAction(action);
    },
})