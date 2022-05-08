({
    handleKeyUp: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var isValid = component.find('address-search').get('v.validity').valid;
        component.find('address-search').showHelpMessageIfInvalid();
        if (isValid && isEnterKey) {
            var searchText = component.find('address-search').get('v.value');
            component.set('v.addressToSearch', searchText);
            component.set('v.canSearchAddress', true);
        }
    },

    checkAddress: function (component) {
        if (component.get('v.addressSuburb') == 'Canceled') {
            component.set('v.addressSuburb', '');
        } else if (component.get('v.addressSuburb') == '') {
            component.set('v.addressProvince', '');
            component.set('v.addressCity', '');
            component.set('v.addressPostalCode', '');
            component.set('v.addressCountry', '');
            var componentEvent = component.getEvent("addressClearEvent");
            var addressType = component.get('v.addressType');
            componentEvent.setParams({
                "addressType" : addressType });
            componentEvent.fire();
        }
    },
    
    validate: function(component) {
        var isValid = component.find('address-search').get('v.validity').valid;
        component.find('address-search').showHelpMessageIfInvalid();
        return isValid;
    }
})