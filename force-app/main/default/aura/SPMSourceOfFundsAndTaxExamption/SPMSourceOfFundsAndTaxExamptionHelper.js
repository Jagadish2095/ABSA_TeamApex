({
	//update Account details 2021-04-11
	updatingAppDetails: function (component, event, helper) {
		var action = component.get("c.updateAppDetails");
		var appRecid = component.get("v.appId");
		console.log("App Rec ID is : " + appRecid);
		var isplatform = component.get("v.isPlatform");

		var srcOfFunds, investmentNumbers, investorType, otherInvestmentType, investmentProducts, applicableOption, listAllProducts, exemption;

		if(isplatform){
			if (component.find("SourceofFunds") == undefined) {
			  alert("Please enter source of funds");
			  console.log("Source of Funds : " + srcOfFunds);
			}else{
			  srcOfFunds = component.find("SourceofFunds").get("v.value");
			}
		  }else{
			srcOfFunds = null;
		  }
		if (component.find("SourceofFunds") == undefined) {
			investmentNumbers = null;
		} else {
			investmentNumbers = component.find("SourceofFunds").get("v.value");
		}
		if(isplatform && investmentNumbers == ''){
			alert("Please enter source of funds");
		}
		if (component.find("investmentNumbers") == undefined) {
			investmentNumbers = null;
		} else {
			investmentNumbers = component.find("investmentNumbers").get("v.value");
		}
		if (component.find("investorType") == undefined) {
			investorType = null;
		} else {
			investorType = component.find("investorType").get("v.value");
		}
		if (component.find("otherInvestmentType") == undefined) {
			otherInvestmentType = null;
		} else {
			otherInvestmentType = component.find("otherInvestmentType").get("v.value");
		}
		if (component.find("investmentProducts") == undefined) {
			investmentProducts = null;
		} else {
			investmentProducts = component.find("investmentProducts").get("v.value");
		}
		//added by Manish for W-010767
		if (component.find("listAllProducts") == undefined) {
			listAllProducts = null;
		} else {
			listAllProducts = component.find("listAllProducts").get("v.value");
		}
		if (component.find("exemption") == undefined) {
			exemption = null;
		} else {
			exemption = component.find("exemption").get("v.value");
		}

		if (component.find("applicableOption") == undefined) {
			applicableOption = null;
		} else {
			applicableOption = component.find("applicableOption").get("v.value");
		}

		action.setParams({
			srcOfFunds: srcOfFunds,
			investmentNumbers: investmentNumbers,
			investorType: investorType,
			otherInvestorType: otherInvestmentType,
			investmentProducts: investmentProducts,
			applicableOption: applicableOption,
			exemption: exemption,
			listAllProducts: listAllProducts,
			appRecid: appRecid
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			console.log("Your state is :" + state);
			if (state === "SUCCESS") {
				var applicationDetails = response.getReturnValue();
				console.log("Application Details Return Value :" + applicationDetails);
				//if (srcOfFunds != undefined) {
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title: "Success!",
						type: "success",
						message: "Record saved Successfully"
					});
					toastEvent.fire();
					this.updatingOppDetails(component, event, helper);
					$A.get("e.force:refreshView").fire();
				//}
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
	getAppDetails: function (component, event, helper) {
		var action = component.get("c.getAppRec");
		console.log("Opp Id " + component.get("v.recordId"));
		action.setParams({
			oppId: component.get("v.recordId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var app = response.getReturnValue();
				console.log("Return Value Is : " + JSON.stringify(app));

				component.set("v.appId", app.Id);
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
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
	},
	/*
	getAppliactionPrdctRec: function (component, event, helper) {
		var action = component.get("c.getAppPrdctRec");
		action.setParams({
			oppId: component.get("v.recordId")
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var appPrdct = response.getReturnValue();
				console.log("appPrdct: " + JSON.stringify(appPrdct));
				console.log("Platform value : " + appPrdct.Platform__c);
				//component.set("v.appPrdctId", appPrdct.Id);
			} else {
				console.log("Failed with state: " + JSON.stringify(appPrdct));
			}
		});

		$A.enqueueAction(action);
	}, */

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
	},
	setInvestorFields: function (component, event, helper) {
		if (component.find("investorType") != undefined) {
			var investorTypeValue = component.find("investorType").get("v.value");

			if (investorTypeValue == "Other") {
				component.set("v.isOtherInvestorType", true);
			} else {
				component.set("v.isOtherInvestorType", false);
			}
		}
	}
});