({
	removeAccount: function (component) {
        
         component.getEvent("CPFCovenents").setParams({
             "UnlimitedRowIndex" : component.get("v.rowindex")
         }).fire();
    },
})