({
    init: function(component, event, helper) {
        helper.fetchData(component);
        helper.fetchTranslationValues(component, 'v.countryOptions', 'CIFCodesList', 'Casa Country', 'Outbound', 'Address__c', 'Shipping_Country__c');
    },

    addressRecordLoaded: function(component, event, helper) {
        var searchComponent = component.find('branchSuburbSearch');
        var payload = event.getParam("recordUi");
        var street = payload.record.fields['Shipping_Street__c'].value;
        var street2 = payload.record.fields['Shipping_Street_2__c'].value;
        var postal = payload.record.fields['Shipping_Zip_Postal_Code__c'].value;
        var suburb = payload.record.fields['Shipping_Suburb__c'].value;
        var city = payload.record.fields['Shipping_City__c'].value;
        var province = payload.record.fields['Shipping_State_Province__c'].value;
        var country = payload.record.fields['Shipping_Country__c'].value;
        component.set("v.addressStreet", street);
        component.set("v.addressStreet2", street2);
        component.set("v.addressPostalCode", postal);
        component.set("v.addressSuburb", suburb);
        searchComponent.set("v.addressSuburb", suburb);
        component.set("v.addressCity", city);
        component.set("v.addressProvince", province);
        component.set("v.addressCountry", country);
        var componentEvent = component.getEvent("addressRecordEvent");
        componentEvent.setParams({
            "eventName" : 'RecordLoaded',
            "statusCode" : '',
            "errorMessage" : '',
            "eventDetails" : ''
        });
        componentEvent.fire();
    },

    addressRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam("fields");
        var street = component.get("v.addressStreet");
        var street2 = component.get("v.addressStreet2");
        var postal = component.get("v.addressPostalCode");
        var suburb = component.get("v.addressSuburb");
        var city = component.get("v.addressCity");
        var province = component.get("v.addressProvince");
        var country = component.get("v.addressCountry");
        eventFields["Shipping_Street__c"] = street;
        eventFields["Shipping_Street_2__c"] = street2;
        eventFields["Shipping_Zip_Postal_Code__c"] = postal;
        eventFields["Shipping_Suburb__c"] = suburb;
        eventFields["Shipping_City__c"] = city;
        eventFields["Shipping_State_Province__c"] = province;
        eventFields["Shipping_Country__c"] = country;
        component.find('BranchAddress').submit(eventFields);
    },

    addressRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        var statusCode = event.getParam("statusCode");
        var componentEvent = component.getEvent("addressRecordEvent");
        componentEvent.setParams({
            "eventName" : 'RecordError',
            "statusCode" : statusCode,
            "errorMessage" : errorMessage,
            "eventDetails" : JSON.stringify(eventDetails)
        });
        componentEvent.fire();
    },

    addressRecordSuccess : function(component, event, helper) {
        var statusCode = event.getParam("statusCode");
        var componentEvent = component.getEvent("addressRecordEvent");
        componentEvent.setParams({
            "eventName" : 'RecordSuccess',
            "statusCode" : statusCode,
            "errorMessage" : '',
            "eventDetails" : ''
        });
        componentEvent.fire();
    },

    handleSearchEvent: function(component, event) {
        var searchComponent = component.find('branchSuburbSearch');
        var addressCity = searchComponent.get('v.addressCity');
        var addressProvince = searchComponent.get('v.addressProvince');
        var addressPostalCode = searchComponent.get('v.addressPostalCode');
        var addressCountry = searchComponent.get('v.addressCountry');
        component.set('v.addressProvince', addressProvince);
        component.set('v.addressCity', addressCity);
        component.set('v.addressPostalCode', addressPostalCode);
        component.set('v.addressCountry', addressCountry);
    },

    handleClearEvent: function(component, event) {
        component.set('v.addressProvince', '');
        component.set('v.addressCity', '');
        component.set('v.addressPostalCode', '');
        component.set('v.addressCountry', '');
    },

    submitAddress: function(component) {
        var globalId = component.getGlobalId();
        document.getElementById(globalId + '_address_submit').click();
    },

    addValidation: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var fieldName = params.fieldName;
            var fieldError = params.fieldError;
        }
        helper.addValidation(component, fieldName, fieldError);
    },

    removeValidation: function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params) {
            var fieldName = params.fieldName;
        }
        helper.removeValidation(component, fieldName);
    },

    validate: function(component) {
        var returnValue = 'pass';
        var searchComponent = component.find('branchSuburbSearch');
        if (!component.find('AddressStreet').get('v.validity').valid) {
            component.find('AddressStreet').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('AddressPostalCode').get('v.validity').valid) {
            component.find('AddressPostalCode').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('AddressCity').get('v.validity').valid) {
            component.find('AddressCity').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('AddressProvince').get('v.validity').valid) {
            component.find('AddressProvince').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('AddressCountry').get('v.validity').valid) {
            component.find('AddressCountry').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!searchComponent.validate()) {
            returnValue = 'fail';
        }
        return returnValue;
    }
})