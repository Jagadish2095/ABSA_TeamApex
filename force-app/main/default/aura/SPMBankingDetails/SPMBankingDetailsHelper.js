({
	//2021-06-11
	onPicklistAccTypeChange: function (component, event) {
		component.set("v.paymentPlan.Account_Type__c", event.getSource().get("v.value"));
	},
	onPicklistTypeChange: function (component, event) {
		component.set("v.paymentPlan.Type__c", event.getSource().get("v.value"));
	},
	fetchPickListVal: function (component, fieldName, elementId) {
		var action = component.get("c.getSelectOptions");
		action.setParams({
			objObject: component.get("v.paymentPlan"),
			fld: fieldName
		});
		var opts = [];
		action.setCallback(this, function (response) {
			if (response.getState() == "SUCCESS") {
				var allValues = response.getReturnValue();

				if (allValues != undefined && allValues.length > 0) {
					opts.push({
						class: "optionClass",
						label: "--- None ---",
						value: ""
					});
				}
				for (var i = 0; i < allValues.length; i++) {
					opts.push({
						class: "optionClass",
						label: allValues[i],
						value: allValues[i]
					});
				}

				if (elementId == "accountType") {
					component.set("v.accTypeOptions", opts);
				}
				if (elementId == "Type") {
					component.set("v.TypeOptions", opts);
				}
			}
		});
		$A.enqueueAction(action);
	},
	submitPaymentPlan: function (component) {
		var action = component.get("c.submitPaymentPlanDetail");
		var accNumber = component.get("v.paymentPlan.Account_Number__c");
		var accType = component.get("v.paymentPlan.Account_Type__c");
		var bankName = component.get("v.paymentPlan.Bank_Name__c");
		var branchCode = component.get("v.paymentPlan.Branch_Code__c");
		var branchName = component.get("v.paymentPlan.Branch_Name__c");
		var biccode = component.get("v.paymentPlan.BIC_Code__c");
		var accName = component.get("v.paymentPlan.Account_Name__c");
		var name = accType + " - " + accNumber;
		var type = component.get("v.paymentPlan.Type__c");
		action.setParams({
			recId: component.get("v.recordId"),
			accNumber: accNumber,
			accType: accType,
			bankName: bankName,
			branchCode: branchCode,
			branchName: branchName,
			bicval: biccode,
			accountName: accName,
			name: name,
			type: type
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				//Set form status to valid
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					type: "success",
					message: "Bank account details validated & saved successfully."
				});
				toastEvent.fire();
			} else if (state === "ERROR") {
				//Set form status to invalid
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);

						// Show toast
						this.fireToast("error", "Error!", "The was an error saving the bank account details. " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			component.set("v.showSpinner", false);
		});
		$A.enqueueAction(action);
	},
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},
	fireToast: function (type, title, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			type: type,
			title: title,
			message: message
		});
		toastEvent.fire();
	},
	getPaymentplanRecord: function (component, event, helper) {
		var action = component.get("c.getPaymentplanRec");
		action.setParams({
			recId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var paymentRec = JSON.stringify(response.getReturnValue());
				var paymentRec1 = response.getReturnValue();
				component.set("v.paymentPlan", paymentRec1[0]);
			} else {
				console.log("Failed with state: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	},
	getAccountRecord: function (component, event, helper) {
		var action = component.get("c.getAccount");
		action.setParams({
			recordId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var accRec = JSON.stringify(response.getReturnValue());
				console.log("accRec@@" + accRec);
				var accRec1 = response.getReturnValue();
				console.log("accRec.SPM_Platform_Type__c@@" + accRec1.SPM_Platform_Type__c);
				console.log('component.get("v.sObjectName")' + component.get("v.sObjectName"));
				if (accRec1 != null) {
					if (accRec1.SPM_Platform_Type__c != null && component.get("v.sObjectName") == "Opportunity") {
						component.set("v.IsPlatform", true);
					} else {
						component.set("v.IsPlatform", false);
					}
					if (accRec1.SPM_Platform_Type__c != null && component.get("v.sObjectName") == "Account") {
						component.set("v.hidefieldsifPlatform", true);
					} else {
						component.set("v.hidefieldsifPlatform", false);
					}
				}
			} else {
				console.log("Failed with state@@@rec: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	},
	getBankingAccountDetails: function (component, event, helper) {
		var action = component.get("c.getBankingDetails");
		var clientOppId = component.get("v.recordId");
		action.setParams({ clientOppId: clientOppId });
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValue = response.getReturnValue();
				if (responseValue.startsWith("Error: ")) {
					// error
					component.set("v.showSpinner", false);
					component.set("v.errorMessage", responseValue);
				} else {
					// success
					//component.set("v.responseToFlow", responseValue); //Added by chandra dated 11/12/2020
					component.set("v.showSpinner", false);
					component.set("v.isCIFRetrieval", false);
					var respObj = JSON.parse(responseValue);
					component.set("v.responseList", respObj);
					console.log("Products Muvhuso -----> " + JSON.stringify(responseValue));
					var prodTypesSet = new Set();
					var productTypeFilter = component.get("v.productTypeFilter");
					var newProdTypeList = [];

					if (productTypeFilter) {
						var productTypeFilterList = productTypeFilter.toLowerCase().split(";");
					}

					for (var key in respObj) {
						var productType = respObj[key].productType;
						var productTypeTranslated = respObj[key].productTypeTranslated;

						if (!prodTypesSet.has(productType)) {
							if (productType == "CQ" || productType == "SA") {
								if (productType && !productTypeFilterList) {
									prodTypesSet.add(productType);
									newProdTypeList.push({
										label: productTypeTranslated != null ? productTypeTranslated : productType,
										value: productType
									});
								} else if (productType && productTypeFilterList && productTypeFilterList.includes(productType.toLowerCase())) {
									prodTypesSet.add(productType);
									newProdTypeList.push({
										label: productTypeTranslated,
										value: productType
									});
								}
							}
						}
					}

					component.set("v.prodTypesList", newProdTypeList);

					var prodTypesList = [...prodTypesSet].sort(); // Convert Set to List and sort

					if (prodTypesList.length == 0 && !productTypeFilterList) {
						component.set("v.errorMessage", "Error: The client does not have a CIF code saved on Salesforce.");
					} else if (prodTypesList.length == 0 && productTypeFilterList) {
						component.set("v.errorMessage", "Error: No linked Accounts found with filter(s): " + productTypeFilterList);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Apex error CIGetAccountLinkedToClientCodeController.getAccountDetails: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unexpected error occurred, state returned: " + state);
			}
			component.set("v.isSpinner", false);
		});
		$A.enqueueAction(action);
	},
	getAppRec: function (component, event, helper) {
		var action = component.get("c.getAppRec");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appId = response.getReturnValue();
				console.log("AppId123: " + JSON.stringify(appId));
				component.set("v.appRec", appId);
			} else {
				console.log("Failed with state: " + JSON.stringify(appId));
			}
		});

		$A.enqueueAction(action);
	},
	additionalApplicationFieldsSaving: function (component, event, helper) {
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
		var action = component.get("c.saveadditionalinfo");
		action.setParams({
			oppId: component.get("v.recordId"),
			firstname: firstname,
			// "absatrust1" : absatrustref1,
			trustname: trustname,
			absatrust2: absatrustref2,
			platform: component.get("v.appRec.Platform__c")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var applicationRec = response.getReturnValue();
				console.log("AppId: " + JSON.stringify(applicationRec));
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success",
					message: "Records has been Sucessfully Updated",
					duration: " 5000",
					type: "success"
				});
				toastEvent.fire();
				component.set("v.showSpinner", false);
				if (component.get("v.appRec.Platform__c") != "" || component.get("v.appRec.Platform__c") != null) {
					this.updatingOppDetails(component, event, helper);
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(appId));
			}
		});

		$A.enqueueAction(action);
	},
	updatingOppDetails: function (component, event, helper) {
		var action = component.get("c.updateOppStage");
		console.log("Opp Id " + component.get("v.recordId"));
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				console.log("Success with state: " + JSON.stringify(response));
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});
		$A.enqueueAction(action);
	}
});