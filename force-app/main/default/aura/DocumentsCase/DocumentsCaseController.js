({
	doInit: function (component, event, helper) {
		var columnsAuditActions = [{ label: "Delete", name: "Delete" }];

		component.set("v.docListColumns", [
			{ label: "Document Name", fieldName: "linkName", type: "url", typeAttributes: { label: { fieldName: "Name" }, target: "_blank" }, wrapText: true },
			{
				label: "Status",
				fieldName: "Document_Status__c",
				type: "text",
				wrapText: true
			},
			{
				label: "Date Created",
				fieldName: "CreatedDate",
				type: "date",
				typeAttributes: {
					year: "numeric",
					month: "long",
					day: "2-digit",
					hour: "2-digit",
					minute: "2-digit"
				}
			},
			{ label: "Document Owner", fieldName: "ownerName", type: "Text", wrapText: true },
			{ type: "action", typeAttributes: { rowActions: columnsAuditActions } }
		]);
		helper.getDocsForCaseAndOpportunity(component, event, helper);
		helper.getRecordType(component, event, helper);
	},

	refreshDocumentsList: function (component, event, helper) {
		helper.getDocsForCaseAndOpportunity(component, event, helper);
	},
	handleRowAction: function (component, event, helper) {
		var action = event.getParam("action");
		var row = event.getParam("row");
		switch (action.name) {
			case "Delete":
				var userName = component.get("v.currentUser");
				console.log("user name " + userName.Name);
				if (userName.Name === row.ownerName) {
					var flag = confirm("Are you sure, you want to delete document ?");
					if (flag) {
						helper.restrictSystemDocuments(component, event, helper, row.Id);
					}
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "You are only allowed to delete documents you uploaded",
						type: "error"
					});
					toastEvent.fire();
				}
				break;
		}
	}
});