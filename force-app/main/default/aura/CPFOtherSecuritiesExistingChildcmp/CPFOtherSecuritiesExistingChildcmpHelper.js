({
	removeNewOtherSecurity: function (component) {
         component.getEvent("CPFOtherSeciuritiesItems").setParams({
             "RowIndex" : component.get("v.rowindex") //Previously "RowIndex"
         }).fire();
    },


})