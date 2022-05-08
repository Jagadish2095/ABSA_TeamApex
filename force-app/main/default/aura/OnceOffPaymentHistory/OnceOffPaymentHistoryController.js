({
	/**DBOOYSEN 2021-03-18
	 * Function called when component loads to set-up the lighting:datatable for Once Off payments
	 */
	doInit: function (component, event, helper) {
		component.set("v.columns", [
			{ label: "Payment date", fieldName: "actDate", type: "text" },
			{ label: "Beneficiary Name", fieldName: "instrRefName", type: "text" },
			{ label: "Bank", fieldName: "targetInstCode", type: "text" },
			{ label: "Branch Code", fieldName: "targetClrCode", type: "text" },
			{ label: "Account Number", fieldName: "targetAccount", type: "text" },
			{ label: "Amount", fieldName: "amount", type: "currency", cellAttributes: { alignment: "left" } },
			{ label: "Reference", fieldName: "sourceStatementRef", type: "text" }
		]);

		helper.fetchPaymentHistory(component, event, helper);
	},

	/**DBOOYSEN 2021-03-18
	 * Function called on row selection the lighting:datatable to set the selected payment
	 */
	rowSelected: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		for (var key in selectedRows) {
			selectedRows[key].actDate = selectedRows[key].actDate.replace(/-/, "");
		}
		//The selected payment is limited to 1 that is why the 1st index position is chosen to set
		component.set("v.SelectedPaymentString", JSON.stringify(selectedRows[0]));
	},

	/**DBOOYSEN 2021-03-18
	 * Function called when using the search input field to filter data
	 * Filters on the statement reference and bank name
	 */
	searchTable: function (component, event, helper) {
		var allRecords = component.get("v.data");
		var searchFilter = event.getSource().get("v.value").toUpperCase();
		var tempArray = [];
		var i;

		for (i = 0; i < allRecords.length; i++) {
			if (
				(allRecords[i].sourceStatementRef && allRecords[i].sourceStatementRef.toUpperCase().indexOf(searchFilter) != -1) ||
				(allRecords[i].targetInstCode && allRecords[i].targetInstCode.toUpperCase().indexOf(searchFilter) != -1)
			) {
				tempArray.push(allRecords[i]);
			}
		}
		component.set("v.filteredData", tempArray);
	},

	/**DBOOYSEN 2021-03-18
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

	/**DBOOYSEN 2021-03-18
	 * Function called to clear the From Date and End Date Fields
	 * Sets the filtered data to the original set
	 */
	resetDate: function (component, event, helper) {
		var originalData = component.get("v.data");
		component.set("v.filteredData", originalData);
		component.find("fromDate").set("v.value", "");
		component.find("endDate").set("v.value", "");
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
				console.log("OnceOffPaymentHistoryController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	}
});