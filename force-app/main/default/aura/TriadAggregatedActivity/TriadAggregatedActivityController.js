({
	handleOnLoad: function (component, event, helper) {
		//set columns 
		//set columnnames
		component.set('v.aggregatedColumns', [
			{ label: 'Client Name', fieldName: 'Client_Name__c', type: 'text', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Client Code', fieldName: 'Client_Code__c', type: 'text', hideDefaultActions: true, initialWidth: 90 },
			{ label: '# Months in Excess (last 6 mth)', fieldName: 'Months_in_Excess_last_6_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: '# Days in Credit (last 6 mth)', fieldName: 'Days_in_Credit_last_6_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: '# Days in Debit (last 6 mth)', fieldName: 'Days_in_Debit_last_6_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Maximum Consecutive Days in Excess', fieldName: 'Maximum_Consecutive_Days_in_Excess__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Total Cheque RD (last 3 mth)', fieldName: 'Total_Cheque_RD_last_3_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Total Cheque RD (last 6 mth)', fieldName: 'Total_Cheque_RD_last_6_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Total Savings RD (last 3 mth)', fieldName: 'Total_Savings_RD_last_3_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Total Savings RD (last 6 mth)', fieldName: 'Total_Savings_RD_last_6_mth__c', type: 'Number', hideDefaultActions: true, initialWidth: 90 }


		]);
		helper.getTriadList(component);

	}
})