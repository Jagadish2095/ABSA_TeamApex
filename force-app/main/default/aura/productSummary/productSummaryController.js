({
	myAction : function(component, event, helper) {
		
	},
    
    doInit: function(component, event, helper) {
        helper.getMainLifeDetails(component);
        helper.getSpouseDetails(component);
        
        component.set('v.columnsBeneficiaries', [
            { label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            { label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            { label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            { label: 'Age', fieldName: 'Age__c', type: 'number' },
            { label: 'Relationship', fieldName: 'Relationship__c', type: 'text' },
            { label: 'Benefit Split %', fieldName: 'Benefit_Split__c', type: 'percent' },
            { label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' }
        ]);
        
        component.set('v.columnsDependants', [
            { label: 'First Name', fieldName: 'First_Name__c', type: 'text' },
            { label: 'Last Name', fieldName: 'Last_Name__c', type: 'text' },
            { label: 'RSA ID Number', fieldName: 'RSA_ID_Number__c', type: 'text' },
            { label: 'Date of Birth', fieldName: 'Date_of_Birth__c', type: 'date' },
            { label: 'Age', fieldName: 'Age__c', type: 'number' },
            { label: 'Benefit Split %', fieldName: 'Benefit_Split__c', type: 'percent' },
            { label: 'Party Type(s)', fieldName: 'Party_Type__c', type: 'text' }
        ]);
        
        helper.fetchQuoteData(component);
        helper.fetchBeneficiaryData(component);
        helper.fetchDependantData(component);
	}
})