({
	getFinancialInstitutionsPicklist: function (cmp, event) {
		return new Promise(function (resolve, reject) {
			var action = cmp.get("c.getFinancialInstitutions");
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					var result = response.getReturnValue();
					cmp.set("v.financialInstitutionList", result);
					resolve("Continue");
				} else if (response.getState() === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error on retrieving Bank Names");
							cmp.set("v.messageDialog", errors[0].message);
						} else {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error on retrieving Bank Names");
							cmp.set("v.messageDialog", "Unknown error");
						}
					}
					reject("Failed");
				} else if (response.getState() === "INCOMPLETE") {
					cmp.set("v.showDialog", true);
					cmp.set("v.headingDialog", "Error on retrieving Bank Names");
					cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
					reject("Failed");
				}
			});
			$A.enqueueAction(action);
		});
	},

	handleNavigation: function (cmp, page, direction, label) {
		var isSwitching = cmp.get("v.isSwitching");
		var isSalarySwitching = cmp.get("v.isSalarySwitching");
		var isDebitOrderSwitching = cmp.get("v.isDebitOrderSwitching");
		var navigate = cmp.get("v.navigateFlow");
		var self = this;
		var employerInstitutionLookup = cmp.find("employerInstitution");
		if (employerInstitutionLookup != null) {
			var employerResult = employerInstitutionLookup.get("v.institutionResult");
			cmp.set("v.EmployerName", employerResult);
		}

		if (direction == "pause") {
			var confirmPause = confirm("Do you want to pause the application? Captured Switches will be saved.");
			if (confirmPause) {
				self.showSpinner(cmp);
				self.saveSwitchingEntries(cmp).then(
					$A.getCallback(function (result) {
						self.hideSpinner(cmp);
						navigate("PAUSE");
					}),
					$A.getCallback(function (error) {
						self.hideSpinner(cmp);
					})
				);
			}
		}

		if (!isSalarySwitching && !isDebitOrderSwitching) {
			cmp.set("v.showSwitchingValidation", true);
		}

		if (!isSwitching) {
			navigate("NEXT");
		}

		if (page == "SelectionPage" && direction == "next") {
			if (isSalarySwitching) {
				cmp.set("v.showSelectionDetails", false);
				cmp.set("v.showSalaryDetails", true);
				self.setEmployerName(cmp);
				if (!isDebitOrderSwitching) {
					cmp.set("v.nextSALLabel", "Finish");
				} else {
					cmp.set("v.nextSALLabel", "Next");
				}
			} else if (isDebitOrderSwitching) {
				cmp.set("v.showSelectionDetails", false);
				cmp.set("v.showDebitOrderDetails", true);
				self.setEmployerName(cmp);
			}
		} else if (page == "SalaryPage" && direction == "next") {
			if (self.validateSalaryPage(cmp)) {
				if (isDebitOrderSwitching) {
					cmp.set("v.showSalaryDetails", false);
					cmp.set("v.showDebitOrderDetails", true);
				} else {
					cmp.set("v.nextSALLabel", "Finish");
					this.sendData(cmp);
				}
			}
		} else if (page == "DebitOrderPage" && direction == "next") {
			this.sendData(cmp);
		}

		if (page == "SalaryPage" && direction == "back") {
			cmp.set("v.showSalaryDetails", false);
			cmp.set("v.showSelectionDetails", true);
		} else if (page == "DebitOrderPage" && direction == "back" && isSalarySwitching) {
			cmp.set("v.showDebitOrderDetails", false);
			cmp.set("v.nextSALLabel", "Next");
			cmp.set("v.showSalaryDetails", true);
			var employerName = cmp.get("v.EmployerName");
			if (employerName != null && employerName != "") {
				self.setEmployerOnPrevious(cmp);
			}
		} else if (page == "DebitOrderPage" && direction == "back" && !isSalarySwitching) {
			cmp.set("v.showDebitOrderDetails", false);
			cmp.set("v.showSelectionDetails", true);
		}
	},
	validateSalaryPage: function (cmp) {
		var isValid = true;
		var employerInstitutionLookup = cmp.find("employerInstitution");
		if (employerInstitutionLookup != null) {
			var employerName = employerInstitutionLookup.get("v.institutionName");
			if (employerName == null || employerName == "") {
				isValid = false;
				employerInstitutionLookup.validate();
			}
		}
		var salaryDate = cmp.find("SalaryDate");
		var salaryDateValue = salaryDate.get("v.value");
		if (salaryDateValue != null) {
			$A.util.removeClass(salaryDate, "slds-has-error");
			salaryDate.setCustomValidity("");
			salaryDate.reportValidity();
		} else {
			$A.util.addClass(salaryDate, "slds-has-error");
			salaryDate.setCustomValidity("Please select salary date paid");
			salaryDate.reportValidity();
			isValid = false;
		}
		return isValid;
	},
	fetchSwitches: function (cmp) {
		var self = this;
		return new Promise(function (resolve, reject) {
			var opportunityId = cmp.get("v.opportunityId");
			var getSwitchesAction = cmp.get("c.getPendingSwitches");
			getSwitchesAction.setParams({
				opportunityId: opportunityId
			});

			getSwitchesAction.setCallback(this, function (response) {
				if (response.getState() === "SUCCESS") {
					var switches = response.getReturnValue();
					for (var i = 0; i < switches.length; i++) {
						if (switches[i].Switch_Type__c == "SALARY") {
							cmp.set("v.isSalarySwitching", true);
							cmp.set("v.pendingSalarySwitchId", switches[i].Id);
							cmp.set("v.AccountName", switches[i].Previous_Account_Holder__c);
							cmp.set("v.AccountNumber", switches[i].Previous_Account_Number__c);
							cmp.set("v.AccountType", switches[i].Previous_Account_Type__c);
							cmp.set("v.financialInstitution", switches[i].Previous_Institution__c);
							cmp.set("v.SalaryDate", switches[i].Due_Date__c);
							cmp.set("v.EmployerName", switches[i].Employer_Name__c);
						} else if (switches[i].Switch_Type__c == "DEBIT_ORDER") {
							cmp.set("v.isDebitOrderSwitching", true);
							var accName = cmp.get("v.AccountName");
							if (accName == "") {
								cmp.set("v.AccountName", switches[i].Previous_Account_Holder__c);
							}
							var accNumber = cmp.get("v.AccountNumber");
							if (accNumber == "") {
								cmp.set("v.AccountNumber", switches[i].Previous_Account_Number__c);
							}
							var accType = cmp.get("v.AccountType");
							if (accType == null) {
								cmp.set("v.AccountType", switches[i].Previous_Account_Type__c);
							}
							var bankName = cmp.set("v.financialInstitution");
							if (bankName == null) {
								cmp.set("v.financialInstitution", switches[i].Previous_Institution__c);
							}
							//Add row
							var g = self.createGuid(cmp);
							var debitOrders = cmp.get("v.debitOrders");
							debitOrders.push({
								id: g,
								serviceProvider: switches[i].Employer_Name__c,
								refAccountNumber: switches[i].Account_Number__c,
								dueDate: switches[i].Due_Date__c,
								frequency: switches[i].Frequency__c,
								amount: switches[i].Amount__c,
								fixvar: switches[i].FixVar__c,
								action: "edit",
								opprLineItemId: opportunityId,
								pendingDebitOrderId: switches[i].Id
							});
							cmp.set("v.debitOrders", debitOrders);
						}
					}
					resolve("Continue");
				} else if (response.getState() === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							console.log("Error message: " + errors[0].message);
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error on retrieving Switches");
							cmp.set("v.messageDialog", errors[0].message);
						} else {
							console.log("unknown error");
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error on retrieving Switches");
							cmp.set("v.messageDialog", "Unknown error");
						}
					}
					reject("Failed");
				} else if (response.getState() === "INCOMPLETE") {
					console.log("Incomplete action. The server might be down or the client might be offline.");
					cmp.set("v.showDialog", true);
					cmp.set("v.headingDialog", "Error on retrieving Switches");
					cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
					reject("Failed");
				}
			});
			$A.enqueueAction(getSwitchesAction);
		});
	},
	setEmployerName: function (cmp) {
		var employerName = cmp.get("v.EmployerName");
		if (employerName != null) {
			var employerInstitutionLookup = cmp.find("employerInstitution");
			if (employerInstitutionLookup != null) {
				employerInstitutionLookup.set("v.institutionResult", employerName);
				employerInstitutionLookup.set("v.institutionName", employerName);
			}
		}
	},
	setEmployerOnPrevious: function (cmp) {
		var employerName = cmp.get("v.EmployerName");
		if (employerName != null) {
			var employerInstitutionLookup = cmp.find("employerInstitution");
			if (employerInstitutionLookup != null) {
				var employerJustName = employerName.split("(")[0];
				employerJustName = employerJustName.trim();
				employerInstitutionLookup.set("v.institutionResult", employerName);
				employerInstitutionLookup.set("v.institutionName", employerJustName);
			}
		}
	},
	removeDebitOrder: function (cmp, row) {
		var rows = cmp.get("v.debitOrders");
		var rowIndex = rows.indexOf(row);

		if (row.pendingDebitOrderId != "" && row.pendingDebitOrderId != null) {
			var removeDebitOrderAction = cmp.get("c.removePendingDebitOrder");

			removeDebitOrderAction.setParams({
				debitOrderId: row.pendingDebitOrderId
			});

			removeDebitOrderAction.setCallback(this, function (response) {
				if (response.getState() === "ERROR") {
					var errors = response.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error removing pending Debit Order");
							cmp.set("v.messageDialog", errors[0].message);
						} else {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error removing pending Debit Order");
							cmp.set("v.messageDialog", "Unknown error");
						}
					}
				}
			});
			$A.enqueueAction(removeDebitOrderAction);
		}

		rows.splice(rowIndex, 1);
		cmp.set("v.debitOrders", rows);
	},
	createGuid: function (component) {
		return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function (c) {
			var r = (Math.random() * 16) | 0,
				v = c === "x" ? r : (r & 0x3) | 0x8;
			return v.toString(16);
		});
	},
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		component.set("v.ShowSpinner", true);
	},
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		component.set("v.ShowSpinner", false);
	},
	sendData: function (cmp) {
		var navigate = cmp.get("v.navigateFlow");
		var self = this;
		self.showSpinner(cmp);
		self.saveSwitchingEntries(cmp).then(
			$A.getCallback(function (result) {
				self.sendCustomerData(cmp).then(
					$A.getCallback(function (result) {
						self.hideSpinner(cmp);
						navigate("NEXT");
					}),
					$A.getCallback(function (error) {
						self.hideSpinner(cmp);
					})
				);
			}),
			$A.getCallback(function (error) {
				self.hideSpinner(cmp);
			})
		);
	},

	sendCustomerData: function (cmp) {
		return new Promise(function (resolve, reject) {
			var accountId = cmp.get("v.recordId");
			var isSalarySwitching = cmp.get("v.isSalarySwitching");
			var isDebitOrderSwitching = cmp.get("v.isDebitOrderSwitching");
			var debitorders = cmp.get("v.debitOrders");
			var accountName = cmp.get("v.AccountName");
			var accountNumber = cmp.get("v.AccountNumber");
			var accountType = cmp.get("v.AccountType");
			var salaryDate = cmp.get("v.SalaryDate");
			var employerEmail = cmp.get("v.EmployerEmail");
			var financialInstitution = cmp.get("v.financialInstitution");
			var employerInstitutionLookup = cmp.find("employerInstitution");
			var employerName = cmp.get("v.EmployerName");

			if (employerInstitutionLookup != null) {
				employerName = employerInstitutionLookup.get("v.institutionName");
			}
			var opportunityId = cmp.get("v.opportunityId");
			var pendingSalarySwitchId = cmp.get("v.pendingSalarySwitchId");

			var SwitchingData = {
				accountId: accountId,
				isSalary: isSalarySwitching,
				isDebitOrder: isDebitOrderSwitching,
				previousAccountHolder: accountName,
				previousAccountNumber: accountNumber,
				previousBank: financialInstitution,
				previousAccountType: accountType,
				employer: employerName,
				datePaid: salaryDate,
				debitOrders: JSON.stringify(debitorders),
				opportunityId: opportunityId,
				pendingSalarySwitchId: pendingSalarySwitchId
			};

			let customerAction = cmp.get("c.switchingCustomerData");

			customerAction.setParams({
				switchingO: SwitchingData
			});

			customerAction.setCallback(this, function (customer) {
				if (customer.getState() === "SUCCESS") {
					if (isSalarySwitching && !isDebitOrderSwitching) {
						let salaryAction = cmp.get("c.switchingSalaryData");

						salaryAction.setParams({
							switchingO: SwitchingData,
							customerLink: customer.getReturnValue()
						});

						salaryAction.setCallback(this, function (salary) {
							if (salary.getState() === "SUCCESS") {
								resolve("Continue");
							} else if (salary.getState() === "ERROR") {
								var errors = salary.getError();
								if (errors) {
									if (errors[0] && errors[0].message) {
										console.log("Error message: " + errors[0].message);
										cmp.set("v.showDialog", true);
										cmp.set("v.headingDialog", "Error on Salary Switch");
										cmp.set("v.messageDialog", errors[0].message);
									} else {
										console.log("unknown error");
										cmp.set("v.showDialog", true);
										cmp.set("v.headingDialog", "Error on Salary Switch");
										cmp.set("v.messageDialog", "Unknown error");
									}
								}
								reject("Failed");
							} else if (salary.getState() === "INCOMPLETE") {
								console.log("Incomplete action. The server might be down or the client might be offline.");
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Salary Switch");
								cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
								reject("Failed");
							}
						});
						$A.enqueueAction(salaryAction);
					}

					if (isDebitOrderSwitching && !isSalarySwitching) {
						for (var i = 0; i < debitorders.length; i++) {
							let debitOrderAction = cmp.get("c.switchingDebitOrderData");
							var doo = {
								serviceProvider: debitorders[i].serviceProvider,
								refAccountNumber: debitorders[i].refAccountNumber,
								dueDate: debitorders[i].dueDate,
								frequency: debitorders[i].frequency,
								amount: debitorders[i].amount,
								fixvar: debitorders[i].fixvar,
								action: debitorders[i].action,
								opportunityId: opportunityId,
								pendingDebitOrderId: debitorders[i].pendingDebitOrderId
							};

							debitOrderAction.setParams({
								debitOrder: JSON.stringify(doo),
								customerLink: customer.getReturnValue(),
								previousAccountNumber: accountNumber,
								previousAccountType: accountType,
								previousInstitution: financialInstitution
							});

							debitOrderAction.setCallback(this, function (debitorder) {
								if (debitorder.getState() === "SUCCESS") {
									if (i == debitorders.length) {
										resolve("Continue");
									}
								} else if (debitorder.getState() === "ERROR") {
									var errors = debitorder.getError();
									if (errors) {
										if (errors[0] && errors[0].message) {
											cmp.set("v.showDialog", true);
											cmp.set("v.headingDialog", "Error on Debit Order");
											cmp.set("v.messageDialog", errors[0].message);
										} else {
											cmp.set("v.showDialog", true);
											cmp.set("v.headingDialog", "Error on Debit Order");
											cmp.set("v.messageDialog", "Unknown error");
										}
									}
									reject("Failed");
								} else if (debitorder.getState() === "INCOMPLETE") {
									cmp.set("v.showDialog", true);
									cmp.set("v.headingDialog", "Error on Debit Order");
									cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
									reject("Failed");
								}
							});
							$A.enqueueAction(debitOrderAction);
						}
					}
					if (isSalarySwitching && isDebitOrderSwitching) {
						let salaryAction = cmp.get("c.switchingSalaryData");

						salaryAction.setParams({
							switchingO: SwitchingData,
							customerLink: customer.getReturnValue()
						});

						salaryAction.setCallback(this, function (salary) {
							if (salary.getState() === "SUCCESS") {
								for (var i = 0; i < debitorders.length; i++) {
									let debitOrderAction = cmp.get("c.switchingDebitOrderData");
									var doo = {
										serviceProvider: debitorders[i].serviceProvider,
										refAccountNumber: debitorders[i].refAccountNumber,
										dueDate: debitorders[i].dueDate,
										frequency: debitorders[i].frequency,
										amount: debitorders[i].amount,
										fixvar: debitorders[i].fixvar,
										action: debitorders[i].action,
										opportunityId: opportunityId,
										pendingDebitOrderId: debitorders[i].pendingDebitOrderId
									};
									debitOrderAction.setParams({
										debitOrder: JSON.stringify(doo),
										customerLink: customer.getReturnValue(),
										previousAccountNumber: accountNumber,
										previousAccountType: accountType,
										previousInstitution: financialInstitution
									});

									debitOrderAction.setCallback(this, function (debitorder) {
										if (debitorder.getState() === "SUCCESS") {
											if (i == debitorders.length) {
												resolve("Continue");
											}
										} else if (debitorder.getState() === "ERROR") {
											var errors = debitorder.getError();
											if (errors) {
												if (errors[0] && errors[0].message) {
													cmp.set("v.showDialog", true);
													cmp.set("v.headingDialog", "Error on Debit Order");
													cmp.set("v.messageDialog", errors[0].message);
												} else {
													cmp.set("v.showDialog", true);
													cmp.set("v.headingDialog", "Error on Debit Order");
													cmp.set("v.messageDialog", "Unknown error");
												}
												reject("Failed");
											}
										} else if (debitorder.getState() === "INCOMPLETE") {
											cmp.set("v.showDialog", true);
											cmp.set("v.headingDialog", "Error on Debit Order");
											cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
											reject("Failed");
										}
									});
									$A.enqueueAction(debitOrderAction);
								}
							} else if (salary.getState() === "ERROR") {
								var errors = salary.getError();
								if (errors) {
									if (errors[0] && errors[0].message) {
										cmp.set("v.showDialog", true);
										cmp.set("v.headingDialog", "Error on Salary Switch");
										cmp.set("v.messageDialog", errors[0].message);
									} else {
										cmp.set("v.showDialog", true);
										cmp.set("v.headingDialog", "Error on Salary Switch");
										cmp.set("v.messageDialog", "Unknown error");
									}
									reject("Failed");
								}
							} else if (salary.getState() === "INCOMPLETE") {
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Salary Switch");
								cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
								reject("Failed");
							}
						});
						$A.enqueueAction(salaryAction);
					}
				} else if (customer.getState() === "ERROR") {
					var errors = customer.getError();
					if (errors) {
						if (errors[0] && errors[0].message) {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error Creating Customer");
							cmp.set("v.messageDialog", errors[0].message);
						} else {
							cmp.set("v.showDialog", true);
							cmp.set("v.headingDialog", "Error Creating Customer");
							cmp.set("v.messageDialog", "Unknown error");
						}
						reject("Failed");
					}
				} else if (customer.getState() === "INCOMPLETE") {
					cmp.set("v.showDialog", true);
					cmp.set("v.headingDialog", "Error Creating Customer");
					cmp.set("v.messageDialog", "Incomplete action. The server might be down or the client might be offline.");
					reject("Failed");
				}
			});
			$A.enqueueAction(customerAction);
		});
	},
	saveSwitchingEntries: function (cmp) {
		return new Promise(function (resolve, reject) {
			var accountId = cmp.get("v.recordId");
			var isSalarySwitching = cmp.get("v.isSalarySwitching");
			var isDebitOrderSwitching = cmp.get("v.isDebitOrderSwitching");
			var debitorders = cmp.get("v.debitOrders");
			var accountName = cmp.get("v.AccountName");
			var accountNumber = cmp.get("v.AccountNumber");
			var accountType = cmp.get("v.AccountType");
			var salaryDate = cmp.get("v.SalaryDate");
			var financialInstitution = cmp.get("v.financialInstitution");
			var employerInstitutionLookup = cmp.find("employerInstitution");
			var employerName = cmp.get("v.EmployerName");

			if (employerInstitutionLookup != null) {
				employerName = employerInstitutionLookup.get("v.institutionName");
			}
			var opportunityId = cmp.get("v.opportunityId");
			var pendingSalarySwitchId = cmp.get("v.pendingSalarySwitchId");

			var SwitchingData = {
				accountId: accountId,
				isSalary: isSalarySwitching,
				isDebitOrder: isDebitOrderSwitching,
				previousAccountHolder: accountName,
				previousAccountNumber: accountNumber,
				previousBank: financialInstitution,
				previousAccountType: accountType,
				employer: employerName,
				datePaid: salaryDate,
				debitOrders: JSON.stringify(debitorders),
				opportunityId: opportunityId,
				pendingSalarySwitchId: pendingSalarySwitchId
			};
			for (var i = 0; i < debitorders.length; i++) {
				var debitOrderAction = cmp.get("c.saveDebitOrderEntries");
				var doo = {
					serviceProvider: debitorders[i].serviceProvider,
					refAccountNumber: debitorders[i].refAccountNumber,
					dueDate: debitorders[i].dueDate,
					frequency: debitorders[i].frequency,
					amount: debitorders[i].amount,
					fixvar: debitorders[i].fixvar,
					action: debitorders[i].action,
					opportunityId: opportunityId,
					pendingDebitOrderId: debitorders[i].pendingDebitOrderId
				};

				debitOrderAction.setParams({
					debitOrder: JSON.stringify(doo),
					previousAccountNumber: accountNumber,
					previousAccountType: accountType,
					selectedBankName: financialInstitution,
					accountName: accountName
				});

				debitOrderAction.setCallback(this, function (debitorder) {
					if (debitorder.getState() === "SUCCESS") {
						var debitorders = cmp.get("v.debitOrders");
						var countdown = i - 1;
						i = countdown;
						debitorders[countdown].pendingDebitOrderId = debitorder.getReturnValue();
						if (countdown == 0) {
							if (employerName != "" && employerName != null) {
								var salaryAction = cmp.get("c.saveSalarySwitchEntry");

								salaryAction.setParams({
									switchingO: SwitchingData
								});

								salaryAction.setCallback(this, function (salary) {
									if (salary.getState() === "SUCCESS") {
										cmp.set("v.pendingSalarySwitchId", salary.getReturnValue());
										resolve("Continue");
									} else if (salary.getState() === "ERROR") {
										var errors = salary.getError();
										if (errors) {
											if (errors[0] && errors[0].message) {
												cmp.set("v.showDialog", true);
												cmp.set("v.headingDialog", "Error on Saving Salary Switch");
												cmp.set("v.messageDialog", errors[0].message);
											} else {
												cmp.set("v.showDialog", true);
												cmp.set("v.headingDialog", "Error on Saving Salary Switch");
												cmp.set("v.messageDialog", "Unknown error");
											}
										}
										reject("Failed");
									}
								});
								$A.enqueueAction(salaryAction);
							} else {
								resolve("Continue");
							}
						}
					} else if (debitorder.getState() === "ERROR") {
						var errors = debitorder.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Saving Debit Order Switch");
								cmp.set("v.messageDialog", errors[0].message);
							} else {
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Saving Debit Order Switch");
								cmp.set("v.messageDialog", "Unknown error");
							}
							reject("Failed");
						}
					}
				});
				$A.enqueueAction(debitOrderAction);
			}
			if (debitorders.length == 0) {
				var onlySalaryAction = cmp.get("c.saveSalarySwitchEntry");

				onlySalaryAction.setParams({
					switchingO: SwitchingData
				});

				onlySalaryAction.setCallback(this, function (salary) {
					if (salary.getState() === "SUCCESS") {
						cmp.set("v.pendingSalarySwitchId", salary.getReturnValue());
						resolve("Continue");
					} else if (salary.getState() === "ERROR") {
						var errors = salary.getError();
						if (errors) {
							if (errors[0] && errors[0].message) {
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Saving Salary Switch");
								cmp.set("v.messageDialog", errors[0].message);
							} else {
								cmp.set("v.showDialog", true);
								cmp.set("v.headingDialog", "Error on Saving Salary Switch");
								cmp.set("v.messageDialog", "Unknown error");
							}
						}
						reject("Failed");
					}
				});
				$A.enqueueAction(onlySalaryAction);
			}
		});
	}
});