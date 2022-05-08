({
	fetchPickListValForDesiredRisk: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "Low",
			value: "Low"
		});
		opts.push({
			class: "optionClass",
			label: "Low-medium",
			value: "Low-medium"
		});
		opts.push({
			class: "optionClass",
			label: "Medium",
			value: "Medium"
		});
		opts.push({
			class: "optionClass",
			label: "Medium-high",
			value: "Medium-high"
		});
		opts.push({
			class: "optionClass",
			label: "High",
			value: "High"
		});
		component.set("v.DesiredriskOptions", opts);
	},
	fetchPickListValForInvestmentobjective: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "Capital growth",
			value: "Capital growth"
		});
		opts.push({
			class: "optionClass",
			label: "Income",
			value: "Income"
		});
		opts.push({
			class: "optionClass",
			label: "Combination",
			value: "Combination"
		});

		component.set("v.InvestmentobjectiveOptions", opts);
	},
	fetchPickListValForCashAccruals: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "Reinvest",
			value: "Reinvest"
		});
		opts.push({
			class: "optionClass",
			label: "Pay out",
			value: "Pay out"
		});
		component.set("v.CashAccrualsOptions", opts);
	},
	fetchPickListValForFrequencyofpayment: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "On request",
			value: "On request"
		});
		opts.push({
			class: "optionClass",
			label: "Monthly",
			value: "Monthly"
		});
		opts.push({
			class: "optionClass",
			label: "Quarterly",
			value: "Quarterly"
		});

		component.set("v.FrequencyofpaymentOptions", opts);
	},
	fetchPickListValForFinancialCategory: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "Yes",
			value: "Yes"
		});
		opts.push({
			class: "optionClass",
			label: "No",
			value: "No"
		});
		component.set("v.FinancialCategoryOptions", opts);
	},
	fetchPickListValForClientAdvice: function (component, event) {
		var opts = [];
		opts.push({
			class: "optionClass",
			label: "--- None ---",
			value: ""
		});
		opts.push({
			class: "optionClass",
			label: "Accepted",
			value: "Accepted"
		});
		opts.push({
			class: "optionClass",
			label: "Did not accept",
			value: "Did not accept"
		});
		component.set("v.ClientAdviceOptions", opts);
	},
	createRecordOfAdviceRecords: function (component, event, helper) {
		/* var Q21;var Q23;var Q24;var Q25;
        if(component.find('AmounttobeinvestedId') ==undefined){
            Q21=null;}else{Q21=component.find('AmounttobeinvestedId').get('v.value');}
        
        if(component.find('MotivationforrecommendationId') ==undefined){
            Q24=null;}else{Q24=component.find('MotivationforrecommendationId').get('v.value');}*/
		var Q25;
		var Q23;
		if (component.find("SupervisornameId") == undefined) {
			Q23 = null;
		} else {
			Q23 = component.find("SupervisornameId").get("v.value");
		}
		if (component.find("PhasingininstructionId") == undefined) {
			Q25 = null;
		} else {
			Q25 = component.find("PhasingininstructionId").get("v.value");
		}
		var action = component.get("c.createQuestionnaireRecordlist");
		action.setParams({
			OppId: component.get("v.recordId"),
			QQ1: component.get("v.clientmandate"),
			QQ2: component.get("v.selectedDesiredriskexposure"),
			QQ3: component.get("v.selectedInvestmentobjective"),
			QQ4: component.get("v.selectedCashAccruals"),
			QQ5: component.get("v.selectedFrequencyofpayment"),
			QQ6: component.get("v.selectedsharesCon"),
			QQ7: component.get("v.selectedsharesRecom"),
			QQ8: component.get("v.selectedmoneymarketCon"),
			QQ9: component.get("v.selectedmoneymarketRecom"),
			QQ10: component.get("v.selectedDebenturesCon"),
			QQ11: component.get("v.selectedDebenturesRecom"),
			QQ12: component.get("v.selectedBondsCon"),
			QQ13: component.get("v.selectedBondsRecom"),
			QQ14: component.get("v.selectedDerivativesCon"),
			QQ15: component.get("v.selectedDerivativesRecom"),
			QQ16: component.get("v.selectedschemesCon"),
			QQ17: component.get("v.selectedschemesRecom"),
			QQ18: component.get("v.selectedWarrantsCon"),
			QQ19: component.get("v.selectedWarrantsRecom"),
			QQ20: component.get("v.Representative"),
			QQ21: component.find("AmounttobeinvestedId").get("v.value"),
			QQ22: component.get("v.Supervisorselect"),
			QQ23: Q23,
			QQ24: component.find("MotivationforrecommendationId").get("v.value"),
			QQ25: Q25,
			QQ26: component.get("v.ClientAdvice")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var result = JSON.stringify(response.getReturnValue());
				console.log("result----" + result);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success",
					message: "Records has been Sucessfully Updated",
					duration: " 5000",
					type: "success"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
			}
		});
		$A.enqueueAction(action);
	},
	fetchQuestionnaireRecordlist: function (component, event, helper) {
		var action = component.get("c.getQuestionnaireRecordlist");
		action.setParams({
			OppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var checklistRec = JSON.stringify(response.getReturnValue());
				console.log("checklistRec" + checklistRec.Question__c);
				var rec = response.getReturnValue();
				var item;
				for (var i = 0; i < rec.length; i++) {
					item = rec[i];

					if (item.Question__c == "Client’s Investment objective has changed from that indicated in client mandate?") {
						component.set("v.clientmandate", item.Answer__c);
						if (item.Answer__c == "Yes") {
							component.set("v.visiblesection1", true);
						} else {
							component.set("v.visiblesection1", false);
						}
					}
					if (item.Question__c == "Desired risk exposure") {
						component.set("v.selectedDesiredriskexposure", item.Answer__c);
					}
					if (item.Question__c == "Investment objective") {
						component.set("v.selectedInvestmentobjective", item.Answer__c);
					}
					if (item.Question__c == "Cash Accruals") {
						component.set("v.selectedCashAccruals", item.Answer__c);
						if (item.Answer__c == "Pay out") {
							component.set("v.visiblesection2", true);
						} else {
							component.set("v.visiblesection2", false);
						}
					}
					if (item.Question__c == "Frequency of payment required") {
						component.set("v.selectedFrequencyofpayment", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Shares (Considered)") {
						component.set("v.selectedsharesCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Shares (Recommended)") {
						component.set("v.selectedsharesRecom", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Money market instruments (Considered)") {
						component.set("v.selectedmoneymarketCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Money market instruments (Recommended)") {
						component.set("v.selectedmoneymarketRecom", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Debentures and securitised debt (Considered)") {
						component.set("v.selectedDebenturesCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Debentures and securitised debt (Recommended)") {
						component.set("v.selectedDebenturesRecom", item.Answer__c);
					}

					if (item.Question__c == "Securities and instruments: Bonds (Considered)") {
						component.set("v.selectedBondsCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Bonds (Recommended)") {
						component.set("v.selectedBondsRecom", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Derivatives instruments (Considered)") {
						component.set("v.selectedDerivativesCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Derivatives instruments (Recommended)") {
						component.set("v.selectedDerivativesRecom", item.Answer__c);
					}
					if (item.Question__c == "Participatory interests in collective investment schemes (Considered)") {
						component.set("v.selectedschemesCon", item.Answer__c);
					}
					if (item.Question__c == "Participatory interests in collective investment schemes (Recommended)") {
						component.set("v.selectedschemesRecom", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Warrants, certificates and other instruments acknowledging (Considered)") {
						component.set("v.selectedWarrantsCon", item.Answer__c);
					}
					if (item.Question__c == "Securities and instruments: Warrants, certificates and other instruments acknowledging (Recommended)") {
						component.set("v.selectedWarrantsRecom", item.Answer__c);
					}
					if (item.Question__c == "Representative under supervision?") {
						component.set("v.Representative", item.Answer__c);
						if (item.Answer__c == "Yes") {
							component.set("v.visiblesection3", true);
						} else {
							component.set("v.visiblesection3", false);
						}
					}
					if (item.Question__c == "Supervisor attended the client meeting with the supervisee?") {
						component.set("v.Supervisorselect", item.Answer__c);
					}
					if (item.Question__c == "Supervisor name") {
						component.set("v.Supervisorname", item.Answer__c);
					}
					if (item.Question__c == "Motivation for recommendation") {
						component.set("v.Motivationforrecommendation", item.Answer__c);
					}
					if (item.Question__c == "Phasing in instruction (if applicable)") {
						component.set("v.Phasingininstruction", item.Answer__c);
					}
					if (item.Question__c == "Client accepted/did not accept advice") {
						component.set("v.ClientAdvice", item.Answer__c);
					}
					if (item.Question__c == "Amount to be invested") {
						component.set("v.Amounttobeinvested", item.Answer__c);
					}
				}
			}
		});
		$A.enqueueAction(action);
	},

	getAccountRecord: function (component, event, helper) {
		var action = component.get("c.getAccount");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state === "SUCCESS") {
				var accRec = JSON.stringify(response.getReturnValue());
				console.log("Is_Platform__c" + accRec.Is_Platform__c);
				var accRec1 = response.getReturnValue();
				//if(accRec1 !=null){
				if (accRec1.SPM_Platform_Type__c != null) {
					component.set("v.isPlatform", true);
				} else {
					component.set("v.isPlatform", false);
				}
				console.log("Is Account Platform " + component.get("v.isPlatform"));

				//}
			} else {
				console.log("Failed with state: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	}
});