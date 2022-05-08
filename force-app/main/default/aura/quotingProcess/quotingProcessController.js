({
	myAction: function(component, event, helper) {},

	doInit: function(component, event, helper) {
		helper.quoteExists(component);
		//Set picklist values
		helper.fetchPickListVal(component, 'Executor_Fee_Cover__c', 'executorsFeePolicy');
		helper.fetchPickListVal(component, 'Estate_Bridging_Cover__c', 'estateBridgingBenefit');

		var opts = [];
		opts.push({
			class: 'optionClass',
			label: 'No',
			value: 'No'
		});
		opts.push({
			class: 'optionClass',
			label: 'Yes',
			value: 'Yes'
		});
		component.set('v.funeralBenefitOptions', opts);
		helper.retrieveQuoteData(component);
		helper.getAllEmails(component);
		helper.getSpouseMinimumAge(component);
		helper.getSpouseMaximumAge(component);
		helper.getPolicyCreate(component);
		helper.checkAccountValid(component);
	},

	onExecutorsCheck: function(component, event, helper) {
		var checkCmp = component.find('executorsCheckbox');
		component.set('v.quoteOnSpouseExecutorFee', checkCmp.get('v.value'));

		if (checkCmp.get('v.value') == true) {
			component.set('v.currentCheckbox', 'executorsCheckbox');
			component.set('v.showSpouseScreen', true);
		} else {
			component.set('v.executorFeePremiumSpouse', 0);
			component.set('v.executorFeePremiumSpouseLbl', '');
			helper.calculateTotal(component);
		}
	},

	onEstateBridgingCheck: function(component, event, helper) {
		var checkCmp = component.find('estateBridgingCheckbox');
		component.set('v.quoteOnSpouseEstateBridging', checkCmp.get('v.value'));

		if (checkCmp.get('v.value') == true) {
			component.set('v.currentCheckbox', 'estateBridgingCheckbox');
			component.set('v.showSpouseScreen', true);
		} else {
			component.set('v.estateBridgingPremiumSpouse', 0);
			component.set('v.estateBridgingPremiumSpouseLbl', '');
			helper.calculateTotal(component);
		}
	},

	onFuneralBenefitCheck: function(component, event, helper) {
		var checkCmp = component.find('funeralBenefitCheckbox');
		component.set('v.quoteOnSpouseFuneralBenefit', checkCmp.get('v.value'));

		if (checkCmp.get('v.value') == true) {
			component.set('v.currentCheckbox', 'funeralBenefitCheckbox');
			component.set('v.showSpouseScreen', true);
		}
	},

	onPicklistExecutorFeeChange: function(component, event, helper) {
		var sumInsured = event.getSource().get('v.value');
		if (sumInsured == '') {
			component.set('v.executorFeePremium', 0);
			component.set('v.executorFeePremiumLbl', 'Premium (Main Member): R0.00');
			component.set('v.executorFeePremiumSpouse', 0);
			component.set('v.executorFeePremiumSpouseLbl', '');

			component.find('executorsCheckbox').set('v.disabled', true);

			helper.calculateTotal(component);
		} else {
			component.find('executorsCheckbox').set('v.disabled', false);

			helper.getMemberPremium(component, sumInsured, 'Executors Fees Cover');

			var checkCmp = component.find('executorsCheckbox');
			var spouseAge = component.get('v.spouseAge');
			if (checkCmp.get('v.value') == true) {
				helper.getSpousePremium(component, sumInsured, spouseAge, 'Executors Fees Cover');
			}
		}
	},

	onPicklistEstateBridgingChange: function(component, event, helper) {
		var sumInsured = event.getSource().get('v.value');
		if (sumInsured == '') {
			component.set('v.estateBridgingPremium', 0);
			component.set('v.estateBridgingPremiumLbl', 'Premium (Main Member): R0.00');
			component.set('v.estateBridgingPremiumSpouse', 0);
			component.set('v.estateBridgingPremiumSpouseLbl', '');

			component.find('estateBridgingCheckbox').set('v.disabled', true);
			helper.calculateTotal(component);
		} else {
			component.find('estateBridgingCheckbox').set('v.disabled', false);

			helper.getMemberPremium(component, sumInsured, 'Estate Bridging Benefit');

			var checkCmp = component.find('estateBridgingCheckbox');
			var spouseAge = component.get('v.spouseAge');
			if (checkCmp.get('v.value') == true) {
				helper.getSpousePremium(component, sumInsured, spouseAge, 'Estate Bridging Benefit');
			}
		}
	},

	onPicklistFuneralBenefitChange: function(component, event, helper) {
		var isTakenBenefit = event.getSource().get('v.value');
		if (isTakenBenefit == 'Yes') {
			helper.getMemberPremium(component, '', 'Family Funeral');
			component.find('funeralBenefitCheckbox').set('v.disabled', false);
		} else {
			component.find('funeralBenefitCheckbox').set('v.disabled', true);
			component.find('funeralBenefitCheckbox').set('v.value', false);
			component.set('v.funeralFeePremium', 0.0);
			component.set('v.funeralFeePremiumLbl', 'Premium: R0.00');
			helper.calculateTotal(component);
		}
	},

	onPicklistEmailChange: function(component, event, helper) {},

	onCompletedCheck: function(component, event) {
		var checkCmp = component.find('completedCheckbox');
		component.set('v.isCompleted', checkCmp.get('v.value'));
		if (checkCmp.get('v.value') == true) {
			component.find('emailSelect').set('v.disabled', true);
			component.set('v.showAlternativeEmail', true);
		} else {
			component.find('emailSelect').set('v.disabled', false);
			component.set('v.showAlternativeEmail', false);
		}
	},

	emailQuote: function(component, event, helper) {
		var checkCmp = component.find('completedCheckbox');
		var emailAddress = component.get('v.selectedEmail');
		var altEmailAddress = component.get('v.alternativeEmail');
		var isAlternative = component.get('v.alternativeEmailSelected');
		//Alternative Email Selected
		if (checkCmp.get('v.value') == true) {
			var motivationArr = [];
			motivationArr.push(component.find('altEmail'));
			var allValid = motivationArr.reduce(function(validSoFar, inputCmp) {
				inputCmp.showHelpMessageIfInvalid();
				inputCmp.focus();
				return validSoFar && inputCmp.get('v.validity').valid;
			}, true);
			var allEmails = component.get('v.emailOptions');
			var alternativeEmail = component.get('v.alternativeEmail');
			var isDuplicate = false;
			for (var i = 0; i < allEmails.length; i++) {
				if (alternativeEmail == allEmails[i].value) {
					isDuplicate = true;
				}
			}
			if (isDuplicate) {
				allValid = false;
				// show error notification
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'This email has already been added and cannot be added as an alternative again!',
					type: 'error'
				});
				toastEvent.fire();
			}
			if (allValid) {
				helper.setOppEmail(component);
			}
		} else {
			//Else use default
			var motivationArr = [];
			motivationArr.push(component.find('emailSelect'));
			var allValid = motivationArr.reduce(function(validSoFar, inputCmp) {
				inputCmp.showHelpMessageIfInvalid();
				inputCmp.focus();
				return validSoFar && inputCmp.get('v.validity').valid;
			}, true);
			if (allValid) {
				helper.setOppEmail(component);
			}
		}
	},

	createNewQuote: function(component, event, helper) {
		var motivationArr = [];
		motivationArr.push(component.find('executorsSelect'));
		var allValid = motivationArr.reduce(function(validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			inputCmp.focus();
			return validSoFar && inputCmp.get('v.validity').valid;
		}, true);
		if (allValid) {
			helper.createNewQuote(component);
		}
	},

	newQuoteProcess: function(component, event, helper) {
		component.set('v.showQuoteScreen', true);
		component.set('v.showCommissionScreen', false);
		helper.getExistingQuote(component);
		helper.checkAccountValid(component);
	},

	openConfirmation: function(component, event, helper) {
		// for Display Model,set the "isOpen" attribute to "true"
		component.set('v.showSpouseScreen', true);
	},

	closeConfirmation: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "False"
		if (component.get('v.currentCheckbox') == 'executorsCheckbox') {
			var executorsCheckbox = component.find('executorsCheckbox');
			executorsCheckbox.set('v.value', false);
		}

		if (component.get('v.currentCheckbox') == 'estateBridgingCheckbox') {
			var estateBridgingCheckbox = component.find('estateBridgingCheckbox');
			estateBridgingCheckbox.set('v.value', false);
		}

		if (component.get('v.currentCheckbox') == 'funeralBenefitCheckbox') {
			var funeralBenefitCheckbox = component.find('funeralBenefitCheckbox');
			funeralBenefitCheckbox.set('v.value', false);
		}

		component.set('v.showSpouseScreen', false);
	},

	confrimAndClose: function(component, event, helper) {
		var motivationArr = [];
		motivationArr.push(component.find('spouseDOB'));
		var allValid = motivationArr.reduce(function(validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			inputCmp.focus();
			return validSoFar && inputCmp.get('v.validity').valid;
		}, true);
		if (allValid) {
			var today = new Date();
			var birthDate = new Date(component.get('v.spouseDOB'));
			var age = today.getFullYear() - birthDate.getFullYear();
			var m = today.getMonth() - birthDate.getMonth();
			if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
				age--;
			}
			var minAge = component.get('v.spouseMinAge');
			var maxAge = component.get('v.spouseMaxAge');
			if (Number(age) < minAge) {
				// show error notification
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'A Spouse must be older than ' + minAge + ' years of age.',
					type: 'error'
				});
				toastEvent.fire();
			} else if (Number(age) >= maxAge) {
				// show error notification
				var toastEvent = $A.get('e.force:showToast');
				toastEvent.setParams({
					title: 'Error!',
					message: 'A Spouse cannot be older than ' + maxAge + ' years of age.',
					type: 'error'
				});
				toastEvent.fire();
			} else {
				component.set('v.spouseAge', Number(age));
				var spouseAge = component.get('v.spouseAge');

				var executorsCheckbox = component.find('executorsCheckbox').get('v.value');
				var estateBridgingCheckbox = component.find('estateBridgingCheckbox').get('v.value');

				if (executorsCheckbox == true) {
					var sumInsured = component.find('executorsSelect').get('v.value');
					if (sumInsured != '') {
						helper.getSpousePremium(component, sumInsured, spouseAge, 'Executors Fees Cover');
					}
				}
				if (estateBridgingCheckbox == true) {
					var sumInsured = component.find('estateBridgingSelect').get('v.value');
					if (sumInsured != '') {
						helper.getSpousePremium(component, sumInsured, spouseAge, 'Estate Bridging Benefit');
					}
				}

				component.set('v.showSpouseScreen', false);
			}
		}
	}
});