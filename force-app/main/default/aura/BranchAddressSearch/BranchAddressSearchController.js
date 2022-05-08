({
    doInit: function(component, event, helper) {
        //component.set('v.addressLoading', true);
        helper.fetchData(component);
        var heading = 'Results based on Search: ' + component.get('v.areaToSearch');
        component.set('v.searchHeading', heading);
    },

    selectAddress: function(component, event, helper) {
        var row = event.getParam('selectedRows');
        var addressSuburb = utilities.capitalizeFirstLetter(row[0].suburbName);
        var addressTown = utilities.capitalizeFirstLetter(row[0].townOrCityName);
        var addressPostal = row[0].streetPostCode;
        component.set('v.addressProvinceName', row[0].provinceName);
        var addressProvince = helper.getProvinceName(component);
        var addressCountry = helper.getCountryName(component);
        component.set('v.addressSuburb', addressSuburb);
        component.set('v.addressTown',  addressTown);
        component.set('v.addressPostal', addressPostal);
        component.set('v.addressProvince', addressProvince);
        component.set('v.addressCountry', addressCountry);
        component.set("v.searchAddress", false); 
        helper.fireEvent(component);
    },
    
    closeSearch: function(component, event, helper) {
        component.set('v.addressSuburb', 'Canceled');
        component.set('v.addressTown',  '');
        component.set('v.addressPostal', '');
        component.set('v.addressProvince', '');
        component.set('v.addressCountry', '');
        component.set("v.searchAddress", false); 
        helper.fireEvent(component);
    },
})