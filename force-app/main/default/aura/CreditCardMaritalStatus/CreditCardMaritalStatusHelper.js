({
	helperAssignCIFValues: function (component, event) {
		var responseData = component.get('v.identityInfo');
		this.mappingTheResponseValue(component, event, responseData);
	},
	mappingTheResponseValue: function (component, event, responseData) {
		component.set('v.maritalStatus', responseData.Marital_Status__pc);
		component.set('v.maritalContractType', responseData.Marital_Contract_Type__pc);
	},
	helperGetInformation: function (component, event) {
		var maritalInformation = new Map();
		maritalInformation['maritalStatus'] = component.get('v.maritalStatus');
		maritalInformation['maritalContractType'] = component.get('v.maritalContractType');
		component.set('v.maritalInformation', maritalInformation);
	},
	helperValidate: function (component, event) {
		var allValid = true;
		var self = this;
		if (component.get('v.isEdit') == false) {
			allValid = component.find('msInputFld').reduce(function (validSoFar, inputCmp) {
				return validSoFar && inputCmp.checkValidity();
			}, true);
		} else {
			component.find('msInputFld').reduce(function (validSoFar, inputCmp) {
				if (inputCmp.get('v.class') == 'required' && (!inputCmp.get('v.value') || inputCmp.get('v.value') === '')) {
					allValid = false;
					self.getToast('Required field missing..!', 'Required field(s) missing', 'error');
				}
			});
		}
		component.set('v.maritalValidity', allValid);
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