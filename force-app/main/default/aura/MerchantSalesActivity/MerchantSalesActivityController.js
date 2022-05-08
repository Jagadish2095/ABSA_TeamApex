({

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method that calls functions/set values on component initialization*/
    doInit: function(component, event, helper) {

        var applicationProductMerchantId = component.get("v.applicationProductMerchantId");
        if($A.util.isEmpty(applicationProductMerchantId)){
            helper.getApplicationProductMerchant(component);
        }
        helper.fieldVisibility(component, event, helper);//Danie Booysen: 2020-08-12 (W-005252)
    },

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method to show/hide Price Matrix & Deferred Delivery Reason*/
    showDeferredDelivery : function(component, event, helper){
        var deferredGoodsOrServicesField = component.find("deferredGoodsOrServicesField").get("v.value");
        component.set("v.deferredGoodsOrServicesField", deferredGoodsOrServicesField);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 31/03/2020
 	**@ Description: Method that calls the helper for exposure calculations*/
    calc: function(component, event, helper){
        helper.calcResult(component, event.getSource().getLocalId());
    },

    /*@ Author: Danie Booysen
 	**@ Date: 15/04/2020
 	**@ Description: Method that controls on load actions of the component*/
    handleOnLoad : function(component, event, helper) {

        var deferredGoodsOrServicesField = component.find("deferredGoodsOrServicesField").get("v.value");

        if(deferredGoodsOrServicesField){
            helper.calcResult(component, event.getSource().getLocalId());
        }
        $A.enqueueAction(component.get('c.showDeferredDelivery'));
        //reset field values for picklist
        helper.resetFieldValue(component);
        //hide spinner after load
        helper.hideSpinner(component, event, helper);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 01/04/2020
 	**@ Description: Method that controls submit actions of the component*/
    handleSubmit : function(component, event, helper) {

        component.set('v.isShowSuccessToast', true);
        var deferredGoodsOrServicesField = component.find("deferredGoodsOrServicesField").get("v.value");
        if(deferredGoodsOrServicesField){
            event.preventDefault();
            var isError = helper.validate(component, helper);
            console.log('*INSIDE handleSubmit==>: '+isError);

            if (!isError) {
                var eventFields = event.getParam("fields");
                console.log('-------SAVING FORM---------');
                console.log('*INSIDE handleSubmit==>: '+JSON.stringify(eventFields));
                component.find('salesActivityForm').submit(eventFields);
            }
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 01/04/2020
 	**@ Description: Method that controls component success time actions*/
    handleSuccess : function(component, event, helper){
        component.set("v.cmpFormStatus", "valid");
        var eventSource = event.getSource().getLocalId();
        var deferredGoodsOrServicesField = component.find("deferredGoodsOrServicesField").get("v.value");
        component.set("v.deferredGoodsOrServicesField", deferredGoodsOrServicesField);

        if (component.get("v.isSubmitForApprovalButtonClicked")) {
            component.set("v.isSubmitForApprovalButtonClicked", false);

            component.find("oppTrigApprovalProcessInput").set("v.value", "Deferred Delivery");
            component.find("oppApprovalStatusInput").set("v.value", "Pending");
            component.find('opportunityEditForm').submit();
        }

        //hide spinner
        helper.hideSpinner(component, event, helper);

        // Show toast
        if (component.get('v.isShowSuccessToast')) {
            helper.fireToast("success", "Success!", "Record has been updated successfully.");
        }
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if(!$A.util.isEmpty(applicationProductMerchantId)){
            component.set("v.applicationProductMerchantId", applicationProductMerchantId);
        }
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantSalesActivity';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("Error!", "Sales Activity: There has been an error saving the data.", "error");
        component.set("v.isSubmitForApprovalButtonClicked", false);
    },

    executeSaveFormMethod : function(component, event, helper) {
        var deferredGoodsOrServicesField = component.find("deferredGoodsOrServicesField").get("v.value");
        if (((deferredGoodsOrServicesField && !helper.validate(component, helper)) || !deferredGoodsOrServicesField) && helper.allFieldsValid(component)) {
            component.set('v.isShowSuccessToast', false);
            component.find('salesActivityForm').submit();
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    },

    // J Quevauvilliers, D Booysen 2020/08/02: Start Deferred Delivery Approval Process
    submitForApproval : function(component, event, helper) {
        if (!helper.validate(component, helper)) {
            if (helper.allFieldsValid(component)) {
                component.set("v.isSubmitForApprovalButtonClicked", true);
                component.set('v.isShowSuccessToast', false);
                component.find('salesActivityForm').submit();
            } else {
                helper.fireToast("error", "Error!", "Required fields missing");
            }
        }
    },

    handleOppSuccess : function(component, event, helper){
        helper.fireToast("success", "Success!", "Record has been submitted for approval.");
    },

    handleOppError : function(component, event, helper){
        component.set("v.errorMessage", "Error while submitting for approval: " + JSON.stringify(event.getParams()));
        helper.fireToast("error", "Error!", "Error while submitting for approval.");
    }
    // J Quevauvilliers, D Booysen 2020/08/02: End Deferred Delivery Approval Process
})