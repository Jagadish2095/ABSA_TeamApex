({
	getAccountDetails: function (component, event, helper) {
		var action = component.get("c.getAccountDetails");
		var clientAccountId = component.get("v.clientAccountIdFromFlow");
		action.setParams({
			clientAccountId: clientAccountId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("Error: ")) {
					// error
					component.set("v.errorMessage", responseValue);
				} else {
					// success
					component.set("v.responseToFlow", responseValue); //Added by chandra dated 11/12/2020

					var respObj = JSON.parse(responseValue);
					component.set("v.responseList", respObj);

					var prodTypesSet = new Set();
					var productTypeFilter = component.get("v.productTypeFilter");
					var newProdTypeList = [];
					var activeCombiAccList = [];

					if (productTypeFilter) {
						var productTypeFilterList = productTypeFilter.toLowerCase().split(";");
					}

					for (var key in respObj) {
						var productType = respObj[key].productType;
						var productTypeTranslated = respObj[key].productTypeTranslated;

						if (!prodTypesSet.has(productType)) {
							if (productType && !productTypeFilterList) {
								prodTypesSet.add(productType);
								newProdTypeList.push({
									label: productTypeTranslated ? productTypeTranslated : productType,
									value: productType
								});
							} else if (productType && productTypeFilterList && productTypeFilterList.includes(productType.toLowerCase())) {
								prodTypesSet.add(productType);
								newProdTypeList.push({
									label: productTypeTranslated ? productTypeTranslated : productType,
									value: productType
								});
							}
						}

						//Collecting Active Combi Accounts - Added by SM - 23 March 2021
						if (respObj[key].productType == "CO" && respObj[key].status == "ACTIVE") {
							respObj[key].oaccntnbr = respObj[key].oaccntnbr.replace(/^0+/, "");
							activeCombiAccList.push(respObj[key].oaccntnbr);
						}
					}

					component.set("v.prodTypesList", newProdTypeList);
                    component.set("v.activeCombiAccList", activeCombiAccList.sort());

					var prodTypesList = [...prodTypesSet].sort(); // Convert Set to List and sort

					if (prodTypesList.length == 0 && !productTypeFilterList) {
						component.set("v.errorMessage", "Error: No linked Accounts found.");
					} else if (prodTypesList.length == 0 && productTypeFilterList) {
						component.set("v.errorMessage", "Error: No linked Accounts found with filter(s): " + productTypeFilterList);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error CIGetAccountLinkedToClientCodeController.getAccountDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getAccountDescriptions: function (component, accNumberList) {
		var action = component.get("c.getAccountDescriptions");
		action.setParams({
			accountNumbers: JSON.stringify(accNumberList)
		});
		//callback function
		action.setCallback(this, function (response) {
			// store the response return value
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseData = response.getReturnValue();
				if (responseData.startsWith("Error: ")) {
					component.set("v.errorMessage", responseData);
				} else {
					var accDescriptions = JSON.parse(responseData);
					var descriptionItems = [];
					for (var i = 0; i < accDescriptions.length; i++) {
						var accFullDescription;
						var accNumber = accDescriptions[i].ACCOUNT;
						if (accDescriptions[i].RESPONSE_CODE == "0") {
							var vehicleManufacture = accDescriptions[i].MANUFACTURER;
							var vehicleModel = accDescriptions[i].MODEL;
							var vehicleVin = accDescriptions[i].VIN;
							accFullDescription = accNumber.replace(/^0+/, "") + " - " + vehicleManufacture + " - " + vehicleModel + " - " + vehicleVin;
						} else {
							accFullDescription = accNumber + " - Description not found";
						}
						descriptionItems.push({ label: accFullDescription, value: accNumber });
					}
					component.set("v.accNumList", descriptionItems);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "getAccountDescriptions error: " + JSON.stringify(errors[0].message));
			} else {
				component.set("v.errorMessage", "getAccountDescriptions unexpected error occurred, state returned: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	}
});