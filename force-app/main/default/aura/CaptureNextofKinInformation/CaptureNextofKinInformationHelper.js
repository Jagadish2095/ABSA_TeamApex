({
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
        var mainCustCellphone = component.get("v.mainCustomerCellNumber");
       	var nextOfkincellphoneNumber = component.get("v.cellphoneNumber");
        this.removeValidation(component,'NextofKinCellphoneNumber');
        var pattern = new RegExp(mainCustCellphone);
        
        if (!component.find('NextofKinFirstName').get('v.validity').valid) {
            component.find('NextofKinFirstName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('NextofKinLastName').get('v.validity').valid) {
            component.find('NextofKinLastName').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('NextofKinRelationship').get('v.validity').valid) {
            component.find('NextofKinRelationship').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (nextOfkincellphoneNumber.match(pattern)){
            this.addValidation(component, 'NextofKinCellphoneNumber', 'CELLPHONE CAN NOT BE THE SAME AS CUSTOMER CELLPHONE.');
            returnValue = 'fail';
        }
        if (!component.find('NextofKinCellphoneNumber').get('v.validity').valid) {
            component.find('NextofKinCellphoneNumber').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('NextofKinTelephoneNumber').get('v.validity').valid) {
            component.find('NextofKinTelephoneNumber').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        if (!component.find('NextofKinEmailAddress').get('v.validity').valid) {
            component.find('NextofKinEmailAddress').showHelpMessageIfInvalid();
            returnValue = 'fail';
        }
        return returnValue;
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
                    reject('Failed');
                }
            });
            $A.enqueueAction(action);
        })
    },
    
    getFieldsValidation : function(component, helper) {
        var firstName = component.get('v.firstName');
        var lastName = component.get('v.lastName');
        var relationship = component.get('v.relationship');
        var cellphoneNumber = component.get('v.cellphoneNumber');
        var telephoneNumber = component.get('v.telephoneNumber');
        if ($A.util.isUndefinedOrNull(telephoneNumber)) {
            telephoneNumber = '';
        }
        var emailAddress = component.get('v.emailAddress');
        if ($A.util.isUndefinedOrNull(emailAddress)) {
            emailAddress = '';
        }
        return [
            {'Value':firstName, 'CMPField':'NextofKinFirstName', 'ServiceField':'nextOfkinFirstname'},
            {'Value':relationship, 'CMPField':'NextofKinRelationship', 'ServiceField':'nextOfkinRelationCode'},
            {'Value':lastName, 'CMPField':'NextofKinLastName', 'ServiceField':'nextOfkinSurname'},
            {'Value':cellphoneNumber, 'CMPField':'NextofKinCellphoneNumber', 'ServiceField':'nextOfKinCellNumber'},
            {'Value':telephoneNumber, 'CMPField':'NextofKinTelephoneNumber', 'ServiceField':'nextOfkinHomeTelNumber'},
            {'Value':emailAddress, 'CMPField':'NextofKinEmailAddress', 'ServiceField':'nextOfKinEmail'}
        ];
    }
})