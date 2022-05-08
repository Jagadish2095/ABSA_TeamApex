({
    //method to add a new row item 
    addNewRow : function(component, event, helper){
        
        var productInterest =  component.find("iFinancialProduct").get("v.value"); 
        //Validation - No product selected
        if(productInterest == null || productInterest == ''){
            var toast = helper.getToast("", "First product interest is required, please select product", "warning");
            toast.fire();
            return null;
        }
        
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    //method to remove a row item 
    removeRow : function(component, event, helper){
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    
    //method to update a row item of productInstance Financial_Product__c field
    setFinancialProduct : function(component, event, helper) {
        
        var productInterest =  component.find("iFinancialProduct").get("v.value"); 
        console.log("productInterest #######",productInterest);
        component.set("v.productInstance.Financial_Product__c", productInterest);
        
    },
})