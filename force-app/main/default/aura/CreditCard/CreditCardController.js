({
    doInit : function (component, event, helper){
        console.log('CreditCard: init');
        helper.getExistingAccounts(component);
        helper.getNewAccounts(component);
    },
    onCheckManageAcc : function (component, event, helper){
        helper.handleOnCheckManageAcc(component,event);
    },
    manageSelectedAccounts : function(component, event, helper){
        helper.hanldeSelectedAccounts(component, event);
    },
    addNewAccount : function (component, event, helper){
        helper.handleAddNewAccount(component);
    },
    saveAndValidate : function (component, event, helper){
        helper.handleSaveAndValidate(component)
    },
    onRender : function(component, event, helper){
        helper.handleOnRender(component,event);
    }
})