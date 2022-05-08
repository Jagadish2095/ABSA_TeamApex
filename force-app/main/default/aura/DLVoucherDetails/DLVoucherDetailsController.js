({
	doInit: function (component, event, helper) {
		//Set Columns
		component.set("v.columns", [
			{ label: "Voucher Name", fieldName: "voucherDescription", type: "text" },
			{ label: "Amount", fieldName: "voucherPaymentAmount", type: "text" },
			{ label: "Date of purchase", fieldName: "dateCreated", type: "text" },
			{ label: "Voucher Expiry - 3 years", fieldName: "voucherExpiryDate", type: "text" },
			{ label: "Order Number", fieldName: "paymentReference", type: "text" },
			{ label: "Purchase Status", fieldName: "transactionStatus", type: "text" },
			{ label: "Account", fieldName: "sourceAccountNumber", type: "text" }
		]);
		//Get Voucher Details and Exception Report
		helper.getVoucherDetailsAndExceptionReport(component, event, helper);
	},

	storeSelectedRows: function (component, event, helper) {
		component.set("v.selectedVouchers", JSON.stringify(event.getParam("selectedRows")));
	},

	attachVouchersNavigateNext: function (component, event, helper) {
		if ($A.util.isEmpty(component.get("v.selectedVouchers")) || component.get("v.selectedVouchers") == "[]") {
			helper.fireToast("Error!", "Please select at least 1 Voucher to attach to this Case", "error");
		} else {
			helper.attachVouchers(component, event, helper);
		}
	}
});