({
    helperAssignCIFValues: function (component, event) {
        var responseData = component.get('v.identityInfo');
        this.mappingTheResponseValue(component, event, responseData);
    },
    
    getResidentialDetails: function (component, event) {
        
        var accountIdNum = component.get('v.recordId');        
        var action = component.get('c.getCPBInfoById');
        action.setParams({
            'accountId': accountIdNum
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var responseData = response.getReturnValue();
            if (state === 'SUCCESS') {
				console.log(responseData);

                if (responseData && responseData.statusCode == 200) {
					if(responseData.responseStatusCode == 0){
                        component.set('v.responseFromCpb', responseData.Person.AddressInformation.ResidentialAddress);

                    }else {
						this.getToast("Error", "An error Occurred ", "error");
						component.set("v.errorMessage", "No Data Found. Please capture residential address");
					}

			    }else {
                    this.getToast("Error", "A service error Occurred ", "error");
                    component.set("v.errorMessage", "Unable to reach CPB, please capture the Residential information");
                }

            } else if (state === "ERROR") {
                var errors = response.getError();
                this.getToast("Error", " An error Occurred", "error");
                component.set("v.errorMessage", "Apex error CreditCardCustomerDetailsController.retriveCPBInfoById: " + 'Enter a valid ID ' + JSON.stringify(errors));
            } else {
                component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
            }
        });
        $A.enqueueAction(action);
    
    },
    //Data Present in  CIF.
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
	//Data present in the CPB
    helperCPBaddress: function (component, event) {
		
        component.set('v.isEdit', false);
        var CPBaddress = component.get('v.responseFromCpb');
        if(CPBaddress !== null ){
        component.set('v.residentialAddressline1',CPBaddress.Line1);
        component.set('v.residentialAddressline3',CPBaddress.Line3);
        component.set('v.postalCode',CPBaddress.PostalCode);
        component.set('v.residentialAddressline2',CPBaddress.Line2);
        component.set('v.residentialAddressline4',CPBaddress.Line4);
        }else{
            this.getToast("Error", "No data found" , "error");
             component.set("v.errorMessage", "No data found, please capture the Residential information");
        }
    },
	//Data captured from the consultant
    helperGetInformation: function (component, event) {
		
        component.set('v.isEdit', false);
    },
    saveFinalResidentialAddress: function(component, event){

        var residentialInformation = new Map();
        residentialInformation['residentialStatus'] = component.get('v.residentialStatus');
        residentialInformation['residentialAddress1'] = component.get('v.residentialAddressline1');
        residentialInformation['residentialForeignTown'] = component.get('v.residentialAddressline3');
        residentialInformation['postalCode'] = component.get('v.postalCode');
        residentialInformation['residentialAddress2'] = component.get('v.residentialAddressline2');
        residentialInformation['residentialCountry'] = component.get('v.residentialAddressline4');
        component.set('v.finalResidentialInformation', residentialInformation);
    }

})