({
	getVoucherDetailsAndExceptionReport: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getExceptionReport");
		action.setParams({ cifCode: component.get("v.accountCIFFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				//Success
				if (!$A.util.isEmpty(resp)) {
					component.set("v.hasExceptions", true);
					component.set("v.exceptionColumns", [
						{ label: "CIF Key", fieldName: "cifKey", type: "text" },
						{ label: "Transaction ID", fieldName: "transactionID", type: "text" },
						{ label: "Transaction Date", fieldName: "transactionDate", type: "text" },
						{ label: "Transaction Amount", fieldName: "transactionAmount", type: "text" },
						{ label: "Account Number", fieldName: "transactionAccount", type: "text" },
						{ label: "Voucher Code/ID", fieldName: "voucherId", type: "text" },
						{ label: "Platform Code", fieldName: "platformCode", type: "text" },
						{ label: "Status ID", fieldName: "transactionStatus", type: "text" },
						{ label: "Exception ID", fieldName: "exceptionDescription", type: "text" }
					]);
					component.set("v.exceptionData", resp);
				}
				//Get Voucher Details
				this.getVoucherDetailsHelper(component, event, helper);
			} else if (state === "ERROR") {
				helper.displayError(
					component,
					helper,
					" retrieve Exception Report.",
					"DLVoucherDetailsController.getExceptionReport: " + JSON.stringify(response.getError())
				);
			} else {
				helper.displayError(
					component,
					helper,
					" retrieve Exception Report.",
					"DLVoucherDetailsController.getExceptionReport, state returned: " + state
				);
			}
		});
		$A.enqueueAction(action);
	},

	getVoucherDetailsHelper: function (component, event, helper) {
		var action = component.get("c.getVoucherDetails");
		action.setParams({ cifCode: component.get("v.accountCIFFromFlow"), idNumber: component.get("v.accountIdNumberFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				helper.hideSpinner(component);
				if (resp.header.statuscode == "0") {
					//success
					if (!$A.util.isEmpty(resp.paymentHistoryList)) {
						component.set("v.data", resp.paymentHistoryList);
					} else {
						component.set("v.errorMessage", "There are no Vouchers for this client. ");
					}
				} else {
					//Error
					if (!$A.util.isEmpty(resp.header.resultMessages)) {
						component.set("v.errorMessage", resp.header.resultMessages[0].responseMessage);
					} else {
						component.set("v.errorMessage", "An error occurred during the Get Voucher Details service call. No Error message returned. ");
					}
				}
			} else if (state === "ERROR") {
				helper.displayError(
					component,
					helper,
					" retrieve Voucher Details.",
					"DLVoucherDetailsController.getVoucherDetails: " + JSON.stringify(response.getError())
				);
			} else {
				helper.displayError(component, helper, " retrieve Voucher Details.", "DLVoucherDetailsController.getVoucherDetails, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	attachVouchers: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.attachVouchersToCase");
		action.setParams({ caseId: component.get("v.caseIdFromFlow"), selectedVouchers: component.get("v.selectedVouchers") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			var resp = response.getReturnValue();
			if (state === "SUCCESS") {
				if (resp == "SUCCESS") {
					//Success
					helper.hideSpinner(component);
					var navigate = component.get("v.navigateFlow");
					navigate("NEXT");
				} else {
					//Error
					helper.displayError(component, helper, " attach Voucher Details to Case.", "DLVoucherDetailsController.attachVouchersToCase: " + resp);
				}
			} else if (state === "ERROR") {
				helper.displayError(
					component,
					helper,
					" attach Voucher Details to Case.",
					"DLVoucherDetailsController.attachVouchersToCase: " + JSON.stringify(response.getError())
				);
			} else {
				helper.displayError(
					component,
					helper,
					" attach Voucher Details to Case.",
					"DLVoucherDetailsController.attachVouchersToCase, state returned: " + state
				);
			}
		});
		$A.enqueueAction(action);
	},

	//Toast, Display & Log Error Message
	displayError: function (component, helper, simpleMsg, complexMsg) {
		helper.hideSpinner(component);
		helper.fireToast("Error!", "An error occurred while trying to " + simpleMsg, "error");
		component.set("v.errorMessage", "Unexpected error occurred " + complexMsg);
		console.log("Unexpected error occurred " + complexMsg);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toastie
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