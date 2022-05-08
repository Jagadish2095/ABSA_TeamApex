({
	//JQUEV 2020/11/05
	//Get List of VAPS Insurance Products (SAPGetList/AvafVapsGetList Service Call)
	getVAPSList: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getVAPSInsuranceList");
		action.setParams({
			accountNumber: component.get("v.selectedAccountNumberFromFlow")
		});
		action.setCallback(this, function (response) {
			helper.hideSpinner(component);
			var state = response.getState();
			if (state === "SUCCESS") {
				var respBean = response.getReturnValue();
				if (respBean.statusCode == 200) {
					//Successful Status Code
					if (respBean.E_RESPONSE == "{0}" || respBean.E_RESPONSE == 0) {
						//Succuss
						component.set("v.data", respBean.BAPI_SF_VAPS_LIST);
					} else {
						//Error Status Code
						component.set("v.errorMessage", "Service Response: " + respBean.E_RESPONSE_DESC);
					}
				} else {
					//Error Status Code
					component.set("v.errorMessage", "AvafVapsGetList Service Error. StatusCode: " + respBean.statusCode + ". Message: " + respBean.message);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error VAPSInsuranceCancellationController.getVAPSInsuranceList: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, VAPSInsuranceCancellationController.getVAPSInsuranceList state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//JQUEV 2020/11/05
	//Cancel VAPS Insurance Product (SAPCancel/AvafVapsCancel Service Call)
	cancelVAPSInsuranceHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.cancelVAPSInsurance");
		action.setParams({
			selectedVAPS: JSON.stringify(component.get("v.selectedRow")),
			authOverride: component.get("v.isEscalatedFromFlow") //If isEscalatedFromFlow then we want to override the cancel insurance
		});
		action.setCallback(this, function (response) {
			helper.hideSpinner(component);
			var state = response.getState();
			if (state === "SUCCESS") {
				var respBean = response.getReturnValue();
				if (respBean.statusCode == 200) {
					//Successful Status Code
					if (respBean.BAPI_SF_VAPS_CANCEL != null && respBean.BAPI_SF_VAPS_CANCEL.length > 0) {
						if (respBean.BAPI_SF_VAPS_CANCEL[0].E_RESPONSE == "0") {
							//Succuss
							//Hide buttons and make read only
							$A.util.addClass(component.find("frontOfficeActionBtns"), "slds-hide");
							$A.util.addClass(component.find("backOfficeActionBtns"), "slds-hide");
							component.find("commentsField").set("v.disabled", true);
							//If IS Escalated then also disable Radio btns and Checkbox
							if (component.get("v.isEscalatedFromFlow")) {
								component.find("confirmCheckboxGroup").set("v.disabled", true);
								component.find("authRadioGroup").set("v.disabled", true);
							}
							//IF Cancellation was successful then set close case flag to close case after email is sent
							component.set("v.closeCurrentCase", true);
							component.set("v.emailTemplateName", $A.get("$Label.c.AVAF_Email_Template_Successful"));
							component.set("v.toastMessage", "Service Response: " + respBean.BAPI_SF_VAPS_CANCEL[0].E_RESPONSE_DESC);
							//Save Comments and Selected Row
							component.find("caseEditForm").submit();
						} else {
							//Error Status Code
							component.set("v.errorMessage", "Service Response: " + respBean.BAPI_SF_VAPS_CANCEL[0].E_RESPONSE_DESC);
						}
					} else {
						//Error No Values returned
						component.set("v.errorMessage", "AvafVapsCancel Service Error. No BAPI_SF_VAPS_CANCEL List was returned");
					}
				} else {
					//Error Status Code
					component.set("v.errorMessage", "AvafVapsCancel Service Error. StatusCode: " + respBean.statusCode + ". Message: " + respBean.message);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error VAPSInsuranceCancellationController.cancelVAPSInsurance: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, VAPSInsuranceCancellationController.cancelVAPSInsurance state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//JQUEV 2020/11/05
	//Transfer Case to specified Service_Group__c
	transferCaseHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.transferCase");
		action.setParams({
			serviceGroupName: $A.get("$Label.c.AVAF_Account_Maintenance"),
			serviceTypeName: $A.get("$Label.c.AVAF_Insurance_Cancellation"),
			caseId: component.get("v.caseIdFromFlow")
		});
		action.setCallback(this, function (response) {
			helper.hideSpinner(component);
			var state = response.getState();
			if (state === "SUCCESS") {
				//Success
				component.set(
					"v.toastMessage",
					"The request for the VAP cancellation has been routed to the Account Maintenance team for authorization."
				);
				$A.util.addClass(component.find("frontOfficeActionBtns"), "slds-hide");
				component.set("v.closeCurrentCase", false);
				component.set("v.emailTemplateName", $A.get("$Label.c.AVAF_Email_Template_Transferred"));
				//Save comments
				component.find("caseEditForm").submit();
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error VAPSInsuranceCancellationController.transferCase: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, VAPSInsuranceCancellationController.transferCase state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
		component.set("v.isFormReadOnly", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
		component.set("v.isFormReadOnly", false);
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