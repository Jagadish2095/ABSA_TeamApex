/**
* JavaScript Help class for the "CaseCloseAction" lightning component
*
* @author  Rudolf Niehaus : CloudSmiths
* @version v1.0
* @since   2018-07-03
*
**/
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
    navHome : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Case"
        });
        homeEvent.fire();
    },
     //Function to show toast for Errors/Warning/Success
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    getRecordTypeName : function(component) {
		var action = component.get("c.getRecordTypenName");

        action.setParams({
			'developerName': component.get("v.developerName"),
            'sobjectName' : component.get("v.sObjectName")
           
        });
		action.setCallback(this, function(response) {
            var state = response.getState();
			if (state === "SUCCESS") {
				var serviceRequestRecordTypeName = response.getReturnValue();
				component.set("v.serviceRequestRecordTypeName", serviceRequestRecordTypeName);
            }
		});
		$A.enqueueAction(action);
		} 
})