({
	//function to handle the post load actions of the accountEditForm
	handleLoad: function (component, event, helper) {
		if (component.get("v.isBusinessAccountFromFlow") == "true") {
			//Business account
			component.set("v.clientEmailAddress", component.find("activeEmailField").get("v.value"));
		} else {
			//Non business account
			component.set("v.clientEmailAddress", component.find("personEmailField").get("v.value"));
		}
	},

	//function to perform actions when a checkbox is clicked on popSelectionGroup
	handleChange: function (component, event, helper) {
		var selectedValue = event.getParam("value");
		component.set("v.proofOfPaymentRecipients", selectedValue);

		if (selectedValue.includes("client") && !selectedValue.includes("beneficiary")) {
			component.set("v.showNextButton", true);
			component.set("v.clientSelected", true);
			component.set("v.beneficiarySelected", false);
		} else if (selectedValue.includes("beneficiary") && !selectedValue.includes("client")) {
			component.set("v.showNextButton", true);
			component.set("v.beneficiarySelected", true);
			component.set("v.clientSelected", false);
		} else if (selectedValue.includes("beneficiary") && selectedValue.includes("client")) {
			component.set("v.showNextButton", true);
			component.set("v.clientSelected", true);
			component.set("v.beneficiarySelected", true);
		} else {
			component.set("v.showNextButton", false);
			component.set("v.clientSelected", false);
			component.set("v.beneficiarySelected", false);
		}
	},

	//function called when the Send Proof of Payment button is clicked
	onButtonClick: function (component, event, helper) {
		component.set("v.errorMessage", "");
		var proofOfPaymentRecipients = component.get("v.proofOfPaymentRecipients");
		if (!$A.util.isEmpty(proofOfPaymentRecipients)) {
			if (proofOfPaymentRecipients == "client") {
				helper.configClientPopHelper(component, event, helper);
			} else if (proofOfPaymentRecipients == "beneficiary") {
				helper.configBeneficiaryPopHelper(component, event, helper);
			} else {
				//Client & Beneficiary
				helper.configClientPopHelper(component, event, helper);
				helper.configBeneficiaryPopHelper(component, event, helper);
			}
		}
	},

	//Function to handle flow custom navigation
	onButtonPressed: function (component, event, helper) {
		component.set("v.showPaymentStatusSuccessFromFlow", false);
		// Figure out which action was called
		var actionClicked = event.getSource().getLocalId();
		// Fire that action
		var navigate = component.get("v.navigateFlow");
		navigate(actionClicked);
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function called when clientIDnVObjectParent attribute value changes
	//closes case
	handleObjectChange: function (component, event, helper) {
		var cacheObject = component.get("v.clientIDnVObjectParent");
		if (!cacheObject) {
			helper.showSpinner(component);
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
		helper.hideSpinner(component);

		//Close the case subTab to go to the previous consultants' view
		var workspaceAPI = component.find("workspace");
		workspaceAPI
			.getFocusedTabInfo()
			.then(function (response) {
				var focusedTabId = response.tabId;
				workspaceAPI.closeTab({ tabId: focusedTabId });
			})
			.catch(function (error) {
				console.log("ProofOfPaymentSelectionController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	}
});