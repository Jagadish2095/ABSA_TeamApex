({
	getCardDeliveryDetailsHelper: function (component, event, helper) {
		var action = component.get("c.getCardDeliveryDetails");
		action.setParams({ cifCode: component.get("v.accountCIFFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			helper.hideSpinner(component);
			if (state === "SUCCESS") {
				if ($A.util.isEmpty(resp)) {
					//Client does not have any cards ready for delivery
					component.set(
						"v.errorMessage",
						"This client with CIF Code: " + component.get("v.accountCIFFromFlow") + " does not have any cards ready for delivery. "
					);
				} else {
					//Success
					var finalCardList = [];
					var processedCards = component.get("v.processedCards");
					if($A.util.isEmpty(processedCards)){
						//No cards have been processed yet, show all cards
						finalCardList = resp;
					}else{
						//Go through all cards. If they have been processed don't add them to the finalCardList
						resp.forEach(function (item) {
							if(!processedCards.includes(item.cardNbr)){
								finalCardList.push(item);
							}
						});
					}
					//If only 1 card remains, set isLastCard to true
					if(finalCardList.length == 1){
						component.set("v.isLastCard", true);
					}
					component.set("v.data", finalCardList);
				}
			} else if (state === "ERROR") {
				var errorMessage = "An Unexpected error occurred: " + JSON.stringify(response.getError());
				helper.fireToast("Error!", errorMessage, "error");
				component.set("v.errorMessage", errorMessage);
			} else {
				helper.fireToast("Error!", "An Unexpected state returned: " + state, "error");
				component.set("v.errorMessage", "An Unexpected state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});