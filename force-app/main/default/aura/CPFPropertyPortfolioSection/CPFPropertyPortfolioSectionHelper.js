({
    removeNewAccount: function (component) {
        component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
            "RowIndex" : component.get("v.rowindex")
        }).fire();
   },
  
})