({
    showSpinner: function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.removeClass(spinnerMain, "slds-hide");
    },
    
    hideSpinner : function(component) {
        var spinnerMain =  component.find("Spinner");
        $A.util.addClass(spinnerMain, "slds-hide");
    },
    
    getAllRecords : function(component) {
        var action = component.get("c.getMonitoringData");
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                console.log("Retrieve from database state is: " + state);
                component.set('v.resultsList', response.getReturnValue());
            }
            else {
                console.log("Retrieve from database state is: " + state); 
            }
            
        });  
        $A.enqueueAction(action);

    },
    
})