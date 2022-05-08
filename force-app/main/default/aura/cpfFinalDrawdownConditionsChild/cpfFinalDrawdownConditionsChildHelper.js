({
    removeotherdrawdown: function (component) {
        component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
    },
    
    removeotherfinaldrawdown: function (component) {
        component.getEvent("CPFApplicationFinancialAccCreation").setParams({
            "RowIndex" : component.get("v.rowindexfinal")
        }).fire();
    },
    
})