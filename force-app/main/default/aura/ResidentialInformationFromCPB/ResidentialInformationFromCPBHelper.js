({
	helperAssignCIFValues: function (component, event) {
		var responseData = component.get('v.identityInfo');
		this.mappingTheResponseValue(component, event, responseData);
	},

	getResidentialDetails: function (component, event) {
		var action = component.get('c.getCPBInfoById');


		action.setParams({
			'accountId': component.get('v.recordId')
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			var responseData = response.getReturnValue();
console.log(responseData.statusCode);
			if (state === 'SUCCESS') {
              if(responseData !== null){
				if (responseData && responseData.statusCode == 200) {
					component.set('v.responseFromCpb', responseData);
							/*component.set('v.line1',responseData.Line1);
						component.set('v.line2',responseData.Line2);
						component.set('v.line3',responseData.Line3);
						component.set('v.line4',responseData.Line4);
						component.set('v.postalCode',responseData.PostalCode);
						component.set('v.AddressCertificate',responseData.AddCert);*/
				} else {
					this.getToast("Error", "A service error Occurred ", "error");
					component.set("v.errorMessage", "Unable to reach CPB, please capture the Residential information");
				}
			} else {
				this.getToast("Error", "Null Response ", "error");
				component.set("v.errorMessage", "Unable to reach CPB, please capture the Residential information");
			}

			} else if (state === "ERROR") {
				var errors = responseData.getError();
				this.getToast("Error", " An error Occurred", "error");
				component.set("v.errorMessage", "Apex error CreditCardCustomerDetailsController.retriveCPBInfoById: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	mappingTheResponseValue: function (component, event, responseData) {
		
		component.set('v.residentialAddressline1', responseData.Shipping_Street__c);
		component.set('v.residentialAddressline2', responseData.Shipping_Street_2__c);
		component.set('v.residentialAddressline3', responseData.Shipping_Suburb__c);
		component.set('v.postalCode', responseData.Shipping_Zip_Postal_Code__c);
		component.set('v.residentialAddressline4', responseData.Shipping_Country__c);
		
	},
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},
	helperCPBaddress: function (component, event) {
		var CPBaddress = component.get('v.responseFromCpb');
		var residentialInformation = new Map();
        residentialInformation['residentialAddress1'] = CPBaddress.Line1;
        residentialInformation['residentialForeignTown'] =CPBaddress.Line3 ;
        residentialInformation['postalCode'] = CPBaddress.PostalCode;
        residentialInformation['residentialAddress2'] = CPBaddress.Line2;
        residentialInformation['residentialCountry'] = CPBaddress.Line4;
        component.set('v.residentialInformation', residentialInformation);

	},
	helperGetInformation: function (component, event) {
		var residentialInformation = new Map();
        residentialInformation['residentialStatus'] = component.get('v.residentialStatus');
        residentialInformation['residentialAddress1'] = component.get('v.residentialAddressline1');
        residentialInformation['residentialForeignTown'] = component.get('v.residentialAddressline3');
        residentialInformation['postalCode'] = component.get('v.postalCode');
        residentialInformation['residentialAddress2'] = component.get('v.residentialAddressline2');
        residentialInformation['residentialCountry'] = component.get('v.residentialAddressline4');
        component.set('v.residentialInformation', residentialInformation);
	}, 

})