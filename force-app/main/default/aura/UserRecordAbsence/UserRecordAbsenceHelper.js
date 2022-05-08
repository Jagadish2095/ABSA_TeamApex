({
	showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    closeFocusedTab : function(component) {
        var workspaceAPI = component.find("workspace");
         
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        }).catch(function(error) {
            console.log(error);
        });
    },
    
    //Lightning toastie
    getToast : function(title, msg, type) {
        
		 var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        
        return toastEvent;
	},
})