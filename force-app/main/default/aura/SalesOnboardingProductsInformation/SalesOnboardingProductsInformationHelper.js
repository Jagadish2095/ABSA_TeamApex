({
    retrieveProductTypeValues: function (component) {
        
		var action = component.get("c.getProductTypesMapping");
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = JSON.parse(response.getReturnValue());
                var productTypeValues = responseData.SalesOnboardingProductTypes;
                console.log("***productTypeValues***", productTypeValues);
                var chequeProductList = [];
                for (var i = 0; i < productTypeValues.ChequeProducts.length; i++) {
                    chequeProductList.push({ label: productTypeValues.ChequeProducts[i].ProductType, 
                                   value: productTypeValues.ChequeProducts[i].ProductCode });
                }
                component.set("v.chequeProductList", chequeProductList);
                
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "retrieveProductTypeValues error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "retrieveProductTypeValues unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
    
    retrieveProductsInformation: function (component, productType) {
        var productCodes;
        if(productType == 'Transactional Cheque'){
            var chequeProductCodesLabel = $A.get("$Label.c.Sales_Onboarding_Cheque_Product_Codes");
            productCodes = chequeProductCodesLabel.split(";");
        }else if(productType == 'Transactional Savings'){
            //Additional condition to be added when onboarding savings
        }
        
		var action = component.get("c.getProductsInformation");
        //setting params
		action.setParams({
			productCodes: productCodes
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
            if (state === "SUCCESS") {
                var responseData = JSON.parse(response.getReturnValue());
                
                var productsData = [];
                
                for (var i = 0; i < responseData.length; i++) {
                    productsData.push(responseData[i]);
                }
                
                console.log("***productsData***", productsData);
                component.set("v.roaFeatureData", productsData);
                
            } else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "retrieveProductsInformation error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "retrieveProductsInformation unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},
    
	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},
    
    fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
})