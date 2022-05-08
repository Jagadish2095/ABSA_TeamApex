({
    setDate: function(component) {
        var today = new Date();
        today.setDate(today.getDate() - 1);
        component.set("v.today", $A.localizationService.formatDate(today, "YYYY-MM-DD"));
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

    setControls: function(component) {
        var processType = component.get('v.processType');
        if (processType == 'Packages') {
            component.set('v.disabled', true);
        }
    },

    checkValidity: function(component, helper) {
        var returnValue = 'pass';
        if (!component.find('ClientType').get('v.validity').valid) {
            component.find('ClientType').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('PersonTitle').get('v.validity').valid) {
            component.find('PersonTitle').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('FirstName').get('v.validity').valid) {
            component.find('FirstName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('LastName').get('v.validity').valid) {
            component.find('LastName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('IdNumber').get('v.validity').valid) {
            component.find('IdNumber').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('DateIdIssued').get('v.validity').valid) {
            component.find('DateIdIssued').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('CountryOfBirth').get('v.validity').valid) {
            component.find('CountryOfBirth').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('Nationality').get('v.validity').valid) {
            component.find('Nationality').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('MaritalStatus').get('v.validity').valid) {
            component.find('MaritalStatus').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (component.get('v.maritalStatus') == 'Married') {
            if (!component.find('MaritalContractType').get('v.validity').valid) {
                component.find('MaritalContractType').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
        }
        if (!component.find('HomeLanguage').get('v.validity').valid) {
            component.find('HomeLanguage').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (component.get('v.homeLanguage') == 'Other') {
            if (!component.find('HomeLanguageOther').get('v.validity').valid) {
                component.find('HomeLanguageOther').showHelpMessageIfInvalid();
                returnValue = 'fail';
            }
        }
        if (!component.find('SourceOfIncome').get('v.validity').valid) {
            component.find('SourceOfIncome').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        return returnValue;
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
                    reject('Failed');
                }
            });
            $A.enqueueAction(action);
        })
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

    getFieldsValidation : function(component, helper) {
        var personTitle = component.get("v.personTitle");
        var firstName = component.get("v.firstName");
        var lastName = component.get("v.lastName");
        var iDNumber = component.get("v.iDNumber");
        var dateIssued = $A.localizationService.formatDate(component.get("v.dateIssued"), 'YYYYMMDD').toString();
        var countryOfBirth = component.get("v.countryOfBirth");
        var nationality = component.get("v.nationality");
        var maritalStatus = component.get("v.maritalStatus");
        var maritalContractType = component.get("v.maritalContractType");
        var homeLanguage = component.get("v.homeLanguage");
        var homeLanguageOther = '';
        if (homeLanguage == 'Other') {
            homeLanguageOther = component.get('v.homeLanguageOther');
        }
        var incomeSource = component.get("v.incomeSource");

        return [
            {'Value':personTitle,'CMPField':'PersonTitle','ServiceField':'titleCode'},
            {'Value':firstName,'CMPField':'FirstName','ServiceField':'firstNames'},
            {'Value':lastName,'CMPField':'LastName','ServiceField':'surname'},
            {'Value':iDNumber,'CMPField':'IdNumber','ServiceField':'idNumber'},
            {'Value':dateIssued,'CMPField':'DateIdIssued','ServiceField':'dateIdDocIssued'},
            {'Value':countryOfBirth,'CMPField':'CountryOfBirth','ServiceField':'countryOfBirthCode'},
            {'Value':nationality,'CMPField':'Nationality','ServiceField':'clientNationalityCode'},
            {'Value':maritalStatus,'CMPField':'MaritalStatus','ServiceField':'maritalStatusCode'},
            //{'Value':maritalContractType,'CMPField':'MaritalContractType','ServiceField':'marriageContractTypeCode'},
            {'Value':homeLanguage,'CMPField':'HomeLanguage','ServiceField':'homeLanguageCode'},
            //{'Value':homeLanguageOther,'CMPField':'HomeLanguageOther','ServiceField':'homeLanguageOther'}
            {'Value':incomeSource,'CMPField':'SourceOfIncome','ServiceField':'sourceOfIncomeCode'}
        ];
    }
})