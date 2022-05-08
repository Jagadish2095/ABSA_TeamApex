({
	init: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'Call Id', fieldName: 'Call_ID__c', type: 'text'},
            {label: ' Call Time', fieldName: 'Call_Start_Time__c', type: 'Date/Time'},
            {label: 'Call Duration', fieldName: 'Call_Duration__c', type: 'Number'},
        ]);  
        helper.fetchCallActivityData(component, event,helper);
    }
})