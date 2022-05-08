({
	doInit: function (component, event, helper) {
		if ($A.util.isEmpty(component.get("v.accountCIFFromFlow"))) {
			component.set("v.errorMessage", "The selected Account does not have a CIF Code. ");
		} else {
			helper.showSpinner(component);
			//Set Columns for Attached Vouchers
			component.set("v.columns", [
				{ label: "Card Number", fieldName: "cardNbr", type: "text" },
				{ label: "Card Holder", fieldName: "persName", type: "text" },
				{ label: "Card Status", fieldName: "cardStatus", type: "text" },
				{ label: "Envelope Number", fieldName: "regNbr", type: "text" },
				{ label: "Distribution Reason", fieldName: "reason", type: "text" },
				{ label: "Distribution Channel and Site", fieldName: "deliveryType", type: "text" },
				{ label: "Issue Type", fieldName: "issueType", type: "text" }
			]);
			//Call CCListCardSummaryTrackingInfo Service
			helper.getCardDeliveryDetailsHelper(component, event, helper);
		}
	},

	handleRowSelection: function (component, event, helper) {
		component.set("v.displayNextBtn", true);
		var selectedRows = event.getParam("selectedRows");
		//Set Attributes to send back to Flow
		component.set("v.deliveryAddressLine1", selectedRows[0].delAddress1);
		component.set("v.deliveryAddressLine2", selectedRows[0].delAddress2);
		component.set("v.deliveryAddressLine3", selectedRows[0].delAddress3);
		component.set("v.deliveryAddressLine4", selectedRows[0].delAddress4);
		component.set("v.postalCode", selectedRows[0].postalCode);
		component.set("v.personName", selectedRows[0].persName);
		component.set("v.regNumber", selectedRows[0].regNbr);
		component.set("v.iDNumber", selectedRows[0].idNbr);
		component.set("v.contactNumber", selectedRows[0].contactNumber);
		component.set("v.issueType", selectedRows[0].issueType);
		component.set("v.cardNumber", selectedRows[0].cardNbr);
		//Set Attributes to display data
		component.set("v.cardStatus", selectedRows[0].cardStatus);
		component.set("v.distributionReason", selectedRows[0].reason);
		component.set("v.deliveryType", selectedRows[0].deliveryType);
	},

	navigateNext: function (component, event, helper) {
		var navigate = component.get("v.navigateFlow");
		navigate("NEXT");
	}
});