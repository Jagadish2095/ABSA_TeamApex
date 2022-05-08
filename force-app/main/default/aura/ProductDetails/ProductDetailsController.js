({
    doInit : function(component, event, helper) {
        helper.getProductDetails(component);
    },

    viewProduct : function(component, event, helper){
        helper.viewProductDetails(component);
    }
})