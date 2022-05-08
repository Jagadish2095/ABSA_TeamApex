({
	//2021-06-11
	doInit: function (component, event, helper) {
		helper.getAppDetails(component, event, helper);
		//helper.getAppliactionPrdctRec(component, event, helper);
		helper.getAccountRecord(component);
		var action = component.get("c.getOppDetails");
		console.log("Opportunity Record Id = " + component.get("v.recordId"));
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var opp = response.getReturnValue();
				console.log("opp result " + JSON.stringify(opp.Id));

				component.set("v.oppId", opp.Id);
				component.set("v.oppRec", opp);
				console.log("Your Opp Record is :" + JSON.stringify(opp));
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});
		$A.enqueueAction(action);
	},

	handleLoad: function (component, event, helper) {
		helper.setInvestorFields(component, event, helper);
	},
	setInvestorTypeFields: function (component, event, helper) {
		helper.setInvestorFields(component, event, helper);
	},

	validateSourceOfFunds: function (component, event, helper) {
		var srcOfFunds = component.find("SourceofFunds").get("v.value");
		if (srcOfFunds == undefined) {
			alert("Please enter source of funds");
		}

		console.log("Source of Funds : " + srcOfFunds);
	},

	selectChange: function (component, event, helper) {
		// first get the div element. by using aura:id
		var changeElement = component.find("DivID");
		// by using $A.util.toggleClass add-remove slds-hide class
		$A.util.toggleClass(changeElement, "slds-hide");
	},

	clientTypeAccess: function (component, event, helper) {
		var clientTypeValue = component.find("clientType");

		if (clientTypeValue == "Individual") {
			component.set("v.isIndividual", true);
		} else {
			component.set("v.isIndividual", false);
		}

		console.log("resultant client Type : " + clientTypeValue);
	},

	handleSubmit: function (component, event, helper) {
		helper.updatingAppDetails(component, event, helper);
	},
	handleSaveError: function (component, event, helper) {
		component.find("appRecord").showToast({
			title: "Something has gone wrong!",
			message: event.getParam("message"),
			variant: "error"
		});
	}
});