({
    doInit : function(component, event, helper) {
        
        component.set("v.columns", [
            {label: 'Tracker Date', fieldName: 'trackerDate', type: 'String'},
            {label: 'Tracker UserId', fieldName: 'trackerUserId', type: 'String'},
            {label: 'Tracker Action', fieldName: 'trackerAction', type: 'String'}
        ]);
        
    },
    
    refreshTrackerHistory : function(component, event, helper) {
        
        helper.showSpinner(component);
        component.set("v.data", null);
        helper.refreshTrackerHistoryHelp(component, event, helper);
        helper.hideSpinner(component);
        
    }
})