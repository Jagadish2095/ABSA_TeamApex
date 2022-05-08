({
    fetchData: function(component) {
        var addressType = component.get("v.addressType");
        this.callApex(component, "c.getAddress", { recordId: component.get("v.recordId"), requestedAddressTypeList: addressType }, this.setRecordId, addressType);
    },

    setRecordId : function(component, responseValue, addressType) {
        if (responseValue) {
            component.set("v.addressRecordId", responseValue[addressType]);
        }
    },

    fetchTranslationValues : function(component) {
        this.getTranslationValues(component, "c.getTranslationValues", this.setTranslationParamOutbound("CIFCodesList", "Casa Country", "Address__c", "Shipping_Country__c"), "v.countryOptions");
    },

    fireAddressRecordEvent : function(component, event, eventName) {
        var errorMessage = event.getParam("message");
        var eventDetails = event.getParam("error");
        var statusCode = event.getParam("statusCode");
        var componentEvent = component.getEvent("addressRecordEvent");
        componentEvent.setParams({
            eventName: eventName,
            eventData: component.get("v.addressType"),
            statusCode: statusCode,
            errorMessage: errorMessage,
            eventDetails: JSON.stringify(eventDetails)
        });
        componentEvent.fire();
    },

    checkValidity : function(component) {
        var returnValue = "pass";
        var searchComponent = component.find("branchSuburbSearch");
        if (!component.find("AddressStreet").get("v.validity").valid) {
            component.find("AddressStreet").showHelpMessageIfInvalid();
            returnValue = "fail";
        }
        if (!component.find("AddressPostalCode").get("v.validity").valid) {
            component.find("AddressPostalCode").showHelpMessageIfInvalid();
            returnValue = "fail";
        }
        if (!component.find("AddressCity").get("v.validity").valid) {
            component.find("AddressCity").showHelpMessageIfInvalid();
            returnValue = "fail";
        }
        if (!component.find("AddressProvince").get("v.validity").valid) {
            component.find("AddressProvince").showHelpMessageIfInvalid();
            returnValue = "fail";
        }
        if (!component.find("AddressCountry").get("v.validity").valid) {
            component.find("AddressCountry").showHelpMessageIfInvalid();
            returnValue = "fail";
        }
        if (!searchComponent.validate()) {
            returnValue = "fail";
        }
        return returnValue;
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