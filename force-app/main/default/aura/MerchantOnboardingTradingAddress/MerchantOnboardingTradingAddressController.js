({
    doInit: function(component, event, helper) {

		var applicationId = component.get("v.applicationId");
        if($A.util.isEmpty(applicationId)){
            helper.getApplication(component);
        }
    },

    handleLoad : function(component, event, helper) {
        var preSelectedRows = [];
        var tradingAddressId = component.find('tradingAddressField').get('v.value');
        if (tradingAddressId) {
            preSelectedRows.push(tradingAddressId);
            component.set('v.preSelectedRows', preSelectedRows);
        }
    },

    handleSubmit : function(component, event, helper) {
        event.preventDefault();
        component.set('v.isShowSuccessToast', true);
        helper.setTradingAddressField(component, event, helper);
    },

    handleSuccess : function(component, event, helper){
		component.set("v.cmpFormStatus", "valid");
		if (component.get('v.isShowSuccessToast')) {
			helper.fireToast("Success!", "Trading Address details saved.", "success");
		}
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantOnboardingTradingAddress';
        console.error(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        helper.fireToast("Error!", "Error saving Trading Address details.", "error");
        component.set("v.cmpFormStatus", "invalid");
    },

	executeSaveFormMethod : function(component, event, helper) {
        component.set('v.isShowSuccessToast', false);
        helper.setTradingAddressField(component, event, helper);
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        if (!$A.util.isEmpty(applicationId)) {
            component.set("v.applicationId", applicationId);
        }
    }
});