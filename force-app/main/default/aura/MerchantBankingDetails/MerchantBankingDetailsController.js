({
    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that get called on initialization loads to setup component*/
    doInit : function(component, event, helper) {
        helper.fetchPickListVal(component, 'Account_Type__c', 'accountType');
    },

    /*@ Author: Danie Booysen
 	**@ Date: 24/03/2020
 	**@ Description: Method that calls handler from child component to get the branch code*/
    handleBrachCodeComponentEvent : function(component, event, helper) {
        //Event handler to get branch code from child component
        var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
        component.set("v.paymentPlan.Branch_Code__c", pselectedBranchCodeGetFromEvent);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that calls the helper to set the Account type selected*/
    onPicklistAccTypeChange : function(component, event, helper) {
        helper.onPicklistAccTypeChange(component, event);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 25/03/2020
 	**@ Description: Method that calls the helper to validate the banking details and save on successful validation*/
    validateAcc : function(component, event, helper) {
        component.set('v.isShowSuccessToast', true);
        helper.validateAcc(component);
    },

    /*@ Author: Danie Booysen
 	**@ Date: 03/04/2020
 	**@ Description: Method that sets the values of Bank Name from the customLookUpCmp & Branch Name from dependentCutomLookupCmp*/
    setSelectedBankAndBranchName : function(component, event, helper){
        console.log("setSelectedBankAndBranchName");
        var params = event.getParam('arguments');

        var customLookUpCmp = component.find('customLookUpCmp');
        customLookUpCmp.setSelectedBankName(params.selectedBankName);

        var dependentCutomLookupCmp = component.find('dependentCutomLookupCmp');
        dependentCutomLookupCmp.setSelectedBranchName(params.selectedBranchName);
    },

    handleApplicationEvent : function(component, event, helper) {
        var applicationId = event.getParam("applicationId");
        component.set("v.applicationId", applicationId);
    },

    executeSaveFormMethod : function(component, event, helper) {
        if (helper.allFieldsValid(component)) {
            component.set('v.isShowSuccessToast', false);
            helper.validateAcc(component);
        } else {
            component.set("v.cmpFormStatus", "invalid");
        }
    }

})