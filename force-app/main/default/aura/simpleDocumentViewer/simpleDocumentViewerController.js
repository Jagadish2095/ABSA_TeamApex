({
    doInit: function(component, event, helper) {
        var actions = [
            { label: 'Download', name: 'download' }
        ];

        component.set('v.columnsAudit', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'User', fieldName: 'ownerName', type: 'text'},
            { label: 'Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true} },
            { type: 'action', typeAttributes: { rowActions: actions }}
        ]);
        
        helper.fetchAuditData(component);
        
    },
    
    /**
    * @description download function to download file from ECM.
    **/
    download: function(cmp, event, helper) {
        var row = event.getParam('row');
        var actionName = event.getParam('action').name;
        helper.download(cmp, row);
    }, 
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'download':
                helper.download(component, row);
                break
        }
    },
    
    refreshDocuments : function(component, event, helper) {
        helper.fetchAuditData(component);
    },
})