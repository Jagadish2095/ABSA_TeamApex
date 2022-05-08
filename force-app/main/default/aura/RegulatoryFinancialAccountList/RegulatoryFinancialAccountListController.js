({
	//Initiation of component
	init: function (component, event, helper) {
		var objectNameVal = component.get("v.sObjectName");
		console.log("objectNameVal : " + objectNameVal);

		if (objectNameVal == "Opportunity") {
			var actions = [{ label: "Edit Product", name: "edit_product" }];

			component.set("v.columnNames", [
				{ label: "Product Type", fieldName: "Product_Type__c", type: "text", editable: false },
				{ label: "Account Number", fieldName: "Account_Number__c", type: "numer", editable: false },
				{ label: "Purpose of Account", fieldName: "Purpose_of_Account_Text__c", type: "text", editable: false, wrapText: true },
				{ label: "Source of Funds", fieldName: "Source_of_Funds__c", type: "text", editable: false, wrapText: true },
				{ label: "Account Activity Calculator", fieldName: "Account_Activity_Calculator__c", type: "text", editable: false, wrapText: true },
				{ type: "action", typeAttributes: { rowActions: actions } }
			]);
		} else {
			component.set("v.columnNames", [
				{ label: "Product Type", fieldName: "Product_Type__c", type: "text", editable: false },
				{ label: "Account Number", fieldName: "Account_Number__c", type: "numer", editable: false },
				{ label: "Status", fieldName: "Status__c", type: "text", editable: false, wrapText: true },
				{ label: "Date Closed", fieldName: "Date_Closed__c", type: "text", editable: false, wrapText: true },
				{ label: "Available Balance", fieldName: "Available_Balance__c", type: "text", editable: false, wrapText: true }
			]);
		}

		//Get Client Hold Record Types with Status
		helper.searchHelper(component, event);
	},

	handleRowAction: function (component, event, helper) {
		var action = event.getParam("action");
		switch (action.name) {
			case "edit_product":
				var row = event.getParam("row");
				component.set("v.productEditRecId", row.Id);
				component.set("v.showEditProductModal", true);
				break;
		}
	},

	editProductRecord: function (component, event, helper) {
		var editForm = component.find("editProductForm");
		editForm.submit();

		var toast = helper.getToast("Success", "Product details updated.", "success");
		toast.fire();
		component.set("v.showEditProductModal", false);

		//Get Client Hold Record Types with Status
		helper.searchHelper(component, event);
	},

	closeEditProductModal: function (component, event, helper) {
		component.set("v.showEditProductModal", false);
	},

	handleOnLoad: function (component, event, helper) {
		var actions = [{ label: "Edit Product", name: "edit_product" }];

		component.set("v.columnNames", [
			{ label: "Product Type", fieldName: "Product_Type__c", type: "text", editable: false },
			{ label: "Account Number", fieldName: "Account_Number__c", type: "numer", editable: false },
			{ label: "Purpose of Account", fieldName: "Purpose_of_Account__c", type: "text", editable: false },
			{ label: "Source of Funds", fieldName: "Source_of_Funds__c", type: "text", editable: false },
			{ label: "Account Activity Calculator", fieldName: "Account_Activity_Calculator__c", type: "text", editable: false, wrapText: true },
			{ type: "action", typeAttributes: { rowActions: actions } }
		]);

		//Get Client Hold Record Types with Status
		helper.searchHelper(component, event);
	},
	//Show Modal for Account Activity Calculator
	openAccountActivity: function (component, event, helper) {
		component.set("v.showAccCalculator", true);
	},
	//Close Account Activity Model
	closeAccActivty: function (component, event, helper) {
		component.set("v.showAccCalculator", false);
	},
	generateAccActivty: function (component, event, helper) {
		var var3 = component.find("creditsReceivedVia").get("v.value");
		var var4 = component.find("whereWilltheCreditCome").get("v.value");
		var var9 = component.find("wheretheSuppLocated").get("v.value");
		var var11 = component.find("reasonForDebit").get("v.value");

		var actCalculator = "";
		var isProductAvail = component.get("v.isProductAvail");
		if (isProductAvail) {
			actCalculator =
				"IT IS EXPECTED THAT THERE WILL BE " +
				var1 +
				" number of CREDITS INTO THE ACCOUNT EACH MONTH to the value of " +
				var2 +
				". THE CREDITS WILL BE RECEIVED VIA " +
				var3 +
				" AND WILL COME FROM " +
				var4 +
				".";
		} else {
			actCalculator =
				"IT IS EXPECTED THAT THERE WILL BE CREDITS INTO THE ACCOUNT EACH MONTH.THE CREDITS WILL BE RECEIVED VIA " +
				var3 +
				" AND WILL COME FROM " +
				var4 +
				". IN TERMS OF DEBITS, THERE WILL BE FOR THE FOLLOWING REASONS " +
				var11 +
				". PAYMENTS OUT OF THE ACCOUNT TO SUPPLIERS / SERVICE PROVIDERS IN " +
				var9 +
				".";
		}

		var editForm = component.find("showAccCalcu");
		editForm.submit();

		component.find("accountActivityCalcField").set("v.value", actCalculator);
		component.set("v.showAccCalculator", false);
	},

	//Added by diksha for W-5029
	showPurposeOfAcctText: function (component, event, helper) {
		var purposeOfAcc = component.find("purposeOfAcc").get("v.value");
		console.log(purposeOfAcc);
		if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - INDIVIDUAL ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE INDIVIDUAL AFFAIRS");
		} else if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - PRIMARY BUSINESS ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "THIS ACCOUNT IS GOING TO BE USED FOR THE DAY TO DAY RUNNING OF THE CLIENTS BUSINESS.");
		} else if (purposeOfAcc == "CURRENT / CHEQUE / SAVINGS - SECONDARY BUSINESS ACCOUNT") {
			component.find("purposeOfAcctText").set("v.value", "CURRENT / CHEQUE / SAVINGS - SECONDARY BUSINESS A");
		} else if (purposeOfAcc == "INVESTMENT") {
			component
				.find("purposeOfAcctText")
				.set("v.value", "THIS ACCOUNT IS GOING TO BE USED TO HOUSE SURPLICE FUNDS THE CLIENT MIGHT HAVE FROM TIME TO TIME.");
		} else if (purposeOfAcc == "VANILLA LENDING - CARD, CAF ETC") {
			component.find("purposeOfAcctText").set("v.value", "APPARENT FROM ACCOUNT TYPE AS PER THE METHODOLOGY PAGES 294 TO 296");
		}
	}
});