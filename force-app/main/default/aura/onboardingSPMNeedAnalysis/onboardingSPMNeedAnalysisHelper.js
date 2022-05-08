({
	getIds: function (component, event, helper) {
		var action = component.get("c.getIds");

		action.setParams({ oppId: component.get("v.recordId") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = response.getReturnValue();
				console.log("respObj" + respObj);
				console.log("respObj---->" + JSON.stringify(respObj));
				var respObjAfter = JSON.stringify(respObj);

				component.set("v.appproductId", respObj[0].appProductId);
				component.set("v.appId", respObj[0].appId);
				component.set("v.opplineId", respObj[0].opplineitemId);
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "Error",
					message: "Something went wrong please contact Administrator."
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},

	updateDetails: function (component, event, helper) {
		var opplineId = component.get("v.opplineId");
		console.log(opplineId);
		var appproductId = component.get("v.appproductId");
		console.log(appproductId);
		var cashaccruals, investmentamountR, regularwithdrawalamountR, frequencyofpaymentrequired, otherspecialrequirements;

		if (component.find("investmentamountR") == undefined) {
			investmentamountR = null;
		} else {
			investmentamountR = component.find("investmentamountR").get("v.value");
		}

		if (component.find("cashaccruals") == undefined) {
			cashaccruals = null;
		} else {
			cashaccruals = component.find("cashaccruals").get("v.value");
		}

		if (component.find("regularwithdrawalamountR") == undefined) {
			regularwithdrawalamountR = null;
		} else {
			regularwithdrawalamountR = component.find("regularwithdrawalamountR").get("v.value");
		}

		if (component.find("frequencyofpaymentrequired") == undefined) {
			frequencyofpaymentrequired = null;
		} else {
			frequencyofpaymentrequired = component.find("frequencyofpaymentrequired").get("v.value");
		}

		if (component.find("otherspecialrequirements") == undefined) {
			otherspecialrequirements = null;
		} else {
			otherspecialrequirements = component.find("otherspecialrequirements").get("v.value");
		}

		var action = component.get("c.updateDetails");
		console.log("Cash accural" + cashaccruals);

		action.setParams({
			investmentamountR: investmentamountR,
			cashaccruals: cashaccruals,
			regularwithdrawalamountR: regularwithdrawalamountR,
			frequencyofpaymentrequired: frequencyofpaymentrequired,
			otherspecialrequirements: otherspecialrequirements,
			opplineId: opplineId,
			appproductId: appproductId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var applicationDetails = response.getReturnValue();

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					type: "success",
					message: "The Details have been saved successfully."
				});
				toastEvent.fire();
				//Re-load Quote builder
				component.set("v.isQuoteBuilderLoaded", false);
				this.renderQuoteBuilderCmp(component, event, helper, null);
			} else if (state === "INCOMPLETE") {
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},

	fecthSPMProductlst: function (component, event, helper) {
		var action = component.get("c.getProducts");
		var changeValue = event.getParam("value");
		console.log("changevalue" + JSON.stringify(changeValue));
		action.setParams({
			oppId: component.get("v.recordId") //oppid
			//portfoliovalue:changeValue
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = response.getReturnValue();

				// respObj= respObj.push({"InvestmentAllocation":"100","InvestmentAllocationAmt":"0","RelatedProductName":"","RiskProfile":"Total"}]);
				//  respObj= respObj.concat([{"InvestmentAllocation":"100","InvestmentAllocationAmt":"0","RelatedProductName":"","RiskProfile":"Total"}]);
				var respObjAfter = JSON.stringify(respObj);
				console.log("respObjAfter: " + respObjAfter);
				component.set("v.data", respObj);

				component.set("v.columns", [
					{ label: "Risk Profile", fieldName: "RiskProfile", type: "text", wrapText: true }, // RiskProfile
					{ label: "", fieldName: "RelatedProductName", type: "text", wrapText: true }, // RelatedProductName
					{ label: "%", fieldName: "InvestmentAllocation", type: "text", editable: true, wrapText: true },
					{ label: "R", fieldName: "InvestmentAllocationAmt", type: "text", wrapText: true }
				]);
				component.set("v.isQuoteBuilderLoaded", false);
				this.renderQuoteBuilderCmp(component, event, helper, null);
				console.log("within the service call");
			} else {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					type: "error",
					title: "Error",
					message: "Something went wrong please contact Administrator."
				});
				toastEvent.fire();
			}
		});
		$A.enqueueAction(action);
	},

	savePortfolios: function (component, event, helper, draftValues) {
		var changedValuesMap = {};
		var changedKeysList = [];
		var savedvalues = event.getParam("draftValues"); //savedvalues[{"InvestmentAllocation":"","Id":"row-6"},{"InvestmentAllocation":"10","Id":"row-7"}]
		var savedValuesAfterStringify = JSON.stringify(savedvalues);
		var objSaved = JSON.parse(savedValuesAfterStringify);
		var totalsavedvalues = 0;
		console.log("objSaved>>" + objSaved.length);
		for (var j in objSaved) {
			if (objSaved[j] instanceof Object) {
				changedKeysList.push(objSaved[j].Id.substr(4, 5));
				changedValuesMap[objSaved[j].Id.substr(4, 5)] = objSaved[j].InvestmentAllocation;
			}
		}

		var existingvalues = component.get("v.data");
		var existingvaluesAfterStringify = JSON.stringify(existingvalues);
		//Start Manoj
		var existingValuesObj = JSON.parse(existingvaluesAfterStringify);
		var existingValuesMap = {};
		var finalValuesMap = {};
		let finalTotalSum = 0;
		for (var i in existingValuesObj) {
			existingValuesMap[i] = existingValuesObj[i].InvestmentAllocation;
			if (changedKeysList.includes(i)) {
				finalValuesMap[i] = changedValuesMap[i];
			} else {
				finalValuesMap[i] = existingValuesObj[i].InvestmentAllocation;
			}
		}
		for (var i in finalValuesMap) {
			if (finalValuesMap[i] != undefined) {
				finalTotalSum = Number(finalTotalSum) + Number(finalValuesMap[i]);
			} else {
				finalTotalSum = Number(finalTotalSum) + 0;
			}
		}
		console.log("finalTotalSum>>>>>" + finalTotalSum);
		component.set("v.finalTotalSum", finalTotalSum);

		if (finalTotalSum > 100 || finalTotalSum < 100) {
			var toastEvent = helper.getToast("Error", "Total Investment Allocation Percentage must be 100%.", "error");
			toastEvent.fire();
			return;
		}

		var action = component.get("c.savePortfolios");

		action.setParams({ oppId: component.get("v.recordId"), savedvalues: savedValuesAfterStringify });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = response.getReturnValue();
				var respObjAfter = JSON.stringify(respObj);
				helper.fireRefreshEvt(component);

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					type: "success",
					message: "The details have been saved successfully."
				});
				toastEvent.fire();

				//Re-load Quote builder
				component.set("v.isQuoteBuilderLoaded", false);
				this.renderQuoteBuilderCmp(component, event, helper, savedvalues); //component.get("v.data")
			} else {
				var toastEvent = helper.getToast("Error", "Something went wrong. Please contact Administrator.");
				toastEvent.fire();
				return;
			}
		});
		$A.enqueueAction(action);
	},

	//Lightning toastie
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		return toastEvent;
	},

	fireRefreshEvt: function (component) {
		var refreshEvent = $A.get("e.force:refreshView");
		if (refreshEvent) {
			refreshEvent.fire();
		}
	},

	//This method needs a clean up when time permits to remove hardcoding
	renderQuoteBuilderCmp: function (component, event, helper, updatedData) {
		var datatableData = component.get("v.data");

		//Prepare data for Quote Builder once all data has been loaded
		if (
			component.get("v.isOpportunityProductLoaded") &&
			component.get("v.isApplicationProductLoaded") &&
			!component.get("v.isQuoteBuilderLoaded") &&
			!$A.util.isEmpty(datatableData)
		) {
			component.set("v.renderQuoteBuilder", false);
			//var filterCategories;
			//Get AppProd.Management_Type_Managed_Code__c (Discretionary account/Non-Discretionary account)
			var filterCategories = component.find("managementTypeManagedCode").get("v.value");

			//If values were updated on the datatable then go through the updates and map them to the datatableData
			if (!$A.util.isEmpty(updatedData)) {
				updatedData.forEach(function (item) {
					var index = item.Id.split("-")[1];
					datatableData[index].InvestmentAllocation = item.InvestmentAllocation;
				});
			}

			//Go through all portfolios with an InvestmentAllocation and check their Geographical Scope.
			//IF they have BOTH Local and Offshore then no need to hide any fields based on those criteria.
			//IF they have ONLY Local then we need to specify in the FilterCategories to hide the fields where mdt.FilterCategory = Local
			//IF they have ONLY Offshore then we need to specify in the FilterCategories to hide the fields where mdt.FilterCategory = Offshore

			//Default booleans to false
			var hasLocal,
				hasOffshore = false;
			datatableData.forEach(function (item) {
				//If there is an InvestmentAllocation
				if (!$A.util.isEmpty(item.InvestmentAllocation)) {
					//Set booleans to true if that type is found
					if (item.ProductType == "Offshore Portfolio") {
						hasOffshore = true;
					} else if (item.ProductType == "Local Portfolio") {
						hasLocal = true;
					}
				}
			});
			//IF only 1 type is found. Use it as the FilterCategory
			if (hasOffshore && !hasLocal) {
				filterCategories += ";Offshore Portfolio";
			} else if (hasLocal && !hasOffshore) {
				filterCategories += ";Local Portfolio";
			}

			console.log("filterCategories render: " + filterCategories);
			component.set("v.quoteBuilderFilterCategory", filterCategories);
			//Render Quote Builder
			component.set("v.isQuoteBuilderLoaded", true);
			component.set("v.renderQuoteBuilder", true);
		}
	},
	getAccountRecord: function (component, event, helper) {
		var action = component.get("c.getAccount");
		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var accRec = JSON.stringify(response.getReturnValue());
				console.log("accRec" + accRec);
				var accRec1 = response.getReturnValue();
				component.set("v.accountRec", accRec1);
			} else {
				console.log("Failed with state: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	},

	getAppliactionPrdctRec: function (component, event, helper) {
		var action = component.get("c.getAppPrdctRec");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appPrdct = response.getReturnValue();
				console.log("appPrdct: " + JSON.stringify(appPrdct));
				console.log("Platform value : " + appPrdct.Platform__c);
				//component.set("v.appPrdctId", appPrdct.Id);
			} else {
				console.log("Failed with state: " + JSON.stringify(appPrdct));
			}
		});

		$A.enqueueAction(action);
	}
});