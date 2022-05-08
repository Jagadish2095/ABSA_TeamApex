({
	helperMethod: function() {},

	fetchPickListVal: function(component, fieldName, elementId) {
		this.showSpinner(component);

		var action = component.get('c.getselectOptions');
		action.setParams({
			objObject: component.get('v.pricingMatrix'),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function(response) {
			if (response.getState() == 'SUCCESS') {
				var allValues = response.getReturnValue();

				//if(elementId == 'estateBridgingBenefit'){
				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: 'optionClass',
						label: '--- None ---',
						value: ''
					});
				}
				//}
				for (var i = 0; i < allValues.length; i++) {
					opts.push({
						class: 'optionClass',
						label: allValues[i],
						value: allValues[i]
					});
				}
				if (elementId == 'executorsFeePolicy') {
					component.set('v.executorFeeOptions', opts);
					//component.set("v.selectedExecutorFee", allValues[0]);
					//this.getMemberPremium(component, allValues[0], 'Executors Fees Cover');
					//this.calculateTotal(component);
				} else if (elementId == 'estateBridgingBenefit') {
					component.set('v.estateBridgingOptions', opts);
				}
				this.getPolicyFee(component);
				this.hideSpinner(component);
			}
		});
		$A.enqueueAction(action);
	},

	retrieveQuoteData: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');
		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				if (data != null) {
					var i;
					var totalMainLifePremium = 0;
					var totalSpousePremium = 0;
					for (i = 0; i < data.length; i++) {
						//Main Life Data Population
						if (
							data[i].PricebookEntry.Name.includes('Executor Fees') &&
							!data[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.mainLifeExecutor', data[i].Policy_Cover__c);
							totalMainLifePremium += Number(data[i].Premium__c);
						} else if (
							data[i].PricebookEntry.Name.includes('Estate Bridging') &&
							!data[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.mainLifeBridging', data[i].Policy_Cover__c);
							totalMainLifePremium += Number(data[i].Premium__c);
						} else if (
							data[i].PricebookEntry.Name.includes('Funeral Benefit') &&
							!data[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.mainLifeFuneral', data[i].Policy_Cover__c);
							totalMainLifePremium += Number(data[i].Premium__c);
						}

						//Spouse Data Population
						if (
							data[i].PricebookEntry.Name.includes('Executor Fees') &&
							data[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.spouseExecutor', data[i].Policy_Cover__c);
							totalSpousePremium += Number(data[i].Premium__c);
						} else if (
							data[i].PricebookEntry.Name.includes('Estate Bridging') &&
							data[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.spouseBridging', data[i].Policy_Cover__c);
							totalSpousePremium += Number(data[i].Premium__c);
						}

						//Policy Fee Data Population
						if (data[i].PricebookEntry.Name.includes('Policy Fee')) {
							component.set('v.policyFeeSummary', data[i].Premium__c);
						}
					}
					component.set('v.mainLifePremium', totalMainLifePremium);
					component.set('v.spousePremium', totalSpousePremium);

					//Main Life Data Checks
					if (component.get('v.mainLifeExecutor') == null) {
						component.set('v.mainLifeExecutor', '0');
					}
					if (component.get('v.mainLifeBridging') == null) {
						component.set('v.mainLifeBridging', '0');
					}
					if (component.get('v.mainLifeFuneral') == null) {
						component.set('v.mainLifeFuneral', '0');
					}
					if (component.get('v.mainLifePremium') == null) {
						component.set('v.mainLifePremium', '0');
					}

					//Spouse Data Checks
					if (component.get('v.spouseExecutor') == null) {
						component.set('v.spouseExecutor', '0');
					}
					if (component.get('v.spouseBridging') == null) {
						component.set('v.spouseBridging', '0');
					}
					if (component.get('v.spouseFuneral') == null) {
						component.set('v.spouseFuneral', '0');
					}
					if (component.get('v.spousePremium') == null) {
						component.set('v.spousePremium', '0');
					}

					if (component.get('v.spousePremium') == 0) {
						component.set('v.showSpousePremium', false);
					} else {
						component.set('v.showSpousePremium', true);
					}

					this.fetchTotalQuoteData(component);
					component.set('v.showQuoteDetails', true);
				} else {
					//Else no quote data found
					component.set('v.showQuoteDetails', false);
					component.find('executorsCheckbox').set('v.disabled', true);
					component.find('estateBridgingCheckbox').set('v.disabled', true);
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	fetchTotalQuoteData: function(component) {
		var oppId = component.get('v.recordId');
		var action = component.get('c.getTotalQuoteData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.quoteTotal', data);
			}
		});
		$A.enqueueAction(action);
	},

	quoteExists: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');

		var action = component.get('c.checkIfQuoteExists');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				var totalPremium = a.getReturnValue();
				if (totalPremium != null) {
					component.set('v.showQuoteScreen', false);
					component.set('v.showCommissionScreen', true);
					component.set('v.totalPremiumCommissionScreen', totalPremium);

					this.calcFirstYearCommission(component);
					this.calcSecondYearCommission(component);
				} else {
					component.set('v.showQuoteScreen', true);
					component.set('v.showCommissionScreen', false);
					component.set('v.totalPremiumCommissionScreen', null);

					this.getExistingQuote(component);
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	getExistingQuote: function(component) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');

		var action = component.get('c.getQuoteLineItemsData');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (a.getReturnValue() != null) {
					var quoteLineItems = a.getReturnValue();
					var isEstateBridgingAdded = false;
					var isFuneralBenefitAdded = false;
					component.set('v.quoteLineItems', quoteLineItems);
					var i;
					for (i = 0; i < quoteLineItems.length; i++) {
						if (
							quoteLineItems[i].PricebookEntry.Name.includes('Executor Fees Policy') &&
							!quoteLineItems[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.selectedExecutorFee', quoteLineItems[i].Policy_Cover__c);
							this.getMemberPremium(component, quoteLineItems[i].Policy_Cover__c, 'Executors Fees Cover');
						}
						if (quoteLineItems[i].PricebookEntry.Name.includes('Executor Fees Policy Spouse')) {
							var executorsCheckbox = component.find('executorsCheckbox');
							executorsCheckbox.set('v.value', true);

							var today = new Date();
							var birthDate = new Date(component.get('v.spouseDOB'));
							var age = today.getFullYear() - birthDate.getFullYear();
							var m = today.getMonth() - birthDate.getMonth();
							if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
								age--;
							}

							component.set('v.spouseAge', Number(age));
							this.getSpousePremium(
								component,
								quoteLineItems[i].Policy_Cover__c,
								age,
								'Executors Fees Cover'
							);
							this.retrieveSpouseDOB(component);
						}

						if (
							quoteLineItems[i].PricebookEntry.Name.includes('Estate Bridging Benefit') &&
							!quoteLineItems[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.selectedEstateBridging', quoteLineItems[i].Policy_Cover__c);
							this.getMemberPremium(
								component,
								quoteLineItems[i].Policy_Cover__c,
								'Estate Bridging Benefit'
							);
							isEstateBridgingAdded = true;
						}
						if (quoteLineItems[i].PricebookEntry.Name.includes('Estate Bridging Benefit Spouse')) {
							var selectedCheckbox = component.find('estateBridgingCheckbox');
							selectedCheckbox.set('v.value', true);

							var today = new Date();
							var birthDate = new Date(component.get('v.spouseDOB'));
							var age = today.getFullYear() - birthDate.getFullYear();
							var m = today.getMonth() - birthDate.getMonth();
							if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
								age--;
							}

							component.set('v.spouseAge', Number(age));
							this.getSpousePremium(
								component,
								quoteLineItems[i].Policy_Cover__c,
								age,
								'Estate Bridging Benefit'
							);
							this.retrieveSpouseDOB(component);
						}

						if (
							quoteLineItems[i].PricebookEntry.Name.includes('Funeral Benefit') &&
							!quoteLineItems[i].PricebookEntry.Name.includes('Spouse')
						) {
							component.set('v.selectedFuneralBenefit', 'Yes');
							this.getMemberPremium(component, '', 'Family Funeral');
							isFuneralBenefitAdded = true;
						}

						if (quoteLineItems[i].PricebookEntry.Name.includes('Funeral Benefit Spouse')) {
							var selectedCheckbox = component.find('funeralBenefitCheckbox');
							selectedCheckbox.set('v.value', true);
							component.find('funeralBenefitCheckbox').set('v.value', true);
						}
					}
					if (isEstateBridgingAdded) {
						component.find('estateBridgingCheckbox').set('v.disabled', false);
					} else {
						component.find('estateBridgingCheckbox').set('v.disabled', true);
					}

					if (isFuneralBenefitAdded) {
						component.find('funeralBenefitCheckbox').set('v.disabled', false);
					} else {
						component.find('funeralBenefitCheckbox').set('v.disabled', true);
					}
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	retrieveSpouseDOB: function(component) {
		var oppId = component.get('v.recordId');

		var action = component.get('c.getSpouseDOB');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				var spouseDOB = a.getReturnValue();
				component.set('v.spouseDOB', spouseDOB);
			}
		});
		$A.enqueueAction(action);
	},

	getPolicyFee: function(component) {
		var action = component.get('c.getPolicyFee');
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				var policyFee = a.getReturnValue();
				component.set('v.policyFee', policyFee);
			}
		});
		$A.enqueueAction(action);
	},

	getMemberPremium: function(component, sumInsured, recordType) {
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.getMemberPremiumWbif');
		action.setParams({
			oppId: oppId,
			sumInsured: sumInsured,
			recordType: recordType,
			policy: component.get('v.policySession')
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (recordType == 'Executors Fees Cover') {
					var executorFeePremium = a.getReturnValue();
					component.set('v.executorFeePremium', executorFeePremium);
					component.set('v.executorFeePremiumLbl', 'Premium (Main Member): R' + executorFeePremium);
				} else if (recordType == 'Estate Bridging Benefit') {
					var estateBridgingPremium = a.getReturnValue();
					component.set('v.estateBridgingPremium', estateBridgingPremium);
					component.set('v.estateBridgingPremiumLbl', 'Premium (Main Member): R' + estateBridgingPremium);
				} else if (recordType == 'Family Funeral') {
					var funeralFeePremium = a.getReturnValue();
					component.set('v.funeralFeePremium', funeralFeePremium);
					component.set('v.funeralFeePremiumLbl', 'Premium: R' + funeralFeePremium);
				}
				this.calculateTotal(component);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	getSpousePremium: function(component, sumInsured, age, recordType) {
		component.set('v.showSpinner', true);

		var oppId = component.get('v.recordId');

		var action = component.get('c.getSpousePremiumWbif');
		action.setParams({
			policy: component.get('v.policySession'),
			oppId: oppId,
			sumInsured: sumInsured,
			age: age,
			recordType: recordType,
			spouseDOB: component.get('v.spouseDOB')
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (recordType == 'Executors Fees Cover') {
					var executorFeePremium = a.getReturnValue();
					component.set('v.executorFeePremiumSpouse', executorFeePremium);
					component.set('v.executorFeePremiumSpouseLbl', 'Premium (Spouse): R' + executorFeePremium);
				} else if (recordType == 'Estate Bridging Benefit') {
					var estateBridgingPremium = a.getReturnValue();
					component.set('v.estateBridgingPremiumSpouse', estateBridgingPremium);
					component.set('v.estateBridgingPremiumSpouseLbl', 'Premium (Spouse): R' + estateBridgingPremium);
				}
				this.calculateTotal(component);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	calculateTotal: function(component) {
		var executorFeePremium = component.get('v.executorFeePremium');
		var estateBridgingPremium = component.get('v.estateBridgingPremium');
		var funeralFeePremium = component.get('v.funeralFeePremium');
		var executorFeePremiumSpouse = component.get('v.executorFeePremiumSpouse');
		var estateBridgingPremiumSpouse = component.get('v.estateBridgingPremiumSpouse');
		var policyFee = component.get('v.policyFee');

		var total =
			Number(executorFeePremium) +
			Number(estateBridgingPremium) +
			Number(funeralFeePremium) +
			Number(executorFeePremiumSpouse) +
			Number(estateBridgingPremiumSpouse) +
			Number(policyFee);
		component.set('v.totalPremium', total);
		component.set('v.totalPremiumLbl', 'Total Premium (including Policy Fee): R' + total);
	},

	createNewQuote: function(component) {
		var valid = true;
		if (
			component.get('v.executorFeePremiumSpouse') != 0 &&
			component.get('v.estateBridgingPremium') != 0 &&
			component.get('v.estateBridgingPremiumSpouse') == 0
		) {
			valid = false;
			// show error notification
			var toastEvent = $A.get('e.force:showToast');
			toastEvent.setParams({
				title: 'Error!',
				message:
					'If a spouse if added for the Executor Fee Benefit and the Estate Bridging Benefit is added, then a spouse must be added for the Estate Bridging Benefit!',
				type: 'error',
				mode: 'sticky'
			});
			toastEvent.fire();
		}

		if (valid) {
			this.showSpinner(component);

			var spouseDOB;
			if (component.get('v.spouseDOB') != null) {
				spouseDOB = component.get('v.spouseDOB').toString();
			}

			var deleteSpouse = false;
			var executorsCheckbox = component.find('executorsCheckbox');
			var estateBridgingCheckbox = component.find('estateBridgingCheckbox');
			var funeralBenefitCheckbox = component.find('funeralBenefitCheckbox');
			if (
				executorsCheckbox.get('v.value') == false &&
				estateBridgingCheckbox.get('v.value') == false &&
				funeralBenefitCheckbox.get('v.value') == false
			) {
				deleteSpouse = true;
			}

			var oppId = component.get('v.recordId');

			var action = component.get('c.createQuote');
			action.setParams({
				oppId: oppId,
				totalPremium: component.get('v.totalPremium').toString(),
				policyFee: component.get('v.policyFee').toString(),

				executorFeePremium: component.get('v.executorFeePremium').toString(),
				executorFeeCover: component.get('v.selectedExecutorFee').toString(),

				estateBridgingPremium: component.get('v.estateBridgingPremium').toString(),
				estateBridgingCover: component.get('v.selectedEstateBridging').toString(),

				funeralFeePremium: component.get('v.funeralFeePremium').toString(),

				executorFeePremiumSpouse: component.get('v.executorFeePremiumSpouse').toString(),
				estateBridgingPremiumSpouse: component.get('v.estateBridgingPremiumSpouse').toString(),

				funeralFeePremiumSpouse: component.find('funeralBenefitCheckbox').get('v.value'),

				spouseDOB: spouseDOB,

				deleteSpouse: deleteSpouse,

				description: component.get('v.quote.Description')
			});
			action.setCallback(this, function(a) {
				var state = a.getState();
				if (state === 'SUCCESS') {
					// show success notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Success!',
						message: 'Quote Successfully Created',
						type: 'success'
					});
					toastEvent.fire();

					this.calcFirstYearCommission(component);
					this.calcSecondYearCommission(component);

					this.quoteExists(component);

					component.set('v.mainLifeBridging', '0');
					component.set('v.spouseBridging', '0');
					component.set('v.mainLifeFuneral', '0');

					component.set('v.showQuoteScreen', false);
					component.set('v.showCommissionScreen', true);
				} else {
					// show error notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Error!',
						message: 'Error creating new quote. Please try again!',
						type: 'error',
						mode: 'sticky'
					});
					toastEvent.fire();
				}
				this.retrieveQuoteData(component);
				this.hideSpinner(component);
				$A.get('e.force:refreshView').fire();

				var a = component.get('c.doInit');
				$A.enqueueAction(a);
			});
			$A.enqueueAction(action);
		}
	},

	calcFirstYearCommission: function(component) {
		var oppId = component.get('v.recordId');

		var action = component.get('c.getFirstYearCommission');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				component.set('v.firstYearCommission', a.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	calcSecondYearCommission: function(component) {
		var oppId = component.get('v.recordId');

		var action = component.get('c.getSecondYearCommission');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				component.set('v.secondYearCommission', a.getReturnValue());
			}
		});
		$A.enqueueAction(action);
	},

	getAllEmails: function(component) {
		var oppId = component.get('v.recordId');
		var action = component.get('c.getEmails');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				var opts = [];
				for (var i = 0; i < data.length; i++) {
					if (i == 0) {
						component.set('v.selectedEmail', data[i]);
					}
					opts.push({
						class: 'optionClass',
						label: data[i],
						value: data[i]
					});
				}
				component.set('v.emailOptions', opts);
			}
		});
		$A.enqueueAction(action);
	},

	setOppEmail: function(component) {
		this.showSpinner(component);
		var oppId = component.get('v.recordId');
		var emailAddress = component.get('v.selectedEmail');
		var altEmailAddress = component.get('v.alternativeEmail');
		var isAlternative = component.get('v.alternativeEmailSelected');
		var action = component.get('c.setOppEmail');
		action.setParams({
			oppId: oppId,
			emailAddress: emailAddress,
			altEmailAddress: altEmailAddress,
			isAlternative: isAlternative
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				if (response.getReturnValue() == true) {
					this.sendQuoteDefault(component);
				} else {
					// show error notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Error!',
						message: 'Error updating the opportunity with the preferred email address. Please try again!',
						type: 'error',
						mode: 'sticky'
					});
					toastEvent.fire();
					this.hideSpinner(component);
					var a = component.get('c.doInit');
					$A.enqueueAction(a);
				}
			} else {
				// show error notification
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'Error updating the opportunity with the preferred email address. Please try again!',
					type: 'error',
					mode: 'sticky'
				});
				toastEvent.fire();
				this.hideSpinner(component);
				var a = component.get('c.doInit');
				$A.enqueueAction(a);
			}
		});
		$A.enqueueAction(action);
	},

	sendQuoteDefault: function(component) {
		this.showSpinner(component);
		var altEmailAddress = component.get('v.alternativeEmail');
		var isAlternative = component.get('v.alternativeEmailSelected');
		var email = component.find('emailSelect');
		var oppId = component.get('v.recordId');
		var emailAddress = email.get('v.value');
		if (isAlternative == true) {
			emailAddress = altEmailAddress;
		}
		var action = component.get('c.sendEmail');
		action.setParams({
			oppId: oppId,
			emailAddress: emailAddress
		});
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				if (a.getReturnValue() == true) {
					// show success notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Success!',
						message: 'Quote Successfully Sent.',
						type: 'success'
					});
					component.set('v.alternativeEmailSelected', false);
					component.find('emailSelect').set('v.disabled', false);
					component.find('completedCheckbox').set('v.value', false);
					component.set('v.showAlternativeEmail', false);
					toastEvent.fire();
				} else {
					// show error notification
					var toastEvent = $A.get('e.force:showToast');
					toastEvent.setParams({
						title: 'Error!',
						message: 'Error sending new quote. Please try again!',
						type: 'error',
						mode: 'sticky'
					});
					toastEvent.fire();
				}
			} else {
				// show error notification
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'Error sending new quote. Please try again!',
					type: 'error',
					mode: 'sticky'
				});
				toastEvent.fire();
			}
			this.hideSpinner(component);
			var a = component.get('c.doInit');
			$A.enqueueAction(a);
		});
		$A.enqueueAction(action);
	},

	getPolicyCreate: function(component) {
		component.set('v.showSpinner2', true);

		var oppId = component.get('v.recordId');
		var action = component.get('c.getPolicy');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.policySession', data);
			}
			component.set('v.showSpinner2', false);
		});
		$A.enqueueAction(action);
	},

	getSpouseMinimumAge: function(component) {
		var oppId = component.get('v.recordId');
		var action = component.get('c.getSpouseMinAge');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.spouseMinAge', data);
			}
		});
		$A.enqueueAction(action);
	},

	getSpouseMaximumAge: function(component) {
		var oppId = component.get('v.recordId');
		var action = component.get('c.getSpouseMaxAge');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.spouseMaxAge', data);
			}
		});
		$A.enqueueAction(action);
	},

	checkAccountValid: function(component) {
		component.set('v.showSpinner', true);
		var oppId = component.get('v.recordId');
		var action = component.get('c.checkAccountValid');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function(response) {
			var state = response;
			var result = response.getReturnValue();
			if (result == 'Valid') {
				component.set('v.accountNotValid', false);
			} else {
				component.set('v.accountInValidReason', result);
				component.set('v.showQuoteScreen', false);
				component.set('v.showCommissionScreen', false);
				component.set('v.showSpouseScreen', false);
				component.set('v.accountNotValid', true);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	showSpinner: function(component) {
		var spinner = component.find('TheSpinner');
		$A.util.removeClass(spinner, 'slds-hide');
	},

	hideSpinner: function(component) {
		var spinner = component.find('TheSpinner');
		$A.util.addClass(spinner, 'slds-hide');
	}
});