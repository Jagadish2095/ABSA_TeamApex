({
	signN : function(component, event, helper) {
        this.showSpinner(component);
        var requestId = event.currentTarget.dataset.value;
        console.log("Request id = " + requestId);
        var action = component.get('c.signNow');
        action.setParams({'requestId': requestId});
        action.setCallback(this, function(resp) {
            var state = resp.getState();
            var data = resp.getReturnValue();
            this.hideSpinner(component);
            alert('The client has responded to the USSD message. Kindly click on the “Refresh” button to see the response.');
        });
        $A.enqueueAction(action);
	},
    
        /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to show lighting spinner*/
    showSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to hide lighting spinner*/
    hideSpinner : function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
})