({ 
    redirectToRecord : function(component, event, helper) { 
        var navEvt = $A.get("e.force:navigateToSObject"); 
        navEvt.setParams({ 
            "recordId": component.get("v.recId"),
            "slideDevName": component.get("v.tabName")
        }); 
        navEvt.fire(); 
    } 
})