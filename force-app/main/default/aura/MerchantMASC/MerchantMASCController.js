({
    doInit: function(component, event, helper) {

        var applicationProductMerchantId = component.get("v.applicationProductMerchantId");
        console.log("applicationProductMerchantId : " + applicationProductMerchantId);
        if($A.util.isEmpty(applicationProductMerchantId)){
            helper.getApplicationProductMerchant(component);
        }
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if (!$A.util.isEmpty(applicationProductMerchantId)) {
            component.set("v.applicationProductMerchantId", applicationProductMerchantId);
            //component.set("v.reloadForm", false);
            //component.set("v.reloadForm", true);
            helper.resetFieldValue(component);
        }
    },

    handleDepositMonitoringCheck : function(component, event, helper) {
        helper.depositMonitoringCheck(component);
    },

    handleLoad : function(component, event, helper) {
        helper.depositMonitoringCheck(component);
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
        var componentName = 'MerchantMASC';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("Error!", "Mass Account Maintenance and Setup: There has been an error saving the data.", "error");
    },

    executeSaveFormMethod : function(component, event, helper) {
        if (helper.allFieldsValid(component)) {
            component.set('v.isShowSuccessToast', false);
            component.find('massAccountMaintenanceAndSetupForm').submit();
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    }
})