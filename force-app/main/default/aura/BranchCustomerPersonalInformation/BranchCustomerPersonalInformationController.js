({
init: function (component, event, helper) {
	helper.setDate(component);
	helper.fetchTranslationValues(component, "v.titleOptions", "CIFCodesList", "Titles", "Outbound", "Account", "Titles__pc");
	helper.fetchTranslationValues(component, "v.maritalStatusOptions", "CIFCodesList", "Maritstat", "Outbound", "Account", "Marital_Status__pc");
	helper.fetchTranslationValues(component, "v.maritalContractTypeOptions", "CIFCodesList", "Marrcontype", "Outbound", "Account", "Marital_Contract_Type__pc");
	helper.fetchTranslationValues(component, "v.countryOfBirthOptions", "CIFCodesList", "Casa Country", "Outbound", "Account", "Country_of_Birth__pc");
	helper.fetchTranslationValues(component, "v.nationalityOptions", "CIFCodesList", "Nationality", "Outbound", "Account", "Nationality_List__pc");
	helper.fetchTranslationValues(component, "v.homeLanguageOptions", "CIFCodesList", "Lang", "Outbound", "Account", "Home_Language__pc");
	helper.fetchTranslationValues(component, "v.incomeSourceOptions", "CIFCodesList", "Sofsoi", "Outbound", "Account", "Income_Source__pc");
	helper.fetchTranslationValues(component, "v.clientTypeOptions", "CIFCodesList", "IndividualCustomertype", "Outbound", "Account", "Client_Type__c");
	helper.setControls(component);
},

infoRecordLoaded: function (component, event, helper) {
	var payload = event.getParam("recordUi");
	var personTitle = "";
	if (payload.record.fields["Titles__pc"] != null) {
		personTitle = payload.record.fields["Titles__pc"].value;
	}

	var firstName = "";
	if (payload.record.fields["FirstName"] != null) {
		firstName = payload.record.fields["FirstName"].value;
	}

	var lastName = "";
	if (payload.record.fields["LastName"] != null) {
		lastName = payload.record.fields["LastName"].value;
	}
	var iDNumber = "";
	if (payload.record.fields["ID_Number__pc"] != null) {
		iDNumber = payload.record.fields["ID_Number__pc"].value;
	}
	var dateIssued = "";
	if (payload.record.fields["Date_Issued__pc"] != null) {
		dateIssued = payload.record.fields["Date_Issued__pc"].value;
	}
	var countryOfBirth = "";
	if (payload.record.fields["Country_of_Birth__pc"] != null) {
		countryOfBirth = payload.record.fields["Country_of_Birth__pc"].value;
	}
	var nationality = "";
	if (payload.record.fields["Nationality_List__pc"] != null) {
		nationality = payload.record.fields["Nationality_List__pc"].value;
	}
	var maritalStatus = "";
	if (payload.record.fields["Marital_Status__pc"] != null) {
		maritalStatus = payload.record.fields["Marital_Status__pc"].value;
	}
	var maritalContractType = "";
	if (payload.record.fields["Marital_Contract_Type__pc"] != null) {
		maritalContractType = payload.record.fields["Marital_Contract_Type__pc"].value;
	}
	var spouseAccountNumber = "";
	if (payload.record.fields["AccountNumber"] != null) {
		spouseAccountNumber = payload.record.fields["AccountNumber"].value;
	}
	var homeLanguage = "";
	if (payload.record.fields["Home_Language__pc"] != null) {
		homeLanguage = payload.record.fields["Home_Language__pc"].value;
	}
	var homeLanguageOther = "";
	if (payload.record.fields["Home_Language_Other__pc"] != null) {
		homeLanguageOther = payload.record.fields["Home_Language_Other__pc"].value;
	}
	var incomeSource = "";
	if (payload.record.fields["Income_Source__pc"] != null) {
		incomeSource = payload.record.fields["Income_Source__pc"].value;
	}

	var clientType = "";
	if (payload.record.fields["Client_Type__c"] != null) {
		clientType = payload.record.fields["Client_Type__c"].value;
	}
			//Koketso added required fields for voice
			var gender ='';
			if (payload.record.fields["Gender__pc"] != null) {
				gender = payload.record.fields['Gender__pc'].value;
			}
			var dateOfBirth = '';
			if (payload.record.fields["PersonBirthdate"] != null) {
				dateOfBirth = payload.record.fields['PersonBirthdate'].value;
			}
	component.set("v.personTitle", personTitle);
	component.set("v.firstName", firstName);
	component.set("v.lastName", lastName);
	component.set("v.iDNumber", iDNumber);
	component.set("v.dateIssued", dateIssued);
	component.set("v.countryOfBirth", countryOfBirth);
	component.set("v.nationality", nationality);
	component.set("v.maritalContractType", maritalContractType);
	component.set("v.homeLanguage", homeLanguage);
	component.set("v.homeLanguageOther", homeLanguageOther);
	component.set("v.incomeSource", incomeSource);
	component.set("v.maritalStatus", maritalStatus);
	component.set("v.clientType", clientType);
	component.set("v.updating", false);
	if(component.get('v.processType') == 'Voice Sales Product Onboarding'){
		component.set('v.gender', gender);
		if(nationality == "South African"){
			component.set('v.idType', 'SA Identity Document');
		}else{
			component.set('v.idType', 'Passport');
		}
		component.set('v.clientGroup', 'Individual');
		component.set('v.dateOfBirth', dateOfBirth);
	}

},

infoRecordSubmit: function (component, event, helper) {
	event.preventDefault();
	var eventFields = event.getParam("fields");
	var personTitle = component.get("v.personTitle");
	var firstName = component.get("v.firstName");
	var lastName = component.get("v.lastName");
	var iDNumber = component.get("v.iDNumber");
	var dateIssued = component.get("v.dateIssued");
	var countryOfBirth = component.get("v.countryOfBirth");
	var nationality = component.get("v.nationality");
	var maritalStatus = component.get("v.maritalStatus");
	var maritalContractType = "0";
	if (maritalStatus == "Married") {
		maritalContractType = component.get("v.maritalContractType");
	}
	var homeLanguage = component.get("v.homeLanguage");
	var homeLanguageOther = component.get("v.homeLanguageOther");
	var incomeSource = component.get("v.incomeSource");
	var clientType = component.get("v.clientType");
	var gender = component.get('v.gender');
	var idType = component.get('v.idType');
	var clientGroup = component.get('v.clientGroup');
	var dateOfBirth = component.get('v.dateOfBirth');


	eventFields["Titles__pc"] = personTitle;
	eventFields["FirstName"] = firstName;
	eventFields["LastName"] = lastName;
	eventFields["ID_Number__pc"] = iDNumber;
	eventFields["Date_Issued__pc"] = dateIssued;
	eventFields["Country_of_Birth__pc"] = countryOfBirth;
	eventFields["Nationality_List__pc"] = nationality;
	eventFields["Marital_Status__pc"] = maritalStatus;
	eventFields["Marital_Contract_Type__pc"] = maritalContractType;
	eventFields["Home_Language__pc"] = homeLanguage;
	eventFields["Home_Language_Other__pc"] = homeLanguageOther;
	eventFields["Income_Source__pc"] = incomeSource;
	eventFields['Gender__pc'] = gender;
	eventFields['ID_Type__pc'] = idType;
	eventFields['Client_Group__c'] = clientGroup;
	eventFields['PersonBirthdate'] = dateOfBirth;

	eventFields["Client_Type__c"] = clientType;
	eventFields['Valid_Update_Bypass__c'] = true;
	component.find("PersonalInformation").submit(eventFields);
},

infoRecordError: function (component, event, helper) {
	var errorMessage = event.getParam("message");
	var eventDetails = event.getParam("error");
	component.find("branchFlowFooter").set("v.heading", errorMessage);
	component.find("branchFlowFooter").set("v.message", JSON.stringify(eventDetails));
	component.find("branchFlowFooter").set("v.showDialog", true);
	component.set("v.updating", false);
},

infoRecordSuccess: function (component, event, helper) {
	var navigate = component.get("v.navigateFlow");
	var actionClicked = component.get("v.actionClicked");
	component.set("v.updating", false);
	navigate(actionClicked);
},

maritalStatusChanged: function (component, event, helper) {
	if (component.get("v.maritalStatus") == "Married") {
		component.set("v.maritalTypeDisabled", false);
		component.set("v.maritalTypeRequired", true);
	} else {
		component.set("v.maritalContractType", "");
		component.set("v.maritalTypeRequired", false);
		component.set("v.maritalTypeDisabled", true);
	}
},

handleNavigate: function (component, event, helper) {
	var navigate = component.get("v.navigateFlow");
	var actionClicked = event.getParam("action");
	var globalId = component.getGlobalId();
	component.set("v.updating", true);
	component.set("v.actionClicked", actionClicked);

	switch (actionClicked) {
		case "NEXT":
		case "FINISH":
			if (helper.checkValidity(component, helper) == "pass") {
				helper.handleRemoveValidation(component);
				var promise = helper.executeValidate(component, helper).then(
					$A.getCallback(function (result) {
						document.getElementById(globalId + "_personal_submit").click();
					}),
					$A.getCallback(function (error) {
						helper.handleAddValidation(component);
						component.set("v.updating", false);
					})
				);
			} else {
				component.set("v.updating", false);
			}
			break;
		case "BACK":
		case "PAUSE":
			if (helper.checkValidity(component, helper) == "pass") {
				document.getElementById(globalId + "_personal_submit").click();
			} else {
				component.set("v.updating", false);
				var ignoreValidity = confirm("Validation failed! Continue without saving?");
				if (ignoreValidity) {
					navigate(actionClicked);
				}
			}
			break;
	}
}
});