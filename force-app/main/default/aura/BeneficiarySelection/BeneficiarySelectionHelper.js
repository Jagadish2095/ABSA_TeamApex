({
	/**DBOOYSEN 2021-03-25
	 * Function called to get the combi cards from another component
	 */
	doInit: function (component, event) {
		var getBenDetails = component.find("hiddenComp");
		getBenDetails.getAccountDetailsMethod(component, event);
	},

	/**DBOOYSEN 2021-03-25
	 * Function called to get the list of beneficiaries from the combi card selected
	 */
	getAccountBeneficiariesHelper: function (component, event) {
		this.showSpinner(component);
		var activeCombiNumber = component.get("v.selectedCombiValue");

		if (!activeCombiNumber) {
			this.fireToast("Error", "Error: No active combi card to retrieve beneficiaries from", "error");
			component.set("v.showSpinner", false);
			return;
		}
		var action = component.get("c.getBeneficiaries");
		action.setParams({
			selectedCombiAccountNumber: activeCombiNumber
		});

		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (
					respObj &&
					respObj.MBS326O &&
					respObj.MBS326O.outputCopybook &&
					respObj.MBS326O.outputCopybook.responseDescription == "SUCCESSFUL PROCESS" &&
					respObj.MBS326O.outputCopybook.instructionTable &&
					respObj.MBS326O.outputCopybook.instructionTable.length > 0
				) {
					//Success
					var accBeneficiaryList = respObj.MBS326O.outputCopybook.instructionTable;

					for (var key in accBeneficiaryList) {
						accBeneficiaryList[key].targetAccount = accBeneficiaryList[key].targetAccount.replace(/^0+/, "");
						accBeneficiaryList[key].ivrNominate = accBeneficiaryList[key].ivrNominate.replace(/^0+/, "");
					}

					component.set("v.accBeneficiaryList", accBeneficiaryList);

					//populate search data
					var childCmp = component.find("searchBen");
					childCmp.passUnfilteredData(component, event);
				} else {
					//Fire Error Toast
					this.fireToast("Error", "Error no beneficiaries found on account: " + activeCombiNumber, "error");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error BeneficiarySelectionApex.getBeneficiaries: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Hide the lightning spinner
	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
	},

	//Show the lighting spinner
	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	//Fire a lighting toast message
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