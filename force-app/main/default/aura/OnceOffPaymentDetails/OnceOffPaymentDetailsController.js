({
    addNewAccount : function(component, event, helper){
        
        helper.addNewBankAccount(component);
    },
    saveAndValidate : function (component, event, helper){
        
        helper.handlePaymentSave(component,event,helper);
    }
})