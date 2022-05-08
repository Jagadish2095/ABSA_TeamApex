({
	/**DBOOYSEN 2021-03-25
	 * Function called to get the historical beneficiary payments made by the client
	 * for a selected beneficiary
	 */
	fetchPaymentHistory: function (component, event, helper) {
		helper.showSpinner(component);

		var selectedBeneficiary = component.get("v.selectedBeneficiary");
		var action = component.get("c.BeneficiaryTransactionHistory");
		action.setParams({
			uniqueEft: selectedBeneficiary.uniqueEFT
		});
		action.setCallback(this, function (response) {
			var dataSet = response.getReturnValue();
			var state = response.getState();
			if (state === "SUCCESS") {
				if (
					dataSet &&
					dataSet.MBgetPaymentDetailV3Response &&
					dataSet.MBgetPaymentDetailV3Response.mbp323o &&
					dataSet.MBgetPaymentDetailV3Response.mbp323o.respDesc == "SUCCESSFUL PROCESS" &&
					dataSet.MBgetPaymentDetailV3Response.mbp323o.payment &&
					dataSet.MBgetPaymentDetailV3Response.mbp323o.payment.length > 0
				) {
					var paymentResp = dataSet.MBgetPaymentDetailV3Response.mbp323o.payment;
					var paymentRespValidPayments = [];
					for (var key in paymentResp) {
						//Filter out blank payments received in the response
						if (paymentResp[key].trgAcc != null && paymentResp[key].srcAcc != null) {
							var paymentDate = paymentResp[key].actDate;
							paymentResp[key].actDate = paymentDate.substring(0, 4) + "-" + paymentDate.substring(4, 6) + "-" + paymentDate.substring(6, 8);
							paymentRespValidPayments.push(paymentResp[key]);
						}
					}
					component.set("v.data", paymentRespValidPayments);
					component.set("v.filteredData", paymentRespValidPayments);
				} else {
					//Fire Error Toast
					helper.fireToast(
						"Error",
						"Error no payments found for selected beneficiary: " +
							selectedBeneficiary.instrRefName +
							". UniqueEFT: " +
							selectedBeneficiary.uniqueEFT,
						"error"
					);
				}
			} else {
				console.log("Failed with state fetchPaymentHistory: " + state);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Show spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Fire lightning toastie
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
	},

	//Open Modal (sendBeneficiaryPaymentHistoryModal)
	openModalHelper: function (component, event, helper) {
		component.set("v.showModal", true);
		$A.util.addClass(component.find("sendBeneficiaryPaymentHistoryModal"), "slds-fade-in-open");
		$A.util.addClass(component.find("Modalbackdrop"), "slds-backdrop--open");
	},

	//Close Modal (sendBeneficiaryPaymentHistoryModal)
	closeModalHelper: function (component, event, helper) {
		component.set("v.showModal", false);
		$A.util.removeClass(component.find("Modalbackdrop"), "slds-backdrop--open");
		$A.util.removeClass(component.find("sendBeneficiaryPaymentHistoryModal"), "slds-fade-in-open");
	},

	/**DBOOYSEN 2021-04-09
	 * Function called to generate and send the historical beneficiary payments made by the client to the client
	 * for a selected beneficiary
	 */
	sendBeneficiaryPaymentsHelper: function (component, event, helper) {
		component.set("v.isModalSpinner", true);

		var beneficiaryPaymentList = JSON.stringify(component.get("v.filteredData"));
		console.log("beneficiaryPaymentList: " + beneficiaryPaymentList + ". caseAccountIdFromFlow: " + component.get("v.caseAccountIdFromFlow"));
		var action = component.get("c.getBenPaymentHistoryData");
		action.setParams({
			beneficiaryPaymentList: beneficiaryPaymentList,
			beneficiaryName: component.get("v.selectedBeneficiary").instrRefName,
			beneficiaryAcc: component.get("v.selectedBeneficiary").targetAccount,
			documentTemplateName: "Beneficiary Payment History List",
			accountId: component.get("v.caseAccountIdFromFlow")
		});
		action.setCallback(this, function (response) {
			var dataSet = response.getReturnValue();
			console.log("sendBeneficiaryPaymentsHelper resp: " + dataSet);
			var state = response.getState();
			if (state === "SUCCESS") {
				if (!$A.util.isEmpty(dataSet) && !dataSet.startsWith("Error:")) {
					helper.fireToast("Success", "Beneficiary Payment List Generated Successfully", "success");
					//Add send email functionality
					component.set("v.isFormReadOnly", true);
					helper.sendEmailHelper(
						component,
						event,
						helper,
						dataSet,
						component.get("v.clientEmailAddress"),
						"Proof of Payments",
						"Historical_Proof_of_Payments"
					);
				} else {
					component.set("v.errorMessageModal", "Apex Error BeneficiaryPaymentHistoryApex.getBenPaymentHistoryData: " + dataSet);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessageModal", "Apex error BeneficiaryPaymentHistoryApex.getBenPaymentHistoryData: " + JSON.stringify(errors));
			} else {
				helper.fireToast("Error", "Unexpected error occurred, BeneficiaryPaymentHistoryApex.sendBeneficiaryPayments state returned: " + state, "error");
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	},

	//function that send an email from apex
	sendEmailHelper: function (component, event, helper, attachment, emailTo, documentName, emailTemplate) {
		component.set("v.isModalSpinner", true);

		var action = component.get("c.sendBeneficiaryPayments");
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
					component.set("v.isFormReadOnly", false);
					component.set("v.errorMessageModal", resp);
					helper.fireToast("Error!", resp, "error");
				} else {
					//Success
					helper.fireToast("Success!", resp, "success");
					helper.closeModalHelper(component, event, helper);
                    //DBOOYSEN. W-008306
                    //Create the charge log by calling aura method from child component "ChargeTransaction"
                    var emailAddressCount = emailTo.split(",").length;
                    var chargeComponent = component.find("chargeTransactionCmp");
                    chargeComponent.createChargeLog("TC008");//Payment History Inquiry
                    for(var i = 0; i < emailAddressCount; i++){
                        chargeComponent.createChargeLog("TC009");//Email
                    }
					//Close Case on success of email sent
					component.find("caseStatusFieldModal").set("v.value", "Closed");
					component.find("caseEditFormModal").submit();
				}
			} else if (state === "ERROR") {
				component.set("v.isFormReadOnly", false);
				var errors = response.getError();
				component.set("v.errorMessageModal", "Apex error BeneficiaryPaymentHistoryApex.sendBeneficiaryPayments: " + JSON.stringify(errors));
			} else {
				component.set("v.isFormReadOnly", false);
				helper.fireToast("Error", "Unexpected error occurred, BeneficiaryPaymentHistoryApex.sendBeneficiaryPayments state returned: " + state, "error");
			}
			component.set("v.isModalSpinner", false);
		});
		$A.enqueueAction(action);
	}
});