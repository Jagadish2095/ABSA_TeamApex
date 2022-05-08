({
    doInit : function(component, event, helper) {
        var mode = component.get("v.mode");
        if(mode == 'view' || mode == 'ViewDetailedCharges'){
            console.log(`getAccounts: in view mode. Getting accounts`);
            helper.setFields(component);
            helper.getCostAccount(component, event, helper);
            helper.getAccountCharges(component, event, helper);
        }else{
            // Only needed for updating which account to charge (for update mode)
            helper.getAllAccounts(component, event, helper);
        }
        helper.getAccountEmail(component, event, helper);
    },

    
    filterCharges : function(component, event, helper) {
        helper.filterCharges(component);
    },
    

    onProductTypeChange : function(component, event, helper) {
        var accountList = component.get("v.accountList");
        var selectedAccountType = component.get("v.selectedAccountType");
        var filteredList = [];

		for (var acc in accountList) {
            if(accountList[acc].ProductType == selectedAccountType){
                filteredList.push(accountList[acc]);
            }

            console.log(`onProductTypeSet: acc: ${accountList[acc].AccountNumber}`);
        }
        component.set("v.filteredAccountList", filteredList);

        component.set("v.isAccountsListDisplayed", true);
    },

    popConfirmationModal: function(component, event, helper) {
        component.set("v.isConfirmingAccountSelection", true);
    },

    sendDetailedCharges: function(component, event, helper) {
        component.set("v.stage", 2);
        component.set("v.isSendingChargesEmail", true);
    },

    sendDetailedChargesConfirmation: function(component, event, helper) {
        helper.createAndEmailTbCharges(component, helper);
    },

    closeModel: function(component, event, helper) {
        component.set("v.isConfirmingAccountSelection", false);
    },

    closeCase: function(component, event, helper) {
        helper.closeCase(component, helper);
    },

    updateCostAccount: function(component, event, helper) {
        helper.updateCostAccount(component, helper);
    }
})