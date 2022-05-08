({
    hasQualificationOptions: [
        {'label': 'Yes', 'value': 'Yes'},
        {'label': 'No', 'value': 'No'}
    ],

    incomeTaxOptions: [
        {'label': 'Yes', 'value': 'Yes'},
        {'label': 'No', 'value': 'No'}
    ],

    foreignTaxOptions: [
        {'label': 'Yes', 'value': 'Yes'},
        {'label': 'No', 'value': 'No'}
    ],

    getHasQalificationOptions: function() {
        return this.hasQualificationOptions;
    },

    getIncomeTaxOptions: function() {
        return this.incomeTaxOptions;
    },

    getForeignTaxOptions: function() {
        return this.foreignTaxOptions;
    },

    getTaxUiValue: function(fieldValue) {
        var returnValue;
        if (fieldValue){
            returnValue = 'Yes';
        } else {
            returnValue = 'No';
        }
        return returnValue;
    },

    getTaxFieldValue: function(UiValue) {
        var returnValue;
        if (UiValue == 'Yes'){
            returnValue = true;
        } else {
            returnValue = false;
        }
        return returnValue;
    },

    getTaxServiceValue: function(UiValue) {
        var returnValue;
        if (UiValue == 'Yes'){
            returnValue = 'Y';
        } else {
            returnValue = 'N';
        }
        return returnValue;
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
        if (!component.find('OccupationStatus').get('v.validity').valid) {
            component.find('OccupationStatus').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        var occupationStatus = component.get('v.occupationStatus');
        switch (occupationStatus) {
            case 'Housewife':
            case 'Student':
            case 'Unemployed':
            case 'Pensioner':
            case 'Pre-School/Scholar':
                break;
            default:
                if (!component.find('OccupationLevel').get('v.validity').valid) {
                    component.find('OccupationLevel').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('OccupationCategory').get('v.validity').valid) {
                    component.find('OccupationCategory').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('Industry').get('v.validity').valid) {
                    component.find('Industry').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('EmployerName').get('v.validity').valid) {
                    component.find('EmployerName').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (!component.find('EmployerPhone').get('v.validity').valid) {
                    component.find('EmployerPhone').showHelpMessageIfInvalid();
                    returnValue = 'fail';
                }
                if (component.find('branchAddress').validate() != 'pass') {
                    returnValue = 'fail';
                }
                break;
        }

        if (!component.find('HasPostMatricQualificationRadioGroup').get('v.validity').valid) {
            component.find('HasPostMatricQualificationRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        var hasQualification = component.get('v.hasQualification');
        if (hasQualification == 'Yes') {
            if (!component.find('PostMatricQualification').get('v.validity').valid) {
                component.find('PostMatricQualification').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
        }

        if (!component.find('IncomeTaxRadioGroup').get('v.validity').valid) {
            component.find('IncomeTaxRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('ForeignTaxRadioGroup').get('v.validity').valid) {
            component.find('ForeignTaxRadioGroup').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }

        return returnValue;
    },

    handleAddValidation: function(component) {
        var addressComponent = component.find("branchAddress");
        var errorMap = component.get('v.errorMap');
        for(var auraId in errorMap) {
            if ((auraId == 'AddressStreet') || (auraId == 'AddressSuburb') || (auraId == 'AddressPostalCode') || (auraId == 'AddressCity') || (auraId == 'AddressProvince') || (auraId == 'AddressCountry')) {
                addressComponent.AddValidation(auraId, errorMap[auraId]);
            } else {
                this.addValidation(component, auraId, errorMap[auraId]);
            }
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
        var addressComponent = component.find("branchAddress");
        var errorMap = component.get('v.errorMap');
        for(var auraId in errorMap) {
            if ((auraId == 'AddressStreet') || (auraId == 'AddressSuburb') || (auraId == 'AddressPostalCode') || (auraId == 'AddressCity') || (auraId == 'AddressProvince') || (auraId == 'AddressCountry')) {
                addressComponent.RemoveValidation(auraId);
            } else {
                this.removeValidation(component, auraId);
            }
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
                    if (returnValue['Response'])
                    {
                        resolve('Continue');
                    } else {
                        component.set('v.errorMap', returnValue);
                        reject('Failed');
                    }
                } else {
                    reject('Failed');
                }
            });
            $A.enqueueAction(action);
        })
    },

    getFieldsValidation : function(component, helper) {
        var addressComponent = component.find("branchAddress");
        var occupationStatus = component.get('v.occupationStatus');
        var occupationLevel = '0';
        var hasPostMatricQualification = helper.getFieldValue(component, 'HasPostMatricQualificationRadioGroup');
        var hasPostMatricQualificationValue = helper.getTaxServiceValue(hasPostMatricQualification);
        var postMatricQualification = '0';
        if (hasPostMatricQualificationValue == 'Y') {
            postMatricQualification = component.get('v.qualification');
        }
        var occupationCategory = '0';
        var industry = '0';
        var employerName = '';
        var testPhone = component.get('v.employerPhone');
        var employerPhoneCode = '0';
        var employerPhone = '0';
        if ((!$A.util.isUndefinedOrNull(testPhone)) && (testPhone != '' )) {
            var employerPhoneCode = testPhone.substring(0, 3);
            var employerPhone = testPhone.substring(3, 10);
        }
        var addressStreet = '';
        var addressSuburb = '';
        var addressPostalCode = '';
        var addressCity = '';
        var incomeTaxValue = helper.getFieldValue(component, 'IncomeTaxRadioGroup');
        var incomeTaxServiceValue = helper.getTaxServiceValue(incomeTaxValue);
        var incomeTaxNumber = '0';
        var incomeTaxReason = '';
        if (incomeTaxValue == 'Yes') {
            incomeTaxNumber = component.get('v.incomeTaxNumber');
            if (incomeTaxNumber == '') {
                incomeTaxNumber = '0';
            }
            incomeTaxReason = component.get('v.incomeTaxReason');
            if (incomeTaxReason == null) {
                incomeTaxReason = '';
            }
        } else {
            component.set('v.incomeTaxNumber', '');
            component.set('v.incomeTaxReason', '');
        }
        var foreignTaxValue = helper.getFieldValue(component, 'ForeignTaxRadioGroup');
        var foreignTaxServiceValue = helper.getTaxServiceValue(foreignTaxValue);
        var occupationStatus = component.get('v.occupationStatus');
        switch (occupationStatus) {
            case 'Housewife':
            case 'Student':
            case 'Unemployed':
            case 'Pensioner':
            case 'Pre-School/Scholar':
                return [
                    {'Value':occupationStatus,'CMPField':'OccupationStatus','ServiceField':'occupationStatusCode'},
                    {'Value':hasPostMatricQualificationValue,'CMPField':'HasPostMatricQualificationRadioGroup','ServiceField':'postMatricQualificationInd'},
                    {'Value':postMatricQualification,'CMPField':'PostMatricQualification','ServiceField':'postMatricQualificationCode'},
                    {'Value':incomeTaxServiceValue,'CMPField':'IncomeTaxRadioGroup','ServiceField':'saTaxRegisteredInd'},
                    {'Value':incomeTaxNumber,'CMPField':'IncomeTaxNumber','ServiceField':'saTaxNumber'},
                    {'Value':incomeTaxReason,'CMPField':'ReasonSaTaxNotGiven','ServiceField':'reasonSaTaxNotGivenCode'},
                    {'Value':foreignTaxServiceValue,'CMPField':'ForeignTaxRadioGroup','ServiceField':'foreignTaxRegisteredInd'}
                ];
            default:
                occupationCategory = component.get('v.occupationCategory');
                occupationLevel = component.get('v.occupationLevel');
                industry = component.get('v.employerSector');
                employerName = component.get('v.employerName');
                addressStreet = addressComponent.get('v.addressStreet');
                addressSuburb = addressComponent.get('v.addressSuburb');
                addressPostalCode = addressComponent.get('v.addressPostalCode');
                addressCity = addressComponent.get('v.addressCity');
                return [
                    {'Value':occupationStatus,'CMPField':'OccupationStatus','ServiceField':'occupationStatusCode'},
                    {'Value':occupationLevel,'CMPField':'OccupationLevel','ServiceField':'occupationLevelCode'},
                    {'Value':hasPostMatricQualificationValue,'CMPField':'HasPostMatricQualificationRadioGroup','ServiceField':'postMatricQualificationInd'},
                    {'Value':postMatricQualification,'CMPField':'PostMatricQualification','ServiceField':'postMatricQualificationCode'},
                    {'Value':occupationCategory,'CMPField':'OccupationCategory','ServiceField':'occupationCode'},
                    {'Value':industry,'CMPField':'Industry','ServiceField':'employmentSectorCode'},
                    {'Value':employerName,'CMPField':'EmployerName','ServiceField':'employerName'},
                    {'Value':employerPhone,'CMPField':'EmployerPhone','ServiceField':'workTelephoneNumber'},
                    {'Value':employerPhoneCode,'CMPField':'EmployerPhone','ServiceField':'workTelephoneDialcode'},
                    {'Value':addressStreet,'CMPField':'AddressStreet','ServiceField':'employerAddrLine1'},
                    {'Value':addressSuburb,'CMPField':'AddressSuburb','ServiceField':'employerSuburb'},
                    {'Value':addressCity,'CMPField':'AddressCity','ServiceField':'employerTown'},
                    {'Value':addressPostalCode,'CMPField':'AddressPostalCode','ServiceField':'employerRsaPostalCode'},
                    {'Value':incomeTaxServiceValue,'CMPField':'IncomeTaxRadioGroup','ServiceField':'saTaxRegisteredInd'},
                    {'Value':incomeTaxNumber,'CMPField':'IncomeTaxNumber','ServiceField':'saTaxNumber'},
                    {'Value':incomeTaxReason,'CMPField':'ReasonSaTaxNotGiven','ServiceField':'reasonSaTaxNotGivenCode'},
                    {'Value':foreignTaxServiceValue,'CMPField':'ForeignTaxRadioGroup','ServiceField':'foreignTaxRegisteredInd'}
                ];
        }
    },

    getFieldValue : function(component, fieldName) {
        var fieldValue = '';
        if (component.find(fieldName).get('v.value')) {
            fieldValue = component.find(fieldName).get('v.value').toString();
        }
        return fieldValue;
    }
})