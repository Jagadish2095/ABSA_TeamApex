({
    doInit: function (component, event, helper) {
        console.log('recordId##' + component.get("v.oppId"));
        helper.refreshData(component, event, helper);
        
    },
})