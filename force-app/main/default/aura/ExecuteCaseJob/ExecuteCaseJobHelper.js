({
    showSpinner: function (component) {
        
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function (component) {

        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    getToast : function(title, msg, type) {
        
		 var toastEvent = $A.get("e.force:showToast");
        
            toastEvent.setParams({
                "title":title,
                "message":msg,
                "type":type
         });
        
        return toastEvent;
    }	
	
})