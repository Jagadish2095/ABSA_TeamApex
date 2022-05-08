({
	GetGroupRestrictionHierarchiesForCustomer: function (component) {
		var CIF = component.get("v.clientAccountIdFromFlow");
		var action = component.get("c.GetGroupRestrictionHierarchiesForCustomer");
		action.setParams({
			customerKey: CIF, //'CTMETRO001',
			forestType: "Staging"
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBean = response.getReturnValue();
					var responseBean1 = JSON.parse(response.getReturnValue());
					console.log(
						"Service Response --> " +
							responseBean1.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.Data
								.GroupRestrictionHierarchyModel[0].Description
					);
					component.set(
						"v.restrictionData",
						responseBean1.GetGroupRestrictionHierarchiesForCustomerResponse.GetGroupRestrictionHierarchiesForCustomerResult.Data
							.GroupRestrictionHierarchyModel
					);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	GetSelectedGroupRestriction: function (component, restrictionId) {
		var restrictionData = component.get("v.restrictionData");

		for (var i = 0; i < restrictionData.length; i++) {
			console.log("ObjectID " + restrictionData[i].ObjectID);
			if (restrictionData[i].ObjectID == restrictionId) {
				component.set("v.restrictionId", restrictionData[i].ObjectID);
				component.set("v.Description", restrictionData[i].Description);
				component.set("v.startDate", restrictionData[i].EffectiveStartDate);
				component.set("v.endDate", restrictionData[i].EffectiveEndDate);
				if (restrictionData[i].Accounts != null) {
					component.set("v.accounts", restrictionData[i].Accounts.AccountModel);
				} else {
					component.set("v.accounts", "");
				}
				if (restrictionData[i].TransactionTypes != null) {
					component.set("v.transactionTypes", restrictionData[i].TransactionTypes.TransactionTypeModel);
				} else {
					component.set("v.transactionTypes", "");
				}
				if (restrictionData[i].Customers != null) {
					component.set("v.customers", restrictionData[i].Customers.CustomerModel);
				} else {
					component.set("v.customers", "");
				}
			}
		}
	},
	getGroupRestriction: function (component) {},
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type,
			duration: 50000
		});

		return toastEvent;
	},

	CreateGroupRestrictionObject: function (component) {
		this.showSpinner(component);
		var groupId = component.get("v.restrictionId");
		var description = component.get("v.Description");
		var caseId = component.get("v.caseId");

		console.log("Group Id --> " + groupId);
		console.log("Description --> " + description);
		console.log("caseId --> " + caseId);

		var action = component.get("c.createNewGroupRestrictionObject");
		action.setParams({
			groupId: groupId,
			description: description,
			caseId: caseId,
            accountId : component.get("v.accountNumberFromFlow")
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value CreateGroupRestrictionObject -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.CreateGroupRestrictionResponse.CreateGroupRestrictionResult.HasErrors == "false") {
						this.hideSpinner(component);
						var toast = this.getToast("Success", "Group Restriction created successfully", "success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.CreateGroupRestrictionResponse.CreateGroupRestrictionResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					//helper.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							this.hideSpinner(component);
							var toast = this.getToast("Error", errors[0].message, "Error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	getGroupRestrictions: function (component) {
		this.showSpinner(component);
		var caseId = component.get("v.caseId");
		var action = component.get("c.getGroupRestrictions");
		action.setParams({
			caseId: caseId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rows = response.getReturnValue();
				console.log("Length --> " + rows.length);
				if (rows.length >= 1) {
					component.set("v.restrictionData", response.getReturnValue());
					component.set("v.HideNodes", true);
					this.hideSpinner(component);
				} else {
					//component.set("v.restrictionData", "");
					component.set("v.HideNodes", false);
					this.hideSpinner(component);
				}
				var setRows = [];

				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					component.set("v.selectedRowDetailToShow", row);
					console.log("===row" + JSON.stringify(row));
					setRows.push(row.Id);
					component.set("v.selectedRows", setRows);
					// this.getGroupAccounts(component,row.Id);
					this.getGroupAccounts(component);
					this.getExcludedAccounts(component);
					break;
				}
			}
		});

		$A.enqueueAction(action);
		component.set("v.maxRowSelection", 1);
		component.set("v.isButtonDisabled", true);
	},
	getGroupAccounts: function (component) {
		//this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var action = component.get("c.getGroupAccounts");
		action.setParams({
			restrictionGroupId: selectedRestrictionGroup.Id
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rows = response.getReturnValue();
				console.log("Length --> " + rows.length);
				if (rows.length >= 1) {
					component.set("v.accounts", response.getReturnValue());
					this.hideSpinner(component);
				} else {
					//component.set("v.accounts", "");
					this.hideSpinner(component);
				}
				var setRows = [];

				for (var i = 0; i < rows.length; i++) {
					var row = rows[i];
					component.set("v.selectedRowAccountDetailToShow", row);
					console.log("===row" + JSON.stringify(row));
					setRows.push(row.Id);
					component.set("v.selectedRowsAccount", setRows);

					break;
				}
			}
		});

		$A.enqueueAction(action);
		//component.set('v.maxRowSelectionAccount', 1);
		component.set("v.isButtonDisabled", true);
	},
	UpdateGroupRestrictions: function (component) {
		var updateSelectedRow = component.get("v.selectedRowDetailToShow");

		var groupRestrictionId = updateSelectedRow.Id;
		var description = updateSelectedRow.Description__c;
		var objectID = updateSelectedRow.Restriction_ID__c;

		var action = component.get("c.updateGroupRestriction");
		action.setParams({
			groupRestrictionId: groupRestrictionId,
			description: description,
			ObjectID: objectID
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value updateGroupRestrictionObject -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.UpdateGroupRestrictionResponse.UpdateGroupRestrictionResult.HasErrors == "false") {
						var toast = this.getToast("Success", "Group Restriction updated successfully", "success");
						toast.fire();
					} else {
						var toast = this.getToast(
							"Error",
							responseBeanService.UpdateGroupRestrictionResponse.UpdateGroupRestrictionResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "Error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	CreateRestrictionAccount: function (component) {
		this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var description = component.get("v.AccountDescription");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var accountNumber = component.get("v.accountNumber");
		var isInfinity = component.find("checkbox").get("v.checked");
		console.log("Start Date -->" + startDate);
		console.log("End Date -->" + endDate);
		console.log("Account Number" + accountNumber);
		var action = component.get("c.createAccountNode");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			description: description,
			effectiveEndDate: endDate,
			effectiveStartDate: startDate,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			AccountNumber: accountNumber,
			isInfinity: isInfinity
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						if (responseBeanService.AddAccountResponse.AddAccountResult.HasErrors == "false") {
							this.hideSpinner(component);
							this.getGroupAccounts(component);
							var toast = this.getToast("Success", "Group Restriction account created successfully", "success");
							toast.fire();
						} else {
							this.hideSpinner(component);
							var toast = this.getToast(
								"Error",
								responseBeanService.AddAccountResponse.AddAccountResult.ValidationErrors.ServiceValidationResult[0].Message,
								"Error"
							);
							toast.fire();
						}
					} else {
						this.hideSpinner(component);
						var toast = this.getToast("Error", "Something went wrong!! , please contact system administrator", "Error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							var toast = helper.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	deleteGroupRestrictionObject: function (component, groupRestrictionId, restrictionId) {
		this.showSpinner(component);
		console.log("Group Id ---> " + groupRestrictionId);
		console.log("restriction id  ---> " + restrictionId);
		var action = component.get("c.removeGroupRestriction");
		action.setParams({
			groupRestrictionId: groupRestrictionId,
			restrictionId: restrictionId
		});
		//alert('Call me');
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value deleteGroupRestrictionObject -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.DeleteGroupRestrictionResponse.DeleteGroupRestrictionResult.HasErrors == "false") {
						this.hideSpinner(component);
						this.getGroupRestrictions(component);
						var toast = this.getToast("Success", "Group Restriction deleted successfully", "success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.DeleteGroupRestrictionResponse.DeleteGroupRestrictionResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					helper.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							this.hideSpinner(component);
							var toast = this.getToast("Error", errors[0].message, "Error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	CreateRestrictionAccounts: function (component, accountList) {
		this.showSpinner(component);
		var accountListJSON = JSON.stringify(accountList);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		// var accountNumber = component.get("v.accountNumber");
		var errorCount = 0;
		console.log("Account List -->" + accountList);
		var accountNumbers = new Array();
		for (var i = 0; i < accountList.length; i++) {
			accountNumbers.push(accountList[i].accountNumber);
		}
		var idListJSON = JSON.stringify(accountNumbers);
		console.log("Satrt Date ----> " + idListJSON);
		console.log("Satrt Date ----> " + component.get("v.accountEffectiveStartDate"));
		var action = component.get("c.createAccountsNode");
		action.setParams({
			accountList: JSON.stringify(accountNumbers),
			groupRestrictionId: selectedRestrictionGroup.Id,
			startDate: component.get("v.accountEffectiveStartDate"), //accountList[i].effStartDate,
			endDate: component.get("v.accountEffectiveEndDate"), //accountList[i].effEndDate,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			isInfinity: component.find("checkbox").get("v.checked")
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						this.hideSpinner(component);
						var toast = this.getToast("Success", responseBeanService, "Success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast("Error", "Something went wrong", "Error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);

		this.getGroupAccounts(component);
		this.hideSpinner(component);
	},

	updateAccountRestriction: function (component, accountId, originalDate) {
		this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var description = component.get("v.AccountDescription");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var accountNumber = component.get("v.accountNumber");
		var originalEffectiveStartDate = component.get("v.originalEffectiveStartDate");
		console.log("Start Date -->" + startDate);
		console.log("End Date -->" + endDate);
		console.log("Account Number" + accountNumber);
		console.log("Account Number" + originalDate);
		var action = component.get("c.updateAccountNode");
		action.setParams({
			accountId: accountId,
			accountNumber: accountNumber,
			description: description,
			startDate: startDate,
			endDate: endDate,
			groupRestrictionObjectId: selectedRestrictionGroup.Restriction_ID__c,
			originalEffectiveStartDate: originalDate
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.UpdateAccountResponse.UpdateAccountResult.HasErrors == "false") {
						this.getGroupAccounts(component);
						this.hideSpinner(component);
						var toast = this.getToast("Success", "Restriction account updated successfully", "success");
						toast.fire();
					} else {
						var toast = this.getToast(
							"Error",
							responseBeanService.UpdateAccountResponse.UpdateAccountResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	deleteRestrictionAccount: function (component, groupAccountId) {
		this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		var groupAccounts = component.get("v.accounts");

		for (var key = 0; key < groupAccounts.length; key++) {
			if (groupAccounts[key].Id == groupAccountId) {
				var action = component.get("c.deleteAccountNode");
				action.setParams({
					accountId: groupAccountId,
					EffectiveStartDate: groupAccounts[key].EffectiveStartDate__c,
					GroupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
					AccountNumber: groupAccounts[key].AccountNumber__c
				});

				action.setCallback(
					this,
					$A.getCallback(function (response) {
						var state = response.getState();
						console.log("State -->" + state);
						if (component.isValid() && state === "SUCCESS") {
							console.log("SUCCESS");
							console.log("Returned Value -->" + response.getReturnValue());
							var responseBeanService = JSON.parse(response.getReturnValue());
							if (responseBeanService != null) {
								if (responseBeanService.DeleteAccountResponse.DeleteAccountResult.HasErrors == "false") {
									this.getGroupAccounts(component);
									window.location.reload();
									this.hideSpinner(component);
									var toast = this.getToast("Success", "Restriction account deleted successfully", "success");
									toast.fire();
								} else {
									this.hideSpinner(component);
									var toast = this.getToast(
										"Error",
										responseBeanService.DeleteAccountResponse.DeleteAccountResult.ValidationErrors.ServiceValidationResult[0].Message,
										"Error"
									);
									toast.fire();
								}
							} else {
								this.hideSpinner(component);
								var toast = this.getToast("Error", "Something went wrong , please contact system adminstrator", "Error");
								toast.fire();
							}
						} else if (state === "ERROR") {
							this.hideSpinner(component);
							var errors = response.getError();
							if (errors) {
								if (errors[0] && errors[0].message) {
									console.log("Error message: " + errors[0].message);
									var toast = helper.getToast("Error", errors[0].message, "error");
									toast.fire();
								}
							}
						}
					})
				);

				$A.enqueueAction(action);
			}
		}
	},
	getTransactionTypeUI: function (component, helper) {
		//alert('In HMS helper function');
		var action = component.get("c.getTransactionType");
		//alert('Action after');
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var responseValue = JSON.parse(response.getReturnValue());
				var data = responseValue.GetGovernanceModelResponse.GetGovernanceModelResult.Data.GovernanceModelTransactionGroup;
				console.log("data " + responseValue.GetGovernanceModelResponse.GetGovernanceModelResult.Data.GovernanceModelTransactionGroup);
				var transData = [];
				for (var i = 0; i < data.length; i++) {
					transData.push(data[i]);
					if (data[i].TransactionTypes.GovernanceModelTransactionType.length > 0) {
						transData[i]._children = data[i].TransactionTypes.GovernanceModelTransactionType;
						delete data[i].TransactionTypes.GovernanceModelTransactionType;
					}
				}
				component.set("v.transactionTypesData", transData);
			}
		});
		$A.enqueueAction(action);
	},
	getAccountDetails: function (component, event, helper) {
		var action = component.get("c.getAccountDetails");
		var clientAccountId = component.get("v.accountNumberFromFlow");
		action.setParams({
			clientAccountId: clientAccountId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("Service Response --->" + response.getReturnValue());
				component.set("v.responseToFlow", response.getReturnValue()); //Added by chandra dated 11/12/2020

				var respObj = JSON.parse(response.getReturnValue());
				component.set("v.responseList", respObj);
			}
		});
		$A.enqueueAction(action);
		component.set("v.isButtonDisabled", true);
	},

	getExcludedAccounts: function (component) {
		//this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var action = component.get("c.getExcludedAccountNodes");
		action.setParams({
			restrictionGroupId: selectedRestrictionGroup.Id //"a469E000000BBlJQAW"//selectedRestrictionGroup.Id
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rows = response.getReturnValue();
				console.log("Length --> " + rows.length);
				if (rows.length >= 1) {
					component.set("v.excludedAccounts", response.getReturnValue());
					this.hideSpinner(component);
				} else {
					component.set("v.excludedAccounts", null);
					this.hideSpinner(component);
				}
			}
		});

		$A.enqueueAction(action);
	},

	createExcludedAccount: function (component) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var accountNumber = component.get("v.accountNumber");
		var accountDescription = component.get("v.AccountDescription") == undefined ? "null" : component.get("v.AccountDescription");
		var accountEffectiveStartDate = component.get("v.accountEffectiveStartDate");
		var accountEffectiveEndDate = component.get("v.accountEffectiveEndDate");
		var isInfinity = component.find("checkbox").get("v.checked");

		console.log("Account List -->" + accountNumber);
		console.log("Account List -->" + accountDescription);
		console.log("Account List -->" + accountEffectiveStartDate);
		console.log("Account List -->" + accountEffectiveEndDate);

		console.log("selectedRestrictionGroup" + JSON.stringify(selectedRestrictionGroup));

		console.log("checkboxSelect" + isInfinity);
		var action = component.get("c.createExcludedAccountNode");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionName: selectedRestrictionGroup.Restriction_ID__c,
			clusterId: "",
			accountNumber: accountNumber,
			accountDescription: accountDescription,
			accountEffectiveStartDate: accountEffectiveStartDate,
			accountEffectiveEndDate: accountEffectiveEndDate,
			isInfinity: isInfinity
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					this.hideSpinner(component);
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						var res = responseBeanService.AddExcludedAccountResponse.AddExcludedAccountResult.HasErrors;
						console.log(typeof res);
						if (responseBeanService.AddExcludedAccountResponse.AddExcludedAccountResult.HasErrors === "false") {
							component.set("v.openExcludedAccount", false);
							var msg = responseBeanService.AddExcludedAccountResponse.AddExcludedAccountResult.Information.ServiceInformationResult[0].Message;
							var toast = this.getToast("Success", msg, "success");
							toast.fire();
							this.getExcludedAccounts(component);
						} else if (responseBeanService.AddExcludedAccountResponse.AddExcludedAccountResult.HasErrors === "true") {
							//component.set("v.openExcludedAccount" , false);
							var msg =
								responseBeanService.AddExcludedAccountResponse.AddExcludedAccountResult.ValidationErrors.ServiceValidationResult[0].Message;
							var toast = this.getToast("Error", msg, "error");
							toast.fire();
							//
						} else {
							console.log("inside else");
							var toast = this.getToast("Error", "Something went wrong , please contact system adminstrator", "error");
							toast.fire();
						}
					} else {
						console.log("inside else");
						var toast = this.getToast("Error", "Something went wrong , please contact system adminstrator", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					component.set("v.openExcludedAccount", false);
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							// alert("Error message: " + errors[0].message);
							var toast = this.getToast("Error", "Error :" + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},
	createExcludedAccounts: function (component, accountList) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var accountNumber = component.get("v.accountNumber");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var isInfinite = component.find("checkbox").get("v.checked");
		var errorCount = 0;
		console.log("accountNumber " + accountNumber);
		console.log("Account List -->" + JSON.stringify(accountList));
		console.log("selectedRestrictionGroup" + JSON.stringify(selectedRestrictionGroup));
		var action = component.get("c.createExcludedAccountNodes");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionName: selectedRestrictionGroup.Restriction_ID__c,
			accounts: JSON.stringify(accountList),
			startDate: startDate,
			endDate: endDate,
			isInfinite: isInfinite
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				this.hideSpinner(component);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						component.set("v.openExcludedAccount", false);
						this.getExcludedAccounts(component);
						this.hideSpinner(component);
						var toast = this.getToast("Success", responseBeanService, "Success");
						toast.fire();
					} else {
						component.set("v.openExcludedAccount", false);
						this.hideSpinner(component);
						var toast = this.getToast("Error", "Something went wrong", "Error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					//component.set("v.openExcludedAccount" , false);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							//errorCount++;
							var toast = this.getToast("Error", "Error : " + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	updateExcludedAccount: function (component, excludedAccountId) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var accountNumber = component.get("v.accountNumber");
		var accountDescription = component.get("v.AccountDescription") == undefined ? "" : component.get("v.AccountDescription");
		var accountEffectiveStartDate = component.get("v.accountEffectiveStartDate");
		var accountEffectiveEndDate = component.get("v.accountEffectiveEndDate");
		var isInfinity = component.find("checkbox").get("v.checked");
		var originalEffectiveStartDate = component.get("v.OriginalEffectiveStartDate");
		console.log("Account List -->" + accountNumber);
		console.log("Account List -->" + accountDescription);
		console.log("Account List -->" + accountEffectiveStartDate);
		console.log("Account List -->" + accountEffectiveEndDate);

		console.log("selectedRestrictionGroup" + JSON.stringify(selectedRestrictionGroup));

		console.log("checkboxSelect" + isInfinity);
		var action = component.get("c.updateExcludedAccountNode");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionName: selectedRestrictionGroup.Restriction_ID__c,
			clusterId: "",
			excludedAccountId: excludedAccountId,
			accountNumber: accountNumber,
			accountDescription: accountDescription,
			accountEffectiveStartDate: accountEffectiveStartDate,
			accountEffectiveEndDate: accountEffectiveEndDate,
			isInfinity: isInfinity,
			originalEffectiveStartDate: originalEffectiveStartDate
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					this.hideSpinner(component);
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						if (responseBeanService.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.HasErrors === "false") {
							component.set("v.openExcludedAccount", false);
							var msg =
								responseBeanService.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.Information.ServiceInformationResult[0].Message;
							var toast = this.getToast("Success", msg, "success");
							toast.fire();
							this.getExcludedAccounts(component);
							//
						} else if (responseBeanService.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.HasErrors === "true") {
							//component.set("v.openExcludedAccount" , false);
							var msg =
								responseBeanService.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.ValidationErrors.ServiceValidationResult[0]
									.Message;
							//alert('Error : '+msg);
							var toast = this.getToast("Error", msg, "error");
							toast.fire();
						} else {
							console.log("inside else");
							var toast = this.getToast("Error", "Error", "error");
							toast.fire();
						}
					} else {
						var toast = this.getToast("Error", "Something went wrong , please contact system adminstrator", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					component.set("v.openExcludedAccount", false);
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							//alert("Error message: " + errors[0].message);
							var toast = this.getToast("Error", "Error : " + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	deleteExcludedAccount: function (component, excludedAccountId) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var accountNumber = component.get("v.accountNumber");
		var accountEffectiveStartDate = component.get("v.accountEffectiveStartDate");
		var accountEffectiveEndDate = component.get("v.accountEffectiveEndDate");
		var action = component.get("c.deleteExcludedAccountNode");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionName: selectedRestrictionGroup.Restriction_ID__c,
			clusterId: "",
			excludedAccountId: excludedAccountId,
			accountNumber: accountNumber,
			accountEffectiveStartDate: accountEffectiveStartDate
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					this.hideSpinner(component);
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.DeleteExcludedAccountResponse.DeleteExcludedAccountResult.HasErrors === "false") {
						component.set("v.isRemoveExcludedAccountOpen", false);
						var msg = "Deleted Successfully";
						var toast = this.getToast("Success", msg, "success");
						toast.fire();
						this.getExcludedAccounts(component);
						//window.location.reload();
						//
					} else if (responseBeanService.UpdateExcludedAccountResponse.UpdateExcludedAccountResult.HasErrors === "true") {
						component.set("v.isRemoveExcludedAccountOpen", false);
						var msg = "Error";
						//alert('Error : '+msg);
						var toast = this.getToast("Error", msg, "error");
						toast.fire();
					} else {
						component.set("v.isRemoveExcludedAccountOpen", false);
						console.log("inside else");
						var toast = this.getToast("Error", "Error", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					component.set("v.isRemoveExcludedAccountOpen", false);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							//alert("Error message: " + errors[0].message);
							var toast = this.getToast("Error", "Error : " + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	effictiveStartDate: function (component) {
		const date = new Date();
		date.setDate(date.getDate() + 7);

		var month = "" + (date.getMonth() + 1),
			day = "" + date.getDate(),
			year = date.getFullYear();

		if (month.length < 2) month = "0" + month;
		if (day.length < 2) day = "0" + day;

		console.log("Today's date " + year + "-" + month + "-" + day);

		return year + "-" + month + "-" + day;
	},
	formValidations: function (component, skip) {
		var count = 0;

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

		if (
			component.get("v.accountEffectiveStartDate") > component.get("v.accountEffectiveEndDate") &&
			component.get("v.accountEffectiveStartDate") != "" &&
			component.get("v.accountEffectiveEndDate") != ""
		) {
			count++;
			this.hideSpinner(component);
			//alert('Enddate should be > StartDate');
			var toast = this.getToast("error", "End date should be greater than Start date", "error");
			toast.fire();
		} else if (component.get("v.accountEffectiveStartDate") == "" || component.get("v.accountEffectiveStartDate") == null) {
			count++;
			this.hideSpinner(component);
			//alert('Start Date is Blank');
			var toast = this.getToast("error", "Start Date Can't be Blank", "error");
			toast.fire();
		} else if (component.get("v.accountEffectiveEndDate") == "" || component.get("v.accountEffectiveEndDate") == null) {
			count++;
			this.hideSpinner(component);
			//alert('End Date is Blank');
			var toast = this.getToast("error", "End Date Can't be Blank", "error");
			toast.fire();
		} else if ((component.get("v.accountNumber") == "" || component.get("v.accountNumber") == null) & (skip == false)) {
			count++;
			this.hideSpinner(component);
			//alert('Account Number is Blank');
			var toast = this.getToast("error", "Account Number Can't be Blank", "error");
			toast.fire();
		} else if (component.get("v.accountEffectiveEndDate") < todayFormattedDate && component.get("v.accountEffectiveEndDate") != "") {
			count++;
			this.hideSpinner(component);
			//alert('Account Number is Blank');
			var toast = this.getToast("error", "End Date Muste be in future", "error");
			toast.fire();
		} else if (component.get("v.accountEffectiveStartDate") < todayFormattedDate && component.get("v.accountEffectiveStartDate") != "") {
			count++;
			this.hideSpinner(component);
			//alert('Account Number is Blank');
			var toast = this.getToast("error", "Start Date Muste be in future", "error");
			toast.fire();
		}
		return count;
	},

	//ADD CUSTOMER START HERE
	CreateRestrictionCustomer: function (component, accountList) {
		var customerDescription = component.get("v.customerDescription");
		var customerKey = component.get("v.customerKey");
		var customerStartDate = component.get("v.customerStartDate");
		var customerEndDate = component.get("v.customerEndDate");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var checkBoxValue = component.find("customerCheckboxId").get("v.checked");

		var action = component.get("c.createCustomerNode");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			customerKey: customerKey,
			description: customerDescription,
			effectiveStartDate: customerStartDate,
			effectiveEndDate: customerEndDate,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			isInfinity: checkBoxValue
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");

					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());

					var HasErrors = responseBeanService.AddCustomerResponse.AddCustomerResult.HasErrors;
					if (HasErrors == "false") {
						console.log("err " + HasErrors);
						this.getCustomerDetails(component);
						var toast = this.getToast("Success", "Customer added successfully", "success");
						toast.fire();
						component.set("v.showIncludedAccountDetails", false);
					} else {
						var msg = responseBeanService.AddCustomerResponse.AddCustomerResult.ValidationErrors.ServiceValidationResult;
						var errMsg = responseBeanService.AddCustomerResponse.AddCustomerResult.ValidationErrors.ServiceValidationResult[0].Message;
						console.log("err " + HasErrors);
						var toast = this.getToast("Error", errMsg, "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	updateRestrictionCustomer: function (component) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var customerKey = component.get("v.customerKey");
		var customerDescription = component.get("v.customerDescription") == undefined ? "" : component.get("v.customerDescription");
		var customerStartDate = component.get("v.customerStartDate");

		var customerEndDate = component.get("v.customerEndDate");
		var isInfinity = component.find("customerCheckboxId").get("v.checked");
		var originalEffectiveStartDate = component.get("v.OriginalEffectiveStartDate");
		var customerAccountId = component.get("v.customerAccountId");

		var action = component.get("c.updateCustomerNode");
		action.setParams({
			customerAccountId: customerAccountId,
			customerKey: customerKey,
			description: customerDescription,
			startDate: customerStartDate,
			endDate: customerEndDate,
			groupRestrictionObjectId: selectedRestrictionGroup.Restriction_ID__c,
			originalEffectiveStartDate: originalEffectiveStartDate,
			isInfinity: isInfinity
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());

					this.hideSpinner(component);
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.UpdateCustomerResponse.UpdateCustomerResult.HasErrors === "false") {
						component.set("v.createCustomer", false);
						var msg = responseBeanService.UpdateCustomerResponse.UpdateCustomerResult.Information.ServiceInformationResult[0].Message;
						var toast = this.getToast("Success", msg, "success");
						toast.fire();
						this.getCustomerDetails(component);
					} else if (responseBeanService.UpdateCustomerResponse.UpdateCustomerResult.HasErrors === "true") {
						var msg = responseBeanService.UpdateCustomerResponse.UpdateCustomerResult.ValidationErrors.ServiceValidationResult[0].Message;
						var toast = this.getToast("Error", msg, "error");
						toast.fire();
					} else {
						console.log("inside else");
						var toast = this.getToast("Error", "Error", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					component.set("v.openExcludedAccount", false);
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							//alert("Error message: " + errors[0].message);
							var toast = this.getToast("Error", "Error : " + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	deleteCustomer: function (component, customerAccountId) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var customerKey = component.get("v.customerKey");
		var customerStartDate = component.get("v.customerStartDate");
		var customerEndDate = component.get("v.customerEndDate");
		var action = component.get("c.deleteCustomer");

		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			customerId: customerAccountId,
			customerKey: customerKey,
			customerEffectiveStartDate: customerStartDate
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					this.hideSpinner(component);
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.DeleteCustomerResponse.DeleteCustomerResult.HasErrors === "false") {
						component.set("v.isRemoveCustomerOpen", false);
						var msg = "Deleted Successfully";
						var toast = this.getToast("Success", msg, "success");
						toast.fire();
						this.getCustomerDetails(component);
					} else if (responseBeanService.DeleteCustomerResponse.DeleteCustomerResult.HasErrors === "true") {
						component.set("v.isRemoveCustomerOpen", false);
						var msg = "Error";
						var toast = this.getToast("Error", msg, "error");
						toast.fire();
					} else {
						component.set("v.isRemoveCustomerOpen", false);
						console.log("inside else");
						var toast = this.getToast("Error", "Error", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					component.set("v.isRemoveCustomerOpen", false);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", "Error : " + errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	getCustomerDetails: function (component, event, helper) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		var action = component.get("c.getGroupCustomer");
		action.setParams({
			restrictionGroupId: selectedRestrictionGroup.Id
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = response.getReturnValue();
				if (respObj.length > 0) {
					var respObj = JSON.stringify(response.getReturnValue());
					component.set("v.responseCustomerList", response.getReturnValue());
					component.set("v.createCustomer", false);
					component.set("v.showIncludedAccountDetails", false);
					component.set("v.showExcludedAccountDetails", true);
				} else {
					component.set("v.responseCustomerList", null);
					component.set("v.showIncludedAccountDetails", true);
					component.set("v.showExcludedAccountDetails", false);
				}
			}
		});
		$A.enqueueAction(action);
	},
	retrieveAccount: function (component, event, helper) {
		var clientAccountId = component.get("v.accountNumberFromFlow");
		var action = component.get("c.getClientCIF");
		action.setParams({
			clientAccountId: clientAccountId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var respObj = response.getReturnValue();
				console.log("Service" + respObj);
				component.set("v.customerKey", respObj);
			}
		});
		$A.enqueueAction(action);
	},

	getTTRecords: function (component) {
		//this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var action = component.get("c.fetchTransactionTypesMain");
		action.setParams({
			groupRestrictionId: selectedRestrictionGroup.Id //"a469E000000BBlJQAW"//selectedRestrictionGroup.Id
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var rows = response.getReturnValue();
				console.log("Length --> " + rows.length);
				if (rows.length >= 1) {
					component.set("v.selectedTransactionTypesDataMain", response.getReturnValue());
					this.hideSpinner(component);
				} else {
					component.set("v.selectedTransactionTypesDataMain", null);
					this.hideSpinner(component);
				}
			}
		});

		$A.enqueueAction(action);
	},

	addingTransactionTypes: function (component, event, transactionTypeList, groupList) {
		//component.set("v.isTransactionTypeOpen", false);
		// alert('In the helper class');
		var ttJSON = JSON.stringify(transactionTypeList);
		console.log("Selected TT List -->" + transactionTypeList);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		var ttsDate = component.get("v.transactionTypeEffectiveStartDate");
		var tteDate = component.get("v.transactioTypeEffectiveEndDate");
		//var childData = [];
		if (transactionTypeList != undefined && groupList != undefined) {
			//alert('Inside undefined condition');
			//alert(childData);

			//for(var i = 0 ; i < transactionTypeList.length ; i++){

			var action = component.get("c.addTransactionTypesNode");
			action.setParams({
				//"objectID" : transactionTypeList[i].ObjectID,
				groupRestrictionId: selectedRestrictionGroup.Id,
				groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
				startdate: ttsDate,
				enddate: tteDate,
				isinfinity: "false",
				transactionTypeList: JSON.stringify(transactionTypeList)
				//"decsription":  transactionTypeList[i].Description,
				//"level" : transactionTypeList[i].level,
				//"hasChildren" : transactionTypeList[i].hasChildren,
				//"isExpanded" : transactionTypeList[i].isExpanded,
			});
			action.setCallback(
				this,
				$A.getCallback(function (response) {
					var state = response.getState();
					console.log("State -->" + state);
					if (component.isValid() && state === "SUCCESS") {
						console.log("SUCCESS");
						console.log("Returned Value -->" + response.getReturnValue());
						var responseBeanService = JSON.parse(response.getReturnValue());
						if (responseBeanService != null) {
							var toast = this.getToast("Success", responseBeanService, "success");
							toast.fire();
							this.getTTRecords(component);
						} else {
							var toast = this.getToast("Error", "Error", "errro");
							toast.fire();
						}
					} else if (state === "ERROR") {
						var errors = response.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								console.log("Error message: " + errors[0].message);
								var toast = this.getToast("Error", errors[0].message, "error");
								toast.fire();
							}
						}
					}
				})
			);

			$A.enqueueAction(action);
			//}

			/*var actionttmain = component.get("c.fetchTransactionTypesMain");
            actionttmain.setParams({
                "groupRestrictionId" : selectedRestrictionGroup.Id                
            });
            alert("groupRestrictionId", +selectedRestrictionGroup.Id);
            actionttmain.setCallback(this, $A.getCallback(function (response){
            var state = response.getState();
            if(component.isValid() && state ==="SUCCESS"){
                console.log("Trasaction Types are successfully Inserted::");
                var returnvalues = response.getReturnValue();
                console.log('Returned values>>>>>>>>>>>>' +returnvalues);
                component.set('v.selectedTransactionTypesDataMain', returnvalues);
                console.log('Returned Values from the Transaction Type object::::::::' +returnvalues);
            
        	}
            
    	}));
            $A.enqueueAction(actionttmain); */
		}
	},
	getRestrictionGrpDetails: function (component) {
		var restrictiongrpId = component.get("v.restrictionGrpId");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var action = component.get("c.restrictionGrpRelatedInfo");
		action.setParams({
			restrictionGrpId: selectedRestrictionGroup.Id //restrictiongrpId
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value -->" + JSON.stringify(response.getReturnValue()));
					var customers = [];
					var accounts = [];
					var excludedAccounts = [];
					var transactionTypes = [];
					var childRecords = [];
					var responseBean = response.getReturnValue();
					for (var i = 0; i < responseBean.customers.length; i++) {
						responseBean.customers[i].Name = responseBean.customers[i].CustomerKey__c;
						responseBean.customers[i].Type = "Customer";
						customers.push(responseBean.customers[i]);
						childRecords.push(responseBean.customers[i]);
					}
					for (var i = 0; i < responseBean.accounts.length; i++) {
						responseBean.accounts[i].Name = responseBean.accounts[i].AccountNumber__c;
						responseBean.accounts[i].Type = "Account";
						accounts.push(responseBean.accounts[i]);
						childRecords.push(responseBean.accounts[i]);
					}
					for (var i = 0; i < responseBean.excludedAccounts.length; i++) {
						responseBean.excludedAccounts[i].Name = responseBean.excludedAccounts[i].AccountNumber__c;
						responseBean.excludedAccounts[i].Type = "Excluded Account";
						excludedAccounts.push(responseBean.excludedAccounts[i]);
						childRecords.push(responseBean.excludedAccounts[i]);
					}
					for (var i = 0; i < responseBean.transactions.length; i++) {
						responseBean.transactions[i].EffectiveStartDate__c = responseBean.transactions[i].Effective_Start_Date__c;
						responseBean.transactions[i].EffectiveEndDate__c = responseBean.transactions[i].Effective_End_Date__c;
						responseBean.transactions[i].Type = "Transaction Type";
						transactionTypes.push(responseBean.transactions[i]);
						childRecords.push(responseBean.transactions[i]);
					}
					var restrictionGrpData = [{}];
					restrictionGrpData[0].Name = selectedRestrictionGroup.Restriction_ID__c;
					(restrictionGrpData[0].Id = "Group Restriciton"),
						(restrictionGrpData[0].EffectiveStartDate__c = selectedRestrictionGroup.EffectiveStartDate__c);
					restrictionGrpData[0].EffectiveEndDate__c = selectedRestrictionGroup.EffectiveEndDate__c;
					restrictionGrpData[0].Type = "Group Restriciton";
					restrictionGrpData[0].Description__c = selectedRestrictionGroup.Description__c;
					var data = [
						{ Id: "Customers", Name: "Customers" },
						{ Id: "Accounts", Name: "Accounts" },
						{ Id: "Excluded Accounts", Name: "Excluded Accounts" },
						{ Id: "Transaction Types", Name: "Transaction Types" }
					];
					for (var i = 0; i < data.length; i++) {
						if (data[i].Name == "Customers") {
							data[i]._children = customers;
						} else if (data[i].Name == "Accounts") {
							data[i]._children = accounts;
						} else if (data[i].Name == "Excluded Accounts") {
							data[i]._children = excludedAccounts;
						} else if (data[i].Name == "Transaction Types") {
							data[i]._children = transactionTypes;
						}
					}
					restrictionGrpData[0]._children = data;
					console.log("data" + JSON.stringify(restrictionGrpData));
					component.set("v.restrictionGrpData", restrictionGrpData);
					component.set("v.restrictionGrpDataCopy", restrictionGrpData);
					component.set("v.childRecords", childRecords);
					component.set("v.expandedDateAjustRows", ["Group Restriciton"]);
					/*var checkedValue = component.find("endDateCheck").set("v.checked", true);
                component.set("v.accountEffectiveEndDate", "4000-12-31");
                component.set("v.isInfinity", true);*/
					//component.find('dateAdjustTable').expandAll();
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	updateDates: function (component, records) {
		//alert('inside');
		var action = component.get("c.bulkUpdateDates");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var isInfinity = component.get("v.isInfinity");
		action.setParams({
			startDate: startDate,
			endDate: endDate,
			isInfinity: isInfinity,
			objectId: selectedRestrictionGroup.Restriction_ID__c,
			records: JSON.stringify(records)
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					component.set("v.isConfirm", false);
					console.log("Returned Value -->" + JSON.stringify(response.getReturnValue()));
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						this.hideSpinner(component);
						component.set("v.accountEffectiveStartDate", "");
						component.set("v.accountEffectiveEndDate", "");
						component.set("v.selectedRowsDateAdjsut", "");
						component.set("v.currentSelected", "");
						component.set("v.isInfinity", false);
						this.getGroupAccounts(component);
						this.getExcludedAccounts(component);
						this.getCustomerDetails(component);
						this.getTTRecords(component);
						var toast = this.getToast("Success", responseBeanService, "success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast("Error", "Error", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					component.set("v.isConfirm", false);
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	updateSelectedDateAdjustRow: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var restrictionGrpDataCopy = component.get("v.restrictionGrpDataCopy");
		var tempRec = JSON.parse(JSON.stringify(restrictionGrpDataCopy));
		var data = tempRec[0]["_children"];
		var currentSelected = component.get("v.currentSelected");
		var selectedData = [];
		var tempList = [];
		helper.keepSelectionPersistent(component, data, currentSelected, tempList);
		for (var i = 0; i < selectedRows.length; i++) {
			tempList.push(selectedRows[i].Id);
		}
		for (var j = 0; j < data.length; j++) {
			// if header was not checked but is now checked, add sub-rows
			if (!currentSelected.includes(data[j].Id) && tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						if (!tempList.includes(item.Id)) {
							tempList.push(item.Id);
						}
					});
				}
			}

			// if header was checked and is no longer checked, remove header and sub-rows
			if (currentSelected.includes(data[j].Id) && !tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						const index = tempList.indexOf(item.Id);
						if (index > -1) {
							tempList.splice(index, 1);
						}
					});
				}
			}

			// if all child rows for the header row are checked, add the header
			// else remove the header
			var allSelected = true;
			if (data[j].hasOwnProperty("_children") && data[j]["_children"].length > 0) {
				data[j]["_children"].forEach((item) => {
					if (!tempList.includes(item.Id)) {
						allSelected = false;
					}
				});

				if (allSelected && !tempList.includes(data[j].Id)) {
					tempList.push(data[j].Id);
				} else if (!allSelected && tempList.includes(data[j].Id)) {
					const index = tempList.indexOf(data[j].Id);
					if (index > -1) {
						tempList.splice(index, 1);
					}
				}
			}
		}
		var uniqueList = [...new Set(tempList)];
		component.set("v.selectedRowsDateAdjsut", uniqueList);
		component.set("v.currentSelected", uniqueList);
		console.log("tempList" + JSON.stringify(uniqueList));
	},

	keepSelectionPersistent: function (component, data, currentSelected, tempList) {
		var toggledRows = component.get("v.toggledIds");
		toggledRows.forEach((row) => {
			data.forEach((rowData) => {
				if (rowData.Id === row) {
					rowData["_children"].forEach((item) => {
						currentSelected.forEach((current) => {
							console.log("current " + current + "item.Id " + item.Id);
							if (current === item.Id) {
								tempList.push(current);
							}
						});
					});
				}
			});
		});
		console.log("tempList " + JSON.stringify(tempList));
	},

	bulkDeleteNode: function (component, event, helper, records) {
		this.showSpinner(component);
		var action = component.get("c.bulkDeleteNodes");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		action.setParams({
			objectId: selectedRestrictionGroup.Restriction_ID__c,
			records: JSON.stringify(records)
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					component.set("v.isConfirmDeleteNode", false);
					console.log("Returned Value -->" + JSON.stringify(response.getReturnValue()));
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						if (responseBeanService.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.HasErrors == "false") {
							this.hideSpinner(component);
							component.set("v.accountEffectiveStartDate", "");
							component.set("v.accountEffectiveEndDate", "");
							component.set("v.selectedRowsDateAdjsut", "");
							component.set("v.currentSelected", "");
							component.set("v.isInfinity", false);
							this.getGroupAccounts(component);
							this.getExcludedAccounts(component);
							this.getCustomerDetails(component);
							this.getTTRecords(component);
							var toast = this.getToast("Success", "Nodes Deleted Successfully", "success");
							toast.fire();
						} else {
							this.hideSpinner(component);
							if (responseBeanService.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.ValidationErrors != null) {
								var toast = this.getToast(
									"Error",
									responseBeanService.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.ValidationErrors.ServiceValidationResult[0].Message,
									"Error"
								);
								toast.fire();
							} else {
								var toast = this.getToast(
									"Error",
									responseBeanService.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.SystemErrorMessage,
									"Error"
								);
								toast.fire();
							}
						}
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.DeleteSchemeNodesResponse.DeleteSchemeNodesResult.ValidationErrors.ServiceValidationResult[0].Message,
							"error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					component.set("v.isConfirm", false);
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	updateSelectedDeleteNodeRow: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var restrictionGrpDataCopy = component.get("v.restrictionGrpDataCopy");
		var tempRec = JSON.parse(JSON.stringify(restrictionGrpDataCopy));
		var data = tempRec[0]["_children"];
		var currentSelected = component.get("v.currentSelected");
		var selectedData = [];
		var tempList = [];
		helper.keepSelectionPersistent(component, data, currentSelected, tempList);
		for (var i = 0; i < selectedRows.length; i++) {
			tempList.push(selectedRows[i].Id);
		}
		for (var j = 0; j < data.length; j++) {
			// if header was not checked but is now checked, add sub-rows
			if (!currentSelected.includes(data[j].Id) && tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						if (!tempList.includes(item.Id)) {
							tempList.push(item.Id);
						}
					});
				}
			}

			// if header was checked and is no longer checked, remove header and sub-rows
			if (currentSelected.includes(data[j].Id) && !tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						const index = tempList.indexOf(item.Id);
						if (index > -1) {
							tempList.splice(index, 1);
						}
					});
				}
			}

			/*if( currentSelected.includes(data[j].Id) && tempList.includes(data[j].Id)){
                    if (data[j].hasOwnProperty('_children')) {
                        data[j]['_children'].forEach(item => {
                            if (!tempList.includes(item.Id)) {
                            tempList.push(item.Id);
                        }
                                                     })
                    }
                }*/

			// if all child rows for the header row are checked, add the header
			// else remove the header
			var allSelected = true;
			if (data[j].hasOwnProperty("_children") && data[j]["_children"].length > 0) {
				data[j]["_children"].forEach((item) => {
					if (!tempList.includes(item.Id)) {
						allSelected = false;
					}
				});

				if (allSelected && !tempList.includes(data[j].Id)) {
					tempList.push(data[j].Id);
				} else if (!allSelected && tempList.includes(data[j].Id)) {
					const index = tempList.indexOf(data[j].Id);
					if (index > -1) {
						tempList.splice(index, 1);
					}
				}
			}
		}
		var uniqueList = [...new Set(tempList)];
		component.set("v.selectedRowsDelNode", uniqueList);
		component.set("v.currentSelected", uniqueList);
		console.log("tempList" + JSON.stringify(uniqueList));
	},

	updateTransTypeParam: function (component, event, helper, recId) {
		//alert('Inside updateTransTypeParam function');
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		//var origData = component.get("v.updateTransactionTypesData");
		var upTType = component.get("v.transType");
		console.log("upTType=======??????????" + upTType);
		var upTDesc = component.get("v.transDescription");
		console.log("upTDesc=====>>>>>>>" + upTDesc);
		var upTTStartDate = component.get("v.updateTransTypeStartDate");
		console.log("upTTStartDate=======>>>>>>" + upTTStartDate);
		var upTTEndDate = component.get("v.updateTransTypeEndDate");
		console.log("upTTEndDate============" + upTTEndDate);
		var origTTDate = component.get("v.updateTransTypeStartDate");
		console.log("origTTDate=======??????????" + origTTDate);
		var isInfinity = component.find("checkbox").get("v.checked");
		console.log("isInfinity==================>>>>>" + isInfinity);
		var origEffDate = component.get("v.ttOriginalEffectiveStartDate");
		console.log("origEffDate ========>>>>>>>>" + origEffDate);

		var action = component.get("c.updateTransactionTypesNode");
		//alert('After calling the apex method');
		action.setParams({
			objectID: upTType,
			decsription: upTDesc,
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			startdate: upTTStartDate,
			enddate: upTTEndDate,
			isinfinity: isInfinity,
			//"ttorigeffdate" : upTTStartDate,
			ttorigeffdate: origEffDate,
			recordId: recId
			//"transactionTypeList": JSON.stringify(transactionTypeList)
		});
		//alert('After the action set params');

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				//alert('State SUCCESS');
				if (state === "SUCCESS") {
					var returnValues = response.getReturnValue();
					console.log("After update response====>>>>>>>>>>>>" + returnValues);
					var toast = this.getToast("Success", "Updated successfully", "success");
					toast.fire();
					this.getTTRecords(component);
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							alert(errors[0].message);
						}
					}
				}
			})
		);
		$A.enqueueAction(action);
	},

	delTransactionType: function (component, recId) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		var rTType = component.get("v.rtransType");
		console.log("rTType=======??????????" + rTType);
		var rTDesc = component.get("v.rtransDescription");
		var rTTStartDate = component.get("v.rTransTypeStartDate");
		var rTTEndDate = component.get("v.rTransTypeEndDate");
		console.log("rTTStartDate=======??????????" + rTTStartDate);
		console.log("Record ID of the transaction type before set params:::" + recId);
		console.log("Group restriction Object ID in helper:::" + selectedRestrictionGroup.Restriction_ID__c);
		console.log("Group restriction ID in helper:::" + selectedRestrictionGroup.Id);

		var action = component.get("c.deleteTransactionTypesNode");
		action.setParams({
			objectID: rTType,
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			startdate: rTTStartDate,
			recordId: recId
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				console.log("After update response====>>>>>>>>>>>>", +returnValues);
				var toast = this.getToast("Success", "Deleted successfully", "success");
				toast.fire();
				this.getTTRecords(component);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						alert("Remove Transaction Type --> " + errors[0].message);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},
	updateSelectedExpireNodeRow: function (component, event, helper) {
		var selectedRows = event.getParam("selectedRows");
		var restrictionGrpDataCopy = component.get("v.restrictionGrpDataCopy");
		var tempRec = JSON.parse(JSON.stringify(restrictionGrpDataCopy));
		var data = tempRec[0]["_children"];
		var currentSelected = component.get("v.currentSelected");
		var selectedData = [];
		var tempList = [];
		helper.keepSelectionPersistent(component, data, currentSelected, tempList);
		for (var i = 0; i < selectedRows.length; i++) {
			tempList.push(selectedRows[i].Id);
		}
		for (var j = 0; j < data.length; j++) {
			// if header was not checked but is now checked, add sub-rows
			if (!currentSelected.includes(data[j].Id) && tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						if (!tempList.includes(item.Id)) {
							tempList.push(item.Id);
						}
					});
				}
			}

			// if header was checked and is no longer checked, remove header and sub-rows
			if (currentSelected.includes(data[j].Id) && !tempList.includes(data[j].Id)) {
				if (data[j].hasOwnProperty("_children")) {
					data[j]["_children"].forEach((item) => {
						const index = tempList.indexOf(item.Id);
						if (index > -1) {
							tempList.splice(index, 1);
						}
					});
				}
			}

			/*if( currentSelected.includes(data[j].Id) && tempList.includes(data[j].Id)){
                    if (data[j].hasOwnProperty('_children')) {
                        data[j]['_children'].forEach(item => {
                            if (!tempList.includes(item.Id)) {
                            tempList.push(item.Id);
                        }
                                                     })
                    }
                }*/

			// if all child rows for the header row are checked, add the header
			// else remove the header
			var allSelected = true;
			if (data[j].hasOwnProperty("_children") && data[j]["_children"].length > 0) {
				data[j]["_children"].forEach((item) => {
					if (!tempList.includes(item.Id)) {
						allSelected = false;
					}
				});

				if (allSelected && !tempList.includes(data[j].Id)) {
					tempList.push(data[j].Id);
				} else if (!allSelected && tempList.includes(data[j].Id)) {
					const index = tempList.indexOf(data[j].Id);
					if (index > -1) {
						tempList.splice(index, 1);
					}
				}
			}
		}
		var uniqueList = [...new Set(tempList)];
		component.set("v.selectedRowsExpireNode", uniqueList);
		component.set("v.currentSelected", uniqueList);
		console.log("tempList" + JSON.stringify(uniqueList));
	},
	bulkExpireNode: function (component, event, helper, records) {
		var expireDate = component.get("v.expiryDate");
		//var expireDate = '2021-03-25';
		this.showSpinner(component);
		var action = component.get("c.bulkExpireGroupNodes");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");

		action.setParams({
			objectId: selectedRestrictionGroup.Restriction_ID__c,
			records: JSON.stringify(records),
			expiryDate: expireDate
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value -->" + JSON.stringify(response.getReturnValue()));
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService != null) {
						this.hideSpinner(component);

						var toast = this.getToast("Success", responseBeanService, "success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast("Error", "Error", "error");
						toast.fire();
					}
				} else if (state === "ERROR") {
					this.hideSpinner(component);
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	expireCustomer: function (component, customerID) {
		this.showSpinner(component);

		var customerDescription = component.get("v.customerDescription");
		var customerKey = component.get("v.customerKey");
		var customerStartDate = component.get("v.customerStartDate");
		var customerEndDate = component.get("v.customerEndDate");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var endDate = component.get("v.accountEffectiveEndDate");

		var action = component.get("c.expireCustomerNode");
		action.setParams({
			customerId: customerID,
			customerKey: customerKey,
			description: customerDescription,
			startDate: customerStartDate,
			endDate: endDate,
			groupRestrictionObjectId: selectedRestrictionGroup.Restriction_ID__c
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == "false") {
						this.hideSpinner(component);
						var toast = this.getToast("Success", "Restriction customer expired successfully", "success");
						toast.fire();
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							this.hideSpinner(component);
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	expireRestrictionAccount: function (component, groupAccountId) {
		this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var description = component.get("v.AccountDescription");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var accountNumber = component.get("v.accountNumber");

		var action = component.get("c.expireAccountNode");
		action.setParams({
			accountId: groupAccountId,
			accountNumber: accountNumber,
			description: description,
			startDate: startDate,
			endDate: endDate,
			groupRestrictionObjectId: selectedRestrictionGroup.Restriction_ID__c
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == "false") {
						this.hideSpinner(component);
						var toast = this.getToast("Success", "Restriction account expired successfully", "success");
						toast.fire();
						this.getGroupAccounts(component);
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							this.hideSpinner(component);
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},

	expireExcludedAccount: function (component, groupAccountId) {
		this.showSpinner(component);
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var description = component.get("v.AccountDescription");
		var startDate = component.get("v.accountEffectiveStartDate");
		var endDate = component.get("v.accountEffectiveEndDate");
		var accountNumber = component.get("v.accountNumber");

		var action = component.get("c.expireExcludedAccount");
		action.setParams({
			accountId: groupAccountId,
			accountNumber: accountNumber,
			description: description,
			startDate: startDate,
			endDate: endDate,
			groupRestrictionObjectId: selectedRestrictionGroup.Restriction_ID__c
		});
		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("SUCCESS");
					console.log("Returned Value -->" + response.getReturnValue());
					var responseBeanService = JSON.parse(response.getReturnValue());
					if (responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == "false") {
						this.hideSpinner(component);
						var toast = this.getToast("Success", "Restriction account expired successfully", "success");
						toast.fire();
						this.getExcludedAccounts(component);
					} else {
						this.hideSpinner(component);
						var toast = this.getToast(
							"Error",
							responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.ValidationErrors.ServiceValidationResult[0].Message,
							"Error"
						);
						toast.fire();
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							this.hideSpinner(component);
							console.log("Error message: " + errors[0].message);
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	},
	expireTransTypeParam: function (component, event, helper, recID) {
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		//var origData = component.get("v.updateTransactionTypesData");
		var exTType = component.get("v.transType");
		console.log("exTType=======?????????? in helper" + exTType);
		//var upTDesc = component.get("v.transDescription");
		var exTTStartDate = component.get("v.updateTransTypeStartDate");
		var exTTEndDate = component.get("v.updateTransTypeEndDate");
		var exRecID = component.get("v.ttRecordId");

		// var isInfinity = component.find("checkboxTT").get("v.checked");

		var action = component.get("c.expireTransactionTypesNode");
		action.setParams({
			objectID: exTType,
			groupRestrictionId: selectedRestrictionGroup.Id,
			groupRestrictionObjectID: selectedRestrictionGroup.Restriction_ID__c,
			startdate: exTTStartDate,
			enddate: exTTEndDate,
			//"recID" : exRecID
			recID: recID
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				console.log("SUCCESS");
				console.log("Returned Value -->" + response.getReturnValue());
				var responseBeanService = JSON.parse(response.getReturnValue());
				if (responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.HasErrors == "false") {
					this.hideSpinner(component);
					var toast = this.getToast("Success", "Expire successfully", "success");
					toast.fire();
					this.getTTRecords(component);
					component.set("v.isInfinityTT", false);
				} else {
					this.hideSpinner(component);
					var toast = this.getToast(
						"Error",
						responseBeanService.ExpireSchemeNodeResponse.ExpireSchemeNodeResult.ValidationErrors.ServiceValidationResult[0].Message,
						"Error"
					);
					toast.fire();
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						alert("Expire error message " + errors[0].message);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},
	getRestrictionGrpDetails1: function (component) {
		var restrictiongrpId = component.get("v.restrictionGrpId");
		var selectedRestrictionGroup = component.get("v.selectedRowDetailToShow");
		var action = component.get("c.restrictionGrpRelatedInfo");
		action.setParams({
			restrictionGrpId: selectedRestrictionGroup.Id //restrictiongrpId
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();
				console.log("State -->" + state);
				if (component.isValid() && state === "SUCCESS") {
					console.log("Returned Value -->" + JSON.stringify(response.getReturnValue()));
					var customers = [];
					var accounts = [];
					var excludedAccounts = [];
					var transactionTypes = [];
					var childRecords = [];
					var responseBean = response.getReturnValue();
					for (var i = 0; i < responseBean.customers.length; i++) {
						responseBean.customers[i].Name = responseBean.customers[i].CustomerKey__c;
						responseBean.customers[i].Type = "Customer";
						customers.push(responseBean.customers[i]);
						childRecords.push(responseBean.customers[i]);
					}
					for (var i = 0; i < responseBean.accounts.length; i++) {
						responseBean.accounts[i].Name = responseBean.accounts[i].AccountNumber__c;
						responseBean.accounts[i].Type = "Account";
						accounts.push(responseBean.accounts[i]);
						childRecords.push(responseBean.accounts[i]);
					}
					for (var i = 0; i < responseBean.excludedAccounts.length; i++) {
						responseBean.excludedAccounts[i].Name = responseBean.excludedAccounts[i].AccountNumber__c;
						responseBean.excludedAccounts[i].Type = "Excluded Account";
						excludedAccounts.push(responseBean.excludedAccounts[i]);
						childRecords.push(responseBean.excludedAccounts[i]);
					}
					for (var i = 0; i < responseBean.transactions.length; i++) {
						responseBean.transactions[i].EffectiveStartDate__c = responseBean.transactions[i].Effective_Start_Date__c;
						responseBean.transactions[i].EffectiveEndDate__c = responseBean.transactions[i].Effective_End_Date__c;
						responseBean.transactions[i].Type = "Transaction Type";
						transactionTypes.push(responseBean.transactions[i]);
						childRecords.push(responseBean.transactions[i]);
					}
					var restrictionGrpData = [{}];
					restrictionGrpData[0].Name = selectedRestrictionGroup.Restriction_ID__c;
					(restrictionGrpData[0].Id = "Group Restriciton"),
						(restrictionGrpData[0].EffectiveStartDate__c = selectedRestrictionGroup.EffectiveStartDate__c);
					restrictionGrpData[0].EffectiveEndDate__c = selectedRestrictionGroup.EffectiveEndDate__c;
					restrictionGrpData[0].Type = "Group Restriciton";
					restrictionGrpData[0].Description__c = selectedRestrictionGroup.Description__c;
					var data = [
						{ Id: "Customers", Name: "Customers" },
						{ Id: "Accounts", Name: "Accounts" },
						{ Id: "Excluded Accounts", Name: "Excluded Accounts" },
						{ Id: "Transaction Types", Name: "Transaction Types" }
					];
					for (var i = 0; i < data.length; i++) {
						if (data[i].Name == "Customers") {
							data[i]._children = customers;
						} else if (data[i].Name == "Accounts") {
							data[i]._children = accounts;
						} else if (data[i].Name == "Excluded Accounts") {
							data[i]._children = excludedAccounts;
						} else if (data[i].Name == "Transaction Types") {
							data[i]._children = transactionTypes;
						}
					}
					restrictionGrpData[0]._children = data;
					console.log("data" + JSON.stringify(restrictionGrpData));
					component.set("v.restrictionGrpData", restrictionGrpData);

					component.set("v.restrictionGrpDataCopy", restrictionGrpData);
					component.set("v.childRecords", childRecords);
					component.set("v.expandedDateAjustRows", ["Group Restriciton"]);
					/*
                var checkedValue = component.find("endDateCheck").set("v.checked", true);
               
                component.set("v.accountEffectiveEndDate", "4000-12-31");
                component.set("v.isInfinity", true);
                */
					//component.find('dateAdjustTable').expandAll();
				} else if (state === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							var toast = this.getToast("Error", errors[0].message, "error");
							toast.fire();
						}
					}
				}
			})
		);

		$A.enqueueAction(action);
	}
});