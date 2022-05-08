({
    doInit: function(component, event, helper) {
        component.set('v.refreshableColumns', [
            { label: 'Source', fieldName: 'source', type: 'text' },
            { label: 'Name', fieldName: 'description', type: 'text' },
            { label: 'ID', fieldName: 'uniqueId', type: 'text' },
            { label: 'Last Refresh Date', fieldName: 'lastRefreshDate', type: 'text' },
            { label: 'Next Refresh Date', fieldName: 'nextRefreshDate', type: 'text' },
            { label: 'Received Date', fieldName: 'receivedDate', type: 'text' }
        ]);
        
        component.set('v.reusableColumns', [
            { label: 'Source', fieldName: 'source', type: 'text' },
            { label: 'Name', fieldName: 'description', type: 'text' },
            { label: 'ID', fieldName: 'uniqueId', type: 'text' },
            { label: 'Last Refresh Date', fieldName: 'lastRefreshDate', type: 'text' },
            { label: 'Next Refresh Date', fieldName: 'nextRefreshDate', type: 'text' },
            { label: 'Received Date', fieldName: 'receivedDate', type: 'text' }
        ]);
            
        helper.fetchData(component);
    },
    
    addressAttestedCheck: function(component, event) {
        var checkCmp = component.find("addressCheckbox");
        component.set("v.addressAttestedCheckbox", checkCmp.get("v.value"));
    },
    
    idAttestedCheck: function(component, event) {
        var checkCmp = component.find("idCheckbox");
        component.set("v.idAttestedCheckbox", checkCmp.get("v.value"));
    },
    
    updateChecks: function(component, event, helper) {
        helper.updateChecks(component);
   	},
})