({
    requestedAddressTypes: [
        'Residential','Postal'
    ],

    statementOptions: [
        {'label': 'Self Service', 'value': 'Self Service'},
        {'label': 'E-Mail', 'value': 'Email'},
        {'label': 'Post', 'value': 'Post'}
    ],

    postalOptions: [
        {'label': 'Yes', 'value': 'true'},
        {'label': 'No', 'value': 'false'}
    ],

    communicationLanguageOptions: [
        'Afrikaans','English'
    ],

    fetchStatementOptions: function(component) {
        component.set('v.statementOptions', this.statementOptions);
    },

    fetchPostalOptions: function(component) {
        component.set('v.postalOptions', this.postalOptions);
    },

    // Need to find better way to get picklistvalues per recordtype. API = lots of calls...
    fetchLanguageOptions: function(component) {
        component.set('v.communicationLanguageOptions', this.communicationLanguageOptions);
    },

    fetchData: function(component) {
        var action = component.get('c.getAddress');
        var recordId = component.get('v.recordId');
        var requestedAddressTypes = this.requestedAddressTypes;
        action.setParams( {
            'recordId' : recordId,
            'requestedAddressTypeList' : requestedAddressTypes
        } );
        action.setCallback(this, function(response) {
            var AdderssData =  response.getReturnValue();
            component.set('v.residentialRecordId',AdderssData['Residential']);
            component.set('v.postalRecordId',AdderssData['Postal']);
        });
        $A.enqueueAction(action);
    },

    fetchTranslationValues: function(component, listName, systemName, valueType, direction, objName, objField) {
        var action = component.get('c.getTranslationValues');
        var objObject = { 'sobjectType': objName };
        action.setParams({
            'systemName': systemName,
            'valueType': valueType,
            'direction': direction,
            'objObject': objObject,
            'objField': objField
        });
        action.setCallback(this, function(response) {
            var mapValues = response.getReturnValue();
            var listValues = [];
            for(var itemValue in mapValues) {
                if (mapValues[itemValue] == 'valid') {
                    listValues.push(itemValue);
                } else {
                    // Add function to log/mail system admin with missing values
                }
            }
            listValues.sort();
            component.set(listName, listValues);
        });
        $A.enqueueAction(action);
    },

    checkValidity: function(component, helper) {
        var returnValue = 'pass';
        if (!component.find('PersonEmail').get('v.validity').valid) {
            component.find('PersonEmail').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PersonOtherPhone').get('v.validity').valid) {
            component.find('PersonOtherPhone').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('CommunicationLanguage').get('v.validity').valid) {
            component.find('CommunicationLanguage').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PersonMobilePhone').get('v.validity').valid) {
            component.find('PersonMobilePhone').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PreferredCommunicationMethod').get('v.validity').valid) {
            component.find('PreferredCommunicationMethod').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('statementOptionsRadioGroup').get('v.validity').valid) {
            component.find('statementOptionsRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (helper.validateResidential(component) == 'fail') {
            returnValue = 'fail';
        }
        if (component.get('v.postalSameIf') == 'false') {
            if (helper.validatePostal(component) == 'fail') {
                returnValue = 'fail';
            }
        }
        return returnValue;
    },

    validateResidential: function(component) {
        var returnValue = 'pass';
        var searchComponent = component.find('ResidentialSuburb');

        if (!component.find('ResidentialStreet').get('v.validity').valid) {
            component.find('ResidentialStreet').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ResidentialPostalCode').get('v.validity').valid) {
            component.find('ResidentialPostalCode').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ResidentialCity').get('v.validity').valid) {
            component.find('ResidentialCity').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ResidentialProvince').get('v.validity').valid) {
            component.find('ResidentialProvince').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ResidentialCountry').get('v.validity').valid) {
            component.find('ResidentialCountry').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!searchComponent.validate()) {
            returnValue = 'fail';
        }
        return returnValue;
    },

    validatePostal: function(component) {
        var returnValue = 'pass';
        var searchComponent = component.find('PostalSuburb');

        if (!component.find('PostalStreet').get('v.validity').valid) {
            component.find('PostalStreet').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PostalPostalCode').get('v.validity').valid) {
            component.find('PostalPostalCode').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PostalCity').get('v.validity').valid) {
            component.find('PostalCity').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PostalProvince').get('v.validity').valid) {
            component.find('PostalProvince').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PostalCountry').get('v.validity').valid) {
            component.find('PostalCountry').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!searchComponent.validate()) {
            returnValue = 'fail';
        }
        return returnValue;
    },

    checkAddress: function(component) {
        var addressSame = 'true';
        if (component.get('v.residentialStreet') != component.get('v.postalStreet')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialStreet2') != component.get('v.postalStreet2')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialSuburb') != component.get('v.postalSuburb')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialCity') != component.get('v.postalCity')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialProvince') != component.get('v.postalProvince')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialPostalCode') != component.get('v.postalPostalCode')) {
            addressSame = 'false';
        }
        if (component.get('v.residentialCountry') != component.get('v.postalCountry')) {
            addressSame = 'false';
        }

        component.set('v.postalSameIf', addressSame);
        component.set('v.postalSame', addressSame);
        component.set('v.updating', false);
    },

    setPostalAddress: function(component) {
        var resStreet = component.get('v.residentialStreet');
        var resStreet2 = component.get('v.residentialStreet2');
        var resSuburb = component.get('v.residentialSuburb');
        var resCity = component.get('v.residentialCity');
        var resProvince = component.get('v.residentialProvince');
        var resPostalCode = component.get('v.residentialPostalCode');
        var resCountry = component.get('v.residentialCountry');
        component.set('v.postalStreet', resStreet);
        component.set('v.postalStreet2', resStreet2);
        component.set('v.postalSuburb', resSuburb);
        component.set('v.postalCity', resCity);
        component.set('v.postalProvince', resProvince);
        component.set('v.postalPostalCode', resPostalCode);
        component.set('v.postalCountry', resCountry);
    },

    searchValues: function(component, componentName) {
        var searchComponent = component.find(componentName);
        var addressCity = searchComponent.get('v.addressCity');
        var addressProvince = searchComponent.get('v.addressProvince');
        var addressPostalCode = searchComponent.get('v.addressPostalCode');
        var addressCountry = searchComponent.get('v.addressCountry');

        switch (componentName) {
            case 'ResidentialSuburb':
                component.set('v.residentialProvince', addressProvince);
                component.set('v.residentialCity', addressCity);
                component.set('v.residentialPostalCode', addressPostalCode);
                component.set('v.residentialCountry', addressCountry);
                break;
            case 'PostalSuburb':
                component.set('v.postalProvince', addressProvince);
                component.set('v.postalCity', addressCity);
                component.set('v.postalPostalCode', addressPostalCode);
                component.set('v.postalCountry', addressCountry);
                break;
        }
    },

    clearValues: function(component, componentName) {
        switch (componentName) {
            case 'ResidentialSuburb':
                component.set('v.residentialProvince', '');
                component.set('v.residentialCity', '');
                component.set('v.residentialPostalCode', '');
                component.set('v.residentialCountry', '');
                break;
            case 'PostalSuburb':
                component.set('v.postalProvince', '');
                component.set('v.postalCity', '');
                component.set('v.postalPostalCode', '');
                component.set('v.postalCountry', '');
                break;
        }
    },

    handleAddValidation: function(component) {
        var errorMap = component.get('v.errorMap');
        for(var auraId in errorMap) {
            this.addValidation(component, auraId, errorMap[auraId]);
        }
    },

    addValidation: function(component, componentAuraId, errorMsg) {
        var styleClass= 'slds-form-element__help validationCss';
        var errorComponent = component.find(componentAuraId);
        $A.util.addClass(errorComponent,'slds-has-error');
        var globalId = component.getGlobalId();
        var elementId = (globalId + '_' + componentAuraId);
        var validationElementId = (elementId + '_Error');
        var errorElement = document.getElementById(elementId)
        var validationElement = document.createElement('div');
        validationElement.setAttribute('id', validationElementId);
        validationElement.setAttribute('class', styleClass);
        validationElement.textContent = errorMsg;
        errorElement.appendChild(validationElement);
    },

    handleRemoveValidation: function(component) {
        var errorMap = component.get('v.errorMap');
        for(var auraId in errorMap) {
            this.removeValidation(component, auraId);
        }
    },

    removeValidation: function(component, componentAuraId) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + '_' + componentAuraId + '_Error');
        var errorComponent = component.find(componentAuraId);
        $A.util.removeClass(errorComponent, 'slds-has-error');
        if(document.getElementById(validationElementId)) {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        }
    },

    executeValidate : function(component, helper) {
        return new Promise(function(resolve, reject) {
            let action = component.get('c.validateFields');
            var RecordId = component.get('v.recordId');
            action.setParams({
                'accountID' : RecordId,
                'fieldsToValidate' :  helper.getFieldsValidation(component, helper)
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var returnValue = response.getReturnValue();
                    if (returnValue['Response']) {
                        resolve('Continue');
                    } else {
                        component.set('v.errorMap', returnValue);
                        reject('Failed');
                    }
                } else {
                    component.find('branchFlowFooter').set('v.heading', 'Error on executeValidate');
                    component.find('branchFlowFooter').set('v.message', response.getError());
                    component.find('branchFlowFooter').set('v.showDialog', true);
                    component.set('v.updating', false);
                    reject('Failed');
                }
            });
            $A.enqueueAction(action);
        })
    },

    getFieldsValidation : function(component, helper) {
        var personEmail = component.get('v.personEmail');
        if ($A.util.isUndefinedOrNull(personEmail)) {
            personEmail = '';
        }
        var testPhone = component.get('v.personOtherPhone');
        var personOtherPhoneCode = '0';
        var personOtherPhone = '0';
        if ($A.util.isUndefinedOrNull(testPhone) || testPhone == "" ) {
            testPhone = '';
        }else {
            var personOtherPhoneCode = testPhone.substring(0, 3);
            var personOtherPhone = testPhone.substring(3, 10);
        }

        var communicationLanguage = component.get('v.communicationLanguage');
        var personMobilePhone = component.get('v.personMobilePhone');
        var communicationMethod = component.get('v.communicationMethod');
        //var statementOption = component.get('v.statementOptionsValue');

        var residentialStreet = component.get('v.residentialStreet');
        var residentialStreet2 = component.get('v.residentialStreet2');

        if ($A.util.isUndefinedOrNull(residentialStreet2) || residentialStreet2 == "" ) {
            residentialStreet2 = '';
        }

        var residentialSuburb = component.get('v.residentialSuburb');
        var residentialCity = component.get('v.residentialCity');
        //var residentialProvince = component.get('v.residentialProvince');
        var residentialPostalCode = component.get('v.residentialPostalCode');
        var residentialCountry = component.get('v.residentialCountry');

        var postalStreet = component.get('v.postalStreet');
        var postalStreet2 = component.get('v.postalStreet2');

        if ($A.util.isUndefinedOrNull(postalStreet2) || postalStreet2 == "" ) {
            postalStreet2 = '';
        }

        var postalSuburb = component.get('v.postalSuburb');
        var postalCity = component.get('v.postalCity');
        //var postalProvince = component.get('v.postalProvince');
        var postalPostalCode = component.get('v.postalPostalCode');
        //var postalCountry = component.get('v.postalCountry');

        return [
            {'Value':personEmail,'CMPField':'PersonEmail','ServiceField':'emailAddress'},
            {'Value':personOtherPhone,'CMPField':'PersonOtherPhone','ServiceField':'homeFaxOrAlternativeNumber'},
            {'Value':personOtherPhoneCode,'CMPField':'PersonOtherPhone','ServiceField':'homeFaxOrAlternativeNumDialCode'},
            {'Value':communicationLanguage,'CMPField':'CommunicationLanguage','ServiceField':'commLanguageCode'},
            {'Value':personMobilePhone,'CMPField':'PersonMobilePhone','ServiceField':'cellphoneNumber'},
            {'Value':communicationMethod,'CMPField':'PreferredCommunicationMethod','ServiceField':'preferredCommMethodCode'},

            {'Value':residentialStreet,'CMPField':'ResidentialStreet','ServiceField':'physicalAddrLine1'},
            {'Value':residentialStreet2,'CMPField':'ResidentialStreet2','ServiceField':'physicalAddrLine2'},
            {'Value':residentialSuburb,'CMPField':'ResidentialSuburb','ServiceField':'physicalSuburb'},
            {'Value':residentialCity,'CMPField':'ResidentialCity','ServiceField':'physicalTown'},
            {'Value':residentialPostalCode,'CMPField':'ResidentialPostalCode','ServiceField':'physicalRsaPostalCode'},
            {'Value':residentialCountry,'CMPField':'residentialCountry','ServiceField':'countryOfPhysicalAddrCode'},

            {'Value':postalStreet,'CMPField':'PostalStreet','ServiceField':'postalAddrLine1'},
            {'Value':postalStreet2,'CMPField':'PostalStreet2','ServiceField':'postalAddrLine2'},
            {'Value':postalSuburb,'CMPField':'PostalSuburb','ServiceField':'postalSuburb'},
            {'Value':postalCity,'CMPField':'PostalCity','ServiceField':'postalTown'},
            {'Value':postalPostalCode,'CMPField':'PostalPostalCode','ServiceField':'postalAddrRsaCode'}
        ];
    }
})