({
	removeAccount: function (component) {
         component.getEvent("CPFotherentityevent").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})