({

    doInit : function(component, event, helper) {
        //Set Tab Label and Icon

        console.log("Loading Stokvel Relatedparty Controller...");
        var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: "Stokvel Onboarding" 
            });
            
            workspaceAPI.setTabIcon({
                tabId: focusedTabId,
                icon: "utility:flow", 
                iconAlt: "Stokvel Onboarding" 
            });
        })

        $A.util.addClass(component.find("ClientResultTable"), "slds-hide");
        component.set("v.selectedStatus", selected);
        
    }
})