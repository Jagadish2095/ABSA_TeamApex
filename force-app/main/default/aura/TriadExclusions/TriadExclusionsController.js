({
	handleOnLoad1: function (component, event, helper) {
		//set columnnames
		component.set('v.exclusionColumns', [
			{ label: 'Client Name', fieldName: 'Client_Name__c', type: 'text', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Client Code', fieldName: 'Client_Code__c', type: 'text', hideDefaultActions: true, initialWidth: 90 },
			{ label: 'Triad Exclusion Type', fieldName: 'Triad_Exclusion_Type__c', type: 'text', hideDefaultActions: true, initialWidth: 150 },
			{ label: 'Triad Exclusion Reason', fieldName: 'Triad_Exclusion_Reason__c', type: 'text', hideDefaultActions: true, initialWidth: 150 },
			{ label: 'Triad Exclusion Reason Description', fieldName: 'Triad_Exclusion_Reason_Description__c', type: 'text', hideDefaultActions: true, initialWidth: 150 },
			{ label: 'Credit Facility Exclusion', fieldName: 'Credit_Facility_Exclusion__c', type: 'text', hideDefaultActions: true, initialWidth: 150 },
			{ label: 'Credit Facility Exclusion Code', fieldName: 'Credit_Facility_Exclusion_Code__c', type: 'text', hideDefaultActions: true, initialWidth: 150 },
			{ label: 'Credit Facility Exclusion Description', fieldName: 'Credit_Facility_Exclusion_Description__c', type: 'text', hideDefaultActions: true, initialWidth: 150 }


		]);

		helper.getTriadList(component);
	}
})