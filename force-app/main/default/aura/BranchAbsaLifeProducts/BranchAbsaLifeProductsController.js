({
    handleSelectedProduct : function (cmp, event, helper) {
        var buttonstate = cmp.get('v.isProductSelected');
        cmp.set('v.isProductSelected', !buttonstate);        
    },
    handleCaptureDetails: function (component, event, helper) {   	
        var selectedProduct = component.get('v.productName');
        var compEvent = component.getEvent("absaLifeProductSelectionEvent");
        compEvent.setParams({
            "productToCapture" : selectedProduct,
            "flowAction": 'CAPTURE'
        });  
        compEvent.fire();
    },
    captureInstantLifeProduct : function(component, event, helper){
        if (component.find('disclosureId').get('v.checked')) {
            helper.handleDisclosureCaptureDetails(component, event, helper);
        }
        else {
            }
    }, 
    
})