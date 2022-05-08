({
	removeAccount: function (component) {
         component.getEvent("CPFFinancialStmtEvent").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})