({
	doInit: function (component, event, helper) {
		helper.fetchTranslationValues(
			component,
			"v.communicationMethodOptions",
			"CIFCodesList",
			"Prefcomms",
			"Outbound",
			"Account",
			"Preferred_Communication_Method__c"
		);
		var communicationOptions = component.get("v.communicationMethodOptions");
		helper.fetchLanguageOptions(component);
		//  communicationOptions.
	},

	handleAccountLoad: function (component, event, helper) {
		var payload = event.getParam("recordUi");

		component.find("iClient_Group__c").set("v.value", "Non Individual"); //Non Individual     Stokvel
		component.find("iSICCategory").set("v.value", "Community, Social and Personal Services");
		component.find("iIdtype").set("v.value", "Registration Number");

		component.find("iSICCode").set("v.value", "95990 - Activities of other membership organisations N.E.C (Not Elsewhere Classified");
		component.find("sourceOfIncome").set("v.value", "Members Contribution");
		console.log("Handle Account Load method");
		var communicationMethod = payload.record.fields["Preferred_Communication_Method__c"].value;
		var communicationLanguage = payload.record.fields["Language__c"].value;
		component.set("v.communicationMethod", communicationMethod);
		component.set("v.communicationLanguage", communicationLanguage);
        component.find("iValidUpdateBypass").set("v.value", true);
	},
	handleSubmit: function (component, event, helper) {
        helper.showSpinner(component);
		event.preventDefault();
		var eventFields = event.getParam("fields");
		var communicationMethod = component.find("PreferredCommunicationMethod").get("v.value");
		eventFields["Preferred_Communication_Method__c"] = communicationMethod;
		var communicationLanguage = component.find("CommunicationLanguage").get("v.value");
		eventFields["Language__c"] = communicationLanguage;
		eventFields["Valid_Update_Bypass__c"] = true;
		component.find("iValidUpdateBypass").set("v.value", true);
       component.find("recordStokEditForm").submit(eventFields);
		helper.hideSpinner(component);
	},
	//Show or Hide Postal Address
	postalSameAsPhysical: function (component, event, helper) {},

	createStokvelEntity: function (component, event, helper) {
		const globalId = component.getGlobalId();
		let errorMessage = helper.validateEntityInformation(component);
		if (errorMessage) {
			helper.fireToast("Error", errorMessage, "error");
			component.set("v.errorMessage", errorMessage);
		} else {
			helper.showSpinner(component);
			component.set("v.isBtnDisabled", true);
			component.find("iValidUpdateBypass").set("v.value", true);
			component.find("recordStokEditForm").submit();
                       
			component.find("iValidUpdateBypass").set("v.value",true);
			//helper.saveContactInfo(component, event, helper);
			document.getElementById(globalId + "_contact_submit").click();
		}
	},
    
 handleAccountSuccess: function (component, event, helper) {
		helper.hideSpinner(component); //hide the spinner
		helper.fireToast("Success", "The entity information has been successfully saved.", "success");

		if ($A.util.isEmpty(component.find("iCASARefNumber").get("v.value"))) {
			console.log("CASA is empty");
			helper.StovelcasaScreening(component, event, helper);
		} else {
			console.log("CASA NOT empty");
            const globalId = component.getGlobalId();
			component.find("iValidUpdateBypass").set("v.value",true);			
			document.getElementById(globalId + "_contact_submit").click();
			var navigate = component.get("v.navigateFlow");
			navigate("NEXT");
		}
	},

	//handle submit for stokvel
	handleAccountError: function (component, event, helper) {
		component.set("v.isBtnDisabled", false);
		helper.hideSpinner(component); //hide the spinner
		var retstring = JSON.stringify(event.getParams());
       if(!retstring.includes('Case, Lead or opportunity linked to it'))
        {
            //console.log("recordStokEditForm Account: error JSON: " + JSON.stringify(event.getParams()));
            component.set("v.errorMessage", "recordStokEditForm Account: error JSON: " + JSON.stringify(event.getParams()));
            helper.fireToast("Error!", "There has been an error saving stokvel entity the data.", "error");
        }
	}
});