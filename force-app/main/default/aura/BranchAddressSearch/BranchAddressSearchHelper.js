({
    fetchData: function(component) {
        component.set('v.columns', [
            {label: 'Suburb', fieldName: 'suburbName', type: 'text'},
            {label: 'City', fieldName: 'townOrCityName', type: 'text'},
            {label: 'Postal code', fieldName: 'streetPostCode', type: 'text'},
            {label: 'Province', fieldName: 'provinceName', type: 'text'}
        ]);

        let action = component.get('c.getPostalCodeDetails');
        var areaToSearch = component.get("v.areaToSearch");
        areaToSearch = areaToSearch.toUpperCase();
        action.setParams({
            "area" : areaToSearch,
        });
        action.setCallback(this, function (response) {
            var res = response.getReturnValue();
            component.set('v.addressDetailsData', res);
            component.set('v.addressLoading', false);
        });
        $A.enqueueAction(action);
    },

    fireEvent: function(component) {
        var componentEvent = component.getEvent("addressSearchEvent");
        var addressType = component.get('v.addressType');
        componentEvent.setParams({
            "addressType" : addressType });
        componentEvent.fire();
    },

    getProvinceName: function(component) {
        switch (component.get('v.addressProvinceName')) {
            case 'EC':
                return 'Eastern Cape';
            case 'FS':
                return 'Free State';
            case 'GAUT':
                return 'Gauteng';
            case 'KZN':
                return 'KwaZulu-Natal';
            case 'LIMP':
                return 'Limpopo';
            case 'MPUM':
                return 'Mpumalanga';
            case 'NC':
                return 'Northern Cape';
            case 'NW':
                return 'North West';
            case 'WC':
                return 'Western Cape';
        }
    },

    getCountryName: function(component) {
        switch (component.get('v.addressProvinceName')) {
            case 'EC':
            case 'FS':
            case 'GAUT':
            case 'KZN':
            case 'LIMP':
            case 'MPUM':
            case 'NC':
            case 'NW':
            case 'WC':
                return 'South Africa';
            default:
                return '';
        }
    }
})