({
	init: function (component, event, helper) {
		var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		component.set("v.today", today);

		component.set("v.columns", [
			{ label: "Restrictions ID", fieldName: "Restriction_ID__c", type: "text" },
			{ label: "Description", fieldName: "Description__c", type: "text" },
			{ label: "Start Date", fieldName: "EffectiveStartDate__c", type: "date" },
			{ label: "End Date", fieldName: "EffectiveEndDate__c", editable: true, type: "date" },
			{ label: "Status", fieldName: "Status__c", type: "text" },
			{
				type: "button",
				typeAttributes: {
					iconName: "utility:delete",
					label: "Delete",
					name: "deleteRecord",
					title: "deleteTitle",
					disabled: false,
					value: "test"
				}
			}
		]);

		component.set("v.accountsColumns", [{ label: "Account Number", fieldName: "accountNumber", type: "text" }]);

		component.set("v.transactionTypesColumns", [
			{ label: "Transaction Types", fieldName: "Type", type: "text" },
			{ label: "Description", fieldName: "Description", type: "text" },
			{ label: "Start Date", fieldName: "StartDate", type: "Date" },
			{ label: "Stop Date", fieldName: "StopDate", type: "Date" }
		]);

		component.set("v.dateExpireTableColumns", [
			{ label: "Name", fieldName: "Name", type: "text" },
			{ label: "Type", fieldName: "Type", type: "text" },
			{ label: "Description", fieldName: "Description__c", type: "text" },
			{ label: "Start Date", fieldName: "EffectiveStartDate__c", type: "Date" },
			{ label: "End Date", fieldName: "EffectiveEndDate__c", type: "Date" },
			{ label: "State", fieldName: "Status__c", type: "text" }
		]);

		component.set("v.deleteNodesColumns", [
			{ label: "Name", fieldName: "Name", type: "text" },
			{ label: "Type", fieldName: "Type", type: "text" },
			{ label: "Description", fieldName: "Description__c", type: "text" },
			{ label: "Start Date", fieldName: "EffectiveStartDate__c", type: "Date" },
			{ label: "End Date", fieldName: "EffectiveEndDate__c", type: "Date" },
			{ label: "State", fieldName: "Status__c", type: "text" }
		]);

		helper.getGroupRestrictions(component);
		component.set("v.dateAdjustTableColumns", [
			{ label: "Name", fieldName: "Name", type: "text" },
			{ label: "Type", fieldName: "Type", type: "text" },
			{ label: "Description", fieldName: "Description__c", type: "text" },
			{ label: "Start Date", fieldName: "EffectiveStartDate__c", type: "Date" },
			{ label: "End Date", fieldName: "EffectiveEndDate__c", type: "Date" },
			{ label: "State", fieldName: "Status__c", type: "text" }
		]);

		var selectedTTcolumn = [
			{
				label: "Type",
				fieldName: "ObjectID",
				_children: [
					{
						ObjectID: "ObjectID"
					}
				]
			},
			{
				label: "Type Description",
				fieldName: "Description"
			},
			{
				label: "Stop Date",
				fieldName: "EffectiveEndDate"
			},
			{
				label: "Start Date",
				fieldName: "EffectiveStartDate"
			}
			/* {
                label: 'Is Effective EndDate Infinity',
                fieldName: 'IsEffectiveEndDateInfinity'
            } */
		];

		component.set("v.selectedTransactionTypeColumns", selectedTTcolumn);
	},

	newRestriction: function (component, event, helper) {
		component.set("v.creatNewRestrictionAccount", true);
		component.set("v.restrictionId", "");
		component.set("v.Description", "");
	},

	selectedItem: function (component, event, helper) {},

	selectedItemValue: function (component, event, helper) {
		var startDate = component.find("muvhusoTest").get("v.value");
		console.log("Start Date --->" + startDate);

		/*
    	var restrictionData = component.get("v.restrictionData");
        console.log('Length -->' + restrictionData.length);
        var ctarget = event.currentTarget.dataset;
        var id_str = ctarget.value;
        
        console.log('Value ' + id_str);
        var startDateId = 'startDate' + id_str; 
        console.log('ID ----> ' + startDateId);
        var startDate = component.find("0").get("v.value");
        console.log('Start Date --->' + startDate);
        helper.GetSelectedGroupRestriction(component , id_str);
        */
	},

	CreateNewRestrictionGroup: function (component, event, helper) {
		//component.set("v.creatNewRestrictionAccount",true);
	},
	SaveNewRestrictionGroup: function (component, event, helper) {
		var groupId = component.get("v.restrictionId");

		if (groupId.length <= 11) {
			component.set("v.creatNewRestrictionAccount", false);
			helper.CreateGroupRestrictionObject(component);
			helper.getGroupRestrictions(component);
		} else {
			var toast = helper.getToast("error", "Group Id should contain 11 characters", "error");
			toast.fire();
		}
	},
	updateSelectedText: function (cmp, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		if (selectedRows != "") {
			cmp.set("v.restrictionId", selectedRows[0].Restriction_ID__c);
			console.log("Hi" + JSON.stringify(selectedRows[0]));
			cmp.set("v.selectedRowDetailToShow", selectedRows[0]);
			cmp.set("v.selectedRowsCount", selectedRows.length);
			console.log("Hi Muvhuso" + selectedRows[0].Id);
		}
		helper.getGroupAccounts(cmp);
		helper.getExcludedAccounts(cmp);
		helper.getTTRecords(cmp);
		helper.getCustomerDetails(cmp);
	},
	updateRestriction: function (component, event, helper) {
		//var rowSelected = component.get("v.selectedRowDetailToShow");
		//console.log('Description '+ rowSelected.Description__c);
		helper.UpdateGroupRestrictions(component);
		helper.getGroupRestrictions(component);
	},
	cancel: function (component, event, helper) {
		console.log("Cancel clicked");
		component.set("v.creatNewRestrictionAccount", false);
		component.set("v.HideNodes", false);
	},
	close: function (component, event, helper) {
		console.log("Close clicked");
		component.set("v.creatNewRestrictionAccount", false);
		component.set("v.HideNodes", false);
	},
	cancelAccount: function (component, event, helper) {
		console.log("Cancel clicked");
		component.set("v.createAccount", false);
	},

	closeAccount: function (component, event, helper) {
		console.log("Close clicked");
		component.set("v.createAccount", false);
	},
	AddAccount: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.createAccount", true);
		component.set("v.isUpdate", false);

		const date = new Date();
		date.setDate(date.getDate() + 7);

		var month = "" + (date.getMonth() + 1),
			day = "" + date.getDate(),
			year = date.getFullYear();

		if (month.length < 2) month = "0" + month;
		if (day.length < 2) day = "0" + day;

		console.log("Today's date " + year + "/" + month + "/" + day);

		component.set("v.accountNumber", "");
		component.set("v.AccountDescription", "");
		component.set("v.accountEffectiveStartDate", year + "-" + month + "-" + day);
		component.set("v.accountEffectiveEndDate", "");
	},
	SaveAccount: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		var accountList = component.get("v.responseList");
		var accountNumber = component.get("v.accountNumber");
		var count = 0;
		for (var i = 0; i < accountList.length; i++) {
			if (accountList[i].accountNumber == accountNumber) {
				count++;
				var originalDate = component.get("v.OriginalEffectiveStartDate");
				console.log("Original Effective Date Test --", originalDate);
				var isEdit = component.get("v.Edit");
				console.log("Muvhuso Test " + isEdit);
				var accountId = component.get("v.restrictionAccountId");
				console.log("Account Id " + accountId);
				if (isEdit === true) {
					var count = helper.formValidations(component, false);
					if (count == 0) {
						helper.updateAccountRestriction(component, accountId, originalDate);
						component.set("v.createAccount", false);
					}
				} else {
					var count = helper.formValidations(component, false);
					if (count == 0) {
						helper.CreateRestrictionAccount(component);
						component.set("v.createAccount", false);
					}
					//var selectedRows = component.get("v.selectedRowsAccount");
					//helper.CreateRestrictionAccounts(component , selectedRows);
				}
				break;
			}
		}

		if (count == 0) {
			var toast = helper.getToast("Error", "Account Number not found in the CIF!!!", "Error");
			toast.fire();
		}
	},

	handleClickUpdate: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.isInfinity", false);
		component.set("v.isUpdate", false);
		component.set("v.Edit", true);
		var groupAccountId = event.getSource().get("v.value");
		console.log("Account ID ---> " + groupAccountId);
		component.set("v.restrictionAccountId", groupAccountId);
		component.set("v.createAccount", true);

		var groupAccounts = component.get("v.accounts");

		for (var key = 0; key < groupAccounts.length; key++) {
			if (groupAccounts[key].Id == groupAccountId) {
				component.set("v.accountNumber", groupAccounts[key].AccountNumber__c);
				component.set("v.AccountDescription", groupAccounts[key].Description__c);
				component.set("v.accountEffectiveStartDate", groupAccounts[key].EffectiveStartDate__c);
				component.set("v.accountEffectiveEndDate", groupAccounts[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", groupAccounts[key].EffectiveStartDate__c);
			}
		}
		//helper.updateAccountRestriction(component , groupAccountId);
		console.log("Original Effective Date --", component.get("v.restrictionAccountId"));
	},

	handleClickRemove: function (component, event, helper) {
		component.set("v.isRemoveAccountOpen", true);
		var groupAccountId = event.getSource().get("v.value");
		component.set("v.restrictionAccountId", groupAccountId);
	},

	closeRemoveAccount: function (component, event, helper) {
		component.set("v.isRemoveAccountOpen", false);
		component.set("v.isRemoveExcludedAccountOpen", false);
	},
	actionRemoveAccount: function (component, event, helper) {
		var accountId = component.get("v.restrictionAccountId");
		helper.deleteRestrictionAccount(component, accountId);
		component.set("v.isRemoveAccountOpen", false);
	},

	checkboxSelect: function (component, event, helper) {
		console.log("Hi Muvhuso");
		var checkBoxValue = component.find("checkbox").get("v.checked");
		component.set("v.isInfinity", true);
		//console.log('Check box --> ' + isInfinity);

		if (checkBoxValue) {
			component.set("v.accountEffectiveEndDate", "4000-12-31");
			component.set("v.transactioTypeEffectiveEndDate", "4000-12-31");
			component.set("v.updateTransTypeEndDate", "4000-12-31");
		} else {
			component.set("v.accountEffectiveEndDate", "");
			component.set("v.transactioTypeEffectiveEndDate", "");
			component.set("v.updateTransTypeEndDate", "");
			component.set("v.isInfinity", false);
		}
	},
	openTransactionType: function (component, event, helper) {
		//alert('Inside openTT controller');
		// Set isTransactionTypeOpen attribute to true
		component.set("v.isTransactionTypeOpen", true);
		//alert('After Popup called');

		var column = [
			{
				label: "Type",
				fieldName: "ObjectID",
				_children: [
					{
						ObjectID: "ObjectID"
					}
				]
			},
			{
				label: "Type Description",
				fieldName: "Description"
			}
			/*{
                        label: 'End Date',
                        fieldName: 'EffectiveEndDate'
                    },
                    {
                        label: 'Start Date',
                        fieldName: 'EffectiveStartDate'
                    },
                    {
                        label: 'Is Effective EndDate Infinity',
                        fieldName: 'IsEffectiveEndDateInfinity'
                    } */
		];
		// alert('Before setting the columns');
		component.set("v.transactionTypeColumns", column);
		// alert('After setting the columns');
		component.set("v.isTTDate", false);
		//alert('Before start date');
		component.set("v.transactionTypeEffectiveStartDate", helper.effictiveStartDate(component));
		// alert('After start date');
		//component.set("v.transactionTypeEffectiveStartDate" , year + '/' + month + '/' + day);
		component.set("v.transactioTypeEffectiveEndDate", "");
		// alert('After end date');

		//var date = new Date();
		//date.setDate(date.getDate() + 7);
		//component.set('transactionTypeEffectiveStartDate',date);
		helper.getTransactionTypeUI(component, helper);
		//helper.getInsertedTransactionTypes(component,helper);
		// alert('After HMS helper');
	},

	closeTransactionType: function (component, event, helper) {
		// Set isTransactionTypeOpen attribute to false
		component.set("v.isTransactionTypeOpen", false);
		component.set("v.isTransactionTypeUpdate", false);
		component.set("v.isTTUpdateDate", false);
		component.set("v.isTransactionTypeDelete", false);
		component.set("v.isTTRemoveDate", false);
		component.set("v.isTransactionTypeExpire", false);
		component.set("v.isTTExpireDate", false);
		component.set("v.isExTTPop", false);
		component.set("v.isExTTPopDate", false);
	},

	actionTransactionType: function (component, event, helper) {
		//Add your code to call apex method or do some processing
		//helper.showSpinner(component);
		var seletedRowsData = component.find("treeGridTT").getSelectedRows();
		var expandedRowsData = component.find("treeGridTT").getCurrentExpandedRows();
		// alert('seletedRowsData', seletedRowsData);
		console.log("Selected rows data>>>>>>" + JSON.stringify(seletedRowsData));
		//alert('expandedRowsData', expandedRowsData);
		console.log("Expanded rows data>>>>>>" + JSON.stringify(expandedRowsData));

		component.set("v.selectedRowsMap", seletedRowsData);
		var rowsMap = component.get("v.selectedRowsMap");
		var ttgroupId = component.get("v.restrictionId");
		var ttstartDate = component.get("v.transactionTypeEffectiveStartDate");
		var ttendDate = component.get("v.transactioTypeEffectiveEndDate");
		//alert('After the date getter');
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDateTT = yyyy + "-" + mm + "-" + dd;

		if (ttgroupId == "" || ttgroupId == null) {
			var toast = helper.getToast("Error", "Please select an Group Restriction", "error");
			toast.fire();
			component.set("v.isTransactionTypeOpen", true);
			//alert('In restriction null');
		} else if (ttstartDate < todayFormattedDateTT || ttendDate < todayFormattedDateTT) {
			var toast = helper.getToast("Error", "Date must be in future", "error");
			toast.fire();
			component.set("v.isTransactionTypeOpen", true);
			//alert('In less than today');
		} else if (ttstartDate == "" || ttstartDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeOpen", true);
			// alert('In start date');
		} else if (ttendDate == "" || ttendDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeOpen", true);
			//alert('In end date');
		} else if (ttendDate < ttstartDate) {
			component.set("v.isTransactionTypeOpen", true);
			var toast = helper.getToast("Error", "End date cannot be greater than Start date", "error");
			toast.fire();

			//alert('In end date less than start date ');
		} else {
			helper.addingTransactionTypes(component, event, seletedRowsData, expandedRowsData);
			component.set("v.isTransactionTypeOpen", false);
		}

		// Set isTransactionTypeOpen attribute to false
	},

	updateSelectedTTRow: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		// var data = component.get("v.transactionTypesData");
		//var selectedData = [];
		/*for(var i = 0; i< selectedRows.length; i++){
            for(var par = 0; par < data.length; par++){
                if(selectedRows[i].ObjectID == data[par].ObjectID){
                    var childRec = data[par]['_children'];
                    selectedData.push(data[par].ObjectID);
                    
                    for(var key = 0; key < childRec.length; key++){
                        selectedData.push(childRec[key].ObjectID);
                    }
                }
            }
        }*/

		console.log("Hi" + JSON.stringify(selectedRows));

		//component.set('v.transactionTypesData', data);
		//component.set('v.selectedTTRows', selectedData );

		component.set("v.selectedTransactionTypesData", selectedRows);
		component.set("v.selectedTTRowsCount", selectedRows.length);
	},

	updateTransactionTypes: function (component, event, helper) {
		var transTypeRecordId = event.getSource().get("v.value");
		component.set("v.ttRecordId", transTypeRecordId);
		console.log("Transaction type record id :::::::::::::::::::" + transTypeRecordId);
		// component.set("v.isInfinity" , true);
		//console.log('Check box --> ' + isInfinity);

		// if(!component.find("checkbox").get("v.checked")){
		component.set("v.isInfinity", false);
		// }

		var ttRecData = component.get("v.selectedTransactionTypesDataMain");
		for (var i = 0; i < ttRecData.length; i++) {
			if (ttRecData[i].Id == transTypeRecordId) {
				component.set("v.transType", ttRecData[i].Name);
				component.set("v.transDescription", ttRecData[i].Description__c);
				component.set("v.updateTransTypeStartDate", ttRecData[i].Effective_Start_Date__c);
				component.set("v.updateTransTypeEndDate", ttRecData[i].Effective_End_Date__c);
				component.set("v.ttOriginalEffectiveStartDate", ttRecData[i].Original_Effective_Start_Date__c);
			}
		}

		//helper.getUpdateTransType(component, event, helper, transTypeRecordId);
		component.set("v.isTransactionTypeUpdate", true);
		component.set("v.isTTUpdateDate", true);
	},

	deleteTransactionTypes: function (component, event, helper) {
		var rTypeRecordId = event.getSource().get("v.value");
		console.log("Transaction type record id :::::::::::::::::::" + rTypeRecordId);
		component.set("v.ttRecordId", rTypeRecordId);

		component.set("v.isTransactionTypeDelete", true);
		component.set("v.isTTRemoveDate", true);
	},

	updateActionTransactionType: function (component, event, helper) {
		var upTType = component.get("v.transType");
		console.log("upTType=======??????????" + upTType);
		var upTDesc = component.get("v.transDescription");
		var upTTStartDate = component.get("v.updateTransTypeStartDate");
		console.log("upTTStartDate=======??????????" + upTTStartDate);
		var upTTEndDate = component.get("v.updateTransTypeEndDate");
		console.log("upTTEndDate=======??????????" + upTTEndDate);
		var upTTRecordId = component.get("v.ttRecordId");
		console.log("upTTEndDate=======??????????" + upTTRecordId);
		var origEffDate = component.get("v.ttOriginalEffectiveStartDate");
		console.log("origEffDate ========>>>>>>>>" + origEffDate);

		var isInfinity = component.find("checkbox").get("v.checked");

		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDateTT = yyyy + "-" + mm + "-" + dd;

		if (upTTStartDate < todayFormattedDateTT || upTTEndDate < todayFormattedDateTT) {
			var toast = helper.getToast("Error", "Date must been in future", "error");
			toast.fire();
			component.set("v.isTransactionTypeUpdate", true);
			//alert('In less than today');
		} else if (upTTStartDate == "" || upTTStartDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeUpdate", true);
			// alert('In start date');
		} else if (upTTEndDate == "" || upTTEndDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeUpdate", true);
			//alert('In end date');
		} else if (upTTEndDate < upTTStartDate) {
			component.set("v.isTransactionTypeUpdate", true);
			var toast = helper.getToast("Error", "End date cannot be greater than Start date", "error");
			toast.fire();

			//alert('In end date less than start date ');
		} else {
			//alert('In Helper if condition');
			helper.updateTransTypeParam(component, event, helper, upTTRecordId);
			component.set("v.isTransactionTypeUpdate", false);
		}

		component.set("v.isTTUpdateDate", false);
		//component.set('v.isTransactionTypeUpdate', false);
	},

	deleteActionTransactionType: function (component, event, helper) {
		var transTypeRecordId = event.getSource().get("v.value");

		var rTTRecordId = component.get("v.ttRecordId");
		console.log("Transaction type record id :::::::::::::::::::" + rTTRecordId);
		var ttRecData = component.get("v.selectedTransactionTypesDataMain");
		for (var i = 0; i < ttRecData.length; i++) {
			if (ttRecData[i].Id == rTTRecordId) {
				component.set("v.rtransType", ttRecData[i].Name);
				//alert('Inside for loop to set the values');

				component.set("v.rtransDescription", ttRecData[i].Description__c);
				component.set("v.rTransTypeStartDate", ttRecData[i].Effective_Start_Date__c);
				component.set("v.rTransTypeEndDate", ttRecData[i].Effective_End_Date__c);
			}
		}
		helper.delTransactionType(component, rTTRecordId);
		component.set("v.isTransactionTypeDelete", false);
		component.set("v.isTTRemoveDate", false);
	},

	updateSelectedTextAccount: function (component, event) {
		var selectedRows = event.getParam("selectedRows");
		if (selectedRows.length > 0) {
			component.set("v.isAccountSelected", true);
		} else {
			component.set("v.isAccountSelected", false);
		}

		console.log("Hi" + JSON.stringify(selectedRows));
		component.set("v.selectedRowsAccount", selectedRows);
	},

	selectExcludedAccounts: function (component, event) {
		var selectedRows = event.getParam("selectedRows");
		component.set("v.selectedExcludedAccounts", selectedRows);
	},

	closeExcludedAccount: function (component, event) {
		component.set("v.openExcludedAccount", false);
		component.set("v.isUpdateExcludedAccount", false);
	},

	addExcludedAccount: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.accountNumber", "");
		component.set("v.AccountDescription", "");
		component.set("v.accountEffectiveStartDate", helper.effictiveStartDate(component));
		component.set("v.accountEffectiveEndDate", "");
		component.set("v.OriginalEffectiveStartDate", "");
		component.set("v.AccountDescription", "");
		component.set("v.isInfinity", false);
		component.set("v.editExcludedAccount", false);
		component.set("v.isUpdateExcludedAccount", false);
		component.set("v.openExcludedAccount", true);
	},
	addExcludedAccounts: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.accountNumber", "");
		component.set("v.AccountDescription", "");
		component.set("v.accountEffectiveStartDate", helper.effictiveStartDate(component));
		component.set("v.accountEffectiveEndDate", "");
		component.set("v.OriginalEffectiveStartDate", "");
		component.set("v.AccountDescription", "");
		component.set("v.openExcludedAccount", true);
		component.set("v.editExcludedAccount", false);
		component.set("v.isUpdateExcludedAccount", true);
	},

	saveExcludedAccounts: function (component, event, helper) {
		helper.showSpinner(component);
		var selectedAccounts = component.get("v.selectedExcludedAccounts");
		var isAccounts = component.get("v.isUpdateExcludedAccount");
		var accountList = component.get("v.responseList");
		var accountNumber = component.get("v.accountNumber");
		var count = 0;
		console.log("selectedRows " + JSON.stringify(accountList));

		if (isAccounts == false) {
			for (var i = 0; i < accountList.length; i++) {
				console.log("accountList[i].accountNumber.substring(7, 17) " + accountList[i].accountNumber.substring(7, 17));
				console.log("accountNumber" + accountNumber);
				if (accountList[i].accountNumber.substring(7, 17) == accountNumber || accountList[i].accountNumber == accountNumber) {
					count++;
					if (component.get("v.editExcludedAccount") == false && isAccounts == false) {
						var errors = helper.formValidations(component);
						if (errors == 0) {
							helper.createExcludedAccount(component, false);
						}
					} else {
						var errors = helper.formValidations(component, false);
						if (errors == 0) {
							helper.updateExcludedAccount(component, component.get("v.excludedAccountId"));
						}
					}
					break;
				}
			}
			if (count == 0) {
				var toast = helper.getToast("Error", "Account Number not found in the CIF!!!", "Error");
				toast.fire();
				helper.hideSpinner(component);
			}
		} else {
			var errors = helper.formValidations(component, true);
			if (errors == 0 && selectedAccounts.length > 0) {
				helper.createExcludedAccounts(component, selectedAccounts);
			} else if (errors == 0 && selectedAccounts.length == 0) {
				var toast = helper.getToast("Error", "Please Select Accounts", "Error");
				toast.fire();
				helper.hideSpinner(component);
			}
		}
	},

	handleExcludedAccountUpdate: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.openExcludedAccount", true);
		component.set("v.isUpdateExcludedAccount", false);
		component.set("v.editExcludedAccount", true);
		component.set("v.isInfinity", true);
		//console.log('Check box --> ' + isInfinity);

		if (!component.find("checkbox").get("v.checked")) {
			component.set("v.isInfinity", false);
		}
		var excludedAccountId = event.getSource().get("v.value");
		console.log("Account ID ---> " + excludedAccountId);
		component.set("v.excludedAccountId", excludedAccountId);
		// component.set("v.createAccount" , true);

		var excludedAccounts = component.get("v.excludedAccounts");

		for (var key = 0; key < excludedAccounts.length; key++) {
			if (excludedAccounts[key].Id == excludedAccountId) {
				component.set("v.accountNumber", excludedAccounts[key].AccountNumber__c);
				component.set("v.AccountDescription", excludedAccounts[key].Description__c);
				component.set("v.accountEffectiveStartDate", excludedAccounts[key].EffectiveStartDate__c);
				component.set("v.accountEffectiveEndDate", excludedAccounts[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", excludedAccounts[key].EffectiveStartDate__c);
			}
		}
		/* if(component.get("v.accountEffectiveEndDate") == '4000-12-31'){
            component.set("v.isInfinity" , true);
            component.find("checkbox").set("v.checked",true);
        }*/
	},

	handleExcludedAccountRemove: function (component, event, helper) {
		component.set("v.isRemoveExcludedAccountOpen", true);
		var excludedAccountId = event.getSource().get("v.value");
		component.set("v.excludedAccountId", excludedAccountId);
	},

	actionRemoveExcludedAccount: function (component, event, helper) {
		var excludedAccountId = component.get("v.excludedAccountId");
		var excludedAccounts = component.get("v.excludedAccounts");

		for (var key = 0; key < excludedAccounts.length; key++) {
			if (excludedAccounts[key].Id == excludedAccountId) {
				component.set("v.accountNumber", excludedAccounts[key].AccountNumber__c);
				component.set("v.AccountDescription", excludedAccounts[key].Description__c);
				component.set("v.accountEffectiveStartDate", excludedAccounts[key].EffectiveStartDate__c);
				component.set("v.accountEffectiveEndDate", excludedAccounts[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", excludedAccounts[key].EffectiveStartDate__c);
			}
		}
		helper.showSpinner(component);
		helper.deleteExcludedAccount(component, excludedAccountId);
	},
	AddAccounts: function (component, event, helper) {
		helper.getAccountDetails(component, event, helper);
		component.set("v.accountEffectiveStartDate", helper.effictiveStartDate(component));
		component.set("v.isCreateAccounts", true);
		component.set("v.isUpdate", true);
	},

	saveAccounts: function (component, event, helper) {
		var selectedAccouts = component.get("v.selectedRowsAccount");
		var isAccountSelected = component.get("v.isAccountSelected");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		console.log("Selected Accounts length  --> " + selectedAccouts.length);
		if (endDate < startDate) {
			var toast = helper.getToast("Error", "Start date cannot greater than end date", "error");
			toast.fire();
			return false;
		}
		if (isAccountSelected == true) {
			var count = helper.formValidations(component, true);
			if (count == 0) {
				helper.CreateRestrictionAccounts(component, selectedAccouts);
				component.set("v.isCreateAccounts", false);
			}
		} else {
			var toast = helper.getToast("Error", "Please select an Account", "error");
			toast.fire();
		}
	},

	closeAccounts: function (component, event, helper) {
		console.log("Cancel clicked");
		component.set("v.isCreateAccounts", false);
	},

	// ADD CUSTOMER START HERE

	AddCustomer: function (component, event, helper) {
		helper.retrieveAccount(component, event, helper);
		component.set("v.customerStartDate", helper.effictiveStartDate(component));
		component.set("v.createCustomer", true);
		component.set("v.editCustomer", false);
	},

	closeCustomer: function (component, event, helper) {
		console.log("Close clicked");
		component.set("v.createCustomer", false);
	},

	cancelCustomer: function (component, event, helper) {
		component.set("v.createCustomer", false);
	},

	SaveCustomer: function (component, event, helper) {
		var customerKey = component.get("v.customerKey");
		var customerDescription = component.get("v.customerDescription");
		var customerStartDate = component.get("v.customerStartDate");
		var customerEndDate = component.get("v.customerEndDate");
		var isUpdateCustomer = component.get("v.isUpdateCustomer");
		var respObj = component.get("v.responseCustomerList");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
		if (customerKey == "" || customerKey == null) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "customerKey cannot be blank.", type: "error" });
			toastEvent.fire();
		} else if (customerStartDate == "" || customerStartDate == null) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "Start date cannot be blank.", type: "error" });
			toastEvent.fire();
		} else if (customerEndDate == "" || customerEndDate == null) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "End date cannot be blank.", type: "error" });
			toastEvent.fire();
		} else if (component.get("v.customerStartDate") <= todayFormattedDate && component.get("v.customerStartDate") != "") {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "Start date must be in future.", type: "error" });
			toastEvent.fire();
		} else if (component.get("v.customerEndDate") < todayFormattedDate && component.get("v.customerEndDate") != "") {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "End date must be in future.", type: "error" });
			toastEvent.fire();
		} else if (component.get("v.customerStartDate") > customerEndDate && component.get("v.customerStartDate") != "") {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({ title: "Error!", message: "Enddate should be > StartDate.", type: "error" });
			toastEvent.fire();
		} else {
			if (component.get("v.editCustomer") == false && isUpdateCustomer == false) {
				if (respObj == null) {
					helper.CreateRestrictionCustomer(component, event, helper);
				} else {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({ title: "Error!", message: "Record already exist for this restriction group.", type: "error" });
					toastEvent.fire();
				}
			} else {
				helper.updateRestrictionCustomer(component);
			}
		}
	},

	handleUpdateCustomer: function (component, event, helper) {
		var customerId = event.getSource().get("v.value");
		var responseCustomerList = component.get("v.responseCustomerList");
		component.set("v.createCustomer", true);
		component.set("v.isUpdateCustomer", false);
		component.set("v.editCustomer", true);
		component.set("v.isInfinity", true);
		component.set("v.customerAccountId", customerId);

		if (!component.find("customerCheckboxId").get("v.checked")) {
			component.set("v.isInfinity", false);
		}

		for (var key = 0; key < responseCustomerList.length; key++) {
			if (responseCustomerList[key].Id == customerId) {
				component.set("v.customerKey", responseCustomerList[key].CustomerKey__c);
				component.set("v.customerDescription", responseCustomerList[key].Description__c);
				component.set("v.customerStartDate", responseCustomerList[key].EffectiveStartDate__c);
				component.set("v.customerEndDate", responseCustomerList[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", responseCustomerList[key].OriginalEffectiveStartDate__c);
			}
		}
	},

	handleCustomerRemove: function (component, event, helper) {
		var customerId = event.getSource().get("v.value");
		component.set("v.isRemoveCustomerOpen", true);
		component.set("v.customerAccountId", customerId);
	},

	actionRemoveCustomer: function (component, event, helper) {
		var responseCustomerList = component.get("v.responseCustomerList");
		var customerId = component.get("v.customerAccountId");

		for (var key = 0; key < responseCustomerList.length; key++) {
			if (responseCustomerList[key].Id == customerId) {
				component.set("v.customerKey", responseCustomerList[key].CustomerKey__c);
				component.set("v.customerDescription", responseCustomerList[key].Description__c);
				component.set("v.customerStartDate", responseCustomerList[key].EffectiveStartDate__c);
				component.set("v.customerEndDate", responseCustomerList[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", responseCustomerList[key].OriginalEffectiveStartDate__c);
			}
		}
		helper.deleteCustomer(component, customerId);
	},

	closeRemoveCustomer: function (component, event, helper) {
		component.set("v.isRemoveCustomerOpen", false);
	},

	customerCheckSelect: function (component, event, helper) {
		var checkBoxValue = component.find("customerCheckboxId").get("v.checked");
		var clientAccountId = component.get("v.accountNumberFromFlow");
		component.set("v.isInfinityCustomerCheck", true);

		if (checkBoxValue) {
			component.set("v.customerEndDate", "4000-12-31");
		} else {
			component.set("v.customerEndDate", "");
			component.set("v.isInfinityCustomerCheck", false);
		}
	},

	onStartDate: function (component, event, helper) {
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
		if (component.get("v.customerStartDate") != "" && component.get("v.customerStartDate") < todayFormattedDate) {
			component.set("v.startDateError", true);
		} else {
			component.set("v.startDateError", false);
		}
	},

	onEndDate: function (component, event, helper) {
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1;
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}

		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;
		if (component.get("v.customerEndDate") != "" && component.get("v.customerEndDate") < todayFormattedDate) {
			component.set("v.endDateError", true);
		} else {
			component.set("v.endDateError", false);
		}
	},
	// ADD CUSTOMER END HERE

	deleteGroupRestriction: function (component, event, helper) {
		var Id = event.getParam("row").Id;
		var restrictionId = event.getParam("row").Restriction_ID__c;
		var status = event.getParam("row").Status__c;
		var caseRec = component.get("v.caseRecord");
		if (status != "Unchanged" && caseRec.ROT_Approval_Status__c == "Rejected" && caseRec.ROT_Approval_Status__c == "") {
			component.set("v.isRemoveRestrictionGroup", true);
			component.set("v.delGroupRestrictionId", Id);
			component.set("v.delRestrictionId", restrictionId);
		} else {
			var toast = helper.getToast("error", "Cannot delete the Group Restriction", "error");
			toast.fire();
		}
		// console.log('###########');
		console.log("###Id=" + Id);
		console.log("###Id=" + restrictionId);
	},

	actionRemoveRestrictionGroup: function (component, event, helper) {
		component.set("v.isRemoveRestrictionGroup", false);
		var Id = component.get("v.delGroupRestrictionId");
		var restrictionId = component.get("v.delRestrictionId");
		helper.deleteGroupRestrictionObject(component, Id, restrictionId);
	},
	closeRemoveRestrictionGroup: function (component, event, helper) {
		component.set("v.isRemoveRestrictionGroup", false);
	},

	bulkDateupdate: function (component, event, helper) {
		component.set("v.isDateAdjustModal", true);
		component.set("v.accountEffectiveStartDate", helper.effictiveStartDate(component));
		component.set("v.accountEffectiveEndDate", "");
		component.set("v.isInfinity", false);
		//component.set("v.checked", true);
		var responseBean = helper.getRestrictionGrpDetails(component);
	},
	closeDateAdjustModal: function (component, event, helper) {
		component.set("v.isDateAdjustModal", false);
		component.set("v.accountEffectiveStartDate", "");
		component.set("v.accountEffectiveEndDate", "");
		component.set("v.isInfinity", false);
		component.set("v.selectedRowsDateAdjsut", "");
		component.set("v.currentSelected", "");
		//component.set("v.checked", false);
	},
	updateSelectedDateAdjustRow: function (component, event, helper) {
		helper.updateSelectedDateAdjustRow(component, event, helper);
	},
	updateDates: function (component, event, helper) {
		var selectedRows = component.get("v.selectedRowsDateAdjsut");
		var childRows = component.get("v.childRecords");
		var records = [];

		for (var i = 0; i < selectedRows.length; i++) {
			for (var j = 0; j < childRows.length; j++) {
				if (selectedRows[i] == childRows[j].Id) records.push(childRows[j]);
			}
		}
		if (records.length > 0) {
			var count = helper.formValidations(component, true);
			if (count == 0) {
				component.set("v.bulkDateUpdateRecords", records);
				//alert('selectedRows'+JSON.stringify(records))
				component.set("v.isDateAdjustModal", false);
				component.set("v.isConfirm", true);
			}
		} else {
			var toast = helper.getToast("error", "Please Select Records", "error");
			toast.fire();
		}
	},

	confirmModal: function (component, event, helper) {
		var records = component.get("v.bulkDateUpdateRecords");
		helper.showSpinner(component);
		helper.updateDates(component, records);
	},
	closeModal: function (component, event, helper) {
		component.set("v.isConfirm", false);
		component.set("v.isDateAdjustModal", true);
	},
	filterRecords: function (component, event, helper) {
		component.find("dateAdjustTable").expandAll();
		var restrictionGrpDataCopy = component.get("v.restrictionGrpDataCopy");
		var keyword = component.find("search").get("v.value");
		var tempRec = JSON.parse(JSON.stringify(restrictionGrpDataCopy));
		var currentSelected = component.get("v.currentSelected");
		var data = tempRec[0]["_children"];
		console.log("currentSelected filter" + JSON.stringify(currentSelected));
		if (keyword.length > 0) {
			component.find("dateAdjustTable").expandAll();
			for (var i = 0; i < data.length; i++) {
				var childrenData = data[i]["_children"];
				var tempData = [];

				for (var j = 0; j < childrenData.length; j++) {
					if (currentSelected.includes(childrenData[j].Id)) {
						tempData.push(childrenData[j]);
					}
					console.log("childrenData[j].Description__c " + childrenData[j].Description__c);
					if (
						childrenData[j].Name.toUpperCase().includes(keyword.toUpperCase()) ||
						(childrenData[j].Description__c != undefined &&
							childrenData[j].Description__c != "" &&
							childrenData[j].Description__c.toUpperCase().includes(keyword.toUpperCase()))
					) {
						tempData.push(childrenData[j]);
					}
				}

				data[i]["_children"] = [...new Set(tempData)];
			}

			tempRec[0]["_children"] = data;
			component.set("v.restrictionGrpData", tempRec);
		} else {
			component.set("v.restrictionGrpData", tempRec);
			component.find("dateAdjustTable").expandAll();
		}
	},
	onToggle: function (component, event, helper) {
		console.log("Toggle");
		var toggledId = event.getParam("name");
		var toggledIds = component.get("v.toggledIds");
		if (event.getParam("isExpanded") === false) {
			toggledIds.push(toggledId);
		} else {
			const index = toggledIds.indexOf(toggledId);
			if (index > -1) {
				toggledIds.splice(index, 1);
			}
		}
		component.set("v.toggledIds", toggledIds);
		console.log("toggledIds " + JSON.stringify(toggledIds));
		var currentSelectedDispo = component.get("v.currentSelected");
		if (currentSelectedDispo.length > 0) {
			component.set("v.selectedRowsDateAdjsut", currentSelectedDispo);
		}
	},
	onNoEndDateSelect: function (component, event, helper) {
		var checkedValue = component.find("endDateCheck").get("v.checked");
		if (checkedValue) {
			component.set("v.accountEffectiveEndDate", "4000-12-31");
			component.set("v.isInfinity", true);
		} else {
			component.set("v.accountEffectiveEndDate", "");
			component.set("v.isInfinity", false);
		}
	},
	bulkNodeDelete: function (component, event, helper) {
		component.set("v.isDeleteNodeModal", true);
		helper.getRestrictionGrpDetails(component);
	},
	saveDeleteNode: function (component, event, helper) {
		var selectedRows = component.get("v.selectedRowsDelNode");
		var childRows = component.get("v.childRecords");
		var records = [];
		if (selectedRows.length > 0) {
			for (var i = 0; i < selectedRows.length; i++) {
				for (var j = 0; j < childRows.length; j++) {
					if (selectedRows[i] == childRows[j].Id) records.push(childRows[j]);
				}
			}

			if (records.length > 0) {
				component.set("v.bulkDeleteNodeRecords", records);
				component.set("v.isConfirmDeleteNode", true);
				component.set("v.isDeleteNodeModal", false);
			} else {
				var toast = helper.getToast("error", "Please Select Nodes", "error");
				toast.fire();
			}
			//alert('selectedRows'+JSON.stringify(records));

			//var count = helper.formValidations(component, true);
			/*
             if(selectedRows == 0){
                 component.set("v.bulkDeleteNodeRecords",records);
                //alert('selectedRows'+JSON.stringify(records))
                 component.set("v.isDateAdjustModal", false);
                 component.set("v.isConfirm", true);
            }*/
		} else {
			var toast = helper.getToast("error", "Please Select Records", "error");
			toast.fire();
		}
	},

	closeDeleteNodeModal: function (component, event, helper) {
		component.set("v.isDeleteNodeModal", false);
	},
	updateSelectedDelNodeRow: function (component, event, helper) {
		helper.updateSelectedDeleteNodeRow(component, event, helper);
	},
	/*bulkDateupdate : function(component, event, helper){
        component.set("v.isDateAdjustModal", true);
        component.set("v.accountEffectiveStartDate", helper.effictiveStartDate(component));
        //component.set("v.endDate","4000-12-31")
        component.set("v.isInfinity", false);
        //component.set("v.checked", true);
        var responseBean = helper.getRestrictionGrpDetails1(component);
        },*/
	confirmModalDeleteNode: function (component, event, helper) {
		var records = component.get("v.bulkDeleteNodeRecords");
		console.log("Records ----> " + records);
		//helper.showSpinner(component);
		helper.bulkDeleteNode(component, event, helper, records);
		// helper.methodTest(component,event,helper);
		component.set("v.isConfirmDeleteNode", false);
	},
	closeModalConfirmDeleteNode: function (component) {
		component.set("v.isConfirmDeleteNode", false);
	},
	bulkExpireNodes: function (component, event, helper) {
		component.set("v.isBulkExpireModal", true);
		helper.getRestrictionGrpDetails1(component);
	},
	closeExpireNodes: function (component, event, helper) {
		component.set("v.isBulkExpireModal", false);
	},
	updateSelectedExpireNodeRow: function (component, event, helper) {
		helper.updateSelectedExpireNodeRow(component, event, helper);
	},
	saveExpireBulk: function (component, event, helper) {
		var expireDate = component.get("v.expiryDate");
		console.log("Expire Date -->" + expireDate);
		if (expireDate == null) {
			var toast = helper.getToast("error", "Expire Date cannot be empty", "error");
			toast.fire();
			return false;
		}
		var selectedRows = component.get("v.selectedRowsExpireNode"); //component.get("v.bulkExpireRecords");
		console.log("Select Rows " + selectedRows.length);
		var childRows = component.get("v.childRecords");
		var records = [];
		if (selectedRows.length > 0) {
			for (var i = 0; i < selectedRows.length; i++) {
				for (var j = 0; j < childRows.length; j++) {
					if (selectedRows[i] == childRows[j].Id) records.push(childRows[j]);
				}
			}

			if (records.length > 0) {
				component.set("v.bulkExpireRecords", records);
				component.set("v.isConfirmExpireNode", true);
				component.set("v.isBulkExpireModal", false);
			} else {
				component.set("v.isBulkExpireModal", false);
				var toast = helper.getToast("error", "Please Select Nodes", "error");
				toast.fire();
			}
		} else {
			var toast = helper.getToast("error", "Please Select Records", "error");
			toast.fire();
		}
		//helper.updateSelectedDeleteNodeRow(component,event, helper);
	},
	closeModalExpireNode: function (component, event, helper) {
		component.set("v.isConfirmExpireNode", false);
	},
	confirmModalExpireNode: function (component, event, helper) {
		component.set("v.isConfirmExpireNode", false);
		component.set("v.isBulkExpireModal", false);
		var expireDate = component.get("v.expiryDate");
		var records = component.get("v.bulkExpireRecords");
		console.log("Records ----> " + records);
		helper.bulkExpireNode(component, event, helper, records);
	},
	openImportRestrictionModal: function (component, event, helper) {
		$A.createComponent(
			"c:ImportGroupRestrictions",
			{
				CIF: component.get("v.clientAccountIdFromFlow"),
				caseId: component.get("v.caseId")
			},
			function (modalComponent, status, errorMessage) {
				if (status === "SUCCESS") {
					//Appending the newly created component in div
					var body = component.find("showImportRestrictionsModal").get("v.body");
					body.push(modalComponent);
					component.find("showImportRestrictionsModal").set("v.body", body);
				} else if (status === "INCOMPLETE") {
					console.log("Error");
				} else if (status === "ERROR") {
					console.log("error");
				}
			}
		);
	},

	handleCustomerExpire: function (component, event, helper) {
		debugger;
		component.set("v.customerExpireDateError", false);
		component.set("v.isExpireCustomer", true);
		var customerId = event.getSource().get("v.value");
		component.set("v.customerAccountId", customerId);

		var responseCustomerList = component.get("v.responseCustomerList");

		for (var key = 0; key < responseCustomerList.length; key++) {
			if (responseCustomerList[key].Id == customerId) {
				console.log("Id on list  " + responseCustomerList[key].Id);
				component.set("v.customerKey", responseCustomerList[key].CustomerKey__c);
				component.set("v.customerDescription", responseCustomerList[key].Description__c);
				component.set("v.customerStartDate", responseCustomerList[key].EffectiveStartDate__c);
				component.set("v.customerEndDate", responseCustomerList[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", responseCustomerList[key].OriginalEffectiveStartDate__c);
			}
		}

		var today = new Date();
		component.set("v.customerExpireDate", today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() + 7));
	},

	closeExpireCustomer: function (component, event, helper) {
		debugger;
		component.set("v.isExpireCustomer", false);
		component.set("v.isConfirmExpireCustomer", false);
	},
	SaveExpireCustomer: function (component, event, helper) {
		debugger;
		var errorFlag = component.get("v.customerExpireDateError");
		if (!errorFlag) {
			component.set("v.isConfirmExpireCustomer", true);
			component.set("v.customerExpireDateError", false);
			component.set("v.customerExpireDate", component.get("v.customerExpireDate"));
		}
	},
	OnCustomerExpire: function (component, event, helper) {
		debugger;
		component.set("v.customerExpireDateError", false);
		var userEnterdEndDate = component.get("v.customerExpireDate");
		var today = new Date();

		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}
		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;

		if (userEnterdEndDate < todayFormattedDate) {
			component.set("v.customerExpireDateError", true);
		}
	},

	actionExpireCustomer: function (component, event, helper) {
		var customerId = component.get("v.customerAccountId");
		component.set("v.accountEffectiveEndDate", component.get("v.customerExpireDate"));
		helper.expireCustomer(component, customerId);
		component.set("v.isExpireCustomer", false);
		component.set("v.isConfirmExpireCustomer", false);
	},
	handleExcludedAccountsExpire: function (component, event, helper) {
		debugger;
		helper.getAccountDetails(component, event, helper);
		var excludedAccountId = event.getSource().get("v.value");
		console.log("Account ID ---> " + excludedAccountId);
		component.set("v.excludedAccountId", excludedAccountId);
		// component.set("v.createAccount" , true);

		var excludedAccounts = component.get("v.excludedAccounts");

		for (var key = 0; key < excludedAccounts.length; key++) {
			if (excludedAccounts[key].Id == excludedAccountId) {
				component.set("v.accountNumber", excludedAccounts[key].AccountNumber__c);
				component.set("v.AccountDescription", excludedAccounts[key].Description__c);
				component.set("v.accountEffectiveStartDate", excludedAccounts[key].EffectiveStartDate__c);
				component.set("v.accountEffectiveEndDate", excludedAccounts[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", excludedAccounts[key].OriginalEffectiveStartDate__c);
			}
		}
		var today = new Date();
		component.set("v.excludedAccountExpireDate", today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() + 7));
		component.set("v.accountEffectiveEndDate", component.get("v.excludedAccountExpireDate"));

		component.set("v.restrictionAccountId", excludedAccountId);
		component.set("v.isExpireExcludedAccountOpen", true);
	},

	closeExpireAccount: function (component, event, helper) {
		debugger;
		component.set("v.isExpireAccountOpen", false);
		component.set("v.isConfirmExpireAccount", false);

		component.set("v.isExpireExcludedAccountOpen", false);
		component.set("v.isConfirmExcludedAccountExpire", false);
	},

	SaveExpireAccount: function (component, event, helper) {
		debugger;

		var errorFlag = component.get("v.accountExpireDateError");
		if (!errorFlag) {
			component.set("v.isConfirmExpireAccount", true);
			component.set("v.accountExpireDateError", false);
			component.set("v.accountEffectiveEndDate", component.get("v.accountExpireDate"));
		}
	},
	SaveExcludedExpireAccount: function (component, event, helper) {
		debugger;

		var errorExcludedFlag = component.get("v.excludedAccountExpireDateError");
		if (!errorExcludedFlag) {
			component.set("v.isConfirmExcludedAccountExpire", true);
			component.set("v.excludedAccountExpireDateError", false);
			component.set("v.accountEffectiveEndDate", component.get("v.excludedAccountExpireDate"));
		}
	},
	onAccountExpire: function (component, event, helper) {
		debugger;
		component.set("v.accountExpireDateError", false);
		var userEnterdEndDate = component.get("v.accountExpireDate");
		var today = new Date();

		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}
		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;

		if (userEnterdEndDate < todayFormattedDate) {
			component.set("v.accountExpireDateError", true);
		}
	},

	onExcludedAccountExpire: function (component, event, helper) {
		debugger;
		component.set("v.excludedAccountExpireDateError", false);
		var userEnterdEndDate = component.get("v.excludedAccountExpireDate");
		var today = new Date();

		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}
		var todayFormattedDate = yyyy + "-" + mm + "-" + dd;

		if (userEnterdEndDate < todayFormattedDate) {
			component.set("v.excludedAccountExpireDateError", true);
		}
	},
	actionExpireAccount: function (component, event, helper) {
		debugger;
		var accountId = component.get("v.restrictionAccountId");
		component.set("v.accountEffectiveEndDate", component.get("v.accountExpireDate"));
		helper.expireRestrictionAccount(component, accountId);
		component.set("v.isExpireAccountOpen", false);
		component.set("v.isConfirmExpireAccount", false);
	},
	actionExcludedExpireAccount: function (component, event, helper) {
		debugger;
		var accountId = component.get("v.restrictionAccountId");
		component.set("v.accountEffectiveEndDate", component.get("v.excludedAccountExpireDate"));
		helper.expireExcludedAccount(component, accountId);
		component.set("v.isExpireExcludedAccountOpen", false);
		component.set("v.isConfirmExcludedAccountExpire", false);
	},
	handleClickExpire: function (component, event, helper) {
		debugger;
		helper.getAccountDetails(component, event, helper);
		var groupAccountId = event.getSource().get("v.value");
		var groupAccounts = component.get("v.accounts");
		component.set("v.accountExpireDateError", false);
		for (var key = 0; key < groupAccounts.length; key++) {
			if (groupAccounts[key].Id == groupAccountId) {
				component.set("v.accountNumber", groupAccounts[key].AccountNumber__c);
				component.set("v.AccountDescription", groupAccounts[key].Description__c);
				component.set("v.accountEffectiveStartDate", groupAccounts[key].EffectiveStartDate__c);
				component.set("v.accountEffectiveEndDate", groupAccounts[key].EffectiveEndDate__c);
				component.set("v.OriginalEffectiveStartDate", groupAccounts[key].EffectiveStartDate__c);
			}
		}
		var today = new Date();
		component.set("v.accountExpireDate", today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + (today.getDate() + 7));
		component.set("v.accountEffectiveEndDate", component.get("v.accountExpireDate"));

		component.set("v.restrictionAccountId", groupAccountId);
		component.set("v.isExpireAccountOpen", true);
	},

	expireTransactionTypes: function (component, event, helper) {
		//alert('Expire controller class');
		var transTypeRecordId = event.getSource().get("v.value");
		component.set("v.ttRecordId", transTypeRecordId);
		console.log("Transaction type record id controller :::::::::::::::::::" + transTypeRecordId);

		var ttRecData = component.get("v.selectedTransactionTypesDataMain");
		for (var i = 0; i < ttRecData.length; i++) {
			if (ttRecData[i].Id == transTypeRecordId) {
				component.set("v.transType", ttRecData[i].Name);
				// alert('transType');
				component.set("v.transDescription", ttRecData[i].Description__c);
				component.set("v.updateTransTypeStartDate", ttRecData[i].Effective_Start_Date__c);
				// component.set('v.updateTransTypeEndDate', ttRecData[i].Effective_End_Date__c);
				component.set("v.updateTransTypeEndDate", helper.effictiveStartDate(component));
			}
		}

		// helper.getExpireTransType(component,transTypeRecordId);
		component.set("v.isTransactionTypeExpire", true);
		component.set("v.isTTExpireDate", true);
	},

	expireConfTransactionType: function (component, event, helper) {
		var rTypeRecordId = component.get("v.ttRecordId");
		console.log("Transaction type record id :::::::::::::::::::" + rTypeRecordId);
		//component.set('v.ttRecordId', rTypeRecordId);

		component.set("v.isTransactionTypeExpire", false);
		component.set("v.isTTExpireDate", false);
		component.set("v.isExTTPop", true);
		component.set("v.isExTTPopDate", true);
	},
	expireActionTransactionType: function (component, event, helper) {
		var excRecId = component.get("v.ttRecordId");
		console.log("excRecId--------> " + excRecId);
		var exTType = component.get("v.transType");
		console.log("exTType=======??????????" + exTType);
		//var upTDesc = component.get("v.transDescription");
		var exTTStartDate = component.get("v.updateTransTypeStartDate");
		console.log("exTTStartDate=======??????????" + exTTStartDate);
		var exTTEndDate = component.get("v.updateTransTypeEndDate");
		console.log("exTTEndDate=======??????????" + exTTEndDate);

		// var isInfinity = component.find("checkboxTT").get("v.checked");

		if (exTTStartDate < Date.now() || exTTEndDate < Date.now()) {
			var toast = helper.getToast("Error", "Date must been in future", "error");
			toast.fire();
			component.set("v.isTransactionTypeExpire", true);
			//alert('In less than today');
		} else if (exTTStartDate == "" || exTTStartDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeExpire", true);
			// alert('In start date');
		} else if (exTTEndDate == "" || exTTEndDate == null) {
			var toast = helper.getToast("Error", "Please select a date value", "error");
			toast.fire();
			component.set("v.isTransactionTypeExpire", true);
			//alert('In end date');
		} else if (exTTEndDate < exTTStartDate) {
			component.set("v.isTransactionTypeExpire", true);
			var toast = helper.getToast("Error", "End date cannot be in past than Start date", "error");
			toast.fire();

			//alert('In end date less than start date ');
		} else {
			//alert('In Helper if condition');
			helper.expireTransTypeParam(component, event, helper, excRecId);
			component.set("v.isTransactionTypeExpire", false);
		}

		//component.set('v.isTTExpireDate', false);
		component.set("v.isExTTPop", false);
		component.set("v.isExTTPopDate", false);
		//component.set('v.isTransactionTypeExpire', false);
	}
});