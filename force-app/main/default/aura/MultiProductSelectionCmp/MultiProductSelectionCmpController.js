({
    doInit: function (component, event, helper) {
       helper.getProductFamilyList(component,event,helper);
        helper.getOpp(component,event,helper);//Added By Himani Joshi
        
    },
     SaveProduct : function(component, event, helper){
        helper.saveSelectedProduct(component, event, helper);
    },

})