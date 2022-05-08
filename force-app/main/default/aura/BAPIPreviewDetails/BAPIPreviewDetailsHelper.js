({
	getAccountFinancialInformationHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getAccFinInformation");
		action.setParam("accountNumber", component.get("v.selectedAccountNumber"));
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				if (!$A.util.isEmpty(returnValues)) {
					if (!$A.util.isUndefinedOrNull(returnValues.BAPI_SF_IF42)) {
						if (returnValues.BAPI_SF_IF42.E_RESPONSE == 0) {
							var responseBean = returnValues.BAPI_SF_IF42.E_FI_DETAILS;
							component.set("v.selectedAccountNumber", responseBean.ACCT_NUM);
							component.set("v.clientReferenceNumber", responseBean.ACCT_NUM);
							component.set("v.arrearsAmount", responseBean.ARBAL);
							component.set("v.instalmentAmount", responseBean.CURRENT_BAL);
							component.set("v.instalmentDate", $A.localizationService.formatDate(responseBean.INSTAL_DATE));
							helper.getAgentDetailsHelper(component, event, helper);
						} else {
							component.set("v.errorMessage", returnValues.BAPI_SF_IF42.E_RESPONSE_DESC);
							helper.hideSpinner(component);
						}
					} else {
						component.set("v.errorMessage", "returnValues.BAPI_SF_IF42 is empty from service");
						helper.hideSpinner(component);
					}
				} else {
					component.set("v.errorMessage", "Empty Response from Service");
					helper.hideSpinner(component);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
				helper.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	//getting the agent details..
	getAgentDetailsHelper: function (component, event, helper) {
		var action = component.get("c.getAgentDetails");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				if (!$A.util.isEmpty(returnValues)) {
					component.set("v.agentNameNSurname", returnValues.Name);
					component.set("v.agentContactNumber", returnValues.MobilePhone);
					component.set("v.agentEmail", returnValues.Email);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
		});
		helper.hideSpinner(component);
		$A.enqueueAction(action);
	},

	sendEmailHelper: function (component, event, helper) {
		let emailTemplateParamMapString = new Map();
		emailTemplateParamMapString["[Surname]"] = component.get("v.clientSurname");
		emailTemplateParamMapString["[Account number]"] = component.get("v.selectedAccountNumber");
		emailTemplateParamMapString["[Arrears]"] = component.get("v.arrearsAmount");
		emailTemplateParamMapString["[Client account number]"] = component.get("v.clientReferenceNumber");
		emailTemplateParamMapString["[Instalment amount]"] = component.get("v.instalmentAmount");
		emailTemplateParamMapString["[Name and Surname]"] = component.get("v.agentNameNSurname");
		emailTemplateParamMapString["[Contact number]"] = component.get("v.agentContactNumber");
		emailTemplateParamMapString["[Insert email address]"] = component.get("v.agentEmail");
		emailTemplateParamMapString["[Instalment date]"] = component.get("v.instalmentDate");
		emailTemplateParamMapString["[insert date]"] = component.get("v.latestContactDate");

		var paragraphText = "The email has been successfully sent to " + component.get("v.clientSurname") + " at " + component.get("v.clientEmail");

		//var action = component.get("c.clientEmailNotification");
		var action = component.get("c.clientSendEmail");
		action.setParams({
			clientAVAFInformation: emailTemplateParamMapString,
			clientContactStatus: component.get("v.clientContactStatus"),
			clientEmail: component.get("v.clientEmail"),
			caseAccountId: component.get("v.CaseAccountId"),
			caseId: component.get("v.caseId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.fireToast("Success!", "Email sent successfully", "success");
				component.set("v.headerTextFromFlow", "Email sent successfully");
				component.set("v.paragraphTextFromFlow", paragraphText);
				var navigate = component.get("v.navigateFlow");
				navigate("NEXT");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	}
});