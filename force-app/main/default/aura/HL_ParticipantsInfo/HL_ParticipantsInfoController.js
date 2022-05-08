({
    doInit : function(component, event, helper) {                
        component.set('v.columns', [               
            { label: 'First Name', fieldName: 'FirstName', type: 'text' },
            { label: 'Last Name', fieldName: 'LastName', type: 'text' },
            { label: 'ID Number', fieldName: 'IDNumber', type: 'text' },
        ]);            
		helper.fetchData(component);
    },
            
	setParticipantSelection: function(component, event, helper) {
		let selectedRows = event.getParam("selectedRows")[0];                      
        if (typeof selectedRows != "undefined") {
            component.set("v.accountSelected", selectedRows.PersonContactId);
            helper.redirectToAccount(component, event, helper);
        }
    },
})