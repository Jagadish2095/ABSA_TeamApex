({
	doInit: function(component, event, helper) {
        var actions = [
            { label: 'Download', name: 'download' }
		];

		component.set('v.columnsAudit', [
			{ label: 'Document Name', fieldName: 'Name', type: 'text', initialWidth: 400},
			{ label: 'Document Type', fieldName: 'Type__c', type: 'text', initialWidth: 400 },
			{ label: 'Approver', fieldName: '', type: 'text', initialWidth: 200 },
            { label: 'Version/Created Date', fieldName: 'CreatedDate', type: 'date', typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}, initialWidth: 100 },
            { type: 'action', typeAttributes: { rowActions: actions }}
		]);

		helper.fetchDocuments(component);
	},

		/**
		* @description download function to download file from ECM.
		**/
	download: function(cmp, event, helper) {
		var row = event.getParam('row');
		//var actionName = event.getParam('action').name;
		helper.download(cmp, row);
	},

	handleMenuSelect : function(component, event, helper) {
		var selectedMenuItemValue = event.getParam("value");
		var docName = '';
		var formStatus= '';
		if (selectedMenuItemValue == 'Credit Approved') {
			docName = 'ABSA 6171 EX - Commercial Property Finance Loan';
			formStatus = selectedMenuItemValue;
		} else {
			docName = 'ABSA 6184 - CPF Investment Loan / MBBL Standard Terms';
			formStatus = '';
		}
		helper.updateOppFormStatus(component, formStatus);
		helper.generateCPFDocument(component,docName);
	},

	refreshDocuments : function(component, event, helper) {
        helper.fetchDocuments(component);
	},

	handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'download':
				helper.download(component, row);
				helper.fetchDocuments(component);
                break
        }
	},

	onload : function(component, event, helper){
		//$A.util.addClass(component.find("spinner"), "slds-hide");
        var creditApprovedVal = component.find("wasTheCreditRequestApproved").get("v.value");
        if (creditApprovedVal == 'YES' || creditApprovedVal == 'NO') {
            component.set("v.creditApproved", creditApprovedVal);
		} else {
			component.set("v.creditApproved", 'NO');
		}
    },
})