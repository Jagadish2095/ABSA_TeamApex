({
	getDocsForCaseAndOpportunity: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var action = component.get("c.getAllDocuments");
		action.setParams({
			caseId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var responsevalue = response.getReturnValue();
				responsevalue.forEach(function (record) {
					record.linkName = "/servlet/servlet.FileDownload?file=" + record.File_Id__c;
					record.ownerName = record.Owner.Name;
				});
				component.set("v.documentsList", responsevalue);
			} else if (state === "ERROR") {
				var errors = response.getError();

				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
		component.set("v.showSpinner", false);
	},

	restrictSystemDocuments: function (component, event, helper, docId) {
		var action = component.get("c.restrictSystemDocs");
		action.setParams({
			docId: docId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var result = response.getReturnValue();
				component.set("v.documentGenerated", result);

				if (result == "System Generated") {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error!",
						message: "Could not delete the system generated documents ",
						type: "error"
					});
					toastEvent.fire();
				} else {
					this.deleteDocument(component, event, helper, docId);
				}
			} else {
				console.log("Failed with state: " + state);
				var errors = response.getError();
				console.log("errors " + JSON.stringify(errors));
			}
		});
		$A.enqueueAction(action);
	},

	deleteDocument: function (component, event, helper, docId) {
		component.set("v.showSpinner", true);
		var action = component.get("c.deleteDocument");
		action.setParams({
			docId: docId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var result = response.getReturnValue();
				component.set("v.deleteDocument", result);
				helper.getDocsForCaseAndOpportunity(component, event, helper);
			} else {
				console.log("Failed with state: " + state);
				var errors = response.getError();
				console.log("errors " + JSON.stringify(errors));
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	},

	getRecordType: function (component, event, helper, docId) {
		component.set("v.showSpinner", true);
		var action = component.get("c.getRecordTypeName");
		action.setParams({
			recordId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				var result = response.getReturnValue();
				console.log("results --" + result);
				if (result == true) {
					component.set("v.showODFacilityLetter", false);
				} else {
					component.set("v.showODFacilityLetter", true);
				}
			} else {
				console.log("Failed with state: " + state);
				var errors = response.getError();
				console.log("errors " + JSON.stringify(errors));
			}
		});
		component.set("v.showSpinner", false);
		$A.enqueueAction(action);
	}
});