({
	fetchProductRecord: function (component, event, helper) {
		var action = component.get("c.getAbsaLifeProducts");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var ProductRecs = response.getReturnValue();
				if (ProductRecs !== undefined) {
					var productlist = [];
					for (var i = 0; i < ProductRecs.length; i++) {
						var obj = {};
						obj.name = ProductRecs[i].Name;
						obj.desc = ProductRecs[i].Description;
						obj.checked = false;
						productlist.push(obj);
					}
					component.set("v.PicklistOptions", productlist);
				}
			} else {
				console.log("Failed with staterec: " + JSON.stringify(response.getReturnValue()));
			}
		});
		$A.enqueueAction(action);
	},

	setIsVisible: function (component) {
		let statement = component.find("statement").get("v.value");
		component.set("v.isVisible", statement);
	},

	manageSelectedProducts: function (component) {
		let PicklistOptions = {};
		let PicklistValue = [];
		let selectedProducts = 0;
		PicklistOptions = component.get("v.PicklistOptions");
		for (let i = 0; i < PicklistOptions.length; i++) {
			if (PicklistOptions[i].checked === true) {
				selectedProducts++;
				PicklistValue.push(PicklistOptions[i].name);
			}
		}
		if (selectedProducts === 0) {
			component.set("v.nextDisabled", true);
		} else {
			component.set("v.nextDisabled", false);
		}
		component.set("v.PicklistValue", PicklistValue);
		component.set("v.selectedProducts", selectedProducts);
	},

	handleProductSelectionEvent: function (component, event, helper) {
		var RecordId = component.get("v.accountRecordId");
		var action = component.get("c.createAbsaLifeOpportunityWithProducts");

		action.setParams({
			accountId: RecordId,
			productNames: component.get("v.PicklistValue")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var absaLifeOpportunityId = response.getReturnValue();
				component.set("v.opportunityId", absaLifeOpportunityId);
				var navigate = component.get("v.navigateFlow");
				navigate("NEXT");
			}
		});
		$A.enqueueAction(action);
	}
});