({
	removeNewUnlimitedGuarantee: function (component) {
         component.getEvent("CPFLimitedandUnlimitedGauranteesevent").setParams({
             "UnlimitedRowIndex" : component.get("v.unlimrowindex")
         }).fire();
    },
})