({
    showToast : function(type, title, message, mode) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message,
            "mode": mode
        });
        toastEvent.fire();
    },
    handleErrors : function(errors) {

        console.log('handleErrors: '+errors.length );
        console.log('server error'+errors[0].message); 
        var message = 'Unable to send sms';

        // Pass the error message if any
         if (errors) {
            message = errors[0].message;
            }
            else {
            message ='Unable to send sms';
            }    
            console.log('showErrors:' + message);
        
        this.showToast ("Error","error",message, "sticky");
    },
    
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },

    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    navHome : function (component, event, helper) {
        var homeEvent = $A.get("e.force:navigateToObjectHome");
        homeEvent.setParams({
            "scope": "Case"
        });
        homeEvent.fire();
    },

})