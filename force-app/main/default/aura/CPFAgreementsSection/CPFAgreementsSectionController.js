({
	doInit: function(component, event, helper) {
        var actions = [
            { label: 'Download', name: 'download' }
		];

		component.set('v.columnsAudit', [
			{ label: 'Document Name', fieldName: 'Name', type: 'text', sortable: true, initialWidth: 200, wrapText: true},
			{ label: 'Document Type', fieldName: 'Type__c', type: 'text', sortable: true, initialWidth: 200, wrapText: true },
			{ label: 'Approver', fieldName: '', type: 'text', sortable: true, initialWidth: 100, wrapText: true },
            { label: 'Version/Created Date', fieldName: 'CreatedDate', type: 'date',
				typeAttributes: {day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true}, 
				initialWidth: 200, sortable: true
			},
            { type: 'action', typeAttributes: { rowActions: actions }}
		]);
		helper.allowWOrdDocGen(component);
		helper.fetchDocuments(component);
        helper.getopplineitemRec(component,event);
	},

		/**
		* @description download function to download file from ECM.
		**/
	download: function(cmp, event, helper) {
		var row = event.getParam('row');
		var actionName = event.getParam('action').name;
		helper.download(cmp, row);
	},

	handleMenuSelect : function(component, event, helper) {
		var selectedMenuItemValue = event.getParam("value");
		var docName = '';
		var formStatus= '';
		if (selectedMenuItemValue == 'Draft' || selectedMenuItemValue == 'Draft Word' || selectedMenuItemValue == 'Draft 6096' ||
			selectedMenuItemValue == 'Draft 6172' || selectedMenuItemValue == 'Draft 6172 Word' ||
			selectedMenuItemValue == 'Pending Credit Approval Word' || selectedMenuItemValue == 'Pending Credit Approval' ||
			selectedMenuItemValue == 'Pending 6096' || selectedMenuItemValue == 'Credit Approved' || selectedMenuItemValue == 'Credit Approved Word'
			|| selectedMenuItemValue == 'Credit Approved 6096' || selectedMenuItemValue == 'Credit Approved 6172' || selectedMenuItemValue == 'Credit Approved 6172 Word') {
			switch (component.get('v.prodName')){
				case 'CPF Development Loan':
					if (selectedMenuItemValue == 'Draft 6096' || selectedMenuItemValue == 'Pending 6096' || selectedMenuItemValue == 'Credit Approved 6096') {
						if (component.get("v.singleOrMulti") == 'Multi') {
							docName = 'ABSA 6096 EX - Word - Multi Phase';
						} else {
							docName = 'ABSA 6096 EX - Word - Single Phase';
						}
						if (selectedMenuItemValue == 'Draft 6096') {formStatus='Draft';}
						if (selectedMenuItemValue == 'Pending 6096') {formStatus='Pending Credit Approval';}
						if (selectedMenuItemValue == 'Credit Approved 6096') {formStatus='Credit Approved';}
					} else {
						if (selectedMenuItemValue == 'Draft Word' || selectedMenuItemValue == 'Pending Credit Approval Word' || selectedMenuItemValue == 'Credit Approved Word'){
							if (selectedMenuItemValue == 'Draft Word') {formStatus='Draft';}
							if (selectedMenuItemValue == 'Pending Credit Approval Word') {formStatus='Pending Credit Approval';}
							if (selectedMenuItemValue == 'Credit Approved Word') {formStatus='Credit Approved';}
							if (component.get("v.singleOrMulti") == 'Multi') {
								docName = 'Absa 6094 - CPF Development Loan Commercial Terms - Word - Multi Phase';
							} else {
								docName = 'Absa 6094 - CPF Development Loan Commercial Terms - Word - Single Phase';
							}
						} else {
							if (component.get("v.singleOrMulti") == 'Multi') {
								docName = 'Absa 6094 - CPF Development Loan Commercial Terms - PDF - Multi Phase';
							} else {
								docName = 'Absa 6094 - CPF Development Loan Commercial Terms - PDF - Single Phase';
							}
							formStatus = selectedMenuItemValue;
						}
					}
					break;
				case 'CPF Above R5 Million':
					if (selectedMenuItemValue == 'Draft Word' || selectedMenuItemValue == 'Draft 6172 Word' || selectedMenuItemValue == 'Pending Credit Approval Word' || selectedMenuItemValue == 'Credit Approved Word'
						|| selectedMenuItemValue == 'Credit Approved 6172 Word'){
						docName = 'ABSA 6171 EX - Commercial Property Finance Loan - Word';
						if (selectedMenuItemValue == 'Draft Word' || selectedMenuItemValue == 'Draft 6172 Word') {formStatus='Draft';}
						if (selectedMenuItemValue == 'Pending Credit Approval Word') {formStatus='Pending Credit Approval';}
						if (selectedMenuItemValue == 'Credit Approved Word') {formStatus='Credit Approved';}
						if (selectedMenuItemValue == 'Draft 6172 Word' || selectedMenuItemValue == 'Credit Approved 6172 Word') {
							docName = 'ABSA 6172 EX Word';
						}
					} else {
						docName = 'ABSA 6171 EX - Commercial Property Finance Loan';
						formStatus = selectedMenuItemValue;
						if (selectedMenuItemValue == 'Draft 6172' || selectedMenuItemValue == 'Credit Approved 6172') {
							docName = 'ABSA 6172 EX PDF';
						}
						if (selectedMenuItemValue == 'Draft 6172') {formStatus='Draft';}
						if (selectedMenuItemValue == 'Credit Approved 6172 Word') {formStatus='Credit Approved';}
					}
					break;
				case 'CPF Below R5 Million':
					if (selectedMenuItemValue == 'Draft Word' || selectedMenuItemValue == 'Pending Credit Approval Word' || selectedMenuItemValue == 'Credit Approved Word'){
						if (selectedMenuItemValue == 'Draft Word') {formStatus='Draft';}
						if (selectedMenuItemValue == 'Pending Credit Approval Word') {formStatus='Pending Credit Approval';}
						if (selectedMenuItemValue == 'Credit Approved Word') {formStatus='Credit Approved';}
						docName = 'ABSA 6171 EX - Commercial Property Finance Loan - Word';
					} else {
						docName = 'ABSA 6171 EX - Commercial Property Finance Loan';
						formStatus = selectedMenuItemValue;
					}
					break;
			}
		} else {
			switch (component.get('v.prodName')){
				case 'CPF Development Loan':
					docName = 'ABSA 6093 - Development Loan Standard Terms';
					break;
				case 'CPF Below R5 Million':
					docName = 'ABSA 6184 - CPF Investment Loan / MBBL Standard Terms';
					break;
				case 'CPF Below R5 Million':
					docName = 'ABSA 6184 - CPF Investment Loan / MBBL Standard Terms';
			}
			formStatus = '';
		}
		console.log('formStatus >>>>> ' + formStatus);
		console.log('docName >>>>> ' + docName);
		console.log('selectedMenuItemValue >>>>> ' + selectedMenuItemValue);
		console.log('prodName >>> ' + component.get('v.prodName'))
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

    handleSort: function(component, event, helper) {
        helper.sortData(component, event, 'v.dataAudit');
    },
})