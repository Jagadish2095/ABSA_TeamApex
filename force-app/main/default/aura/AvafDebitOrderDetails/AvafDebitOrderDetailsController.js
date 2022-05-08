({
	//D BOOYSEN 2020-11-19
	doInit: function (component, event, helper) {
		helper.showSpinner(component);

		//Set Columns
		component.set("v.columns", [
			{ label: "Debit Order Type", fieldName: "ZDEBIT_ORDER", type: "text" },
			{ label: "Collection Start Date", fieldName: "ZCOLSTARTDATE", type: "text" },
			{ label: "Collection End Date", fieldName: "ZCOLENDDATE", type: "text" },
			{ label: "Amount to Collect", fieldName: "ZCOLAMOUNT", type: "text" },
			{ label: "Day of Collection", fieldName: "ZCOLDAY", type: "text" },
			{ label: "Status", fieldName: "ZSTATUS", type: "text" },
			{ label: "Bank ID", fieldName: "ZCOLBANKID", type: "text" },
			{ label: "Bank Account Number", fieldName: "ZBANKACC", type: "text" }
		]);

		var debitOrderDetailsResp = component.get("v.avafGetDebitOrderResponse");
		if ($A.util.isEmpty(debitOrderDetailsResp)) {
			//Integration Service Call to get debit order details
			helper.getAvafDebitOrderDetails(component, event, helper);
		} else {
			//AvafGetDebitOrderDetails response set passed in, just need to set the data attribute
			var debitOrderDetailsObj = JSON.parse(debitOrderDetailsResp);
			if (
				debitOrderDetailsObj &&
				debitOrderDetailsObj.statusCode == 200 &&
				debitOrderDetailsObj.E_RESPONSE == "{0}" &&
				debitOrderDetailsObj.BAPI_SF_DO_DETAILS
			) {
				component.set("v.data", debitOrderDetailsObj.BAPI_SF_DO_DETAILS);
			} else {
				//Service Error
				component.set("v.errorMessage", "AvafGetDebitOrderDetails Service Error. Service Response: " + JSON.stringify(debitOrderDetailsResp));
				helper.hideSpinner(component);
			}
		}

		var avafGetBankDetailsResp = component.get("v.avafGetBankDetailsResponse");
		if ($A.util.isEmpty(avafGetBankDetailsResp)) {
			if ($A.util.isEmpty(component.get("v.partnerNumber"))) {
				//Integration Service Calls to get the partner number and banking details
				helper.getAvafPartnerDetails(component, event, helper);
			} else {
				//Integration Service Call to get the banking details
				helper.getPartnerBankingDetails(component, event, helper);
			}
		} else {
			//AvafGetBankDetails response passed in, just need to build the bankID picklist
			var avafGetBankDetailsObj = JSON.parse(avafGetBankDetailsResp);
			if (
				avafGetBankDetailsObj &&
				avafGetBankDetailsObj.statusCode == 200 &&
				avafGetBankDetailsObj.BAPI_BUPA_BANKDETAILS_GET &&
				avafGetBankDetailsObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS &&
				avafGetBankDetailsObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS.length > 0
			) {
				//Build the picklist for the bank Id from the AvafGetBankDetails service response
				helper.buildBankIdPicklist(component, event, helper, avafGetBankDetailsObj.BAPI_BUPA_BANKDETAILS_GET.BANKDETAILS);
			} else {
				//Service Error
				component.set("v.errorMessage", "No Banking Details found. AvafGetBankDetails Service response: " + avafGetBankDetailsResp);
				helper.hideSpinner(component);
			}
		}
	},

	//Handle Action
	handleRowSelection: function (component, event, helper) {
		var selectedRow = event.getParam("selectedRows")[0];
		//Disabling Once Off/Type 4 debit order selection. DBOOYSEN W-012245 Defect Fix
		if (selectedRow.ZDEBIT_ORDER == "Once Off") {
			helper.fireToast("Attention!", "Unable to change Once Off debit order details", "info");
			component.find("debitOrderDetailsDatatable").set("v.selectedRows", []);
		} else {
			//If Once Off/Type 4 debit order details are enabled, remove if statement checking for "Once Off" above. DBOOYSEN W-012245 Defect Fix
			component.set("v.selectedDebitOrderRow", selectedRow);
			component.set("v.selectedBankDetailIdValue", selectedRow.ZCOLBANKID + "-" + selectedRow.ZBANKACC);
			if (selectedRow.ZDEBIT_ORDER == "Recurring") {
				component.set("v.isModalReadOnly", true);
			}
			helper.openModalHelper(component);
		}
	},

	//Closing Case
	handleCloseCase: function (component, event, helper) {
		component.set("v.isCloseCase", true);
		console.log("cc isSendEmail: " + component.get("v.isSendEmail"));
		console.log("cc isCloseCase: " + component.get("v.isCloseCase"));
		if (component.get("v.isSendEmail")) {
			//Use the flow navigation to go to the CloseCaseScreen component if isSendEmail is true
			helper.navigateNextHelper(component);
		} else {
			helper.showSpinner(component);
			component.find("statusField").set("v.value", "Closed");
			//Submit to Close Case
			component.find("caseCloseEditForm").submit();
		}
	},

	//Navigate Next
	navigateNext: function (component, event, helper) {
		helper.navigateNextHelper(component);
	},

	//Success - Case
	handleSuccess: function (component, event, helper) {
		if (component.get("v.isCloseCase")) {
			component.set("v.isFormReadOnly", true);
			component.find("debitOrderDetailsDatatable").set("v.hideCheckboxColumn", true);
			helper.hideSpinner(component);
			helper.fireToast("Success!", "Case successfully closed. ", "success");
		}
	},

	//On load - Case
	handleLoad: function (component, event, helper) {
		//Append the Avaf Account Number
		var caseSubject = component.find("subjectField").get("v.value");
		var avafAccount = component.get("v.selectedAvafAccFromFlow");
		if (!caseSubject.includes(avafAccount)) {
			console.log("setting case subject");
			component.find("subjectField").set("v.value", caseSubject + " - " + avafAccount);
			component.find("caseCloseEditForm").submit();
		}
	},

	//Error - Case
	handleError: function (component, event, helper) {
		helper.hideSpinner(component);
		helper.fireToast("Error!", "There has been an error closing the case. ", "error");
		component.set("v.errorMessage", "There has been an error closing the case: " + JSON.stringify(event.getParams()));
	},

	//handle Save action from Modal to update the debit order
	handleDebitOrderChange: function (component, event, helper) {
		helper.updateDebitOrderDetails(component, event, helper);
		component.set("v.modalErrorMessage", null);
		console.log("handleDebitOrderChange: " + component.get("v.selectedBankDetailIdValue"));
	},

	//Open Modal
	openModal: function (component, event, helper) {
		helper.openModalHelper(component);
	},

	//Close Modal
	closeModal: function (component, event, helper) {
		helper.closeModalHelper(component);
	}
});