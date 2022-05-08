({
    helperAssignCIFValues: function (component, event) {
        var identityInformation = component.get('v.identityInfo');
        component.set('v.identityInformation', identityInformation);
        this.mappingTheResponseValue(component, event, identityInformation);
    },
    mappingTheResponseValue: function (component, event, response) {
        component.set('v.personTitle', response.PersonTitle);
        component.set('v.firstName', response.FirstName);
        component.set('v.idNumber', response.ID_Number__pc);
        component.set('v.genderValue', response.Gender__pc);
        component.set('v.nationality', response.Nationality__pc);
        component.set('v.countryOfResidence', response.Country_of_Residence__pc);
        component.set('v.initials', response.Initials__pc);
        component.set('v.lastName', response.LastName);
        component.set('v.personBirthDate', response.PersonBirthdate);
        component.set('v.idType', response.ID_Type__pc);
        component.set('v.countryOfBirth', response.Country_of_Birth__pc);
    },
    helperGetInformation: function (component, event) {
        var identityInformation = new Map();
        identityInformation['personTitle'] = component.get('v.personTitle');
        identityInformation['firstName'] = component.get('v.firstName');
        identityInformation['idNumber'] = component.get('v.idNumber');
        identityInformation['genderValue'] = component.get('v.genderValue');
        identityInformation['nationality'] = component.get('v.nationality');
        identityInformation['countryOfResidence'] = component.get('v.countryOfResidence');
        identityInformation['initials'] = component.get('v.initials');
        identityInformation['lastName'] = component.get('v.lastName');
        identityInformation['personBirthDate'] = component.get('v.personBirthDate');
        identityInformation['idType'] = component.get('v.idType');
        identityInformation['countryOfBirth'] = component.get('v.countryOfBirth');
        component.set('v.basicIdentityInformation', identityInformation);
    },
    helperValidate: function (component, event) {
        var allValid = true;
        var self = this;
        if(component.get('v.isEdit') == false){
            allValid = component.find('inputFld').reduce(function (validSoFar, inputCmp) {
                inputCmp.reportValidity();
                inputCmp.focus();
                return validSoFar && inputCmp.checkValidity();
            }, true);
        } else {
            component.find('inputFld').reduce(function (validSoFar, inputCmp){
                if(inputCmp.get('v.class') == 'required' && (!inputCmp.get('v.value') || inputCmp.get('v.value') === '') ){
                    allValid = false;
                    self.getToast('Required field missing..!', 'Required field(s) missing', 'error' );
                }
            });
        }
        component.set('v.identityValidity', allValid);
    },

    //Function to show toast for Errors/Warning/Success
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}, 
})