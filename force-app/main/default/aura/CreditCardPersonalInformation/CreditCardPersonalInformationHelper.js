({
	helperAssignCIFValues: function (component, event) {
		var responseData = component.get('v.identityInfo');
		this.mappingTheResponseValue(component, event, responseData);
	},
	mappingTheResponseValue: function (component, event, responseData) {
		component.set('v.homeLanguage', responseData.Home_Language__pc);
		component.set('v.communicationLanguage', responseData.Communication_Language__pc);
		component.set('v.communicationChannel', responseData.Preferred_Communication_Method__pc);
	},
	helperGetInformation: function (component, event) {
		var personalInformation = new Map();
		personalInformation['homeLanguage'] = component.get('v.homeLanguage');
		personalInformation['communicationLanguage'] = component.get('v.communicationLanguage');
		personalInformation['communicationChannel'] = component.get('v.communicationChannel');
		component.set('v.personalInformation', personalInformation);
	},
	helperValidate: function (component, event) {
		var allValid = true;
        var self = this;
		if(component.get('v.isEdit') == false){
			allValid = component.find('perInputFld').reduce(function (validSoFar, inputCmp) {
				inputCmp.reportValidity();
				inputCmp.focus();
				return validSoFar && inputCmp.checkValidity();
			}, true);
		} else {
			component.find('perInputFld').reduce(function (validSoFar, inputCmp){
                if(inputCmp.get('v.class') == 'required' && (!inputCmp.get('v.value') || inputCmp.get('v.value') === '') ){
                    allValid = false;
                    self.getToast('Required field missing..!', 'Required field(s) missing', 'error' );
                }
            });
		}
		component.set('v.personalValidity', allValid);
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