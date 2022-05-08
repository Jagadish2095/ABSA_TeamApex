({
	init: function (component, event, helper) {
		var initialAnswerId = component.get("v.initialAnswerId");
		if (initialAnswerId == "SAVINGS_OR_INVESTMENT") {
			component.set("v.headerText", "Complete Needs Analysis");
		}
		var compEvent = component.getEvent("roaQuestionaireSelectionEvent");
		compEvent.setParams({
			answerId: initialAnswerId,
			sequenceNumber: "0"
		});
		compEvent.fire();
        var processType =component.get("v.processType");
        if(processType ==='Voice Sales Product Onboarding'){
            helper.getrecommendedProductsforVocie(component, event, helper);
        }

	},

	handleAnswerSelectionEvent: function (component, event, helper) {
		var processType =component.get("v.processType");
        if(processType ==='Voice Sales Product Onboarding'){
            component.set("v.CanNavigate", true);
        }
        else{
        component.set("v.updating", true);
		helper.removeFutureQuestions(component, event, helper);
		helper.loadNextQuestion(component, event, helper);
        }
	},

	handleProductSelectionEvent: function (component, event, helper) {
		var productId = event.getParam("productId");
		component.set("v.selectedProducts", productId);
		component.set("v.productId", productId);
		var Wasproductselect = component.get("v.productIsSelected");
		var IsproductSelected = event.getParam("productIsSelected");		
		if (Wasproductselect && !IsproductSelected) {
			helper.removeFutureQuestions(component, event, helper);
		}
		component.set("v.productIsSelected", IsproductSelected);
	},

	handleNavigate: function (component, event, helper) {
		component.set("v.updating", true);
		var navigate = component.get("v.navigateFlow");
		var actionClicked = event.getParam("action");
		switch (actionClicked) {
			case "NEXT":
			case "FINISH":
				var promise = helper.OnNext(component, event, helper).then(
					$A.getCallback(function (result) {
						navigate(actionClicked);
					}),
					$A.getCallback(function (error) {
						component.set("v.updating", false);
					})
				);
				break;
			case "BACK":
			case "PAUSE":
				component.set("v.updating", false);
				navigate(event.getParam("action"));
				break;
		}
	}
});