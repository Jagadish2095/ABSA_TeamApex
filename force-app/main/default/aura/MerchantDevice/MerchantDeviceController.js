({
    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
 	**@ Description: Method that calls functions/set values on component initialization*/
    doInit : function(component, event, helper) {
        helper.getFormData(component);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
 	**@ Description: Method that controls on load actions of the component*/
     handleOnLoad : function(component, event, helper) {
        console.log("handleOnLoad");
        //reset field values for picklists
        helper.resetFieldValue(component);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 21/05/2020
 	**@ Description: Method that submit the component from the Save button*/
    handleSubmitButton : function(component, event, helper){
        component.set('v.isShowSuccessToast', true);
        helper.submitDeviceForms(component, event, helper);
    },

    /*@ Author: J QUEV
 	**@ Date: 07/05/2020
    **@ Description: Method that validates and saves the component when the Generate Merchant Agreement button is clicked
    **               on the Application Parent component*/
    executeSaveFormMethod : function(component, event, helper) {
        component.set('v.isShowSuccessToast', false);
        helper.submitDeviceForms(component, event, helper);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
 	**@ Description: Method that controlls component success time actions*/
    handleSuccess : function(component, event, helper){
        component.set("v.cmpFormStatus", "valid");
        if (component.get('v.isShowSuccessToast')) {
            helper.fireToast("success", "Success!", "Record has been updated successfully.");
        }
    },

    /*@ Author: Danie Booysen
 	**@ Date: 19/05/2020
 	**@ Description: Method that controlls component error time actions*/
    handleError : function(component, event, helper){
        var componentName = 'MerchantDevice';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("error", "Error!", "Terminal: There has been an error saving the data.");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 21/05/2020
 	**@ Description: Method that handles component events*/
    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam('applicationProductMerchantId');

        if (!$A.util.isEmpty(applicationProductMerchantId)) {
            component.set('v.applicationProdMerchId', applicationProductMerchantId);
            helper.getFormData(component);
        }
    }

})