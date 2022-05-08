({
	removePerphases: function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
    removeprelodgment: function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
    removepredisbursement: function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "RowIndex" : component.get("v.rowindex")
         }).fire();
    },
})