({
	handleNext : function(component, event, helper) {
        helper.showSpinner(component);
        var response = event.getSource().getLocalId();
        var navigate = component.get("v.navigateFlow");
        if(response == 'NEXT'){
            helper.createAccountRecord(component, event, helper,response,navigate);
           // if(component.get('v.isnavigateNext')){
            //    navigate(response);
            //}
        }
        if(response == 'BACK'){
            navigate(response);
        }
	},
})