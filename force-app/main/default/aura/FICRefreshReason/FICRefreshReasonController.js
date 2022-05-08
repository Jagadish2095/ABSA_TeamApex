({ 
    redirectToRecord : function(component, event, helper) { 
        var navEvt = $A.get("e.force:navigateToSObject"); 
        navEvt.setParams({ 
            "recordId": component.get("v.recId"),
            "slideDevName": component.get("v.tabName")
        }); 
        navEvt.fire(); 
    },
    handleSubmit : function(component, event, helper) {
        var ficReason = component.get("v.ficReason");
        helper.showSpinner(component);
        //event.preventDefault(); // Prevent default submit
        console.log('handle handleSubmit');
    },
    handleSuccess : function(component, event, helper) {
        console.log('handle handleSuccess');
        helper.hideSpinner(component);
        //component.set("v.isBeforesave",false);
        //component.set("v.saveCompleted",true);
    },
    handleError : function(component, event, helper) {
        helper.hideSpinner(component); //hide the spinner
        var componentName = 'FICRefreshReason';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":"Error",
            "message":"There has been an error saving the data.",
            "type":"error"
        });
        toastEvent.fire();
    },
    
})