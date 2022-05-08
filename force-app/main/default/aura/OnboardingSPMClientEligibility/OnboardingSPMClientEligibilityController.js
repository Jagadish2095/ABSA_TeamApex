({
	doInit: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		helper.getOppDetails(component, event, helper);
		helper.getAppRec(component, event, helper);
		helper.getAppliactionPrdctRec(component, event, helper);
		var optionGiven = component.get("v.optionGiven");
		// component.get("v.usoption");
	},
	handleSubmit: function (component, event, helper) {
		component.set("v.showSpinner", true);
		//helper.updateOppr(component, event, helper);
		helper.updateAppRec(component, event, helper);
		helper.updateAppProductRec(component, event, helper);
	},
	handleChange: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var changeValue = event.getParam("value");
		var optionGiven = component.get("v.optionGiven");

		if (changeValue == "N") {
			component.set("v.optionGiven", "N");
			component.set("v.showCitizenshipmessage", "No");
			component.set("v.IsstageClosed", false);
		} else if (changeValue == "Y") {
			component.set("v.optionGiven", "Y");
			component.set("v.showCitizenshipmessage", "Yes");
			component.set("v.IsstageClosed", true);
		}

		helper.updateOpprstage(component, event, helper);
	},
	handleChangeofOtherBanks: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var changeOtherBankValue = event.getParam("value");
		if (changeOtherBankValue == "N") {
			component.set("v.optionGivenforotherbank", "N");
			component.set("v.showOtherBankmessage", "No");
			component.set("v.Isotherbankoptiongiven", false);
			component.find("purposeOfAcc").set("v.value", "SPM");
			var purposeOfAcc = component.find("purposeOfAcc").get("v.value");
			console.log(purposeOfAcc);
			if (purposeOfAcc == "SPM") {
				component.find("purposeOfAcctText").set("v.value", "Apparent");
			}
			component.find("accActTracker").set("v.value", "Apparent");
		} else if (changeOtherBankValue == "Y") {
			component.set("v.showSpinner", true);
			component.set("v.optionGivenforotherbank", "Y");
			component.set("v.showOtherBankmessage", "Yes");
			component.set("v.Isotherbankoptiongiven", true);
		}
		helper.updateOpprstage(component, event, helper);
	},

	checkValidity: function (component, event, helper) {
		var userSelectedDate = component.find("pasportexpiry").get("v.value");
		var today = new Date();
		var passportselecteddate = new Date(userSelectedDate);
		var passdate1 = today.getTime();
		var pass2 = passportselecteddate.getTime();
		var milliseconds = passdate1 - pass2;
		var seconds = milliseconds / 1000;
		var minutes = seconds / 60;
		var hours = minutes / 60;
		var days = hours / 24;
		var minDiv = 60;
		var hoursDiv = 24;

		if (Math.floor(days) >= -30 && Math.floor(days) <= 0) {
			component.set("v.Isapplcomplex", true);
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "error!",
				type: "error",
				message: "The passport will be expiring in less than 1 month"
			});
			toastEvent.fire();
			return;
		}
	},

	onManagementTypeChenge: function (component) {
		var managementTypeValue = component.find("managementTypeId").get("v.value");
		if (managementTypeValue == "Discretionary account") {
			component.set("v.isFullDiscretionary", false);
		} else {
			component.set("v.isFullDiscretionary", true);
		}
	}
});