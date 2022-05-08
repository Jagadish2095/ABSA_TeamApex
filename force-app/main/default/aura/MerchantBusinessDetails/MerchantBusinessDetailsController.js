({
	doInit: function(component, event, helper) {

        var applicationId = component.get("v.applicationId");
        console.log("applicationId : " + applicationId);
        if($A.util.isEmpty(applicationId)){
            helper.getApplication(component);
        }
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        if (!$A.util.isEmpty(applicationId)) {
            component.set("v.applicationId", applicationId);
        }
    },

    handleSubmit : function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
    },

    handleSuccess : function(component, event, helper){
        component.set("v.cmpFormStatus", "valid");
        if (component.get('v.isShowSuccessToast')) {
            helper.fireToast("Success!", "Record has been updated successfully.", "success");
        }
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantBusinessDetails';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("Error!", "Business Details: There has been an error saving the data.", "error");
    },

    executeSaveFormMethod : function(component, event, helper) {
        if (helper.allFieldsValid(component)) {
            component.set('v.isShowSuccessToast', false);
            component.find('merchantBusinessDetailsForm').submit();
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    }
})