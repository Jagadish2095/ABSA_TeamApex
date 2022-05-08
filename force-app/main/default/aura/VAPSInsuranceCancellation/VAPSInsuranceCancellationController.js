({
	//JQUEV 2020-11-05
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		if (!component.get("v.isEscalatedFromFlow")) {
			//Is Not Escalated (Inbound Consultant / Front Office)
			if (!$A.util.isEmpty(component.get("v.selectedAccountNumberFromFlow"))) {
				//Set Columns
				component.set("v.columns", [
					{ label: "VAP Product Code", fieldName: "ZZPRDCODE", type: "text" },
					{ label: "VAP Product Description", fieldName: "ZZPRDDESC", type: "text" },
					{ label: "Unique Id", fieldName: "ZZUNIQUE_ID", type: "text" },
					{ label: "Insurance Code", fieldName: "ZZINSCODE", type: "text" },
					{ label: "Insurance Company", fieldName: "ZZINSCOMP", type: "text" },
					{ label: "Policy Start Date", fieldName: "ZZPOLIDATE", type: "text" },
					{ label: "Policy Amount", fieldName: "ZZINSAMT", type: "text" },
					{ label: "Insurance Term", fieldName: "ZZINSTRM", type: "text" },
					{ label: "Authorization Required", fieldName: "INS_AUTH_REQ", type: "text" }
				]);

				//Integration Service Call to get list
				helper.getVAPSList(component, event, helper);
			} else {
				//Error - No Account Selected
				component.set("v.errorMessage", "Please select an Account on the previous tab. ");
				helper.hideSpinner(component);
			}
		}
	},

	//Load
	handleLoad: function (component, event, helper) {
		if (component.get("v.isEscalatedFromFlow")) {
			//Is Escalated (Outbound Consultant / Back Office)
			var addAttributes = component.find("addAttributes").get("v.value");
			if (!$A.util.isEmpty(addAttributes)) {
				//Has Additional_Attributes__c - Set SelectedRow
				var addAttributesObj = JSON.parse(addAttributes);
				component.set("v.selectedRow", addAttributesObj);
				component.set("v.selectedAccountNumberFromFlow", addAttributesObj.ACCOUNT);
				//Next Action will always be to close case after email send
				component.set("v.closeCurrentCase", true);
			} else {
				//Error - No Additional_Attributes__c
				component.set("v.errorMessage", "Error: No data was stored for the selected product in Case.Additional_Attributes__c. ");
			}
		}
		helper.hideSpinner(component);
	},

	//Submit
	handleSubmit: function (component, event, helper) {
		helper.showSpinner(component);
	},

	//Success
	handleSuccess: function (component, event, helper) {
		helper.hideSpinner(component);
		component.set("v.errorMessage", null);
		component.find("commentsField").set("v.disabled", true);
		//Fire Toast messages
		if (!$A.util.isEmpty(component.get("v.toastMessage"))) {
			helper.fireToast("Success!", component.get("v.toastMessage"), "success");
		} else {
			helper.fireToast("Success!", "Case successfully updated. ", "success");
		}
		//Navigate to next Screen (Send Email)
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	//Error
	handleError: function (component, event, helper) {
		helper.hideSpinner(component);
		helper.fireToast("Error!", "There has been an error saving the data. ", "error");
		component.set("v.errorMessage", "There has been an error saving the data: " + JSON.stringify(event.getParams()));
	},

	//Handle Action
	handleRowSelection: function (component, event, helper) {
		//Save Selected Row to Temp var
		component.set("v.tempSelectedRow", event.getParam("selectedRows")[0]);
		component.find("openSelectedRowBtn").set("v.disabled", false);
	},

	//Go to Selected Row.
	openSelectedRow: function (component, event, helper) {
		//Save Selected Row
		component.set("v.selectedRow", component.get("v.tempSelectedRow"));
		//Save Selected Row to Additional Attributes
		component.find("addAttributes").set("v.value", JSON.stringify(component.get("v.tempSelectedRow")));
		if(component.get("v.tempSelectedRow.INS_AUTH_REQ") == "P"){
			component.find("inboundActionBtn").set("v.label", "Cancel VAP");
		}else{
			component.find("inboundActionBtn").set("v.label", "Route to Account Maintenance Team");
		}
	},

	//Cancel Insurance
	handleInsuranceCancellation: function (component, event, helper) {
		if ($A.util.isEmpty(component.find("commentsField").get("v.value"))) {
			//Validation Error
			helper.fireToast("Error!", "Please complete the required fields. ", "error");
		} else {
			var authRequired = component.get("v.selectedRow.INS_AUTH_REQ");
			//IF Is Not Escalated & Requires Authorization
			if (!component.get("v.isEscalatedFromFlow") && (authRequired == "E" || authRequired == "X")) {
				//Needs Authorization - Transfer to AVAF Account Maintenance
				helper.transferCaseHelper(component, event, helper);
			} else {
				//Is Escalated OR Does not Require Auth
				//Does not need Authorization - Call AvafVapsCancel Service
				helper.cancelVAPSInsuranceHelper(component, event, helper);
			}
		}
	},

	//Radio Button Change
	handleRadioBtnChange: function (component, event, helper) {
		if (event.getParam("value") == "authorized") {
			//Show Confirm Checkbox, Hide Next Btn
			$A.util.removeClass(component.find("confirmCheckbox"), "slds-hide");
			$A.util.addClass(component.find("nextCmpBtn"), "slds-hide");
			//Nullify email template
			component.set("v.emailTemplateName", null);
		} else {
			//Show Next Btn, Hide Confirm Checkbox and Action Btn
			$A.util.addClass(component.find("confirmCheckbox"), "slds-hide");
			$A.util.addClass(component.find("backOfficeActionBtns"), "slds-hide");
			$A.util.removeClass(component.find("nextCmpBtn"), "slds-hide");
			component.set("v.emailTemplateName", $A.get("$Label.c.AVAF_Email_Template_Unsuccessful"));
			//Deselect Confirm Checkbox
			component.set("v.confirmCheckboxValue", []);
		}
	},

	//Confirmation Attached
	handleConfirmation: function (component, event, helper) {
		//Show / Hide the Cancel Insurance Button
		if (event.getParam("value").includes("confirmed")) {
			$A.util.removeClass(component.find("backOfficeActionBtns"), "slds-hide");
		} else {
			$A.util.addClass(component.find("backOfficeActionBtns"), "slds-hide");
		}
	},

	//Navigate Next
	navigateNextScreen: function (component, event, helper) {
		//Navigate to next Screen (Send Email)
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},
	//Navigate Next
	navigateBackScreen: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		navigate("BACK");
	},

	//Back Btn - nullify selectedRow
	goBackToAvafVapsList: function (component, event, helper) {
		component.set("v.selectedRow", null);
		component.set("v.tempSelectedRow", null);
		component.set("v.errorMessage", null);
	}
});