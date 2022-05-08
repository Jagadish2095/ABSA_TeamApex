({
	//Handle Init event
	doInit: function (component, event) {
		var declineReasonOptions = [];
		var approvalReasonOptions = [];

		declineReasonOptions.push({
			class: "optionClass",
			label: "--None--",
			value: "--None--"
		});

		declineReasonOptions.push({
			class: "optionClass",
			label: "Does not qualify",
			value: "Does not qualify"
		});
		declineReasonOptions.push({
			class: "optionClass",
			label: "Already showing as redeemed for the month",
			value: "Already showing as redeemed for the month"
		});

		declineReasonOptions.push({
			class: "optionClass",
			label: "Voucher is still valid",
			value: "Voucher is still valid"
		});
		declineReasonOptions.push({
			class: "optionClass",
			label: "Customer not found on any of the lists",
			value: "Customer not found on any of the lists"
		});
		declineReasonOptions.push({
			class: "optionClass",
			label: "Voucher is still valid",
			value: "Voucher is still valid"
		});

		declineReasonOptions.push({
			class: "optionClass",
			label: "--None--",
			value: "--None--"
		});

		//approvalReasonOptions
		approvalReasonOptions.push({
			class: "optionClass",
			label: "--None--",
			value: "--None--"
		});

		approvalReasonOptions.push({
			class: "optionClass",
			label: "Invalid Vouchers",
			value: "Invalid Vouchers"
		});
		approvalReasonOptions.push({
			class: "optionClass",
			label: "Incomplete Vouchers (Digits Missing)",
			value: "Incomplete Vouchers (Digits Missing)"
		});

		approvalReasonOptions.push({
			class: "optionClass",
			label: "GOGW (Complaint)",
			value: "GOGW (Complaint)"
		});
		approvalReasonOptions.push({
			class: "optionClass",
			label: "Client not able to redeem since inception",
			value: "Client not able to redeem since inception"
		});
		approvalReasonOptions.push({
			class: "optionClass",
			label: "Duplicate voucher numbers issued from vendors",
			value: "Duplicate voucher numbers issued from vendors"
		});
		approvalReasonOptions.push({
			class: "optionClass",
			label: "Unable to redeem but met criteria",
			value: "Unable to redeem but met criteria"
		});

		component.set("v.columnList", [
			{ label: "Reward Type", fieldName: "Reward_Type__c", type: "text" },
			{ label: "Voucher Pin", fieldName: "Voucher_Pin__c", type: "text" },
			{ label: "Amount", fieldName: "Amount__c", type: "text" },
			{ label: "Challenge Id", fieldName: "Name", type: "text" }
		]);

		component.set("v.declineReasonOptions", declineReasonOptions);
		component.set("v.approvalReasonOptions", approvalReasonOptions);
	},

	setEscalatedFormView: function (component, event, helper) {
		var escalatedFromFlow = component.get("v.escalatedFromFlow");
		if (escalatedFromFlow) {
			var reissueVoucherField = component.get("v.cse.Reissue_Voucher__c");
			var approvalStatus = component.get("v.cse.Approval_Status__c");
			if (reissueVoucherField) {
				component.set("v.approvedDeclinedValue", reissueVoucherField);
			}

			if (approvalStatus != "Approved") {
				component.set("v.disableReissueRequest", true);
			}
		}
	},

	CloseCaseHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var reissueVoucherField = component.find("reissueVoucherField").get("v.value");
		var action = component.get("c.closeCaseApex");
		action.setParams({
			caseIdP: component.get("v.caseIdFromFlow"),
			reissueVoucherFieldValue: reissueVoucherField
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.fireToast("Success!", "Case successfully closed. ", "success");
			
			} else if (state === "ERROR") {
			
				var message = "AbsaRewardsCloseOrEscalateCTRL.closeCase: There was an error while closing the case: "+ JSON.stringify(response.getError());
				helper.fireToast("Error", message, "error");
				component.set( "v.errorMessage", message);
			} else {
				var message = "AbsaRewardsCloseOrEscalateCTRL.closeCase: There was an unknown error while closing the case: "+ state;
				helper.fireToast("Error", message, "error");
				component.set( "v.errorMessage", message);
			}
		});
		$A.enqueueAction(action);
		helper.hideSpinner(component);
	
	},

	transferCase: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.transferCase");
		action.setParams({
			serviceGroupName: $A.get("$Label.c.Digital_Lifestyle_Rewards_Team_Call_Centre"),
			serviceTypeName: component.find("typeField").get("v.value"),
			caseId: component.get("v.caseIdFromFlow")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.fireToast("Success!", "Case Escalated to Rewards Team Call Centre queue. ", "success");
				var caseServiceType = component.find("typeField").get("v.value");
				this.sendEmailHelper(component, event);
			} else if (state === "ERROR") {
			
				var message = "AbsaRewardsCloseOrEscalateCTRL.transferCase: There was an error while escalating and transferring the Case: "+ JSON.stringify(response.getError());
				helper.fireToast("Error", message, "error");
				component.set( "v.errorMessage", message);
			} else {
				var message = "AbsaRewardsCloseOrEscalateCTRL.transferCase: There was an unknown error while escalating and transferring the Case: "+ state;
				helper.fireToast("Error", message, "error");
				component.set( "v.errorMessage", message);
			}
		});
		$A.enqueueAction(action);
		helper.hideSpinner(component);
	},

	//send and email
	sendEmailHelper: function (component, event) {
		var action = component.get("c.sendEmail");
		action.setParams({
			caseId: component.get("v.caseIdFromFlow"),
			emailAddress: $A.get("$Label.c.TLCEscalationEmailAddress"),
			emailTemplateName: $A.get("$Label.c.DL_Escalate_to_Stellr_Email_Template"),
			caseComments: component.find("caseComments").get("v.value")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.includes("Error")) {
					component.set(
						"v.errorMessage",
						"AbsaRewardsCloseOrEscalateCTRL.sendEmail: " + "An Error Occurred while attempting to send an email: " + resp
					);
				} else {
					//Success
					component.set("v.isFormReadOnly", true);
					this.hideSpinner(component);
					this.fireToast("Success!", resp + " to TLC", "success");
					component.set("v.escalatedFromFlow", true);
					$A.get('e.force:refreshView').fire();
				}
			} else if (state === "ERROR") {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.sendEmail: " + JSON.stringify(response.getError()));
			} else {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.sendEmail, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	/**
	 * @author Simangaliso Mathenjwa
	 * @description gets voucher attached to the case
	 * @param  component
	 * @param  event
	 */
	getVoucher: function (component, event, helper) {
		var action = component.get("c.getAttachedVoucher");
		action.setParams({
			caseId: component.get("v.caseIdFromFlow")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				if (resp.includes("Error")) {
					component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.getAttachedVoucher: " + resp);
				} else {
					//Success
					component.set("v.isFormReadOnly", true);
					helper.hideSpinner(component);
					component.set("v.data", resp);
				}
			} else if (state === "ERROR") {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.getAttachedVoucher: " + JSON.stringify(response.getError()));
			} else {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.getAttachedVoucher, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	getTxnReferenceHelper: function (component, event) {
		this.showSpinner(component);
		var action = component.get("c.getAvailableVouchers");

		//Pass a black txntxnReference to get a for subsequent txnReference calls
		action.setParams({
			txnReference: ""
		});

		//callback
		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					if (respObj.header.statuscode == "590") {
						component.set("v.txnReference", respObj.txnReference);
						this.pollForAvailableVouchersHelper(component, event, respObj.txnReference);
					} else {
						//deal with unsuccessful response
						if (respObj.header.statuscode == "1") {
							var message = "There was an error while getting txnReference for polling: " + respObj.header.resultMessages;
							this.fireToast("Error", message, "error");
						} else {
							var message = "There was an unknown error while getting txnReference for polling";
							this.fireToast("Error", message, "error");
						}
					}
				} else {
					//Fire Error Toast
					this.fireToast("Error", "Error while calling GetAvailableVouchers for txnReference: " + respObj.statusCode, "error");
					component.set(
						"v.errorMessage",
						"Apex error AbsaRewardsCloseOrEscalateCTRL.getAvailableVouchers: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AbsaRewardsCloseOrEscalateCTRL.getAvailableVouchers: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
		this.hideSpinner(component);
	},

	/**
	 * @author simangaliso Mathenjwa
	 * @description Get Available vouchers
	 * @param  component
	 * @param  event
	 * @param  txnReference
	 */
	pollForAvailableVouchersHelper: function (component, event, txnReference) {
		this.showSpinner(component);
		var action = component.get("c.getAvailableVouchers");

		//Pass a black txntxnReference to get a for subsequent txnReference calls
		action.setParams({
			txnReference: txnReference
		});

		//callback
		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					var AvailableVouchersList = [];
					//OfflineCode
					if (respObj.header.statuscode == "0") {
						component.set("v.AvailableVouchersList", respObj.voucherPartners);

						for (var i = 0; i < respObj.voucherPartners.length; i++) {
							for (var j = 0; j < respObj.voucherPartners[i].partnerOffers.length; j++) {
								respObj.voucherPartners[i].partnerOffers[j]["partnerId"] = respObj.voucherPartners[i].partnerId;
								AvailableVouchersList.push(respObj.voucherPartners[i].partnerOffers[j]);
							}
						}

						component.set("v.AvailableVouchersList", AvailableVouchersList);
						if (AvailableVouchersList.length > 0) {
							this.checkSelectedVoucherAvailability(component, event);
						}
					} else {
						//deal with unsuccessful response
						if (respObj.header.statuscode == "1") {
							var message = "There was an error while getting available vouchers: " + respObj.header.resultMessages;
							this.fireToast("Error", message, "error");
							component.set("v.errorMessage", message);
						} else {
							var message = "There was an unknown error while getting available vouchers:";
							this.fireToast("Error", message, "error");
							component.set("v.errorMessage", message);
						}
					}
				} else {
					//Fire Error Toast
					this.fireToast("Error", "Error while calling GetAvailableVouchers: " + respObj.statusCode, "error");
					component.set(
						"v.errorMessage",
						"Apex error AbsaRewardsCloseOrEscalateCTRL.getAvailableVouchers: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AbsaRewardsCloseOrEscalateCTRL.getAvailableVouchers: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
		this.hideSpinner(component);
	},

	checkSelectedVoucherAvailability: function (component, event) {
		var availableVouchersList = component.get("v.AvailableVouchersList");
		var attachedVoucher = component.get("v.data");
		for (var i = 0; i < availableVouchersList.length; i++) {
			if (
				availableVouchersList[i].partnerId == attachedVoucher[0].Voucher_Type_Selected__c &&
				availableVouchersList[i].offerDescription.substring(1, 3) == attachedVoucher[0].Amount__c
			) {
				component.set("v.showVoucherOutOfStockRadio", false);
				component.set("v.selectedVoucher", availableVouchersList[i]);
				break;
			}
		}
	},

	getReissueTxnReference: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getAvailableVouchers");

		var selectedVoucher = component.get("v.selectedVoucher");
		var attachedVoucher = component.get("v.data");
		var selectedVoucherMap = new Map();
		selectedVoucherMap["txnReference"] = "";
		selectedVoucherMap["cifKey"] = component.get("v.cifKey");
		selectedVoucherMap["idNumber"] = component.get("v.idNumberFromFlow");
		selectedVoucherMap["cifKey"] = component.get("v.cifFromFlow");
		selectedVoucherMap["partnerId"] = selectedVoucher.partnerId;
		selectedVoucherMap["offerTier"] = selectedVoucher.offerTier;
		selectedVoucherMap["offerId"] = selectedVoucher.offerId;
		selectedVoucherMap["oldRewardPinVoucher"] = attachedVoucher[0].Voucher_Pin__c;
		selectedVoucherMap["challengeId"] = attachedVoucher[0].Name;
		var action = component.get("c.reissueVoucherApex");

		action.setParams({
			requestFieldsMap: selectedVoucherMap
		});

		//callback
		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					if (respObj.header.statuscode == "590") {
						component.set("v.txnReference", respObj.txnReference);
						if(component.get("v.schedule")){
							helper.scheduleVoucherHelper(component, event, helper);
						}else{
							helper.sendVoucherHelper(component, event, helper, respObj.txnReference);

						}
						
					} else {
						//deal with unsuccessful response
						if (respObj.header.statuscode == "1") {
							var message = "There was an error while getting txnReference for voucher reissue: " + JSON.stringify(respObj.header.resultMessages);
							component.set("v.errorMessage", message);
							this.fireToast("Error", message, "error");
						} else {
							var message =
								"There was an unknown error while getting txnReference for  voucher reissue " + JSON.stringify(respObj.header.resultMessages);
							this.fireToast("Error", message, "error");
							component.set("v.errorMessage", message);
						}
					}
				} else {
					//Fire Error Toast
					this.fireToast("Error", "Error while calling ReIssueVoucher for txnReference: " + respObj.statusCode, "error");
					component.set(
						"v.errorMessage",
						"Apex error AbsaRewardsCloseOrEscalateCTRL.reissueVoucherApex: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AbsaRewardsCloseOrEscalateCTRL.reissueVoucherApex: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
		this.hideSpinner(component);
	},

	sendVoucherHelper: function (component, event, helper, txnReference) {
		helper.showSpinner(component);
		helper.fireToast("Success", "Voucher Reissue Request Successful", "success");
		helper.hideSpinner(component);

		var selectedVoucher = component.get("v.selectedVoucher");
		var attachedVoucher = component.get("v.data");
		var selectedVoucherMap = new Map();
		selectedVoucherMap["txnReference"] = txnReference;
		selectedVoucherMap["cifKey"] = component.get("v.cifKey");
		selectedVoucherMap["idNumber"] = component.get("v.idNumberFromFlow");
		selectedVoucherMap["cifKey"] = component.get("v.cifFromFlow");
		selectedVoucherMap["partnerId"] = selectedVoucher.partnerId;
		selectedVoucherMap["offerTier"] = selectedVoucher.offerTier;
		selectedVoucherMap["offerId"] = selectedVoucher.offerId;
		selectedVoucherMap["oldRewardPinVoucher"] = attachedVoucher[0].Voucher_Pin__c;
		selectedVoucherMap["challengeId"] = attachedVoucher[0].Name;

		var action = component.get("c.reissueVoucherApex");

		action.setParams({
			requestFieldsMap: selectedVoucherMap
		});

		//callback
		action.setCallback(this, function (response) {
			var respObj = response.getReturnValue();
			var state = response.getState();
			if (state == "SUCCESS") {
				if (respObj.statusCode == 200) {
					var AvailableVouchersList = [];
					//OfflineCode
					if (respObj.header.statuscode == "0") {
						helper.fireToast("Success", "Voucher Reissue Request Successful", "success");
					} else {
						//deal with unsuccessful response
						if (respObj.header.statuscode == "1") {
							var message = "There was an error while attempting reissue request: " + JSON.stringify(respObj.header.resultMessages);
							this.fireToast("Error", message, "error");
							component.set("v.errorMessage", message);
						} else {
							var message = "There was an unknown error while while attempting reissue request:";
							this.fireToast("Error", message, "error");
							component.set("v.errorMessage", message);
						}
					}
				} else {
					//Fire Error Toast
					this.fireToast("Error", "Error while calling ReIssueVoucher: " + respObj.statusCode, "error");
					component.set(
						"v.errorMessage",
						"Apex error AbsaRewardsCloseOrEscalateCTRL.reissueVoucherApex: " +
							"Status: " +
							JSON.stringify(respObj.statusCode) +
							" : " +
							JSON.stringify(respObj.message)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AbsaRewardsCloseOrEscalateCTRL.reissueVoucherApex: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	scheduleVoucherHelper: function (component, event, helper) {
		helper.showSpinner(component);
		helper.fireToast("Success", "Voucher Reissue Request Schedule Successful, please check after 2 hours", "success");
		helper.hideSpinner(component);

		helper.showSpinner(component);
		helper.fireToast("Success", "Voucher Reissue Request Successful", "success");
		helper.hideSpinner(component);

		var selectedVoucher = component.get("v.selectedVoucher");
		var attachedVoucher = component.get("v.data");
		var selectedVoucherMap = new Map();
		selectedVoucherMap["txnReference"] = component.get("v.txnReference");
		selectedVoucherMap["cifKey"] = component.get("v.cifKey");
		selectedVoucherMap["idNumber"] = component.get("v.idNumberFromFlow");
		selectedVoucherMap["cifKey"] = component.get("v.cifFromFlow");
		selectedVoucherMap["partnerId"] = selectedVoucher.partnerId;
		selectedVoucherMap["offerTier"] = selectedVoucher.offerTier;
		selectedVoucherMap["offerId"] = selectedVoucher.offerId;
		selectedVoucherMap["oldRewardPinVoucher"] = attachedVoucher[0].Voucher_Pin__c;
		selectedVoucherMap["challengeId"] = attachedVoucher[0].Name;
		var action = component.get("c.scheduleVoucherReissueApex");
		action.setParams({
			requestFieldsMap: selectedVoucherMap
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();

				if (resp.includes("Error")) {
					component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.scheduleVoucherReissueApex: " + resp);
				} else {
					//Success
					helper.hideSpinner(component);

					helper.fireToast("Success", "Voucher Reissue Request Schedule Successful, please check after 2 hours", "success");
				}
			} else if (state === "ERROR") {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.scheduleVoucherReissueApex: " + JSON.stringify(response.getError()));
			} else {
				component.set("v.errorMessage", "AbsaRewardsCloseOrEscalateCTRL.scheduleVoucherReissueApex, state returned: " + state);
			}
		});
		$A.enqueueAction(action);
		helper.hideSpinner(component);
	},
	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	//Lightning toast
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