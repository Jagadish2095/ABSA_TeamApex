({
	showRmuserlist: function (component, event, helper) {
		var action = component.get("c.getRelationshipManagerlist");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				component.set("v.rmList", response.getReturnValue());
				var relationManger = component.get("v.rmList");
				var selectedRm = component.get("v.selectedRm");
				component.set("v.selectedRm", selectedRm);
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});

		$A.enqueueAction(action);
	},
	getAccountDetails: function (component, event, helper) {
		var action = component.get("c.getAccount");
		console.log("Opp Id " + component.get("v.recordId"));
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var acc = response.getReturnValue();
				console.log("accountresp " + JSON.stringify(acc.Platform__c));
				component.set("v.accId", acc.Id);
				component.set("v.accRec", acc);
				if (acc.SPM_Platform_Type__c == null || acc.SPM_Platform_Type__c == "" || acc.SPM_Platform_Type__c == undefined) {
					component.set("v.isPlatform", false);
				} else {
					component.set("v.isPlatform", true);
					component.set("v.Platform", acc.SPM_Platform_Type__c);
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});
		$A.enqueueAction(action);
	},
	getradiobtndetails: function (component, event, helper) {
		var action = component.get("c.getradiobtn");
		console.log("Opp Id " + component.get("v.recordId"));
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var oppRec = response.getReturnValue();
				console.log("oppRec " + JSON.stringify(oppRec));
				console.log("oppRec2 " + JSON.stringify(oppRec.Client_Or_Person_of_US_Citizenship__c));

				//var userradiooption=component.find("usradioId").get("v.value");
				//console.log("userradiooption " + userradiooption);
				component.set("v.usoption", oppRec.Client_Or_Person_of_US_Citizenship__c);
				var userradiooption = component.get("v.usoption");
				console.log("userradiooption " + userradiooption);
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});
		$A.enqueueAction(action);
	},
	getOppDetails: function (component, event, helper) {
		var action = component.get("c.getOpp");
		console.log("Opp Id " + component.get("v.recordId"));
		action.setParams({
			recId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var OPP = response.getReturnValue();
				console.log("OPP " + JSON.stringify(OPP));
				if (OPP.Client_Or_Person_On_US_Citizenship__c == "Yes") {
					component.set("v.optionGiven", "Y");
					component.set("v.showCitizenshipmessage", "Yes");
					component.set("v.showOtherBankmessage", "No");
					component.set("v.IsstageClosed", true);
				} else if (OPP.Client_Or_Person_On_US_Citizenship__c == "No") {
					component.set("v.optionGiven", "N");
					component.set("v.showCitizenshipmessage", "No");
					component.set("v.IsstageClosed", false);
				}
				if (OPP.Client_Has_Accs_Prdcts_Relationship_Bank__c == "Yes") {
					component.set("v.optionGivenforotherbank", "Y");
					component.set("v.showOtherBankmessage", "Yes");
					component.set("v.Isotherbankoptiongiven", true);
				} else if (OPP.Client_Has_Accs_Prdcts_Relationship_Bank__c == "No") {
					component.set("v.optionGivenforotherbank", "N");
					component.set("v.showOtherBankmessage", "No");
					component.set("v.Isotherbankoptiongiven", false);
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}
		});
		$A.enqueueAction(action);
	},
	updateOppr: function (component, event, helper) {
		var action = component.get("c.updateOpp");
		var cmplxapp = component.get("v.Isapplcomplex");
		var pasportexpiry;
		if (component.find("pasportexpiry") == undefined) {
			pasportexpiry = null;
		} else {
			pasportexpiry = component.find("pasportexpiry").get("v.value");
		}
		action.setParams({
			recId: component.get("v.recordId"),
			spmregion: component.find("spmregion").get("v.value"),
			pasportexpiry: pasportexpiry,
			appSource: component.find("Applicationsource").get("v.value"),
			platform: component.find("platform").get("v.value"),
			productwrapper: component.find("productwrapper").get("v.value"),
			housePortfolio: component.find("housePortfolio").get("v.value"),
			inFinAdvisor: component.find("independentfinadvisor").get("v.value"),
			prinumber: component.find("prinumber").get("v.value"),
			cmplxapp: cmplxapp
		});
		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var oppRec = response.getReturnValue();
				component.set("v.selectedWm", oppRec.Linked_Private_Banker_Wealth_Manager__c);
				component.set("v.selectedLf", oppRec.Linked_Financial_Investment_Advisor__c);
				component.set("v.opp", oppRec);
				component.set("v.showSpinner", false);
				//$A.get('e.force:refreshView').fire();
				this.refresh(component);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					type: "success",
					message: "Opportunity record updated Successfully"
				});
				toastEvent.fire();
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	updateOpprstage: function (component, event, helper) {
		var action = component.get("c.updateOppStage");

		action.setParams({
			recId: component.get("v.recordId"),
			IsstageClosed: component.get("v.IsstageClosed"),
			Isotherbankoptiongiven: component.get("v.Isotherbankoptiongiven")
		});
		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
			var stage = component.get("v.IsstageClosed");
			var otherbankaccgievn = component.get("v.Isotherbankoptiongiven");
			if (state === "SUCCESS") {
				var oppRec = response.getReturnValue();
				component.set("v.opp", oppRec);
				component.set("v.showSpinner", false);

				this.refresh(component);

				if (oppRec.StageName == "Closed Lost") {
					var toastEvent = $A.get("e.force:showToast");

					toastEvent.setParams({
						title: "error!",
						type: "error",
						message: "Opportunity Has Been Closed"
					});

					toastEvent.fire();
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	//Function to show spinner when loading
	showSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.removeClass(spinner, "slds-hide");
	},

	//Function to hide spinner after loading
	hideSpinner: function (component) {
		var spinner = component.find("TheSpinner");
		$A.util.addClass(spinner, "slds-hide");
	},
	refresh: function (component, event, helper) {
		var action = component.get("c.dummyRefresh");
		action.setCallback(component, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				$A.get("e.force:refreshView").fire();
			} else {
				//do something
			}
		});
		$A.enqueueAction(action);
	},
	//Added by diksha for  W-007104 11/9/2020

	getAppRec: function (component, event, helper) {
		var action = component.get("c.getAppRec");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appId = response.getReturnValue();
				console.log("AppId: " + JSON.stringify(appId));
				component.set("v.appId", appId.Id);
			} else {
				console.log("Failed with state: " + JSON.stringify(appId));
			}
		});

		$A.enqueueAction(action);
	},
	getAppliactionPrdctRec: function (component, event, helper) {
		var action = component.get("c.getAppPrdctRec");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appPrdct = response.getReturnValue();
				component.set("v.appPrdctId", appPrdct.Id);
				/*
                if(appPrdct.Platform__c == undefined){
                    component.set("v.isPlatform" , false);
                }else{
                    component.set("v.isPlatform" , true);
                    component.set("v.Platform" , appPrdct.Platform__c);
                }*/
				if ((appPrdct.Application_Source__c == undefined || appPrdct.Application_Source__c == "") && component.get("v.isPlatform") == true) {
					component.set("v.appSource", "Platform");
				} else {
					component.set("v.appSource", appPrdct.Application_Source__c);
				}
			} else {
				console.log("Failed with state: " + JSON.stringify(appPrdct));
			}
		});

		$A.enqueueAction(action);
	},
	updateAppRec: function (component, event, helper) {
		var appRecid = component.get("v.appId");
		console.log(appRecid);
		var action = component.get("c.updateAppRec");

		var purposeOfAcc, purposeOfAcctText, accActTracker;

		if (component.find("purposeOfAcc") == undefined) {
			purposeOfAcc = null;
		} else {
			purposeOfAcc = component.find("purposeOfAcc").get("v.value");
		}
		if (component.find("purposeOfAcctText") == undefined) {
			purposeOfAcctText = null;
		} else {
			purposeOfAcctText = component.find("purposeOfAcctText").get("v.value");
		}
		if (component.find("accActTracker") == undefined) {
			accActTracker = null;
		} else {
			accActTracker = component.find("accActTracker").get("v.value");
		}

		action.setParams({
			purposeOfAcc: purposeOfAcc,
			purposeOfAcctText: purposeOfAcctText,
			accActTracker: accActTracker,
			appRecid: appRecid
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var applicationDetails = response.getReturnValue();
			} else if (state === "INCOMPLETE") {
				//cmp.set('v.showSpinner', true);
			} else if (state === "ERROR") {
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	},
	updateAppProductRec: function (component, event, helper) {
		var action = component.get("c.updateAppPrdctRec");
		var managementType;
		var cmplxapp = component.get("v.Isapplcomplex");
		var pasportexpiry;
		var paltform = component.get("v.Platform");
		var productWrapper = component.find("productwrapper").get("v.value");
		var housePortfolio = component.find("housePortfolio").get("v.value");
		// console.log('Prodcut Wrepper -- ' + component.find("productwrapper").get("v.value"));
		/* 
       if(component.find("productwrapper").get("v.value") == undefined){
             productWrapper = null;
        }

        if(component.find("housePortfolio").get("v.value") == undefined){
            housePortfolio = null;
        }*/
		if (component.find("managementTypeId") == undefined) {
			productWrapper = null;
		} else {
			managementType = component.find("managementTypeId").get("v.value");
		}
		if (component.find("pasportexpiry") == undefined) {
			pasportexpiry = null;
		} else {
			pasportexpiry = component.find("pasportexpiry").get("v.value");
		}
		console.log("Prodcut Wrepper -- " + productWrapper);
		if (paltform != "" && productWrapper == null) {
			component.set("v.showSpinner", false);
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Error",
				message: "Product wrapper cannot be empty!!"
			});
			toastEvent.fire();
			return false;
		}
		console.log("House Portofolio --> " + housePortfolio);
		if (productWrapper != null && housePortfolio == null) {
			component.set("v.showSpinner", false);
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Error",
				message: "House portfolio cannot be empty!!"
			});
			toastEvent.fire();
			return false;
		}

		action.setParams({
			oppId: component.get("v.recordId"),
			managmenttype: managementType,
			spmregion: component.find("spmregion").get("v.value"),
			pasportexpiry: pasportexpiry,
			appSource: component.find("Applicationsource").get("v.value"),
			productwrapper: component.find("productwrapper").get("v.value"),
			housePortfolio: component.find("housePortfolio").get("v.value"),
			inFinAdvisor: component.find("independentfinadvisor").get("v.value"),
			prinumber: component.find("prinumber").get("v.value"),
			cmplxapp: cmplxapp
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appProductDetails = response.getReturnValue();
				console.log("appProductDetails@@@@" + JSON.stringify(appProductDetails));
				component.set("v.showSpinner", false);
				//$A.get('e.force:refreshView').fire();
				this.refresh(component);
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Success!",
					type: "success",
					message: "Opportunity record updated Successfully"
				});
				toastEvent.fire();
			} else if (state === "INCOMPLETE") {
				//cmp.set('v.showSpinner', true);
			} else if (state === "ERROR") {
				component.set("v.showSpinner", false);
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.log("Error message: " + errors[0].message);
					}
				} else {
					console.log("Unknown error");
				}
			}
		});
		$A.enqueueAction(action);
	}
});