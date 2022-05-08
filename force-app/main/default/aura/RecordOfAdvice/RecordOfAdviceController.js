({
	doInit: function (component, event, helper) {
		helper.fetchPickListValForDesiredRisk(component, event);
		helper.fetchPickListValForInvestmentobjective(component, event);
		helper.fetchPickListValForFrequencyofpayment(component, event);
		helper.fetchPickListValForCashAccruals(component, event);
		helper.fetchPickListValForFinancialCategory(component, event);
		helper.fetchPickListValForClientAdvice(component, event);
		helper.fetchQuestionnaireRecordlist(component, event);
		helper.getAccountRecord(component);
	},
	onChange: function (component, event, helper) {
		var QQ1;
		var QQ2;
		var QQ3;
		var QQ4;
		var QQ5;
		var QQ22;
		if (component.find("indicateclientmandateId") == undefined) {
			QQ1 = null;
		} else {
			QQ1 = component.find("indicateclientmandateId").get("v.value");
		}
		if (component.find("DesiredriskexposureId") == undefined) {
			QQ2 = null;
		} else {
			QQ2 = component.find("DesiredriskexposureId").get("v.value");
		}
		if (component.find("InvestmentobjectiveId") == undefined) {
			QQ3 = null;
		} else {
			QQ3 = component.find("InvestmentobjectiveId").get("v.value");
		}
		if (component.find("CashAccrualsId") == undefined) {
			QQ4 = null;
		} else {
			QQ4 = component.find("CashAccrualsId").get("v.value");
		}
		if (component.find("FrequencyofpaymentrequiredId") == undefined) {
			QQ5 = null;
		} else {
			QQ5 = component.find("FrequencyofpaymentrequiredId").get("v.value");
		}
		if (component.find("indicateSupervisorId") == undefined) {
			QQ22 = null;
		} else {
			QQ22 = component.find("indicateSupervisorId").get("v.value");
		}
		var QQ6 = component.find("SharesConsideredId").get("v.value");
		var QQ7 = component.find("SharesRecommendedId").get("v.value");
		var QQ8 = component.find("moneymarketConsideredId").get("v.value");
		var QQ9 = component.find("moneymarketRecommendedId").get("v.value");
		var QQ10 = component.find("DebenturesConsideredId").get("v.value");
		var QQ11 = component.find("DebenturesRecommendedId").get("v.value");
		var QQ12 = component.find("BondsConsideredId").get("v.value");
		var QQ13 = component.find("BondsRecommendedId").get("v.value");
		var QQ14 = component.find("DerivativesConsideredId").get("v.value");
		var QQ15 = component.find("DerivativesRecommendedId").get("v.value");
		var QQ16 = component.find("schemesConsideredId").get("v.value");
		var QQ17 = component.find("schemesRecommendedId").get("v.value");
		var QQ18 = component.find("WarrantsConsideredId").get("v.value");
		var QQ19 = component.find("WarrantsRecommendedId").get("v.value");
		var QQ20 = component.find("indicateReperesentativeId").get("v.value");
		var QQ26 = component.find("ClientAdviceId").get("v.value");
		component.set("v.clientmandate", QQ1);
		component.set("v.selectedDesiredriskexposure", QQ2);
		component.set("v.selectedInvestmentobjective", QQ3);
		component.set("v.selectedCashAccruals", QQ4);
		component.set("v.selectedFrequencyofpayment", QQ5);
		component.set("v.selectedsharesCon", QQ6);
		component.set("v.selectedsharesRecom", QQ7);
		component.set("v.selectedmoneymarketCon", QQ8);
		component.set("v.selectedmoneymarketRecom", QQ9);
		component.set("v.selectedDebenturesCon", QQ10);
		component.set("v.selectedDebenturesRecom", QQ11);
		component.set("v.selectedBondsCon", QQ12);
		component.set("v.selectedBondsRecom", QQ13);
		component.set("v.selectedDerivativesCon", QQ14);
		component.set("v.selectedDerivativesRecom", QQ15);
		component.set("v.selectedschemesCon", QQ16);
		component.set("v.selectedschemesRecom", QQ17);
		component.set("v.selectedWarrantsCon", QQ18);
		component.set("v.selectedWarrantsRecom", QQ19);
		component.set("v.Representative", QQ20);
		component.set("v.ClientAdvice", QQ26);
		component.set("v.Supervisorselect", QQ22);
		if (QQ1 == "Yes") {
			component.set("v.visiblesection1", true);
		} else {
			component.set("v.visiblesection1", false);
		}
		if (QQ4 == "Pay out") {
			component.set("v.visiblesection2", true);
		} else {
			component.set("v.visiblesection2", false);
		}
		if (QQ20 == "Yes") {
			component.set("v.visiblesection3", true);
		} else {
			component.set("v.visiblesection3", false);
		}
	},

	handleSubmit: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var QQ1;
		var QQ2;
		var QQ3;
		var QQ4;
		var QQ5;
		var QQ22;
		if (component.find("indicateclientmandateId") == undefined) {
			QQ1 = null;
		} else {
			QQ1 = component.find("indicateclientmandateId").get("v.value");
		}
		if (component.find("DesiredriskexposureId") == undefined) {
			QQ2 = null;
		} else {
			QQ2 = component.find("DesiredriskexposureId").get("v.value");
		}
		if (component.find("InvestmentobjectiveId") == undefined) {
			QQ3 = null;
		} else {
			QQ3 = component.find("InvestmentobjectiveId").get("v.value");
		}
		if (component.find("CashAccrualsId") == undefined) {
			QQ4 = null;
		} else {
			QQ4 = component.find("CashAccrualsId").get("v.value");
		}
		if (component.find("FrequencyofpaymentrequiredId") == undefined) {
			QQ5 = null;
		} else {
			QQ5 = component.find("FrequencyofpaymentrequiredId").get("v.value");
		}
		if (component.find("indicateSupervisorId") == undefined) {
			QQ22 = null;
		} else {
			QQ22 = component.find("indicateSupervisorId").get("v.value");
		}
		var QQ6 = component.find("SharesConsideredId").get("v.value");
		var QQ7 = component.find("SharesRecommendedId").get("v.value");
		var QQ8 = component.find("moneymarketConsideredId").get("v.value");
		var QQ9 = component.find("moneymarketRecommendedId").get("v.value");
		var QQ10 = component.find("DebenturesConsideredId").get("v.value");
		var QQ11 = component.find("DebenturesRecommendedId").get("v.value");
		var QQ12 = component.find("BondsConsideredId").get("v.value");
		var QQ13 = component.find("BondsRecommendedId").get("v.value");
		var QQ14 = component.find("DerivativesConsideredId").get("v.value");
		var QQ15 = component.find("DerivativesRecommendedId").get("v.value");
		var QQ16 = component.find("schemesConsideredId").get("v.value");
		var QQ17 = component.find("schemesRecommendedId").get("v.value");
		var QQ18 = component.find("WarrantsConsideredId").get("v.value");
		var QQ19 = component.find("WarrantsRecommendedId").get("v.value");
		var QQ20 = component.find("indicateReperesentativeId").get("v.value");
		var QQ21 = component.find("AmounttobeinvestedId").get("v.value");
		var QQ24 = component.find("MotivationforrecommendationId").get("v.value");
		var QQ26 = component.find("ClientAdviceId").get("v.value");
		if (
			QQ1 == undefined ||
			QQ6 == undefined ||
			QQ7 == undefined ||
			QQ8 == undefined ||
			QQ9 == undefined ||
			QQ9 == undefined ||
			QQ10 == undefined ||
			QQ10 == undefined ||
			QQ11 == undefined ||
			QQ12 == undefined ||
			QQ13 == undefined ||
			QQ14 == undefined ||
			QQ15 == undefined ||
			QQ16 == undefined ||
			QQ17 == undefined ||
			QQ18 == undefined ||
			QQ19 == undefined ||
			QQ20 == undefined ||
			QQ21 == undefined ||
			QQ24 == undefined ||
			QQ26 == undefined
		) {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Error",
				message: "Please complete all required fields",
				duration: " 5000",
				type: "error"
			});
			toastEvent.fire();
			component.set("v.showSpinner", false);
		} else if (QQ1 == "Yes") {
			if (QQ2 == undefined || QQ3 == undefined || QQ4 == undefined) {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error",
					message: "Please complete all required fields",
					duration: " 5000",
					type: "error"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
			} else if (QQ4 == "Pay out") {
				if (QQ5 == undefined) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Error",
						message: "Please complete all required fields",
						duration: " 5000",
						type: "error"
					});
					toastEvent.fire();
					component.set("v.showSpinner", false);
				} else {
					helper.createRecordOfAdviceRecords(component);
				}
			} else {
				helper.createRecordOfAdviceRecords(component);
			}
		} else if (QQ20 == "Yes") {
			if (QQ22 == undefined || component.find("SupervisornameId").get("v.value") == undefined) {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error",
					message: "Please complete all required fields",
					duration: " 5000",
					type: "error"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
			} else {
				helper.createRecordOfAdviceRecords(component);
			}
		} else {
			helper.createRecordOfAdviceRecords(component);
		}
	}
});