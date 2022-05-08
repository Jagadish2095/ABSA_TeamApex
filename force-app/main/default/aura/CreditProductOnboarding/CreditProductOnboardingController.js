({
    doInit : function(component, event, helper) {
        //Set Tab Label and Icon
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "New Credit Product" 
            });
            
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:flow", 
                iconAlt: "New Credit Product" 
            });
        })
    }
})