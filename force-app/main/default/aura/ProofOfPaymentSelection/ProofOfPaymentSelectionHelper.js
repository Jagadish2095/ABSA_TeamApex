({
	//function to call apex to generate a document
	//calls sendEmailHelper to send the email with the generated document from in this function on success
	generateProofOfPaymentHelper: function (component, event, helper, docTemplateName) {
		helper.showSpinner(component);
		var selectedOOPFromFlow = component.get("v.selectedOOPFromFlow");
		var selectedBenPaymentFromFlow = component.get("v.selectedBenPaymentFromFlow");
		var action;
		if (!$A.util.isEmpty(selectedOOPFromFlow)) {
			action = component.get("c.generateHistoricalOOP");
			action.setParams({
				selectedPaymentString: selectedOOPFromFlow,
				documentTemplateName: docTemplateName,
				accountId: component.get("v.accountIdFromFlow")
			});
		} else if (!$A.util.isEmpty(selectedBenPaymentFromFlow)) {
			action = component.get("c.generateHistoricalBenPayment");
			action.setParams({
				selectedPaymentString: selectedBenPaymentFromFlow,
				recipientName: component.get("v.selectedBenNameFromFlow"),
				uniqueEft: component.get("v.selectedBenEftFromFlow"),
				documentTemplateName: docTemplateName,
				accountId: component.get("v.accountIdFromFlow")
			});
		} else {
			//Proof of Payment for a regular payment made using MBinitiatePaymentV10 service
			action = component.get("c.generateProofOfPayment");
			action.setParams({
				MBinitiatePaymentResp: component.get("v.mbInitiateRespFromFlow"),
				uiInputProofOfPayment: component.get("v.uiFieldsForProofOfPaymentFromFlow"),
				documentTemplateName: docTemplateName,
				accountId: component.get("v.accountIdFromFlow")
			});
		}

		action.setCallback(this, function (response) {
			var resp = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (!$A.util.isEmpty(resp) && !resp.startsWith("Error:")) {
					//success
					if (docTemplateName == $A.get("$Label.c.Proof_of_Payment_Owner")) {
						component.set("v.clientAttachment", resp);
						helper.sendEmailHelper(
							component,
							event,
							helper,
							component.get("v.clientAttachment"),
							component.get("v.clientEmailAddress"),
							docTemplateName,
							$A.get("$Label.c.ProofOfPaymentClientRequest")
						);
					} else if (docTemplateName == $A.get("$Label.c.Proof_of_Payment_Beneficiary")) {
						component.set("v.beneficiaryAttachment", resp);
						helper.sendEmailHelper(
							component,
							event,
							helper,
							component.get("v.beneficiaryAttachment"),
							component.get("v.beneficiaryEmailAddress"),
							docTemplateName,
							$A.get("$Label.c.ProofOfPaymentBeneficiaryRequest")
						);
					}
				} else {
					component.set("v.errorMessage", "Apex Error ProofOfPaymentSelController.generateProofOfPayment: " + resp);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex Error ProofOfPaymentSelController.generateProofOfPayment: " + JSON.stringify(errors));
			} else {
				//Fire State Error Toast
				helper.fireToast("Error", "Unexpected error occurred, ProofOfPaymentSelController.generateProofOfPayment state returned: " + state, "error");
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//function that send an email from apex
	sendEmailHelper: function (component, event, helper, attachment, emailTo, documentName, emailTemplate) {
		helper.showSpinner(component);
		var action = component.get("c.sendEmailWithAttach");
		action.setParams({
			caseId: component.get("v.caseIdFromFlow"),
			emailAddress: emailTo,
			emailTemplateName: emailTemplate,
			pdfData: attachment,
			docName: documentName
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.startsWith("Error:")) {
					component.set("v.errorMessage", resp);
					helper.fireToast("Error!", resp, "error");
				} else {
					//Success
					helper.fireToast("Success!", resp, "success");
					component.set("v.isFormReadOnly", true);
					//DBOOYSEN. W-008306
					//Create the charge log by calling aura method from child component "ChargeTransaction"
					var emailAddressCount = emailTo.split(",").length;
					var chargeComponent = component.find("chargeTransactionCmp");
					for (var i = 0; i < emailAddressCount; i++) {
						chargeComponent.createChargeLog("TC009"); //Email
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error ProofOfPaymentSelController.sendEmailWithAttach: " + JSON.stringify(errors));
			} else {
				helper.fireToast("Error", "Unexpected error occurred, ProofOfPaymentSelController.sendEmailWithAttach state returned: " + state, "error");
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//function that performs validation specific to the payer and calling the generateProofOfPaymentHelper
	//to generate the Proof of Payment document for the payer
	configClientPopHelper: function (component, event, helper) {
		var clientEmailAddressVal = component.find("clientEmailAddressField").get("v.value");
		if ($A.util.isEmpty(clientEmailAddressVal)) {
			helper.fireToast("Error!", "Payer Email Address Is Required", "error");
			component.find("clientEmailAddressField").showHelpMessageIfInvalid();
		} else {
			if (component.find("clientEmailAddressField").checkValidity() == true) {
				component.set("v.clientEmailAddress", clientEmailAddressVal);
				helper.generateProofOfPaymentHelper(component, event, helper, $A.get("$Label.c.Proof_of_Payment_Owner"));
			} else {
				helper.fireToast("Error!", "Payer Email Address Is Not Valid", "error");
			}
		}
	},

	//function that performs validation specific to the beneficiary and calling the generateProofOfPaymentHelper
	//to generate the Proof of Payment document for the beneficiary
	configBeneficiaryPopHelper: function (component, event, helper) {
		var beneficiaryEmailAddressVal = component.find("beneficiaryEmailAddressField").get("v.value");
		if ($A.util.isEmpty(beneficiaryEmailAddressVal)) {
			helper.fireToast("Error!", "Beneficiary Email Address Is Required", "error");
			component.find("beneficiaryEmailAddressField").showHelpMessageIfInvalid();
		} else {
			if (component.find("beneficiaryEmailAddressField").checkValidity() == true) {
				component.set("v.beneficiaryEmailAddress", beneficiaryEmailAddressVal);
				helper.generateProofOfPaymentHelper(component, event, helper, $A.get("$Label.c.Proof_of_Payment_Beneficiary"));
			} else {
				helper.fireToast("Error!", "Beneficiary Email Address Is Not Valid", "error");
			}
		}
	},

	showSpinner: function (component) {
		component.set("v.showSpinner", true);
	},

	hideSpinner: function (component) {
		component.set("v.showSpinner", false);
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