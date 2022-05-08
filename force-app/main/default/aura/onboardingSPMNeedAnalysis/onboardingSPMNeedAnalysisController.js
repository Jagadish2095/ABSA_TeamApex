({
	init: function (component, event, helper) {
		helper.getIds(component, event, helper);
		helper.fecthSPMProductlst(component, event, helper);
		helper.getAccountRecord(component);
		helper.getAppliactionPrdctRec(component, event, helper);
	},

	handleOppProdLoad: function (component, event, helper) {
		if (!$A.util.isEmpty(component.find("investmentamountR").get("v.value"))) {
			component.set("v.isOpportunityProductLoaded", true);
			helper.renderQuoteBuilderCmp(component, event, helper, null);
		}
	},

	handleAppProdLoad: function (component, event, helper) {
		if (!$A.util.isEmpty(component.find("managementTypeManagedCode").get("v.value"))) {
			component.set("v.isApplicationProductLoaded", true);
			helper.renderQuoteBuilderCmp(component, event, helper, null);
		}
	},

	handleChange: function (component, event, helper) {
		var changeValue = event.getParam("value");
		console.log(JSON.stringify(changeValue));
		// helper.fecthSPMProductlst(component, event, helper);
		var cashaccruals;
		if (component.find("cashaccruals") == undefined) {
			cashaccruals = null;
		} else {
			cashaccruals = component.find("cashaccruals").get("v.value");
		}

		console.log("cashaccruals" + cashaccruals);

		if (cashaccruals == "Paid Out") {
			component.set("v.renderfields", true);
		} else {
			component.set("v.renderfields", false);
		}
	},

	handleSave: function (component, event, helper, draftValues) {
		helper.savePortfolios(component, event, helper, draftValues);
	},

	handleSubmit: function (component, event, helper) {
		helper.updateDetails(component, event, helper);
	},

	handleSuccess: function (component, event, helper) {},

	handleError: function (component, event, helper) {
		//  helper.hideSpinner(component); //hide the spinner
		/*   var componentName = 'controlOfficerLinkingBankerDetails';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "There has been an error saving the data.", "error");*/
	},
	renderFields: function (component, event, helper) {
		var cashaccruals;
		if (component.find("cashaccruals") == undefined) {
			cashaccruals = null;
		} else {
			cashaccruals = component.find("cashaccruals").get("v.value");
		}

		console.log("cashaccruals" + cashaccruals);

		if (cashaccruals == "Paid Out") {
			component.set("v.renderfields", true);
		} else {
			component.set("v.renderfields", false);
		}
	}
});