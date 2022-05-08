({
	doInit: function(component, event, helper) {
		helper.retrieveProductTypeValues(component);
	},
    
    viewProductInformation: function(component, event, helper) {
        var selectedProductType = component.get("v.selectedProductType");
		if (!selectedProductType) {
            helper.hideSpinner(component);
			helper.fireToastEvent("Validation Warning", "Please select from product list", "warning");
			return;
		}
        helper.showSpinner(component);
        helper.retrieveProductsInformation(component, selectedProductType);
		component.set("v.showProductInformation", true);
	},
    
    closeProductInformation: function (component, event, helper) {
		component.set("v.showProductInformation", false);
	}
})