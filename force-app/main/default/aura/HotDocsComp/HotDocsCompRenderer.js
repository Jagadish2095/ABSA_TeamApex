({
	afterRender: function (component, helper) {
    	this.superAfterRender();
        var handleWorkItem = $A.getCallback( function (evt) {
            component.set("v.workItemId", evt.data);
            helper.updateWorkItem(component);
        });
        if (window.addEventListener) {
			window.addEventListener("message", handleWorkItem, false);
		} else {
			window.attachEvent("onmessage", handleWorkItem);
		}
        
	}
})