({
	init : function(component, event, helper) {
		helper.fetchTranslationValues(component, 'v.incomeTaxReasonOptions', 'CIFCodesList', 'ReasonSATaxNotGiven', 'Outbound', 'Account', 'Income_Tax_Number_Reason__pc');
        component.set('v.incomeTaxOptions', helper.getIncomeTaxOptions());
        component.set('v.foreignTaxOptions', helper.getForeignTaxOptions());
	},
    handleIncomeTaxGroup: function(component, event, helper) {
        var incomeTaxValue = event.getSource().get('v.value');
        component.set('v.incomeTaxValue', incomeTaxValue);
    },

    handleForeignTaxGroup: function(component, event, helper) {
        var foreignTaxValue = event.getSource().get('v.value');
        component.set('v.foreignTaxValue', foreignTaxValue);
    }

})