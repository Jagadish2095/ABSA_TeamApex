({
	removeLeases: function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
    
    removeFurtherCond : function (component) {
        debugger;
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
    
    removeSpecialCond : function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
        removeConversionAcct: function (component) {
        component.getEvent("CPFApplicationFinancialAccCreation").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
   },
})