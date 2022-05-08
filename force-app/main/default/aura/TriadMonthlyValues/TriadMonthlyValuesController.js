({
	loading: function (component, event, helper) {

		//set columnnames
		component.set('v.monthlyColumns', [
			{ label: 'Month', fieldName: 'Month__c', type: 'date', typeAttributes: { year: "numeric", month: "short" }, hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Risk Grade', fieldName: 'Risk_Grade__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Credit Turnover', fieldName: 'Credit_Turnover__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Debit Turnover', fieldName: 'Debit_Turnover__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Total Limit', fieldName: 'Total_Limit__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Highest Limit', fieldName: 'Highest_Limit__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Minimum Balance', fieldName: 'Minimum_Balance__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Maximum Balance', fieldName: 'Maximum_Balance__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Average Balance', fieldName: 'Average_Balance__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Cheque RD Value', fieldName: 'Returned_Items_Value_Cheques_value__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Savings RD Value', fieldName: 'Returned_Items_Value_Savings_value__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 }]);

		//get monthly data

		helper.getMonthlyValueData(component);

		component.set('v.showSpinner', false);
	}
})