({
	doInit: function (component, event, helper) {
		helper.showSpinner(component);
		helper.fetchServiceProvidersData(component);
	},

	handleCaseLoad: function (component, event, helper) {
		component.set("v.caseNumber", component.find("caseNumberField").get("v.value"));
		component.set("v.cifCode", component.find("cifField").get("v.value"));
		helper.fetchMobileBeneficiaries(component);
	},

	handleServiceProviderChange: function (component, event, helper) {
		var selectedValue = event.getSource().get("v.value");
		component.set("v.serviceProvider", selectedValue);

		if (selectedValue != "") {
			component.find("fRechargeType").set("v.disabled", false);
			helper.populateRechargeTypeValues(component, selectedValue);
		} else {
			component.find("fRechargeType").set("v.disabled", true);
			component.find("fRechargeAmount").set("v.disabled", true);
		}
	},

	handleRechargeTypeChange: function (component, event, helper) {
		var selectedValue = event.getSource().get("v.value");
		if (selectedValue != "") {
			component.find("fRechargeAmount").set("v.disabled", false);
			helper.populateRechargeAmountValues(component, selectedValue);
		} else {
			component.find("fRechargeAmount").set("v.disabled", true);
		}
	},

	handleRechargeAmountChange: function (component, event, helper) {
		var selectedValue = event.getSource().get("v.value");
		var selectedValueSplit = selectedValue.split(";");
		var voucherAmount;

		if (selectedValueSplit[1] == "Own amount") {
			component.set("v.isOwnAmount", true);
		} else {
			component.set("v.isOwnAmount", false);
			voucherAmount = selectedValueSplit[1];
		}

		component.set("v.serviceProviderID", selectedValueSplit[0]);
		component.set("v.purchaseAmount", voucherAmount);
	},

	handleSubmit: function (component, event, helper) {
		helper.validateRechargeValues(component);
	},

	confirmSubmission: function (component, event, helper) {
		helper.showSpinner(component);
		helper.submitRechargeValues(component);
	},

	cancelSubmission: function (component, event, helper) {
		component.set("v.showConfirmSubmission", false);
		helper.hideSpinner(component);
	},

	handleSaveBeneficiary: function (component, event, helper) {
		helper.validateBeneficiaryDetails(component);
		var allowBeneficiarySave = component.get("v.allowBeneficiarySave");
		if (allowBeneficiarySave) {
			helper.showSpinner(component);
			helper.createMobileBeneficiaries(component);
		}
	},

	handleShowBeneficiaries: function (component, event, helper) {
		var beneficiaryListColumns = [
			{ label: "IVR Number", fieldName: "ivrPaymentNo", type: "text" },
			{ label: "Name", fieldName: "description", type: "Text" },
			{ label: "Cellphone Number", fieldName: "cellNo", type: "text" },
			{ label: "Service Provider", fieldName: "cellProvider", type: "text" }
		];

		helper.fetchMobileBeneficiaries(component);
		component.set("v.beneficiaryListColumns", beneficiaryListColumns);
		component.set("v.showBeneficiariesResults", true);
	},

	handleBeneficiarySelection: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var description = selectedRows[0].description;
		var cellNo = selectedRows[0].cellNo;
		var cellProvider = selectedRows[0].cellProvider;

		component.set("v.recipientName", description);
		component.set("v.cellphoneNumber", cellNo);
		component.set("v.serviceProvider", cellProvider);
		component.set("v.showSaveAsBeneficiary", false);
		component.set("v.saveAsBeneficiary", false);
		component.find("fRechargeType").set("v.disabled", false);
		component.find("btnSubmit").set("v.disabled", false);
		helper.populateRechargeTypeValues(component, cellProvider);
	},

	deselectBeneficiaryRow: function (component, event, helper) {
		var beneficiaryDataTable = component.find("beneficiaryDataTable");
		beneficiaryDataTable.set("v.selectedRows", []);
		component.set("v.rechargeTypeOptions", []);
		component.set("v.rechargeAmountOptions", []);
		component.set("v.serviceProviderID", "");
		component.set("v.recipientName", "");
		component.set("v.cellphoneNumber", "");
		component.set("v.serviceProvider", "");
		component.set("v.rechargeType", "");
		component.set("v.rechargeAmountDetail", "");
		component.set("v.ownAmount", "");
		component.set("v.purchaseAmount", "");
		component.set("v.rechargeAmountDetail", "");
		component.set("v.isOwnAmount", false);
		component.set("v.showSaveAsBeneficiary", true);
		component.find("fRechargeType").set("v.disabled", true);
		component.find("fRechargeAmount").set("v.disabled", true);
	},

	toggleSaveAsBeneficiary: function (component, event, helper) {
		var recipientName = component.get("v.recipientName");
		var benDescription = component.get("v.benDescription");
		var saveAsBeneficiary = component.get("v.saveAsBeneficiary");

		if (!benDescription) {
			component.set("v.benDescription", recipientName);
		}

		if (saveAsBeneficiary) {
			component.find("btnSubmit").set("v.disabled", true);
		} else {
			component.find("btnSubmit").set("v.disabled", false);
			component.set("v.benDescription", "");
		}
	}
});