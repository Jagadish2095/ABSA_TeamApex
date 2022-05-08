({
	getAttachmentHelper: function (component, event, helper, selectedDocDate) {
		component.set("v.showSpinner", true);
		var action = component.get("c.pdfFileService");
		action.setParams({
			accountId: component.get("v.clientAccountIdFromFlow"),
			cifKey: component.get("v.cifKey"),
			selectedDocDate: selectedDocDate,
			accountType: component.get("v.SelectedaccountTypeFromFlow"),
			selectedAccNumber: parseInt(component.get("v.SelectedAccNumberFromFlow")),
			listRef: component.get("v.responseWrapper.listRef"),
			isRateChange: component.get("v.isRateChange")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseWrapper = response.getReturnValue();
				if (responseWrapper != null) {
					if (!$A.util.isUndefinedOrNull(responseWrapper.error)) {
						helper.toastEventHelper("Error!", "error", responseWrapper.error);
					} else if (!$A.util.isUndefinedOrNull(responseWrapper.doc)) {
						var responseList = component.get("v.docResoponseList");
						responseWrapper.timestamp = selectedDocDate;
						responseList.push(responseWrapper);
						component.set("v.docResoponseList", responseList);
						component.set("v.jsStg", JSON.stringify(component.get("v.docResoponseList")));
						helper.toastEventHelper("Success!", "success", "Documents are successfully retrieved");
					} else {
						helper.toastEventHelper("Error!", "error", "Document is not available for selected date:" + selectedDocDate);
					}
				} else {
					helper.toastEventHelper("Error!", "error", "Document is not available for selected date:" + selectedDocDate);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.toastEventHelper("Error!", "error", JSON.stringify(errors));
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	statementDownloadHelper: function (component, event, helper, selectedDocDate) {
		component.set("v.showSpinner", true);
		var action = component.get("c.statementDownload");
		action.setParams({
			accountId: component.get("v.clientAccountIdFromFlow"),
			cifKey: component.get("v.cifKey"),
			selectedDocDate: selectedDocDate,
			accountType: component.get("v.SelectedaccountTypeFromFlow"),
			selectedAccNumber: parseInt(component.get("v.SelectedAccNumberFromFlow")),
			listRef: component.get("v.responseWrapper.listRef")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseWrapper = response.getReturnValue();
				if (responseWrapper != null) {
					if (!$A.util.isUndefinedOrNull(responseWrapper.error)) {
						helper.toastEventHelper("Error!", "error", responseWrapper.error);
					} else if (!$A.util.isUndefinedOrNull(responseWrapper.doc)) {
						var responseList = component.get("v.docResoponseList");
						responseWrapper.timestamp = selectedDocDate;
						responseList.push(responseWrapper);
						component.set("v.docResoponseList", responseList);
						component.set("v.jsStg", JSON.stringify(component.get("v.docResoponseList")));
						helper.toastEventHelper("Success!", "success", "Documents are successfully retrieved");
					} else {
						helper.toastEventHelper("Error!", "error", "Document is not available for selected date:" + selectedDocDate);
					}
				} else {
					helper.toastEventHelper("Error!", "error", "Document is not available for selected date:" + selectedDocDate);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.toastEventHelper("Error!", "error", JSON.stringify(errors[0].message));
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	toastEventHelper: function (title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			type: type,
			message: message
		});
		toastEvent.fire();
	},

	//Fire Sticky Lightning toast
	fireStickyToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			mode: "sticky",
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	getAccountCategory: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var selectedAccNumber = component.get("v.SelectedAccNumberFromFlow");
		var action = component.get("c.getAccountCategory");
		action.setParams({ accountNumber: selectedAccNumber });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseCategory = response.getReturnValue();
				console.log("response category : ", responseCategory);
				let emailTemplateToUse;
				if (responseCategory == "FSA" || responseCategory == "FORD") {
					// the Account is of Ford
					emailTemplateToUse = "Ford_Monthly_Statement_Template";
				} else if (responseCategory == "AVF" || responseCategory == "AVAF") {
					// the Account is of AVAF
					emailTemplateToUse = "AVAF_Monthly_Statement_Template";
				}
				component.set("v.emailTemplateName", emailTemplateToUse);
				if (emailTemplateToUse) {
					let newCaseSubject = component.find("caseSubjectField").get("v.value") + " " + responseCategory;
					component.find("caseSubjectField").set("v.value", newCaseSubject);
					component.find("caseSubjectEditForm").submit();
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.toastEventHelper("Error!", "error", JSON.stringify(errors));
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	}
});