({
	sendTransactionListHelper: function (component, event, helper) {
		component.set("v.isModalSpinner", true);
		var action = component.get("c.getDocumentData");
		action.setParams({
			transHistoryResponse: JSON.stringify(component.get("v.transactionHistoryResp")),
			transactionList: JSON.stringify(component.get("v.transactionData")),
			accountNumber: component.get("v.selectedAccountNumber"),
			documentTemplateName: "Transaction History List",
			accountId: component.get("v.clientAccountIdFromFlow"),
			fromDate: $A.localizationService.formatDate(component.get("v.fromDate"), "MM dd yyyy").trim().replace(/\s+/g, "."),
			toDate: $A.localizationService.formatDate(component.get("v.toDate"), "MM dd yyyy").trim().replace(/\s+/g, "."),
			accountType: component.get("v.selectedProductValue")
		});
		action.setCallback(this, function (response) {
			var dataSet = response.getReturnValue();
			console.log("sendTransactionListHelper resp: " + dataSet);
			var state = response.getState();
			if (state === "SUCCESS") {
				if (!$A.util.isEmpty(dataSet) && !dataSet.startsWith("Error:")) {
					helper.fireToast("Success", "Transaction List Generated", "success");
					//Add send email functionality
					helper.sendEmailHelper(
						component,
						event,
						helper,
						dataSet,
						component.get("v.clientEmailAddress"),
						"Transaction History",
						"Transaction_History_List"
					);
				} else {
					component.set("v.errorMessage", "Apex Error TransactonListHelper.sendTransactionListHelper: " + dataSet);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error TransactonListHelper.sendTransactionListHelper: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error, TransactonListHelper.sendTransactionListHelper : " + state);
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	},

	//function that send an email from apex
	sendEmailHelper: function (component, event, helper, attachment, emailTo, documentName, emailTemplate) {
		component.set("v.isModalSpinner", true);
		var action = component.get("c.sendTransactions");
		action.setParams({
			caseId: component.get("v.caseId"),
			emailAddress: emailTo,
			emailTemplateName: emailTemplate,
			pdfData: attachment,
			docName: documentName
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.startsWith("Error:")) {
					component.set("v.errorMessage", resp);
				} else {
					//Success
					helper.fireToast("Success!", resp, "success");
					//DBOOYSEN. W-008306
					//Create the charge log by calling aura method from child component "ChargeTransaction"
					var emailAddressCount = emailTo.split(",").length;
					var chargeComponent = component.find("chargeTransactionCmp");
					chargeComponent.createChargeLog("TC008"); //Transaction History Inquiry
					for (var i = 0; i < emailAddressCount; i++) {
						chargeComponent.createChargeLog("TC009"); //Email
					}
					//Close Case on success of email sent
					component.find("caseStatusFieldModal").set("v.value", "Closed");
					component.find("caseEditFormModal").submit();
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "TransactonListhistory.sendEmailHelper: " + JSON.stringify(errors));
			} else {
				helper.fireToast("Error", "Unexpected error, TransactonListhistory.sendEmailHelper: " + state, "error");
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	},

	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Fire lightning toast event
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	}
});