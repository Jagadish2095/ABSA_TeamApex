({
	/****************@ Author: Chandra*******************************************
	 ****************@ Date: 20/10/2020******************************************
	 ****************@ Work Id: W-006280,006901,007778,007783********************
	 ***@ Description: Method Added by chandra to set Data to Pass Parent Comp**/
	SetDataToPassParentComp: function (component, event, helper) {
		var data = [];

		var percentSplit = component.get("v.percentSplit");
		var email = component.get("v.emailAddress"); //Changes against W-013608 start by chandra
		var addressLineTwo = component.get("v.addressLine2"); //Changes against W-013608 start by chandra
		var suburb = component.get("v.suburb"); //Changes against W-013608 start by chandra
		var postalCode = component.get("v.postalCode"); //Changes against W-013608 start by chandra
		var addressLineOne = component.get("v.addressLine1"); //Changes against W-013608 start by chandra
		var city = component.get("v.city"); //Changes against W-013608 start by chandra

		if (percentSplit == undefined || percentSplit == "" || percentSplit == null) {
			percentSplit = 0;
		}

		//Changes against W-013608 start by chandra
		if (email == undefined || email == "" || email == null) {
			email = "";
		}

		if (addressLineTwo == undefined || addressLineTwo == "" || addressLineTwo == null) {
			addressLineTwo = "";
		}

		if (component.get("v.selectedProductType") == "LX" && (suburb == undefined || suburb == "" || suburb == null)) {
			addressLineTwo = "";
		}

		if (component.get("v.selectedProductType") == "LX" && (postalCode == undefined || postalCode == "" || postalCode == null)) {
			addressLineTwo = "";
		}

		if (component.get("v.selectedProductType") == "LX" && (addressLineOne == undefined || addressLineOne == "" || addressLineOne == null)) {
			addressLineTwo = "";
		}

		if (component.get("v.selectedProductType") == "LX" && (city == undefined || city == "" || city == null)) {
			addressLineTwo = "";
		}

		//Changes against W-013608 end by chandra

		data.push({
			firstName: component.get("v.firstName"),
			surname: component.get("v.surName"),
			relationshipCode: component.get("v.relationshipCode"),
			percentSplit: percentSplit,
			lifeClientCode: component.get("v.lifeClientCode"),
			idType: component.get("v.idType"),
			idNumber: component.get("v.idNumber"),
			emailAddress: email,
			dateOfBirth: component.get("v.dateOfBirth"),
			titleCode: component.get("v.titleCode"),
			addressLine1: addressLineOne,
			addressLine2: addressLineTwo,
			suburb: component.get("v.suburb"),
			city: city,
			postalCode: postalCode,
			contactTelephoneNumber: component.get("v.contactTelephoneNumber"),
			contactTypeID: component.get("v.contactTypeID"),
			clientGID: component.get("v.clientGID")
		});

		var appEvent = $A.get("e.c:AddUpdatePolicyBeneficiaryEvent");
		appEvent.setParams({ policyBeneficiaryList: data });
		appEvent.setParams({ actionType: component.get("v.actionType") });
		appEvent.fire();

		component.find("overlayLib").notifyClose();
	},

	/****************@ Author: Chandra**************************************
	 ****************@ Date: 20/10/2020*************************************
	 ****************@ Work Id: W-006280,006901,007778,007783***************
	 ***@ Description: Method Added by chandra to check Required Validation*/

	checkRequiredValidation: function (component, event, helper) {
		var relationshipCode = component.get("v.relationshipCode");
		var firstName = component.get("v.firstName");
		var surName = component.get("v.surName");
		var idType = component.get("v.idType");
		var contactNumber = component.get("v.contactTelephoneNumber");
		var dateOfBirth = component.get("v.dateOfBirth");
		var selectedTitleValue = component.get("v.titleCode");
		var suburb = component.get("v.suburb");
		var contactTypeID = component.get("v.contactTypeID");
		var postalCode = component.get("v.postalCode");
		var addressLineOne = component.get("v.addressLine1");
		var city = component.get("v.city");

		//Changes against W-013608 start by chandra
		if (
			relationshipCode == undefined ||
			relationshipCode == "" ||
			relationshipCode == null ||
			firstName == undefined ||
			firstName == "" ||
			firstName == null ||
			surName == undefined ||
			surName == "" ||
			surName == null ||
			idType == undefined ||
			idType == "" ||
			idType == null ||
			dateOfBirth == undefined ||
			dateOfBirth == "" ||
			dateOfBirth == null ||
			selectedTitleValue == undefined ||
			selectedTitleValue == "" ||
			selectedTitleValue == null
		) {
			component.set("v.isRequiredValidationNotPassed", true);
		} else {
			if (component.get("v.selectedProductType") == "LX" && (contactTypeID == undefined || contactTypeID == "" || contactTypeID == null)) {
				component.set("v.isRequiredValidationNotPassed", true);
			} else if (
				component.get("v.selectedProductType") != "LX" &&
				(suburb == undefined ||
					suburb == "" ||
					suburb == null ||
					city == undefined ||
					city == "" ||
					city == null ||
					addressLineOne == undefined ||
					addressLineOne == "" ||
					addressLineOne == null ||
					postalCode == undefined ||
					postalCode == "" ||
					postalCode == null)
			) {
				component.set("v.isRequiredValidationNotPassed", true);
			} else {
				component.set("v.isRequiredValidationNotPassed", false);
			}
		}

		//Changes against W-013608 end by chandra
	}
});