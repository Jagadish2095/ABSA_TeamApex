({
	helperMethod: function() {
		
	},
	
    getIncomeTaxOptions: function() {
        return this.incomeTaxOptions;
    },

    getForeignTaxOptions: function() {
        return this.foreignTaxOptions;
    },

    getTaxUiValue: function(fieldValue) {
        var returnValue;
        if (fieldValue){
            returnValue = 'Yes';
        } else {
            returnValue = 'No';
        }
        return returnValue;
    },
})