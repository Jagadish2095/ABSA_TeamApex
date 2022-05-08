({
	/**DBOOYSEN 2021-03-18
	 * Function called to get the historical once off payments made by the client
	 * against a selected account number
	 */
	fetchPaymentHistory: function (component, event, helper) {
		helper.showSpinner(component);

		var accountNumber = component.get("v.AccountNumberFromFlow");
		var action = component.get("c.OOPTransactionHistory");
		action.setParams({
			selectedAccountNumber: accountNumber
		});
		action.setCallback(this, function (response) {
			var dataSet = response.getReturnValue();
			var state = response.getState();
			if (state === "SUCCESS") {
				if (
					dataSet &&
					dataSet.MBS326O &&
					dataSet.MBS326O.outputCopybook &&
					dataSet.MBS326O.outputCopybook.responseDescription == "SUCCESSFUL PROCESS" &&
					dataSet.MBS326O.outputCopybook.instructionTable &&
					dataSet.MBS326O.outputCopybook.instructionTable.length > 0
				) {
					//Success
					var onceOffPaymentList = dataSet.MBS326O.outputCopybook.instructionTable;
					//Remove leading 0's from the Account number
					for (var key in onceOffPaymentList) {
						onceOffPaymentList[key].targetAccount = onceOffPaymentList[key].targetAccount.replace(/^0+/, "");
						var paymentDate = onceOffPaymentList[key].actDate;
						onceOffPaymentList[key].actDate = paymentDate.substring(0, 4) + "-" + paymentDate.substring(4, 6) + "-" + paymentDate.substring(6, 8);
					}
					//Sorts from the latest payment made (Service returns payments unsorted)
					onceOffPaymentList.sort((a, b) => (a.actDate < b.actDate ? 1 : -1));
					component.set("v.data", onceOffPaymentList);
					component.set("v.filteredData", onceOffPaymentList);
				} else {
					//Fire Error Toast
					helper.fireToast("Error", "Error no once off payments found on account: " + accountNumber, "error");
				}
			} else {
				console.log("Failed with state fetchPaymentHistory: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Show spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Fire lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
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
	}
});