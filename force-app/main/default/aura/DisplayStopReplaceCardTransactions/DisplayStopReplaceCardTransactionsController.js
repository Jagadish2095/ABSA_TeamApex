({
	doInit : function(component, event, helper) {
		component.set('v.columns',[
            {label: 'Transaction Description', fieldName: 'transactionDescription', type: 'text'},
            {label: 'Transaction Date', fieldName: 'transactionDate', type: 'text'},
            {label: 'Transaction Amount', fieldName: 'transactionAmount', type: 'text'}
        ]);
        component.set("v.cardTransDetailsList",component.get("v.cardTransDetails"));
	}
})