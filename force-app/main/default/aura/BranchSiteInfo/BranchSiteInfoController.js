({
    handleKeyUp: function (component, event) {
        var isEnterKey = event.keyCode === 13;
        var searchCmp = component.find('site-search');
        searchCmp.setCustomValidity('');
        var isValid = searchCmp.get('v.validity').valid;
        searchCmp.reportValidity();
        if (isValid && isEnterKey) {
            var searchText = searchCmp.get('v.value');
            component.set('v.siteToSearch', searchText );
            component.set('v.canSearchSites', true );
        }
    },

    checkSearch: function (component) {
        if (component.get('v.siteResult') == '') {
            component.set('v.siteName', '');
            component.set('v.siteCode', '');
        }
        if (component.get('v.siteResult') == 'Canceled') {
            component.set('v.siteResult', '');
        }
    },

    validate: function(component) {
        var searchCmp = component.find('site-search');
        var siteName = component.get('v.siteName');
        var siteCode = component.get('v.siteCode');
        if ($A.util.isUndefinedOrNull(siteName) || siteName == '') {
            searchCmp.setCustomValidity('Invalid Site');
        }
        if ($A.util.isUndefinedOrNull(siteCode) || siteCode == '') {
            searchCmp.setCustomValidity('Invalid Site');
        }
        searchCmp.reportValidity();
        return searchCmp.get('v.validity').valid;
    }
})