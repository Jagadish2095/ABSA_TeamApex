({
    doInit : function(component, event, helper) {
        //Set Tab Label and Icon
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
    },
    
    createOpportunityAndLinkAccount : function(component, event, helper) {
        helper.showSpinner(component);
        var selectedAccount = component.get("v.accountSelected");
        //Navigate to the New Opportunity
        var navService = component.find('navService');
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: selectedAccount.Id,
                objectApiName: "Account",
                actionName: 'view'
            }
        }
        navService.navigate(pageReference);
        helper.hideSpinner(component);
    }
})