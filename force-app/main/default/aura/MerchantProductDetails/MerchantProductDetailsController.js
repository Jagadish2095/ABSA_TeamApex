({
    doInit: function(component, event, helper) {
        helper.getDataForForm(component);
    },

    handleSaveRecord: function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
        if(helper.allFieldsValid(component, true)){
            helper.handleSaveRecord(component, event, helper);
        } else {
            component.set('v.cmpFormStatus', "invalid");
        }
    },

    executeSaveFormMethod: function(component, event, helper) {
        component.set('v.isShowSuccessToast', false);
        if(helper.allFieldsValid(component, false)){
            helper.handleSaveRecord(component, event, helper);
        } else {
            component.set('v.cmpFormStatus', "invalid");
        }
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam('applicationProductMerchantId');

        if (!$A.util.isEmpty(applicationProductMerchantId)) {
            component.set('v.applicationProdMerchId', applicationProductMerchantId);
            helper.getDataForForm(component);
        }
    }
})