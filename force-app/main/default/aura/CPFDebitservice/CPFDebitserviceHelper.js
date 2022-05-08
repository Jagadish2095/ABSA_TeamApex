({
	removeAccount: function (component) {
         component.getEvent("CPFdebitevent").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})