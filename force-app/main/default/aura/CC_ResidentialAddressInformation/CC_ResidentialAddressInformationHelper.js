({
    helperAssignCIFValues: function (component, event) {
        var responseData = component.get('v.identityInfo');
        this.mappingTheResponseValue(component, event, responseData);
    },
    helperGetInformation: function (component, event) {
        var residentialInformation = new Map();
        residentialInformation['cpbYes'] = component.get('v.cpbYes');
        residentialInformation['cpbNo'] = component.get('v.cpbNo');
        residentialInformation['timeLivedInAddress'] = component.get('v.timeLivedInAddress');
        residentialInformation['residentialStatus'] = component.get('v.residentialStatus');
        residentialInformation['postalAddressSameAsPhysicalAddress'] = component.get('v.postalAddressSameAsPhysicalAddress');
        residentialInformation['postalAddress1'] = component.get('v.postalAddress1');
        residentialInformation['postalForeignTown'] = component.get('v.postalForeignTown');
        residentialInformation['postalCode'] = component.get('v.postalCode');
        residentialInformation['postalAddress2'] = component.get('v.postalAddress2');
        residentialInformation['postalCountry'] = component.get('v.postalCountry');
        component.set('v.residentialInformation', residentialInformation);
    },
    mappingTheResponseValue: function (component, event, responseData) {
        // Shipping_State_Province__c
        component.set('v.postalAddress1', responseData.Shipping_Street__c);
        component.set('v.postalAddress2', responseData.Shipping_Street_2__c);
        component.set('v.postalForeignTown', responseData.Shipping_Suburb__c);
        component.set('v.postalCode', responseData.Shipping_Zip_Postal_Code__c);
        component.set('v.postalCountry', responseData.Shipping_Country__c);
    },
})