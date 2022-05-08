({
    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method called to retrieve Payment Plan data*/
    getBankingDetails : function(component, event, helper){
        console.log("getBankingDetails");
        var action = component.get("c.getBankAccountDetails");
        var oppId = component.get("v.recordId");
        action.setParams({
            opportunityId: oppId,
            type: "Merchant Product"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" ) {
                //if(response.getReturnValue().length > 0){

                //Store the response of apex controller (return map)
                var result = response.getReturnValue();
                for (var key in result) {
                    if(key == "Business Bank"){
                        component.set("v.paymentPlanBusiness", result[key]);
                    }
                    if(key == "Personal Bank"){
                        component.set("v.paymentPlanPersonal", result[key]);
                    }
                }
                //}
                helper.setBankAndBranchName(component, event, helper);
            } else if(state === "ERROR"){
                var errors = response.getError();
                this.showError(component, "getQuoteBuilderData: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                this.showError(component, "getQuoteBuilderData: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that sets the Bank Name and Branch Name values to pass to the applicable component*/
    setBankAndBranchName : function(component, event, helper){
        console.log("setBankAndBranchName");
        var paymentPlanBusiness = component.get("v.paymentPlanBusiness");
        var paymentPlanPersonal = component.get("v.paymentPlanPersonal");

        if (paymentPlanBusiness.Bank_Name__c && paymentPlanBusiness.Branch_Name__c) {
            var MerchantBusinessBankingDetailsCmp = component.find('MerchantBusinessBankingDetailsCmp');
            MerchantBusinessBankingDetailsCmp.setSelectedBankAndBranchName(paymentPlanBusiness.Bank_Name__c, paymentPlanBusiness.Branch_Name__c);
        }

        if (paymentPlanPersonal.Bank_Name__c && paymentPlanPersonal.Branch_Name__c) {
            var MerchantPersonalBankingDetailsCmp = component.find('MerchantPersonalBankingDetailsCmp');
            MerchantPersonalBankingDetailsCmp.setSelectedBankAndBranchName(paymentPlanPersonal.Bank_Name__c, paymentPlanPersonal.Branch_Name__c);
        }
    },

    /*@ Author: Danie Booysen
    **@ Date: 08/04/2020
    **@ Description: Method to fetch Application record id*/
    getApplication: function(component) {

        var action = component.get("c.getApplication");
        action.setParams({
            "opportunityIdP": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null && responseValue.Id != null) {
                    component.set("v.applicationId", responseValue.Id);
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                this.showError(component, "getQuoteBuilderData: Apex error: [" + JSON.stringify(errors) + "]. ");
            } else {
                this.showError(component, "getQuoteBuilderData: Apex error. ");
            }
        });
        $A.enqueueAction(action);
    },

    /*@ Author: Danie Booysen
    **@ Date: 09/04/2020
    **@ Description: Method to validate that all the fields on the modal have values*/
    validateMotivation: function(component, event, helper){
        var isError = false;
        var toastEvent = $A.get("e.force:showToast");

        var appAboutBusiness = component.find("appAboutBusiness").get("v.value");
        var appAboutBusinessOwner = component.find("appAboutBusinessOwner").get("v.value");
        var appReasonRecommendation = component.find("appReasonRecommendation").get("v.value");
        var appRiskIdentified = component.find("appRiskIdentified").get("v.value");
        var appRiskMitigation = component.find("appRiskMitigation").get("v.value");

        if(!appAboutBusiness || !appAboutBusinessOwner || !appReasonRecommendation || !appRiskIdentified || !appRiskMitigation){
            isError = true;

            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": "Please ensure that all of the fields have been filled in."
            });
        }
        toastEvent.fire();
        return isError;
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that opens the Modal and shows the backdrop*/
    openModal : function(component, event, helper){
        var cmpTarget = component.find('motivationBankingDetailsModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.addClass(cmpTarget, 'slds-fade-in-open');
        $A.util.addClass(cmpBack, 'slds-backdrop--open');
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that closes the Modal and hides the backdrop*/
    closeModal : function(component, event, helper){
        var cmpTarget = component.find('motivationBankingDetailsModal');
        var cmpBack = component.find('Modalbackdrop');
        $A.util.removeClass(cmpBack,'slds-backdrop--open');
        $A.util.removeClass(cmpTarget, 'slds-fade-in-open');
    },

    /*@ Author: Danie Booysen
 	**@ Date: 09/04/2020
 	**@ Description: Method that shows the spinner*/
    showSpinner : function(component, event, helper){
        $A.util.removeClass(component.find("spinner"), "slds-hide");
    },

    /*@ Author: Danie Booysen
 	**@ Date: 08/04/2020
 	**@ Description: Method that hides the spinner*/
    hideSpinner : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");
    },

    showError: function(component, message){
        var errorMsgCmp = component.get("v.errorMessage");
        if(errorMsgCmp == null || errorMsgCmp == ''){
            component.set("v.errorMessage", message);
        }else{
            component.set("v.errorMessage", errorMsgCmp + message);
        }
        
    },

    //Lightning toastie
    fireToast: function(title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        toastEvent.fire();
    }

    // J QUEV 2020-05-07
    // Method to validate all fields
    // Called onLoad so does not need to show the errors on the fields
    /*allFieldsValid: function(component) {

        var arrayAuraIdsToBeValidated = component.get("v.arrayAuraIdsToBeValidated");
        var allValid = true;

        for (var i = 0; i < arrayAuraIdsToBeValidated.length; i++) {

            var inputField = component.find(arrayAuraIdsToBeValidated[i]);
            var inputFieldValue = Array.isArray(inputField) ? inputField[0].get("v.value") : inputField.get("v.value");
            var inputFieldRequired = Array.isArray(inputField) ? inputField[0].get("v.required") : inputField.get("v.required");

            if(inputFieldRequired && $A.util.isEmpty(inputFieldValue)){
                allValid = false;
            }
        }
        return allValid;
    }*/
})