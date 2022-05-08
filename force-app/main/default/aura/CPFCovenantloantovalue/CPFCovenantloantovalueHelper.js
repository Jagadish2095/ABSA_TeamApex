({
	removeAccount: function (component) {
         component.getEvent("CPFloantovalue").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})