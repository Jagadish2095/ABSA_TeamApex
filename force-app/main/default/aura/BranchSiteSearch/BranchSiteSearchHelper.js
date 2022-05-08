({
    fetchData: function(component) {
        component.set('v.columns', [
            {label: 'Site Name', fieldName: 'Name', type: 'text'},
            {label: 'Site Code', fieldName: 'SiteCode', type: 'text'}
        ]);
        let action = component.get('c.searchNameLike');
        var nameLike = component.get("v.siteToSearch");	
        action.setParams({
            "nameLike" : nameLike,
        });
        action.setCallback(this, function (response) {
            var siteData = response.getReturnValue();
            component.set('v.siteData', siteData);
        });
        $A.enqueueAction(action);
    }
})