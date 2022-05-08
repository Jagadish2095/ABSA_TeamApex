({
	doInit: function (component, event, helper) {
		component.set("v.selectedAccountList", "");
		var today = new Date();
		component.set("v.endDate", $A.localizationService.formatDate(today, "YYYY-MM-DD"));
		component.set("v.startDate", $A.localizationService.formatDate(new Date(today.setMonth(today.getMonth() - 1)), "YYYY-MM-DD"));
		var action = component.get("c.getCIFValue");
		action.setParams({ clientAccountId: component.get("v.clientAccountIdFromFlow") });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				component.set("v.cifKey", responseValue);
			} else {
			}
		});
		$A.enqueueAction(action);
		helper.getAccountCategory(component, event, helper);
	},

	submit: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var toastEvent = $A.get("e.force:showToast");
		component.set("v.columns", [
			{ label: "Number of Pages", fieldName: "docNbrPages", type: "text" },
			{ label: "Statement Date", fieldName: "statementDate", type: "text" }
		]);
		let button = event.getSource();
		button.set("v.disabled", true);
		var serviceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
		var serviceType = component.find("caseType__cField").get("v.value");

		var action = component.get("c.getAccountDetails");
		//Added by Nagpalsing dated 09/07/2021
		component.set("v.taxYear", component.get("v.startDate") + " : " + component.get("v.endDate"));
		action.setParams({
			selectedAccNumber: parseInt(component.get("v.SelectedAccNumberFromFlow")),
			accountType: component.get("v.SelectedaccountTypeFromFlow"),
			startDate: $A.localizationService.formatDate(component.get("v.startDate"), "YYYY-MM-DD"),
			endDate: $A.localizationService.formatDate(component.get("v.endDate"), "YYYY-MM-DD"),
			cifkey: component.get("v.cifKey"),
			isRateChange: component.get("v.isRateChange"),
			businessUnit: component.get("v.serviceGroup")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("test");
				var responseWrapper = response.getReturnValue();

				if (responseWrapper != null) {
					if (!$A.util.isUndefinedOrNull(responseWrapper.error)) {
						helper.toastEventHelper("Error!", "error", responseWrapper.error);
					} else if (responseWrapper.statementList.length > 0) {
						if (serviceGroup == $A.get("$Label.c.Home_Loans_SG") && serviceType == $A.get("$Label.c.Tax_Cert_ST")) {
							var statementList = [];
							for (var key in responseWrapper.statementList) {
								let monthAndDay = responseWrapper.statementList[key].statementDate.slice(-4);

								if (monthAndDay === "0228" || monthAndDay === "0229") {
									statementList.push(responseWrapper.statementList[key]);
								}
							}
							component.set("v.responseList", statementList);
							component.set("v.responseWrapper", responseWrapper);
						} else {
							component.set("v.responseList", responseWrapper.statementList);
							component.set("v.responseWrapper", responseWrapper);
						}
						helper.toastEventHelper("Success!", "success", "Documents are successfully retrieved");
					} else if (responseWrapper.statementList.length < 1) {
						helper.toastEventHelper("Error!", "error", "There is no documents available");
					}
				} else {
					helper.toastEventHelper("Error!", "error", "Something went wrong!");
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				helper.toastEventHelper("Error!", "error", JSON.stringify(errors));
			}

			button.set("v.disabled", false);
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},

	getSelectedRow: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		component.set("v.selectedDocList", selectedRows);
	},

	getAttachment: function (component, event, helper) {
		let button = event.getSource();
		button.set("v.disabled", true);
		let selectedDocList = component.get("v.selectedDocList");
		var serviceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
		var serviceType = component.find("caseType__cField").get("v.value");

		for (let doc in selectedDocList) {
			if (serviceGroup == $A.get("$Label.c.Home_Loans_SG") && serviceType == $A.get("$Label.c.Tax_Cert_ST")) {
				helper.statementDownloadHelper(component, event, helper, selectedDocList[doc].statementDate);
			} else {
				helper.getAttachmentHelper(component, event, helper, selectedDocList[doc].statementDate);
			}
		}
		button.set("v.disabled", false);
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function called when clientIDnVObjectParent attribute value changes.
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
		component.set("v.serviceGroup", currentServiceGroup);
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
				console.log("ABSAOnlineStatementSearchController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	}
});