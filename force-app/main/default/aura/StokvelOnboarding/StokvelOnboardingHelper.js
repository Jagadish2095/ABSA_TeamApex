({
    //Show Spinner
	showSpinner: function(component) {
        component.set("v.isSpinner",true);
    },

	//hide Spinner
    hideSpinner: function(component) {
        component.set("v.isSpinner",false);
    },

	//Fire Lightning toast
    fireToast : function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }
})