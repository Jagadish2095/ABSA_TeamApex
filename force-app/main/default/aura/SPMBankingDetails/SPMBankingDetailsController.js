({
	doInit: function (component, event, helper) {
		//console.log('Opportunity Id' + component.get("v.recordId"));

		helper.fetchPickListVal(component, "Account_Type__c", "accountType");
		helper.fetchPickListVal(component, "Type__c", "Type");
		helper.getPaymentplanRecord(component);
		helper.getAccountRecord(component);
		helper.getAppRec(component, event, helper);
		// helper.getBankingAccountDetails(component, event, helper);
	},
	onPicklistChange: function (component, event, helper) {
		helper.onPicklistAccTypeChange(component, event);
	},
	onPicklisttypeChange: function (component, event, helper) {
		helper.onPicklistTypeChange(component, event);
	},
	handleBrachCodeComponentEvent: function (component, event, helper) {
		//Event handler to get branch code from child component
		//2021-06-11
		var pselectedBranchCodeGetFromEvent = event.getParam("recordBranchCodeEvent");
		var pselectedBankNameGetFromEvent = event.getParam("recordBankNameEvent");
		component.set("v.paymentPlan.Branch_Code__c", pselectedBranchCodeGetFromEvent);
		// component.set("v.paymentPlan.Bank_Name__c", pselectedBankNameGetFromEvent);
	},
	setSelectedBankAndBranchName: function (component, event, helper) {
		console.log("setSelectedBankAndBranchName");
		var params = event.getParam("arguments");

		var customLookUpCmp = component.find("customLookUpCmp");
		customLookUpCmp.setSelectedBankName(params.selectedBankName);

		var dependentCutomLookupCmp = component.find("dependentCutomLookupCmp");
		dependentCutomLookupCmp.setSelectedBranchName(params.selectedBranchName);
	},
	validateAcc: function (component, event, helper) {
		component.set("v.showSpinner", true);
		helper.submitPaymentPlan(component);
	},
	getAccountNumbers: function (component, event, helper) {
		var selectedProdType = component.get("v.selectedProductValue");
		var respObj = component.get("v.responseList");
		var acc = [];

		for (var key in respObj) {
			if (respObj[key].productType == selectedProdType) {
				acc.push(respObj[key].oaccntnbr);
			}
		}
		component.set("v.accNumList", acc);
	},

	getSelectedAccount: function (component, event, helper) {
		var selectedAccountValue = component.get("v.selectedAccountNumber");
		var accBranchCode;
		var respObj = component.get("v.responseList");
		var selectedProdType = component.get("v.selectedProductValue");

		for (var key in respObj) {
			if (respObj[key].oaccntnbr == selectedAccountValue) {
				accBranchCode = respObj[key].branch;
				component.set("v.paymentPlan.Bank_Name__c", "ABSA BANK LIMITED");
				component.set("v.paymentPlan.Branch_Code__c", respObj[key].branch);
				component.set("v.paymentPlan.Account_Number__c", selectedAccountValue);
				component.set("v.paymentPlan.BIC_Code__c", "ABSAZAJJ");

				if (selectedProdType == "CQ") {
					component.set("v.paymentPlan.Account_Type__c", "Cheque");
				} else {
					component.set("v.paymentPlan.Account_Type__c", "Savings");
				}
			}
		}

		component.set("v.selectedAccountNumberToFlow", selectedAccountValue);
		component.set("v.selectedProductBranch", accBranchCode);
	},

	retrieveBankingDetails: function (component, event, helper) {
		component.set("v.showSpinner", true);
		helper.getBankingAccountDetails(component, event, helper);
	},
	saveadditionalfields: function (component, event, helper) {
		component.set("v.showSpinner", true);
		var firstname;
		var absatrustref1;
		var trustname;
		var absatrustref2;
		if (component.find("clientname1") == undefined) {
			firstname = null;
		} else {
			firstname = component.find("clientname1").get("v.value");
		}
		/*if(component.find('clientnumber1')==undefined){
            absatrustref1=null;}else{absatrustref1=component.find('clientnumber1').get('v.value');}*/
		if (component.find("clientname2") == undefined) {
			trustname = null;
		} else {
			trustname = component.find("clientname2").get("v.value");
		}
		if (component.find("clientnumber2") == undefined) {
			absatrustref2 = null;
		} else {
			absatrustref2 = component.find("clientnumber2").get("v.value");
		}
		if (
			component.get("v.appRec.Platform__c") == "Absa Trust - Burg Managed (BD)" ||
			component.get("v.appRec.Platform__c") == "Absa Trust - Burg Managed Portfolio (BG)" ||
			component.get("v.appRec.Platform__c") == "Absa Trust - Ex TR (BK)" ||
			component.get("v.appRec.Platform__c") == "Absa Trust Discretionary (BP)"
		) {
			if (trustname == undefined || absatrustref2 == undefined || trustname == "" || absatrustref2 == "") {
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
				helper.additionalApplicationFieldsSaving(component);
			}
		} else if (
			component.get("v.appRec.Platform__c") != "Absa Trust - Burg Managed (BD)" ||
			component.get("v.appRec.Platform__c") != "Absa Trust - Burg Managed Portfolio (BG)" ||
			component.get("v.appRec.Platform__c") != "Absa Trust - Ex TR (BK)" ||
			component.get("v.appRec.Platform__c") != "Absa Trust Discretionary (BP)"
		) {
			if (firstname == undefined || firstname == "") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error",
					message: "Please complete all required fields2",
					duration: " 5000",
					type: "error"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
			} else {
				helper.additionalApplicationFieldsSaving(component);
			}
		}
	}
});