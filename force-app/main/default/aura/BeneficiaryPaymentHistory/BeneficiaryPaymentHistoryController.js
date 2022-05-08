({
	/**DBOOYSEN 2021-03-25
	 * Function called when component loads to set-up the lighting:datatable for beneficiary payments
	 */
	doInit: function (component, event, helper) {
		component.set("v.columns", [
			{ label: "Payment date", fieldName: "actDate", type: "text" },
			{ label: "Reference", fieldName: "srcStmtRef", type: "text" },
			{ label: "Amount", fieldName: "amount", type: "currency", cellAttributes: { alignment: "left" } }
		]);
	},

	/**DBOOYSEN 2021-03-25
	 * Function called when selectedBeneficiaryEvt is fired after a beneficiary is selected
	 * Calls a helper function to get the payments for the selected beneficiary
	 */
	handleSelectBeneficiaryEvent: function (component, event, helper) {
		//get the beneficiary record record from the event
		var selectedBeneficiary = event.getParam("beneficiaryEventRecord");
		component.set("v.selectedBeneficiary", selectedBeneficiary);
		component.set("v.showBeneficiarySelection", false);
		helper.fetchPaymentHistory(component, event, helper);
	},

	/**DBOOYSEN 2021-03-25
	 * Function called on row selection the lighting:datatable to set the selected payment
	 */
	rowSelected: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		for (var key in selectedRows) {
			selectedRows[key].actDate = selectedRows[key].actDate.replace(/-/g, "");
		}
		//The selected payment is limited to 1 that is why the 1st index position is chosen to set
		component.set("v.selectedPaymentString", JSON.stringify(selectedRows[0]));
		component.set("v.selectedBeneficiaryEft", component.get("v.selectedBeneficiary").uniqueEFT);
		component.set("v.selectedBeneficiaryName", component.get("v.selectedBeneficiary").instrRefName);
		$A.util.addClass(component.find("sendBeneficiaryPaymentsListBtn"), "slds-hide");
	},

	/**DBOOYSEN 2021-03-25
	 * Function called when using the search input field to filter data
	 * Filters on the statement reference
	 */
	searchTable: function (component, event, helper) {
		var allRecords = component.get("v.data");
		var searchFilter = event.getSource().get("v.value").toUpperCase();
		if (!$A.util.isEmpty(searchFilter)) {
			var tempArray = [];
			var i;

			for (i = 0; i < allRecords.length; i++) {
				if (allRecords[i].srcStmtRef && allRecords[i].srcStmtRef.toUpperCase().indexOf(searchFilter) != -1) {
					tempArray.push(allRecords[i]);
				}
			}
			component.set("v.filteredData", tempArray);
		} else {
			component.set("v.filteredData", allRecords);
		}
	},

	/**DBOOYSEN 2021-03-25
	 * Function called when a date is entered in either the From Date,
	 * End Date or both fields. And filters accordingly
	 */
	filterDate: function (component, event, helper) {
		var originalData = component.get("v.data");
		var fromDate = component.find("fromDate").get("v.value");
		var endDate = component.find("endDate").get("v.value");
		var tempDateFilteredArray = [];
		if (!$A.util.isEmpty(fromDate) && $A.util.isEmpty(endDate)) {
			//Filters from the From Date onwards
			for (var i = 0; i < originalData.length; i++) {
				if (originalData[i].actDate >= fromDate) {
					tempDateFilteredArray.push(originalData[i]);
				}
			}
			component.set("v.filteredData", tempDateFilteredArray);
		} else if (!$A.util.isEmpty(endDate) && $A.util.isEmpty(fromDate)) {
			//Filters before the End Date upwards
			for (var i = 0; i < originalData.length; i++) {
				if (originalData[i].actDate <= endDate) {
					tempDateFilteredArray.push(originalData[i]);
				}
			}
			component.set("v.filteredData", tempDateFilteredArray);
		} else if (!$A.util.isEmpty(fromDate) && !$A.util.isEmpty(endDate)) {
			//Filters on a date range between From Date and End Date
			for (var i = 0; i < originalData.length; i++) {
				if (originalData[i].actDate >= fromDate && originalData[i].actDate <= endDate) {
					tempDateFilteredArray.push(originalData[i]);
				}
			}
			component.set("v.filteredData", tempDateFilteredArray);
		} else {
			//No Date
			component.set("v.filteredData", originalData);
		}
	},

	/**DBOOYSEN 2021-03-25
	 * Function called to clear the From Date and End Date Fields
	 * Sets the filtered data to the original set
	 */
	resetDate: function (component, event, helper) {
		var originalData = component.get("v.data");
		component.set("v.filteredData", originalData);
		component.find("fromDate").set("v.value", "");
		component.find("endDate").set("v.value", "");
	},

	/**DBOOYSEN 2021-03-25
	 * Function called to when the Choose Another Beneficiary button is clicked to reselect
	 */
	chooseNewBeneficiary: function (component, event, helper) {
		component.set("v.showBeneficiarySelection", true);
		component.set("v.data", "");
		component.set("v.filteredData", "");
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function called when clientIDnVObjectParent attribute value changes
	//closes case
	handleObjectChange: function (component, event, helper) {
		var cacheObject = component.get("v.clientIDnVObjectParent");
		if (!cacheObject) {
			component.set("v.showSpinner", true);
			//Close case
			component.find("statusFieldIDnV").set("v.value", "Closed");
			component.find("caseEditFormIDnV").submit();
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to set attributes once the caseEditFormIDnV has loaded
	handleCaseLoadIDnV: function (component, event, helper) {
		var serviceGroupsPollingAllowed = $A.get("$Label.c.Client_IDnV_Polling_Service_Groups");
		var currentServiceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
		if (serviceGroupsPollingAllowed.includes(currentServiceGroup)) {
			component.set("v.clientCifCodeParent", component.find("clientCIFFieldIDnV").get("v.value"));
			component.set("v.allowClientIDnVPolling", true);
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to execute when the caseEditFormIDnV save is successful
	handleCaseSuccessIDnV: function (component, event, helper) {
		var caseNumber = component.find("caseNumberFieldIDnV").get("v.value");
		var cifNumber = component.find("clientCIFFieldIDnV").get("v.value");
		helper.fireStickyToast("Error!", "Call dropped. Case number: " + caseNumber + " was auto closed for the client with CIF: " + cifNumber, "error");
		component.set("v.showSpinner", false);

		//Close the case subTab to go to the previous consultants' view
		var workspaceAPI = component.find("workspace");
		workspaceAPI
			.getFocusedTabInfo()
			.then(function (response) {
				var focusedTabId = response.tabId;
				workspaceAPI.closeTab({ tabId: focusedTabId });
			})
			.catch(function (error) {
				console.log("BeneficiaryPaymentHistory.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	},

	openModal: function (component, event, helper) {
		helper.openModalHelper(component, event, helper);
	},

	closeModal: function (component, event, helper) {
		helper.closeModalHelper(component, event, helper);
	},

	//DBOOYSEN. 2021/04/09
	//calling helper function to generate the payment list and send the email
	sendEmailCloseCase: function (component, event, helper) {
		if (component.find("clientEmailAddressField").checkValidity() == true) {
			component.set("v.clientEmailAddress", component.find("clientEmailAddressField").get("v.value"));
			helper.sendBeneficiaryPaymentsHelper(component, event, helper);
		} else {
			helper.fireToast("Error!", "Email Address Is Not Valid", "error");
		}
	},

	//DBOOYSEN. 2021/04/09
	//function to handle the post load actions of the caseEditFormModal
	handleAccountLoadModal: function (component, event, helper) {
		if (component.get("v.isBusinessAccountFromFlow") == "true") {
			//Business account
			component.set("v.clientEmailAddress", component.find("activeEmailFieldModal").get("v.value"));
		} else {
			//Non business account
			component.set("v.clientEmailAddress", component.find("personEmailFieldModal").get("v.value"));
		}
	},

	//DBOOYSEN. 2021/04/09
	//function to handle the actions of the caseEditFormModal when successfully saved
	handleCaseSuccessModal: function (component, event, helper) {
		helper.fireToast("Success", "Beneficiary Payment List sent and Case Closed Successfully", "success");
	},

	//DBOOYSEN. 2021/04/09
	//Navigate to the next view to send the proof of payment for the selected payment
	navigateToComponent: function (component, event, helper) {
		//Navigate Next
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	}
});