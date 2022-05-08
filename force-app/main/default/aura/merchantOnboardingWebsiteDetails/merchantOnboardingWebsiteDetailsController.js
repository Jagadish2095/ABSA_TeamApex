({
    //Load for recordEditForm (Application_Product_Merchant__c)
    handleLoad : function(component, event, helper) {
        var oppProdId = component.find("appProdMerch_OppProdId").get("v.value");
        if($A.util.isEmpty(component.get("v.oppProductId") && !$A.util.isEmpty(oppProdId))){
            component.set("v.oppProductId", oppProdId);
        }
    },

    // JQUEV: 20201002
    //Load for force:recordData (OpportunityLineItem)
    oppProductRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            //Check if Product Family includes E-commerce. Then render form
            var productFamily = component.get("v.oppProductRecord.Product2.Family");
            if(!$A.util.isEmpty(productFamily) && productFamily.includes("E-Commerce")){
                component.set("v.isEcommerceProduct", true);
            }
        }
    },

    //Method called from Generate Merchant Agreement btn
    executeSaveFormMethod: function(component, event, helper) {
        //Check if E-Commerce Product (only applicable to E-Commerce products)
        if(component.get("v.isEcommerceProduct")){
            if (helper.allFieldsValid(component)) {
                component.set('v.isShowSuccessToast', false);
                component.find("appProdMerchForm").submit();
            } else {
                component.set("v.cmpFormStatus", "invalid");
            }
        }else{
            component.set("v.cmpFormStatus", "valid");
        }
    },

    //Submit
    //Show toast message
    handleSubmit : function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
    },

    //Success
    handleSuccess : function(component, event, helper) {
        //Set Form Status to Valid
        component.set("v.cmpFormStatus", "valid");
        if (component.get('v.isShowSuccessToast')) {
            //Toast message
            helper.fireToast('Success!', 'Website Details saved successfully! ', 'success');
        }
    },

    //Error
    handleError : function(component, event, helper) {
        //Set Form Status to Invalid
        component.set('v.cmpFormStatus', 'invalid');
        //Show error and fire toast
        component.set('v.errorMessage', "Record error: " + JSON.stringify(event.getParams()));
        helper.fireToast('Error!', 'There has been an error saving the data.', 'error');
    }
})