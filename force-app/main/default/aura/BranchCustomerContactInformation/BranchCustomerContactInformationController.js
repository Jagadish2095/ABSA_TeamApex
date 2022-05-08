({
    init: function(component, event, helper)
    {
        helper.fetchTranslationValues(component, 'v.communicationMethodOptions', 'CIFCodesList', 'Prefcomms', 'Outbound', 'Account', 'Preferred_Communication_Method__pc');
        helper.fetchTranslationValues(component, 'v.countryOptions', 'CIFCodesList', 'Casa Country', 'Outbound', 'Address__c', 'Shipping_Country__c');
        helper.fetchLanguageOptions(component);//Must be limited to Afr and Eng
        helper.fetchPostalOptions(component);
        helper.fetchStatementOptions(component);
        helper.fetchData(component);
    },

    checkForEmail: function(component, event, helper) {
        var communicationMethod = component.get('v.communicationMethod');
        var statementOptionsValue = component.get('v.statementOptionsValue');

        if (communicationMethod == 'Email' || statementOptionsValue == 'Email') {
            component.set('v.emailRequired', true);
        } else {
            component.set('v.emailRequired', false);
        }
    },

    contactRecordLoaded: function(component, event, helper) {
        var payload = event.getParam('recordUi');
        var personEmail = payload.record.fields['PersonEmail'].value;
        var personOtherPhone = payload.record.fields['PersonOtherPhone'].value;
        var communicationLanguage = payload.record.fields['Communication_Language__pc'].value;
        var personMobilePhone = payload.record.fields['PersonMobilePhone'].value;
        var communicationMethod = payload.record.fields['Preferred_Communication_Method__pc'].value;
       // var statementOption = payload.record.fields['Statement_Preference__pc'].value;
	    var statementOption = '';
	   if (payload.record.fields["Statement_Preference__pc"] != null) {
		   statementOption  = payload.record.fields["Statement_Preference__pc"].value;
	   }  
	   component.set('v.personEmail', personEmail);
        component.set('v.personOtherPhone', personOtherPhone);
        component.set('v.communicationLanguage', communicationLanguage);
        component.set('v.personMobilePhone', personMobilePhone);
        component.set('v.communicationMethod', communicationMethod);
        component.set('v.statementOptionsValue', statementOption);
    },

    contactRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var personEmail = component.get('v.personEmail');
        var personOtherPhone = component.get('v.personOtherPhone');
        var communicationLanguage = component.get('v.communicationLanguage');
        var personMobilePhone = component.get('v.personMobilePhone');
        var communicationMethod = component.get('v.communicationMethod');
        var statementOption = component.get('v.statementOptionsValue');
        eventFields['PersonEmail'] = personEmail;
        eventFields['PersonOtherPhone'] = personOtherPhone;
        eventFields['Communication_Language__pc'] = communicationLanguage;
        eventFields['PersonMobilePhone'] = personMobilePhone;
        eventFields['Preferred_Communication_Method__pc'] = communicationMethod;
        eventFields['Statement_Preference__pc'] = statementOption;
        eventFields['Valid_Update_Bypass__c'] = true;
        component.find('ContactInformation').submit(eventFields);
    },

    contactRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
        component.set('v.updating', false);
    },

    contactRecordSuccess : function(component, event, helper) {
        var globalId = component.getGlobalId();
        document.getElementById(globalId + '_residential_submit').click();
    },

    residentialRecordLoaded: function(component, event, helper) {
        var searchComponent = component.find('ResidentialSuburb');
        var payload = event.getParam('recordUi');
        var street = payload.record.fields['Shipping_Street__c'].value;
        var street2 = payload.record.fields['Shipping_Street_2__c'].value;
        var postal = payload.record.fields['Shipping_Zip_Postal_Code__c'].value;
        var suburb = payload.record.fields['Shipping_Suburb__c'].value;
        var city = payload.record.fields['Shipping_City__c'].value;
        var province = payload.record.fields['Shipping_State_Province__c'].value;
        var country = payload.record.fields['Shipping_Country__c'].value;
        if (component.get('v.residentialLoaded') == 'false') {
            component.set('v.residentialStreet', street);
            component.set('v.residentialStreet2', street2);
            component.set('v.residentialPostalCode', postal);
            component.set('v.residentialSuburb', suburb);
            component.set('v.residentialCity', city);
            component.set('v.residentialProvince', province);
            component.set('v.residentialCountry', country);
            if (!$A.util.isUndefinedOrNull(searchComponent)) {
            	searchComponent.set('v.residentialSuburb', suburb);
            }
            component.set('v.residentialLoaded', 'true');
            if (component.get('v.postalLoaded') == 'true') {
                helper.checkAddress(component);
            }
        }
    },

    residentialRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var street = component.get('v.residentialStreet');
        var street2 = component.get('v.residentialStreet2');
        var postal = component.get('v.residentialPostalCode');
        var suburb = component.get('v.residentialSuburb');
        var city = component.get('v.residentialCity');
        var province = component.get('v.residentialProvince');
        var country = component.get('v.residentialCountry');
        eventFields['Shipping_Street__c'] = street;
        eventFields['Shipping_Street_2__c'] = street2;
        eventFields['Shipping_Zip_Postal_Code__c'] = postal;
        eventFields['Shipping_Suburb__c'] = suburb;
        eventFields['Shipping_City__c'] = city;
        eventFields['Shipping_State_Province__c'] = province;
        eventFields['Shipping_Country__c'] = country;
        component.find('ResidentialAddressDetail').submit(eventFields);
    },

    residentialRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
        component.set('v.updating', false);
    },

    residentialRecordSuccess : function(component, event, helper) {
        var globalId = component.getGlobalId();
        document.getElementById(globalId + '_postal_submit').click();
    },

    postalRecordLoaded: function(component, event, helper) {
        var searchComponent = component.find('PostalSuburb');
        var payload = event.getParam('recordUi');
        var street = payload.record.fields['Shipping_Street__c'].value;
        var street2 = payload.record.fields['Shipping_Street_2__c'].value;
        var postal = payload.record.fields['Shipping_Zip_Postal_Code__c'].value;
        var suburb = payload.record.fields['Shipping_Suburb__c'].value;
        var city = payload.record.fields['Shipping_City__c'].value;
        var province = payload.record.fields['Shipping_State_Province__c'].value;
        var country = payload.record.fields['Shipping_Country__c'].value;
        if (component.get('v.postalLoaded') == 'false') {
            component.set('v.postalStreet', street);
            component.set('v.postalStreet2', street2);
            component.set('v.postalPostalCode', postal);
            component.set('v.postalSuburb', suburb);
            component.set('v.postalCity', city);
            component.set('v.postalProvince', province);
            component.set('v.postalCountry', country);
            if (!$A.util.isUndefinedOrNull(searchComponent)) {
            	searchComponent.set('v.postalSuburb', suburb);
            }
            component.set('v.postalLoaded', 'true');
            if (component.get('v.residentialLoaded') == 'true') {
                helper.checkAddress(component);
            }
        }
    },

    postalRecordSubmit: function(component, event, helper) {
        event.preventDefault();
        var eventFields = event.getParam('fields');
        var street = component.get('v.postalStreet');
        var street2 = component.get('v.postalStreet2');
        var postal = component.get('v.postalPostalCode');
        var suburb = component.get('v.postalSuburb');
        var city = component.get('v.postalCity');
        var province = component.get('v.postalProvince');
        var country = component.get('v.postalCountry');
        eventFields['Shipping_Street__c'] = street;
        eventFields['Shipping_Street_2__c'] = street2;
        eventFields['Shipping_Zip_Postal_Code__c'] = postal;
        eventFields['Shipping_Suburb__c'] = suburb;
        eventFields['Shipping_City__c'] = city;
        eventFields['Shipping_State_Province__c'] = province;
        eventFields['Shipping_Country__c'] = country;
        component.find('PostalAddressDetail').submit(eventFields);
        component.set('v.postalLoaded', 'false');
    },

    postalRecordError : function(component, event, helper) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        component.find('branchFlowFooter').set('v.heading', errorMessage);
        component.find('branchFlowFooter').set('v.message', JSON.stringify(eventDetails));
        component.find('branchFlowFooter').set('v.showDialog', true);
        component.set('v.updating', false);
    },

    postalRecordSuccess : function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = component.get('v.actionClicked');
        component.set('v.updating', false);
        navigate(actionClicked);
    },

    postalSelectionChange: function(component, event, helper) {
        var postalSame = component.get('v.postalSame');
        var residentialLoaded = component.get('v.residentialLoaded');
        var postalLoaded = component.get('v.postalLoaded');
        if ((postalSame == 'true') && (residentialLoaded == 'true') && (postalLoaded == 'true')) {
            helper.setPostalAddress(component);
            helper.checkAddress(component);
        } else {
            component.set('v.postalSameIf', postalSame);
        }
    },

    handleStatementOptionsGroup: function(component, event, helper) {
        var statementOption = component.get('v.statementOptionsValue');
        var resultCmp = component.find('statementOptionsRadioGroup');
        resultCmp.set('v.value', statementOption);
    },

    handleSearchEvent: function(component, event, helper) {
        var addressType = event.getParam('addressType');
        if (addressType == 'Residential') {
            helper.searchValues(component, 'ResidentialSuburb');
        }
        if (addressType == 'Postal') {
            helper.searchValues(component, 'PostalSuburb');
        }
    },

    handleClearEvent: function(component, event, helper) {
        var addressType = event.getParam('addressType');
        if (addressType == 'Residential') {
            helper.clearValues(component, 'ResidentialSuburb');
        }
        if (addressType == 'Postal') {
            helper.clearValues(component, 'PostalSuburb');
        }
    },

    addressChanged: function (component, event, helper) {
        if (component.get('v.postalSame') == 'true') {
            helper.checkAddress(component);
        }
    },

    handleNavigate: function(component, event, helper) {
        var navigate = component.get('v.navigateFlow');
        var actionClicked = event.getParam('action');
        var globalId = component.getGlobalId();
        component.set('v.updating', true);
        component.set('v.actionClicked', actionClicked);

        switch(actionClicked)
        {
            case 'NEXT':
            case 'FINISH':
                if (helper.checkValidity(component, helper) == 'pass') {
                    helper.handleRemoveValidation(component);
                    var promise = helper.executeValidate(component, helper)
                    .then(
                        $A.getCallback(function(result) {
                            document.getElementById(globalId + '_contact_submit').click();
                        }),
                        $A.getCallback(function(error) {
                            helper.handleAddValidation(component);
                            component.set('v.updating', false);
                        })
                    )
                    } else {
                        component.set('v.updating', false);
                    }
                break;
            case 'BACK':
            case 'PAUSE':
                if (helper.checkValidity(component, helper) == 'pass') {
                    document.getElementById(globalId + '_contact_submit').click();
                } else {
                    component.set('v.updating', false);
                    var ignoreValidity = confirm('Validation failed! Continue without saving?');
                    if (ignoreValidity) {
                        navigate(actionClicked);
                    }
                }
                break;
        }
    }
})