({
	helperMethod: function () {

	},
	checkAccountValid: function (component) {
		component.set('v.showSpinner', true);
		var oppId = component.get("v.OpportunityFromFlow");//component.get('v.recordId');
		var action = component.get('c.checkAccountValid');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			var state = response;
			var result = response.getReturnValue();
			if (result == 'Valid') {
				component.set('v.accountNotValid', false);
				this.getOpportunityDetails(component);
			} else {
				component.set('v.accountInValidReason', result);
				component.set('v.accountNotValid', true);
				component.set("v.showUpScreen", false);
				component.set("v.showErrorScreen", false);
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},

	getOpportunityDetails: function (component, event) {
		component.set("v.showSpinner", true);
		var oppId = component.get("v.OpportunityFromFlow");
		console.log(component.get("v.OpportunityFromFlow") + ' oppId Road cover ' + oppId);
		var action = component.get("c.fetchOpportunityRecord");
		action.setParams({
			"oppId": oppId
		});
		action.setCallback(this, function (a) {

			var state = a.getState();
			console.log('state ' + state);
			if (state === "SUCCESS") {
				var oppRecord = a.getReturnValue();
				component.set("v.opportunityDetails", oppRecord[0]);
				this.getOpportunitypartyDetails(component);
				if (oppRecord[0].Person_Account_Age__c && oppRecord[0].Person_Account_Age__c != null) {
					if (oppRecord[0].Person_Account_Age__c >= 60) {
						component.set("v.showErrorScreen", true);
					} else {
						component.set("v.showUpScreen", true);
					}

				} else {
					component.set("v.showUpScreen", true);
					component.set("v.showErrorScreen", false);
				}
				component.set('v.showSpinner', false);

			} else {
				component.set('v.showSpinner', false);
			}
		});
		$A.enqueueAction(action);
	},

	getOpportunitypartyDetails: function (component, event) {
		component.set("v.showSpinner", true);
		var oppData = component.get("v.opportunityDetails");
		var quoteStatus;
		var oppId = component.get("v.OpportunityFromFlow");
		var action = component.get("c.getPartyData");
		action.setParams({
			"oppId": oppId
		});
		action.setCallback(this, function (a) {
			var state = a.getState();
			console.log('state ' + state)
			if (state === "SUCCESS") {
				var oppPartyExist = [];
				var existingData = a.getReturnValue();
				if (existingData.length > 0) {
					/*for (var i = 0; i < existingData.length; i++) {
						if (existingData[i].DD_Cross_Sell_Product_Member_Type__c && existingData[i].DD_Cross_Sell_Product_Member_Type__c != '') { //Rider_Type__c temp chnage
							//counting the data
							if (existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Ultimate Protector")) {
								oppPartyExist.push(existingData[i]);
								existingData[i].DD_Cross_Sell_Product_Member_Type__c = "Ultimate Protector";
								if (existingData[i].Question1__c) {
									component.set("v.quest1Res", 'Yes');
								} else {
									component.set("v.quest1Res", 'No');
								}
								if (existingData[i].Question2__c) {
									component.set("v.quest2Res", 'Yes');
								} else {
									component.set("v.quest2Res", 'No');
								}
								if (existingData[i].Question3__c) {
									component.set("v.quest3Res", 'Yes');
								} else {
									component.set("v.quest3Res", 'No');
								}


							}
						}//outer if end
					}//for loop end*/
				//	component.set("v.oppPartyDetailsList", oppPartyExist);
					var action2 = component.get("c.getQuoteLineItemsDataByProduct");
					action2.setParams({
						"oppId": oppId,
						"productName": 'Ultimate Protector'
					});
					action2.setCallback(this, function (res) {
						var state1 = res.getState();
						if (state1 === 'SUCCESS') {
							var quoteData = res.getReturnValue();
							if (quoteData != null && quoteData.length > 0) {
								//added newly for outcome change

								for (var i = 0; i < existingData.length; i++) {
									if (existingData[i].DD_Cross_Sell_Product_Member_Type__c && existingData[i].DD_Cross_Sell_Product_Member_Type__c != '') { //Rider_Type__c temp chnage
										//counting the data
										if (existingData[i].DD_Cross_Sell_Product_Member_Type__c.includes("Ultimate Protector")) {
											oppPartyExist.push(existingData[i]);
											existingData[i].DD_Cross_Sell_Product_Member_Type__c = "Ultimate Protector";
											if (existingData[i].Question1__c) {
												component.set("v.quest1Res", 'Yes');
											} else {
												component.set("v.quest1Res", 'No');
											}
											if (existingData[i].Question2__c) {
												component.set("v.quest2Res", 'Yes');
											} else {
												component.set("v.quest2Res", 'No');
											}
											if (existingData[i].Question3__c) {
												component.set("v.quest3Res", 'Yes');
											} else {
												component.set("v.quest3Res", 'No');
											}
			
			
										}
									}//outer if end
								}//for loop end

								component.set("v.oppPartyDetailsList", oppPartyExist);
									//------end
								if (oppPartyExist != null && oppPartyExist.length > 0 && quoteData != null && quoteData.length > 0) {
									for (var k = 0; k < quoteData.length; k++) {
										oppData.Quote_Outcome__c = quoteData[k].Quote.Quote_Outcome__c;//addedd by pranv 19022021
										oppData.Quote_Outcome_Reason__c = quoteData[k].Quote.Quote_Outcome_Reason__c;//addedd by pranv 19022021
										quoteStatus = quoteData[k].Quote.Status;//addedd by pranv 19022021
										if (quoteData[k].Benefit__c != null) {
											if (quoteData[k].Benefit__c == 'U01_U03') {
												component.set("v.showDeathDisablity", true);
												component.set("v.showBenfit", true);
												component.set("v.selectedDeathDisablity", true);
												//component.set();
											} else if (quoteData[k].Benefit__c == 'U02_U03') {
												component.set("v.showAccidentalDeathDisablity", true);
												component.set("v.selectedAccidentalDeathDisablity", true);
												component.set("v.showBenfit", true);
											} else if (quoteData[k].Benefit__c == 'policyCover' && quoteData[k].Premium__c != null) {
												component.set('v.policyFee', quoteData[k].Premium__c)
											}
										}
										if (quoteData[k].Policy_Cover__c != null && quoteData[k].Policy_Cover__c != 0) {
											component.set("v.coverage", quoteData[k].Policy_Cover__c);
											component.set("v.Premium", quoteData[k].Premium__c);
										}
									}//for loop end
									component.set("v.quoteStatus", quoteStatus);
									component.set("v.opportunityDetails", oppData);
									this.calculateTotal(component);
								} //length check end
							}//Quotelengthcheck newly added
							else {

								var action = component.get('c.getQuoteData1');
								action.setParams({
									"oppId": oppId,
									"productName" : 'Ultimate Protector'
								});
								action.setCallback(this, function (a) {//
									var state = a.getState();
									if (state === "SUCCESS") {
										var quoteResp = a.getReturnValue();
										if (quoteResp != null && quoteResp.length > 0) {
											oppData.Quote_Outcome__c = quoteResp[0].Quote_Outcome__c;
											oppData.Quote_Outcome_Reason__c = quoteResp[0].Quote_Outcome_Reason__c;
											quoteStatus = quoteResp[0].Status;
											component.set("v.quoteStatus", quoteStatus);
											component.set("v.opportunityDetails", oppData);
											component.set("v.oppPartyDetailsList", existingData);

										}
                                        else {
										component.set("v.spinner", false);
									}

									}
									else {
										component.set("v.spinner", false);
									}
								});
								$A.enqueueAction(action);


							}
							component.set("v.spinner", false);
						}//success 2 end
						else {
							component.set("v.spinner", false);
						}
					});
					$A.enqueueAction(action2);
				}//length check if end

			}//1st success if end
			else {
				component.set("v.spinner", false);
			}
		});
		$A.enqueueAction(action);
	},


	fetchPickListVal: function (component, fieldName, elementId) {
		//this.showSpinner(component);
		component.set('v.showSpinner', true);
		var action = component.get('c.getselectOptions');
		action.setParams({
			objObject: component.get('v.pricingMatrix'),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function (response) {
			if (response.getState() == 'SUCCESS') {
				var allValues = response.getReturnValue();

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
				if (elementId == 'accidentalDeathBenefit') {
					component.set('v.accidentalDeathBenefitOptions', opts);
				} else if (elementId == 'deathBenifit') {
					component.set('v.deathBenifitOptions', opts);
				}
				this.getPolicyFee(component);
				//	this.hideSpinner(component);
				component.set('v.showSpinner', false);
			} else {
				component.set('v.showSpinner', false);
			}
		});
		$A.enqueueAction(action);
	},

	getPolicyCreate: function (component) {
		component.set('v.showSpinner2', true);

		var oppId = component.get("v.OpportunityFromFlow");
		var action = component.get('c.getPolicy');
		action.setParams({
			oppId: oppId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				var data = response.getReturnValue();
				component.set('v.policySession', data);
				console.log('1st log ' + component.get('v.policySession'));
			}
			component.set('v.showSpinner2', false);
		});
		$A.enqueueAction(action);
	},
	getPolicyFee: function (component) {
		component.set('v.policyFee', 10);
		/*var action = component.get('c.getPolicyFee');
		action.setCallback(this, function(a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				var policyFee = a.getReturnValue();
				component.set('v.policyFee', policyFee);
			}
		});
		$A.enqueueAction(action);*/
	},

	getMemberPremium: function (component, sumInsured, recordType) {
		component.set('v.showSpinner', true);
		var oppId = component.get("v.OpportunityFromFlow");
		var action = component.get('c.getMemberPremiumWbif');
		console.log('policySession', component.get('v.policySession'));
		action.setParams({
			oppId: oppId,
			sumInsured: sumInsured,
			recordType: recordType,
			policy: component.get('v.policySession')
		});
		action.setCallback(this, function (a) {
			var state = a.getState();
			if (state === 'SUCCESS') {
				console.log('***' + a.getReturnValue());
				var prem = a.getReturnValue();
				if (!$A.util.isEmpty(prem) && prem > 0) {
					component.set("v.isQuoteDone", false);
				}
				if (recordType == 'Death and Accidental Disability') {
					var deathBenifitPremium = a.getReturnValue();
					component.set('v.Premium', deathBenifitPremium.toFixed(2));
					this.calculateTotal(component);
				} else if (recordType == 'Accidental Death Benifit and Accidental Disability') {
					var accidentalDeathBenefitPremium = a.getReturnValue();
					component.set('v.Premium', accidentalDeathBenefitPremium.toFixed(2));
					this.calculateTotal(component);
				}
			}
			component.set('v.showSpinner', false);
		});
		$A.enqueueAction(action);
	},
	calculateTotal: function (component) {
		var deathBenifitPremium = component.get('v.Premium');
		//var accidentalDeathBenefitPremium = component.get('v.accidentalDeathBenefitPremium');
		var policyFee = component.get('v.policyFee');

		var total =
			Number(deathBenifitPremium) +
			Number(policyFee);
		component.set('v.totalPremium', total.toFixed(2));
		component.set('v.totalPremiumLbl', 'Total Premium (including Policy Fee): R' + total.toFixed(2));
	},

	saveOppPartyData: function (component, event, helper) {
		component.set("v.showSpinner", true);
		//var oppData =component.get("v")
		var oppPartyData = component.get("v.oppPartyDetailsList");
		var ques1res = component.get("v.quest1Res");
		var ques2res = component.get("v.quest2Res");
		var ques3res = component.get("v.quest3Res");
		var updatelist = [];
		// Added by Poulami to update quote status
		var quoteOutcome = component.find('Quote_Outcome__c').get("v.value");
		var quoteOutcomeReason = component.find('Quote_Outcome_Reason__c').get("v.value");
		var quoteStatus;
		if (quoteOutcome == 'Client Interested')
			quoteStatus = 'Accepted';
		else if (quoteOutcome == 'Client Not Interested')
			quoteStatus = 'Rejected';
		else if (quoteOutcome == 'Client Not Insurable' || quoteOutcome == 'Duplicate Quote')
			quoteStatus = 'Denied';
		else
			quoteStatus = 'Draft';
		component.set('v.quoteStatus', quoteStatus);
		if(ques1res!=''){
		if (ques1res == 'Yes') {
			oppPartyData[0].Question1__c = true;
		} else {
			oppPartyData[0].Question1__c = false;
		}
	}

	if(ques1res!=''){
		if (ques2res == 'Yes') {
			oppPartyData[0].Question2__c = true;
		} else {
			oppPartyData[0].Question2__c = false;
		}
	}
		if(ques1res!=''){
		if (ques3res == 'Yes') {
			oppPartyData[0].Question3__c = true;
		} else {
			oppPartyData[0].Question3__c = false;
		}
	}
		updatelist.push(oppPartyData[0]);
		component.set("v.oppPartyDetailsList", updatelist)
		console.log('party datac ' + JSON.stringify(component.get("v.oppPartyDetailsList")));
		var action = component.get("c.insertOppPartyData");
		action.setParams({
			"oppPartyList": component.get("v.oppPartyDetailsList")
		});
		action.setCallback(this, function (a) {
			var state = a.getState();
			if (state === "SUCCESS") {
				var oppParties = a.getReturnValue();
				var qteList = [];
				var namelabel = 'name';
				if (component.get("v.selectedDeathDisablity") == true) {
					namelabel = 'U01_U03';
				} else if (component.get("v.selectedAccidentalDeathDisablity") == true) {
					namelabel = 'U02_U03';
				}
				qteList.push({
					Name: namelabel,
					premium: component.get("v.Premium"),
					SumInsured: component.get("v.coverage"),
					OppPartyId: oppParties[0].Id
				});
				qteList.push({
					Name: 'policyCover',
					premium: 10,
					SumInsured: 0,
					OppPartyId: oppParties[0].Id
				});

				var action1 = component.get("c.createDDQuote");
				action1.setParams({
					oppId: component.get('v.OpportunityFromFlow'),
					totalPremium: '',
					product: 'Ultimate Protector',
					lineItems: JSON.stringify(qteList),
					partyType: 'Ultimate Protector',
					oppData: component.get("v.opportunityDetails"),//added newly
					quoteStatus: quoteStatus
				});

				action1.setCallback(this, function (a) {
					var state = a.getState();
					console.log('state' + state)
					if (state === 'SUCCESS') {

						// show success notification
						component.set("v.showSpinner", false);
						var toastEvent = $A.get('e.force:showToast');
						toastEvent.setParams({
							title: 'Success!',
							message: 'Quote Successfully Created',
							type: 'success'
						});
						toastEvent.fire();
						var editQuote = component.get("v.showQuoteEdit");
						if (editQuote == true) {
							//showQuoteEditEvent
							component.set("v.updateQuoteScreenClose", false);

						} else {
							//added fro navigation
							var actionClicked = event.getSource().getLocalId();
							// Call that action
							var navigate = component.getEvent("navigateFlowEvent");
							navigate.setParam("action", actionClicked);
							navigate.setParam("outcome", quoteStatus);
							navigate.fire();
						}
					} else {
						// show error notification
						component.set("v.showSpinner", false);
						var toastEvent = $A.get('e.force:showToast');
						toastEvent.setParams({
							title: 'Error!',
							message: 'Error creating new quote. Please try again!',
							type: 'error',
							mode: 'sticky'
						});
						toastEvent.fire();
					}
					//$A.get('e.force:refreshView').fire();
				});
				$A.enqueueAction(action1);
			}

		});
		$A.enqueueAction(action);

	}
})