({
	doInit: function (cmp, event, helper) {
		helper.showSpinner(cmp);
		cmp.set("v.mycolumns", [
			{
				label: "ServiceProvider",
				fieldName: "serviceProvider",
				type: "text",
				typeAttributes: { required: true }
			},
			{
				label: "Reference Account Number",
				fieldName: "refAccountNumber",
				type: "text",
				typeAttributes: { required: true }
			},
			{
				label: "Due Date",
				fieldName: "dueDate",
				type: "date",
				typeAttributes: { required: true }
			},
			{
				label: "Frequency",
				fieldName: "frequency",
				type: "text",
				typeAttributes: { required: true }
			},
			{
				label: "Amount",
				fieldName: "amount",
				type: "currency",
				typeAttributes: { currencyCode: "ZAR" },
				typeAttributes: { required: true }
			},
			{
				label: "Fixed or Variable",
				fieldName: "fixvar",
				type: "text",
				typeAttributes: { required: true }
			},
			{
				type: "button-icon",
				fixedWidth: 40,
				typeAttributes: {
					iconName: "utility:edit",
					name: "edit_record",
					title: "Edit",
					variant: "border-filled",
					alternativeText: "edit",
					disabled: false
				}
			},
			{
				type: "button-icon",
				fixedWidth: 40,
				typeAttributes: {
					iconName: "utility:delete",
					name: "delete_record",
					title: "Delete",
					variant: "border-filled",
					alternativeText: "delete",
					disabled: false
				}
			}
		]);

		cmp.set("v.debitOrders", []);
		var promise = helper.getFinancialInstitutionsPicklist(cmp).then(
			$A.getCallback(function (result) {
				helper.fetchSwitches(cmp).then(
					$A.getCallback(function (result) {
						helper.hideSpinner(cmp);
					}),
					$A.getCallback(function (error) {
						helper.hideSpinner(cmp);
					})
				);
			}),
			$A.getCallback(function (error) {
				helper.hideSpinner(cmp);
			})
		);
	},
	toggleSwitching: function (cmp, event, helper) {
		var isSwitching = cmp.get("v.isSwitching");
		if (!isSwitching) {
			cmp.set("v.showSwitchingOptions", false);
			cmp.set("v.isSalarySwitching", false);
			cmp.set("v.isDebitOrderSwitching", false);
		} else {
			cmp.set("v.showSwitchingOptions", true);
		}
	},
	navigate: function (cmp, event, helper) {
		var page = event.getSource().get("v.name");
		var label = event.getSource().get("v.label");
		helper.handleNavigation(cmp, page, "next", label);
	},
	navigateBack: function (cmp, event, helper) {
		var page = event.getSource().get("v.name");
		var label = event.getSource().get("v.label");
		helper.handleNavigation(cmp, page, "back", label);
	},
	navigatePause: function (cmp, event, helper) {
		var page = event.getSource().get("v.name");
		var label = event.getSource().get("v.label");
		helper.handleNavigation(cmp, page, "pause", label);
	},
	getSelectedName: function (cmp, event) {
		var selectedRows = event.getParam("selectedRows");
		// Display that fieldName of the selected rows
		for (var i = 0; i < selectedRows.length; i++) {
			//alert("You selected: " + selectedRows[i].serviceProvider);
		}
	},
	addRow: function (cmp, event, helper) {
		var g = helper.createGuid(cmp);
		cmp.set("v.selectedDebitOrder", {
			id: g,
			serviceProvider: "",
			refAccountNumber: "",
			dueDate: "",
			frequency: "",
			amount: 0,
			fixvar: "",
			action: "add"
		});
		cmp.set("v.isOpen", true);
		cmp.set("v.Heading", "Add");
		cmp.set("v.isSaved", false);
	},
	handleRowAction: function (cmp, event, helper) {
		var action = event.getParam("action");
		var row = event.getParam("row");

		switch (action.name) {
			case "view_details":
				break;
			case "delete_record":
				helper.removeDebitOrder(cmp, row);
				break;
			case "edit_record":
				row.action = "edit";
				cmp.set("v.selectedDebitOrder", row);
				cmp.set("v.Heading", "Edit");
				cmp.set("v.isOpen", true);
				break;
			default:
				break;
		}
	},
	editAccountInfo: function (cmp, event, helper) {
		var institutionLookup = cmp.find("serviceProvider");
		var institutionName = institutionLookup.get("v.institutionName");
		var fixvar = cmp.find("fixvar");
		var fixvarValue = fixvar.get("v.value");
		var frequency = cmp.find("frequency");
		var frequencyValue = frequency.get("v.value");
		var amount = cmp.find("amount");
		var amountValue = amount.get("v.value");

		var allValid = cmp.find("field").reduce(function (validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get("v.validity").valid;
		}, true);

		if (institutionName == null || institutionName == "") {
			institutionLookup.validate();
			allValid = false;
		}

		if (fixvarValue == null || fixvarValue == "") {
			fixvar.showHelpMessageIfInvalid();
			allValid = false;
		}

		if (frequencyValue == null || frequencyValue == "") {
			frequency.showHelpMessageIfInvalid();
			allValid = false;
		}

		if (amountValue == null || amountValue == "" || amountValue == 0) {
			$A.util.addClass(amount, "slds-has-error");
			amount.setCustomValidity("Amount is required.");
			amount.reportValidity();
			allValid = false;
		} else {
			$A.util.removeClass(amount, "slds-has-error");
			amount.setCustomValidity("");
			amount.reportValidity();
		}

		if (allValid) {
			var debitOrders = cmp.get("v.debitOrders");
			var debitorder = cmp.get("v.selectedDebitOrder");
			debitorder.fixvar = fixvarValue;
			debitorder.frequency = frequencyValue;

			switch (debitorder.action) {
				case "edit":
					var data = cmp.get("v.debitOrders");
					data = data.map(function (rowData) {
						if (rowData.id === debitorder.id) {
							rowData.serviceProvider = institutionName;
						}
						return rowData;
					});
					cmp.set("v.debitOrders", data);
					cmp.set("v.isOpen", false);
					break;
				case "add":
					debitOrders.push({
						id: debitorder.id,
						serviceProvider: institutionName,
						refAccountNumber: debitorder.refAccountNumber,
						dueDate: debitorder.dueDate,
						frequency: debitorder.frequency,
						amount: debitorder.amount,
						fixvar: debitorder.fixvar,
						action: "edit"
					});
					cmp.set("v.debitOrders", debitOrders);
					cmp.set("v.isOpen", false);
					cmp.set("v.isSaved", true);
					break;
				default:
					break;
			}
		} else {
			cmp.set("v.isOpen", true);
		}
	},
	cancelAccountInfo: function (cmp, event, helper) {
		cmp.set("v.isOpen", false);
	}
});