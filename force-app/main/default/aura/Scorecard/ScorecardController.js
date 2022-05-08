({
    //Function called when the component tab is selected using aura method
    initializeCmpData : function(component, event, helper) {
        helper.fetchScorecardData(component, event, helper);
    }
})