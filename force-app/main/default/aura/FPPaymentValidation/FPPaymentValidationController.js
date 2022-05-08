({
    validate : function(component, event, helper) {
        helper.fetchPaymentDetails(component);
    },
    returnToApp : function(component, event, helper){
        component.set("v.isModalOpen", false);
    },
    handleChange : function(component,event){
        component.set('v.hideValidate',false);
    }
})