({
    fetchData: function(component) {
        var action = component.get("c.getAddress");
        var recordId = component.get("v.recordId");
        var requestedAddressTypes = component.get("v.addressType");
        action.setParams({
            "recordId" : recordId,
            "requestedAddressTypeList" : requestedAddressTypes
        });
        action.setCallback(this, function(response) {
            var adderssData =  response.getReturnValue();
            component.set("v.addressRecordId", adderssData[requestedAddressTypes]);
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

    removeValidation: function(component, componentAuraId) {
        var globalId = component.getGlobalId();
        var validationElementId = (globalId + '_' + componentAuraId + '_Error');
        var errorComponent = component.find(componentAuraId);
        $A.util.removeClass(errorComponent, 'slds-has-error');
        if(document.getElementById(validationElementId)) {
            var errorElement = document.getElementById(validationElementId);
            errorElement.parentNode.removeChild(errorElement);
        }
    }
})