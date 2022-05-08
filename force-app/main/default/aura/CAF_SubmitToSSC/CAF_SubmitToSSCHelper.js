({
    successMsg : function(component, msg) {
     
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "success",
            "title": "Success!",
            "message": msg
        });
        toastEvent.fire();		
    },
    errorMsg : function(component,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "error",
            "title": "Error!",
            "message": msg
    	});
    	toastEvent.fire();
	},
    infoMsg : function(component,msg) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": "info",
            "title": "Information!",
            "message": msg
    	});
    	toastEvent.fire();
	} 
})