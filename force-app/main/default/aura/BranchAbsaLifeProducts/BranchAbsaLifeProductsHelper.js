({    
    UpdateVisuals: function(component){
        var isProductSelected = component.get('v.isProductSelected');
        var isProductFulfilled = component.get('v.isProductFulfilled');
        
        if(isProductSelected){
            component.set('v.buttonStateIcon','action:approval');
            if(isProductFulfilled){
                component.set('v.buttonVariant','Success');
            }
            else{
                component.set('v.buttonVariant','bare');
            }
        }
        else{
            component.set('v.buttonStateIcon','utility:add');
        }
    },
     handleDisclosureCaptureDetails: function (component, event, helper) {   	
        var selectedProduct = component.get('v.productName');
        var compEvent = component.getEvent("absaLifeProductSelectionEvent");
        compEvent.setParams({
            "productToCapture" : selectedProduct,
            "flowAction": 'CAPTURE'
        });  
        compEvent.fire();
    },
})