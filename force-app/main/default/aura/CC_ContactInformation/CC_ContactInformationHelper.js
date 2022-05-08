({
	helperAssignCIFValues: function (component, event) {
		var responseData = component.get('v.identityInfo');
		this.mappingTheResponseValue(component, event, responseData);
	},
	mappingTheResponseValue: function (component, event, responseData) {
		component.set('v.personEmail', responseData.PersonEmail);
		component.set('v.personWorkPhone', responseData.Work_Phone__pc);
		component.set('v.personHomePhone', responseData.PersonHomePhone);
		component.set('v.personMobilePhone', responseData.PersonMobilePhone);
		component.set('v.statementDeliveryMethod', responseData.Statement_Preference__pc);
	},
	helperGetInformation: function (component, event) {
		var contactInformation = new Map();
		contactInformation['personEmail'] = component.get('v.personEmail');
		contactInformation['personWorkPhone'] = component.get('v.personWorkPhone');
		contactInformation['personHomePhone'] = component.get('v.personHomePhone');
		contactInformation['personMobilePhone'] = component.get('v.personMobilePhone');
		contactInformation['statementDeliveryMethod'] = component.get('v.statementDeliveryMethod');
		component.set('v.contactInformation', contactInformation);
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
	helperValidateInput: function (component, event) {
		var allValid = true;
		var inputCmp, self = this;		
		if (component.get('v.isEdit') == false) {	
			inputCmp = component.find('cnInputFld');		
			return inputCmp.some(function (el, ind, arr) {
				if (el.get('v.type') != 'email' && el.get('v.value')) {
					allValid = true;
					component.set('v.contactValidity', allValid);
					return true;
				} else if (el.get('v.type') != 'email' && !el.get('v.value')) {
					allValid = false;
					self.getToast('Required field missing..!', 'At least one telephone number is required', 'error');
					component.set('v.contactValidity', allValid);
					return false;
				}
			});
			// allValid = component.find('cnInputFld').reduce(function (validSoFar, inputCmp) {
			// 	inputCmp.reportValidity();
			// 	inputCmp.focus();
			// 	return validSoFar && inputCmp.checkValidity();
			// }, true);
		} else {
			inputCmp = component.find('cnInputFld');
			return inputCmp.some(function (el, ind, arr) {
					if ((el.get('v.type') != 'email' && el.get('v.class') == 'required') && (!el.get('v.value') || el.get('v.value') === '')) {
						allValid = false;
						component.set('v.contactValidity', allValid);
						self.getToast('Required field missing..!', 'Required field(s) missing', 'error');
						return false;
					} else if ((el.get('v.type') != 'email' && el.get('v.class') == 'required') && (el.get('v.value') || el.get('v.value') !== '')) {
						allValid = true;
						component.set('v.contactValidity', allValid);
						return true;
					}
				});
			// component.find('cnInputFld').reduce(function (validSoFar, inputCmp) {
			// 	if (inputCmp.get('v.class') == 'required' && (!inputCmp.get('v.value') || inputCmp.get('v.value') === '')) {
			// 		allValid = false;
			// 		self.getToast('Required field missing..!', 'Required field(s) missing', 'error');
			// 	}
			// });
		}
		// component.set('v.contactValidity', allValid);
	}
})