({
    doInit : function(component, event, helper) {
        
        helper.getAccountDetails(component, event, helper);
        helper.getAppDetails(component, event, helper);
    },     
    
    handleSubmit : function(component, event, helper) {
        
        helper.updateAppDetails(component, event, helper);
    },
    
    handleSuccess : function(component, event, helper) {
        // Call Risk Profile service once the form details are saved
        component.set("v.showSpinner", true);
        
        helper.CalculateScore(component, event, helper);
    },
    
    handleError : function(component, event, helper) {
        //  helper.hideSpinner(component); //hide the spinner
        
        /*   var componentName = 'controlOfficerLinkingBankerDetails';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "There has been an error saving the data.", "error");*/
    },
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
})