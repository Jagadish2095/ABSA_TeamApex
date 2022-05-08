({
    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method that calls functions/set values on component initialization*/
    doInit: function(component, event, helper) {

        var applicationProductMerchantId = component.get("v.applicationProductMerchantId");
        console.log("applicationProductMerchantId : " + applicationProductMerchantId);
        if($A.util.isEmpty(applicationProductMerchantId)){
            helper.getApplicationProductMerchant(component);
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method that controlls on load actions of the component*/
    handleOnLoad : function(component, event, helper) {
        helper.hideSpinner(component, event, helper);
        var merchRelationshipType = component.find("merchRelationshipType");
        //Checks for is not undefined
        if(merchRelationshipType !== undefined){
            merchRelationshipType.reset();
        }
    },

    handleSubmit : function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 29/04/2020
 	**@ Description: Method that controlls component success time actions*/
    handleSuccess : function(component, event, helper){
        component.set("v.cmpFormStatus", "valid");
        if (component.get('v.isShowSuccessToast')) {
            helper.fireToast("success", "Success!", "Record has been updated successfully.");
        }
    },

    handleError : function(component, event, helper){
        var componentName = 'MerchantIndicators';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("error", "Error!", "Indicators: There has been an error saving the data.");
    },

    //Event listener fired from component
    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if(!$A.util.isEmpty(applicationProductMerchantId)){
            component.set("v.applicationProductMerchantId", applicationProductMerchantId);
        }
    },

    executeSaveFormMethod : function(component, event, helper) {
        if (helper.allFieldsValid(component)) {
            component.set('v.isShowSuccessToast', false);
            component.find('indicatorsForm').submit();
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    }

})