({
	init : function(component, event, helper) {
        component.set('v.aicColumns', [
            {label: 'Department', fieldName: 'Department__c', type: 'text'},
            {label: 'Email', fieldName: 'Email__c', type: 'email'},
            {label: 'Contact Number', fieldName: 'Contact_Number__c', type: 'text'}            
        ]);
        helper.getAICContactDetailsHelper(component, event, helper);
	}
})