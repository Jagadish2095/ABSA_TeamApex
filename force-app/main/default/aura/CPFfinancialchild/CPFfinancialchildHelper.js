({
	removeAccount: function (component) {
         component.getEvent("CPFFinancialChildEvent").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})