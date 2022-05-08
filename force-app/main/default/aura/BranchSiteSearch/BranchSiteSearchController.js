({
    doInit : function(component, event, helper) {
        helper.fetchData(component);
        var heading = 'Active Site(s) based on Search: ' + component.get('v.siteToSearch');
        component.set('v.searchHeading', heading);
    },

    selectSite : function(component, event, helper) {
        var row = event.getParam('selectedRows');
        var siteName = row[0].Name;
        var siteCode = row[0].SiteCode;
        var siteResult = siteName + ' (' + siteCode + ')';
        component.set('v.siteName', siteName);
        component.set('v.siteCode', siteCode);
        component.set('v.siteResult', siteResult);
        component.set("v.searchSiteInfo", false);    
    },
    
    closeSearch: function(component, event, helper) {
        component.set('v.siteResult', 'Canceled');
        component.set('v.siteName', '');
        component.set('v.siteCode', '');
        component.set("v.searchSiteInfo", false);
    },
})