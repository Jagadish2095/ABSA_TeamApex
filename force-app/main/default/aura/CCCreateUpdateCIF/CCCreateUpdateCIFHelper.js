({
	callCreateUpdate: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var recordId = component.get("v.recordId");
		//var action = component.get("c.createOrUpdate");
		var cifDataMap = component.get("v.cifDataMap");
		var cifObjDataMap = JSON.parse(cifDataMap);
		console.log('CIF OBJECT DATA MAP..' ,cifObjDataMap);

		let cifDataParamsMap = new Map();
		cifDataParamsMap["firstName"] = cifObjDataMap.identityInformation.firstName;
		cifDataParamsMap["idNumber"] = cifObjDataMap.identityInformation.idNumber;
		cifDataParamsMap["lastName"] = cifObjDataMap.identityInformation.lastName;
		cifDataParamsMap["initials"] = cifObjDataMap.identityInformation.initials;
		cifDataParamsMap["personBirthDate"] = cifObjDataMap.identityInformation.personBirthDate;
		cifDataParamsMap["idType"] = cifObjDataMap.identityInformation.idType;
		cifDataParamsMap["countryOfBirth"] = cifObjDataMap.identityInformation.countryOfBirth;
		cifDataParamsMap["nationality"] = cifObjDataMap.identityInformation.nationality;
		cifDataParamsMap["genderValue"] = cifObjDataMap.identityInformation.genderValue;

		cifDataParamsMap["postalAddress1"] = cifObjDataMap.residentialInformation.postalAddress1;
		cifDataParamsMap["postalForeignTown"] = cifObjDataMap.residentialInformation.postalForeignTown;
		cifDataParamsMap["postalCode"] = cifObjDataMap.residentialInformation.postalCode;
		cifDataParamsMap["postalCountry"] = cifObjDataMap.residentialInformation.postalCountry;

		cifDataParamsMap["personEmail"] = cifObjDataMap.contactInformation.personEmail;
		cifDataParamsMap["personWorkPhone"] = cifObjDataMap.contactInformation.personWorkPhone;
		cifDataParamsMap["personHomePhone"] = cifObjDataMap.contactInformation.personHomePhone;
		cifDataParamsMap["personMobilePhone"] = cifObjDataMap.contactInformation.personMobilePhone;
		//cifDataParamsMap["statementDeliveryMethod"] = cifObjDataMap.contactInformation.statementDeliveryMethod;

		cifDataParamsMap["homeLanguage"] = cifObjDataMap.personalInformation.homeLanguage;
		cifDataParamsMap["communicationLanguage"] = cifObjDataMap.personalInformation.communicationLanguage;
		cifDataParamsMap["communicationChannel"] = cifObjDataMap.personalInformation.communicationChannel;

		cifDataParamsMap["kinFirstName"] = cifObjDataMap.nextKinInformation.kinFirstName;
		cifDataParamsMap["kinRelationShip"] = cifObjDataMap.nextKinInformation.kinRelationShip;
		cifDataParamsMap["kinEmailAddress"] = cifObjDataMap.nextKinInformation.kinEmailAddress;
		cifDataParamsMap["kinSurname"] = cifObjDataMap.nextKinInformation.kinSurname;
		cifDataParamsMap["kinMobilePhone"] = cifObjDataMap.nextKinInformation.kinMobilePhone;
		
		cifDataParamsMap["maritalStatus"] = cifObjDataMap.maritalInformation.maritalStatus;
		cifDataParamsMap["maritalContractType"] = cifObjDataMap.maritalInformation.maritalContractType;


		var action = component.get("c.createCIFv22");
		console.log('CIF DATA MAP..' +component.get("v.cifDataMap"));
		action.setParams({
			cifData: cifDataParamsMap
		});
		

		action.setCallback(this, function (response) {
			component.set("v.showSpinner", false);
			var state = response.getState();
			var response = response.getReturnValue();
			var isCalledFromFlow = component.get("v.isCalledFromFlow");
			if (state == "SUCCESS") {
				console.log('CVS STATE..'+state);
				if (response == "Success") {
					if (isCalledFromFlow) {
						var navigate = component.get("v.navigateFlow");
						navigate("NEXT");
					} else {
						component.set("v.cardStatus", "Status : ");
						component.set("v.cardStatusValue", "Successful");
						component.set("v.showSuccess", true);
						component.set("v.isSuccessful", true);
					}
				} else {
					this.handleError(component, response);
				}
			} else {
				this.handleError(component, "An error occurred on calling the CVS service");
			}
		});
		$A.enqueueAction(action);
	},

	handleError: function (component, Error) {
		var isCalledFromFlow = component.get("v.isCalledFromFlow");
		component.set("v.showError", true);
		if (isCalledFromFlow) {
			component.find("branchFlowFooter").set("v.heading", "Something went wrong");
			component.find("branchFlowFooter").set("v.message", Error);
			component.find("branchFlowFooter").set("v.showDialog", true);
		} else {
			component.set("v.hasProcessStopped", true);
			component.set("v.errorDisplay", true);
			component.set("v.errorMessage", Error);
		}
	}
});