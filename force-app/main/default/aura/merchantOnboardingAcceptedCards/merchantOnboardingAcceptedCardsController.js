({
    //JQUEV: 20200928
    //Set OpportunityLineItem Id and reload force:RecordData
    handleLoad : function(component, event, helper) {
        var oppProdId = component.find("oppLineItemId").get("v.value");
        if($A.util.isEmpty(component.get("v.oppProductId") && !$A.util.isEmpty(oppProdId))){
            component.set("v.oppProductId", oppProdId);
            //component.find('oppProductRecordEditor').reloadRecord();
        }
    },

    // JQUEV: 20200928
    oppProductRecordUpdated : function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            $A.enqueueAction(component.get('c.hideSpinner'));
            helper.fetchAcceptedCardsData(component, event, helper);
        }
    },

    /*@ Author: Tinashe Shoko
 	**@ Date: 01/04/2020
 	**@ Description: Method that controls submit actions of the component*/
    handleSubmit : function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
        event.preventDefault(); // prevent default submission of form so we do error handling
        helper.handleFormSubmit(component, event, helper); // field validation before form submission
        console.log('-------SAVING FORM---------');
    },

    /*@ Author: Tinashe Shoko
 	**@ Date: 01/04/2020
 	**@ Description: Method that controls component success time actions*/
    handleSuccess : function(component, event, helper){
        component.set("v.cmpFormStatus", "valid");
        //hide spinner
        $A.enqueueAction(component.get('c.hideSpinner'));
        if (component.get('v.isShowSuccessToast')) {
            // Show toast
            helper.fireToast("Success!", "Accepted cards have been updated successfully.", "success");
        }
    },

    handleError : function(component, event, helper){
        var componentName = 'merchantOnboardingAcceptedCards';
        console.log(componentName + ': error JSON: ' + JSON.stringify(event.getParams()));
        component.set("v.cmpFormStatus", "invalid");
        helper.fireToast("Error!", "Accepted Cards: There has been an error saving the data.", "error");
    },

    /*@ Author: Tinashe Mutsungi Shoko
 	**@ Date: 03/04/2020
 	**@ Description: Method that closes the modal that pops up when clients are advised
    **@ to register with certain financial institutions for certain cards */
    closeModal:function(component,event,helper){
        var cmpTarget = component.find('editDialog');
        var cmpBack = component.find('overlay');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
        component.set('v.openModal',false);
    },

    showSpinner: function(component) {
        component.set("v.isSpinner",true);
    },

    hideSpinner: function(component) {
        component.set("v.isSpinner",false);
    },

    executeSaveFormMethod : function(component, event, helper) {
        component.set('v.isShowSuccessToast', false);
        helper.handleFormSubmit(component, event, helper);
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationProductMerchantId = event.getParam("applicationProductMerchantId");
        if ($A.util.isEmpty(applicationProductMerchantId)) {
            component.set("v.applicationProductMerchantId", applicationProductMerchantId);
            helper.fetchAcceptedCardsData(component, event, helper);
        }
    }
})