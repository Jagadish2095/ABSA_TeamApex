({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		//Set Columns for Attached Vouchers
		component.set("v.columns", [
			{ label: "Voucher Name", fieldName: "Name", type: "text" },
			{ label: "Amount", fieldName: "Amount__c", type: "text" },
			{ label: "Date of purchase", fieldName: "Date_of_Purchase__c", type: "text" },
			{ label: "Voucher Expiry - 3 years", fieldName: "Voucher_Expiry_Date__c", type: "text" },
			{ label: "Order Number", fieldName: "Order_Number__c", type: "text" },
			{ label: "Purchase Status", fieldName: "Purchase_Status__c", type: "text" },
			{ label: "Account", fieldName: "Account_Number__c", type: "text" }
		]);
		//Display readonly fields
		if (component.get("v.isEscalatedFromFlow")) {
			$A.util.removeClass(component.find("headingDiv"), "slds-hide");
			$A.util.removeClass(component.find("whyClientCalledDiv"), "slds-hide");
			$A.util.removeClass(component.find("reasonForCloseOrEscalateDiv"), "slds-hide");
			$A.util.removeClass(component.find("commentsDiv"), "slds-hide");
		}
	},

	//Load - Case
	handleCaseLoad: function (component, event, helper) {
		if (!component.get("v.isDataLoaded")) {
			helper.getDataHelper(component, event, helper);
			var options = component.get("v.solvedRadioOptions");
			//Add additional radio option for Timeout Errors/Voucher not received job
			if (component.find("typeField").get("v.value") == "Timeout Errors/Voucher not received" && !JSON.stringify(options).includes("DBS")) {
				options.push({ label: "I was not able to solve the client's query, I referred the client to DBS", value: "DBS" });
				component.set("v.solvedRadioOptions", options);
			}
			//Set accountId attribute for Account RecordViewForm
			component.set("v.accountId", component.find("accountIdField").get("v.value"));
		}
	},

	//Load - Account
	handleAccountLoad: function (component, event, helper) {
		var fullNameObj = component.find("accountNameField").get("v.value");
		if (!$A.util.isEmpty(fullNameObj)) {
			var fullNameString = fullNameObj.FirstName + " " + fullNameObj.LastName;
			if (fullNameObj.Suffix != null) {
				fullNameString = fullNameObj.Suffix + " " + fullNameString;
			}
			component.set("v.clientName", fullNameString);
		}
	},

	//Success
	handleCaseSuccess: function (component, event, helper) {
		if (component.get("v.isCaseSolved")) {
			helper.hideSpinner(component);
			helper.fireToast("Success!", "Case successfully closed. ", "success");
		} else {
			//Escalate to Outbound Consultant - Case is transferred
			helper.transferCase(component, event, helper);
		}
	},

	//Error
	handleCaseError: function (component, event, helper) {
		helper.hideSpinner(component);
		helper.displayError(component, helper, "save the data. ", JSON.stringify(event.getParams()));
	},

	//Change the values displayed in the picklists as well as the button depending on the radio option selected for Case Solved
	handleSolvedRadioBtnChange: function (component, event, helper) {
		$A.util.removeClass(component.find("caseActionBtn"), "slds-hide");
		//Default to Solved - Close Case (prevents duplicating code in IF statements)
		component.set("v.isCaseSolved", true);
		component.find("caseActionBtn").set("v.label", "Close Case");
		//Default to hide DBS Script if another option is selected
		component.set("v.displayReferringDBSScript", false);
		if (event.getParam("value") == "Unsolved") {
			//Has not been solved
			component.find("caseActionBtn").set("v.label", "Escalate Case");
			component.set("v.isCaseSolved", false);
		} else if (event.getParam("value") == "DBS") {
			//Referred to DBS (Case marked as Solved isCaseSolved because case is then closed)
			component.set("v.displayReferringDBSScript", true);
		}
		var dependentPicklist = JSON.parse(component.get("v.dependentPicklistJSON"));
		var whyValueList = dependentPicklist[component.find("typeField").get("v.value")][event.getParam("value")]["Why_Did_The_Client_Call__c"];
		var reasonValueList =
			dependentPicklist[component.find("typeField").get("v.value")][event.getParam("value")]["Reason_for_Closing_or_Escalating_Case__c"];
		helper.createOptions(component, whyValueList, "v.whyDidTheClientCall_Options");
		helper.createOptions(component, reasonValueList, "v.reasonForClosingOrEscalatingCase_Options");
	},

	//Change the values displayed in the picklists as well as the button depending on the radio option selected for Case Valid
	handleValidRadioBtnChange: function (component, event, helper) {
		$A.util.removeClass(component.find("closeCaseBtn"), "slds-hide");
		//Save Validity Choice
		component.find("validityField").set("v.value", event.getParam("value"));
		var dependentPicklist = JSON.parse(component.get("v.dependentPicklistJSON"));
		var outcomeValueList = dependentPicklist[component.find("typeField").get("v.value")][event.getParam("value")]["Case_Query_Outcome_Reason__c"];
		helper.createOptions(component, outcomeValueList, "v.validityReason_Options");
	},

	caseAction: function (component, event, helper) {
		var whyDidTheClientCallValue = component.get("v.whyDidTheClientCall_SelectedValue");
		var reasonForClosingOrEscalatingValue = component.get("v.reasonForClosingOrEscalatingCase_SelectedValue");
		if (
			$A.util.isEmpty(whyDidTheClientCallValue) ||
			$A.util.isEmpty(reasonForClosingOrEscalatingValue) ||
			$A.util.isEmpty(component.find("inboundCommentsTextarea").get("v.value"))
		) {
			//Error required fields are missing
			helper.fireToast("Error!", "Please complete all the required fields. ", "error");
		} else {
			component.set("v.isFormReadOnly", true);
			helper.showSpinner(component);
			//Set picklist values
			component.find("whyClientCalledField").set("v.value", whyDidTheClientCallValue);
			component.find("reasonForCloseOrEscalateField").set("v.value", reasonForClosingOrEscalatingValue);
			component.find("commentsField").set("v.value", component.find("inboundCommentsTextarea").get("v.value"));
			if (component.get("v.isCaseSolved")) {
				//close Case
				component.find("statusField").set("v.value", "Closed");
			}
			component.find("caseEditForm").submit();
		}
	},

	closeCase: function (component, event, helper) {
		var validityReasonValue = component.get("v.validityReason_SelectedValue");
		if ($A.util.isEmpty(validityReasonValue) || $A.util.isEmpty(component.find("outboundCommentsTextarea").get("v.value"))) {
			//Error required fields are missing
			helper.fireToast("Error!", "Please complete all the required fields. ", "error");
		} else {
			component.set("v.isFormReadOnly", true);
			helper.showSpinner(component);
			component.set("v.isCaseSolved", true);
			component.find("statusField").set("v.value", "Closed");
			component.find("validityReasonField").set("v.value", validityReasonValue);
			component.find("commentsField").set("v.value", component.find("outboundCommentsTextarea").get("v.value"));
			component.find("caseEditForm").submit();
		}
	}
});