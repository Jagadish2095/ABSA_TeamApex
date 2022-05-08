({
	//Danie Booysen - 2020/11/19
	//Debit Order Details - get details from apex controller
	getAvafDebitOrderDetails: function (component, event, helper) {
		var action = component.get("c.DebitOrderDetails");
		action.setParams({
			avafAccount: component.get("v.selectedAvafAccFromFlow")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respBean = response.getReturnValue();
				component.set("v.avafGetDebitOrderResponse", JSON.stringify(respBean));
				if (respBean && respBean.statusCode == 200 && respBean.BAPI_SF_DO_DETAILS) {
					//Successful Status Code
					if (respBean.E_RESPONSE == "{0}") {
						//Succuss
						component.set("v.data", respBean.BAPI_SF_DO_DETAILS);
					} else {
						//Error Status Code
						component.set("v.errorMessage", "Service Response: " + respBean.E_RESPONSE_DESC);
					}
				} else {
					//Error Status Code
					component.set("v.errorMessage", "AvafGetDebitOrderDetails Service Error. Service Response: " + JSON.stringify(respBean));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AvafDebitOrderDetailsController.DebitOrderDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.DebitOrderDetails state returned: " + state);
			}
			if (!$A.util.isEmpty(component.get("v.errorMessage"))) {
				helper.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	//Danie Booysen - 2020/11/19
	//Partner Details - get details from apex controller
	getAvafPartnerDetails: function (component, event, helper) {
		var action = component.get("c.PartnerDetails");
		action.setParams({
			avafAccount: component.get("v.selectedAvafAccFromFlow")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respBean = response.getReturnValue();
				if (respBean && respBean.statusCode == 200 && respBean.BAPI_SF_PARTNER_GET && respBean.BAPI_SF_PARTNER_GET.length > 0) {
					//Successful Status Code
					if (respBean.BAPI_SF_PARTNER_GET[0].E_RESPONSE == "0") {
						//Succuss
						component.set("v.partnerNumber", respBean.BAPI_SF_PARTNER_GET[0].E_SOLD_TO);
						helper.getPartnerBankingDetails(component, event, helper);
					} else {
						//Error Status Code
						component.set("v.errorMessage", "Service Response: " + respBean.BAPI_SF_PARTNER_GET[0].E_RESPONSE_DESC);
					}
				} else {
					//Error Status Code
					component.set("v.errorMessage", "AvafGetPartner Service Error. Service Response: " + JSON.stringify(respBean));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AvafDebitOrderDetailsController.PartnerDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.PartnerDetails state returned: " + state);
			}
			if (!$A.util.isEmpty(component.get("v.errorMessage"))) {
				helper.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	//JQUEV 2020/11/19
	//Get Partner Banking Details
	getPartnerBankingDetails: function (component, event, helper) {
		var action = component.get("c.getPartnerBankingDetails");
		action.setParams({
			businessPartnerNumber: component.get("v.partnerNumber")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var resp = response.getReturnValue();
				component.set("v.avafGetBankDetailsResponse", JSON.stringify(resp));
				if (
					resp &&
					resp.statusCode == 200 &&
					resp.BAPI_BUPA_BANKDETAILS_GET &&
					resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS &&
					resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS.length > 0
				) {
					//Success
					helper.buildBankIdPicklist(component, event, helper, resp.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS);
				} else {
					//Service Error
					component.set(
						"v.errorMessage",
						"No Banking Details found for Partner Number: " +
							component.get("v.partnerNumber") +
							"AvafGetBankDetails Service response: " +
							JSON.stringify(resp)
					);
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error AvafDebitOrderDetailsController.getPartnerBankingDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, AvafDebitOrderDetailsController.getPartnerBankingDetails state returned: " + state);
			}
			if (!$A.util.isEmpty(component.get("v.errorMessage"))) {
				helper.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	//Danie Booysen - 2020/11/24
	//Update Debit Order Details - Update the banking details of a debit order
	updateDebitOrderDetails: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.UpdateDebitOrderDetails");
		var bankDetailIdAccount = component.find("bankDetailIdField").get("v.value").split("-");
		action.setParams({
			avafAccount: component.get("v.selectedAvafAccFromFlow"),
			debitOrder: component.get("v.selectedDebitOrderRow.ZDEBIT_ORDER"),
			collectionDay: component.get("v.selectedDebitOrderRow.ZCOLDAY"),
			collectionStartDate: component.get("v.selectedDebitOrderRow.ZCOLSTARTDATE"),
			collectionEndDate: component.get("v.selectedDebitOrderRow.ZCOLENDDATE"),
			collectionAmount: component.get("v.selectedDebitOrderRow.ZCOLAMOUNT"),
			collectionBankId: bankDetailIdAccount[0],
			bankAccount: bankDetailIdAccount[1]
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respBean = response.getReturnValue();
				if (respBean && respBean.statusCode == 200 && respBean.BAPI_SF_DO_CHG && respBean.BAPI_SF_DO_CHG.length > 0) {
					if (respBean.BAPI_SF_DO_CHG[0].E_RESPONSE == 0) {
						//Success
						helper.fireToast("Success!", "Debit Order Change Successfully Requested: . " + respBean.BAPI_SF_DO_CHG[0].E_RESPONSE_DESC, "success");
						component.set("v.isSendEmail", true);
						component.set("v.modalErrorMessage", null);
						helper.closeModalHelper(component);
					} else {
						//Error when updating the debit order
						component.set(
							"v.modalErrorMessage",
							"Unable to change the current debit order. Using AvafChangeDebitOrder Service. Response: " +
								respBean.BAPI_SF_DO_CHG[0].E_RESPONSE_DESC
						);
					}
				} else {
					//Error Status Code
					component.set("v.modalErrorMessage", "AvafChangeDebitOrder Service Error. Service Response: " + JSON.stringify(respBean));
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.modalErrorMessage", "Apex error AvafDebitOrderDetailsController.updateDebitOrderDetails: " + JSON.stringify(errors));
			} else {
				component.set(
					"v.modalErrorMessage",
					"Unexpected error occurred, AvafDebitOrderDetailsController.updateDebitOrderDetails state returned: " + state
				);
			}
			helper.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Danie Booysen - 2020/11/24
	//Function to build the picklist for the bank Id from the AvafGetBankDetails service response
	buildBankIdPicklist: function (component, event, helper, bankDetailIdResponseList) {
		var opts = [];
		bankDetailIdResponseList.forEach(function (record) {
			opts.push({
				class: "optionClass",
				label: record.BANKDETAILID + " - " + record.BANK_ACCT,
				value: record.BANKDETAILID + "-" + record.BANK_ACCT
			});
		});
		component.set("v.bankDetailIdList", opts);
		helper.hideSpinner(component);
	},

	//Open Debit Order Details Modal
	openModalHelper: function (component) {
		$A.util.addClass(component.find("changeDebitOrderDetailsModal"), "slds-fade-in-open");
		$A.util.addClass(component.find("Modalbackdrop"), "slds-backdrop--open");
	},

	//Close Debit Order Details Modal and set selectedDataTable row to null
	closeModalHelper: function (component) {
		$A.util.removeClass(component.find("Modalbackdrop"), "slds-backdrop--open");
		$A.util.removeClass(component.find("changeDebitOrderDetailsModal"), "slds-fade-in-open");
		component.find("debitOrderDetailsDatatable").set("v.selectedRows", []);
		component.set("v.selectedDebitOrderRow", null);
	},

	//Navigate to next screen element
	navigateNextHelper: function (component) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
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