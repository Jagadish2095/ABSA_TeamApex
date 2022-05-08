({
	handleNext : function(component, event, helper) {
        helper.showSpinner(component);
        var response = event.getSource().getLocalId();
        if(response == 'BACK'){
            helper.hideSpinner(component);
            var toastEvent = helper.getToast('WARNING', 'Sorry, We cannot proceed with your Application', 'Warning', helper);
        	toastEvent.fire();
            return false;
        }
        var navigate = component.get("v.navigateFlow");
         navigate(response);
	}
})