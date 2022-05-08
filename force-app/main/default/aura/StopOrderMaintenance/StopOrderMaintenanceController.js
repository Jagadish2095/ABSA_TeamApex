({
	doInit: function (component, event, helper) {
		helper.getLoggedInUserDetails(component, event, helper);
	},

	handleSelect: function (component, event, helper) {
		var menuLabel = event.detail.menuItem.get("v.label");
		var instrNo = event.detail.menuItem.get("v.value");
		switch (menuLabel) {
			case "Edit":
				helper.handleClickUpdate(component, helper, event, menuLabel, instrNo);
				break;
			case "Delete":
				helper.handleClickRemove(component, helper, event, instrNo);
				break;
		}
	},

	handleClickAdd: function (component, event, helper) {
		var clickedBtn = event.getSource().getLocalId();

		component.set("v.typeOfAction", "insert");

		var instrNo = event.getSource().get("v.value");

		component.set("v.instrNo", instrNo);
		component.set("v.isEditBeneficiaryOpen", true);

		component.set("v.beneficiaryName", "");
		component.set("v.bankName", "");
		component.set("v.targetAccount", "");
		component.set("v.sourceRef", "");
		component.set("v.targetRef", "");
		component.set("v.frequency", "");
		component.set("v.amount", "");
		component.set("v.payDate", "");
		component.set("v.payEndDate", "");
		//Set Bank Name and Branch
		component.set("v.selectedBankId", null);
		component.set("v.selectedBranchCodeId", null);
		component.set("v.selectedBranchCodeName", null);
	},

	/**
	 *  DO NOT REMOVE - WILL BE USED WHEN DOCFUSION IS READY *****
	 *
	handleEmailStopOrderHistory : function(component, event, helper) {

		var mappedJason = component.get('v.mapValues');

		if( JSON.stringify(mappedJason) == "{}" ){

			var toast = helper.getToast("Warning", "There are no Stop Orders to send to the client", "warning");

			toast.fire();

		}else{
			component.set("v.isEmailStopOrderHistoryOpen", true);
		}

	},
	**/

	closeEditBeneficiary: function (component, event, helper) {
		component.set("v.isEditBeneficiaryOpen", false);
	},

	closeRemoveBeneficiary: function (component, event, helper) {
		component.set("v.isRemoveBeneficiaryOpen", false);
	},

	closeEmailStopOrderHistory: function (component, event, helper) {
		component.set("v.isEmailStopOrderHistoryOpen", false);
	},

	onTargetAccTypeChange: function (component, event, helper) {
		component.set("v.selectedTargetAccType", component.find("iselectAccType").get("v.value"));
	},

	onFreqChange: function (component, event, helper) {
		component.set("v.frequency", component.find("iFreq").get("v.value"));
	},

	onPayDayChange: function (component, event, helper) {
		component.set("v.payDay", component.find("iPayDay").get("v.value"));
	},

	actionRemoveBeneficiary: function (component, event, helper) {
		var accountId = component.get("v.recordId");
		var instrNo = component.get("v.instrNo");
		var loggedInUser = component.get("v.userRecord");

		var actionRemoveBeneficiary = component.get("c.removeBeneficiary");

		actionRemoveBeneficiary.setParams({
			accId: accountId,
			instrNo: instrNo,
			userRecord: loggedInUser
		});

		// Add callback behavior for when response is received
		actionRemoveBeneficiary.setCallback(this, function (response) {
			var state = response.getState();
			var message = "";

			if (component.isValid() && state === "SUCCESS") {
				var reponseRemoveBeneficiary = response.getReturnValue();

				var toast = helper.getToast("Success", reponseRemoveBeneficiary, "Success");

				toast.fire();

				component.set("v.isRemoveBeneficiaryOpen", false);

				//Enqueue doInit again
				var a = component.get("c.doInit");
				$A.enqueueAction(a);
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					for (var i = 0; i < errors.length; i++) {
						for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
						}
						if (errors[i].fieldErrors) {
							for (var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for (var j = 0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
								}
							}
						}
						if (errors[i].message) {
							message += (message.length > 0 ? "\n" : "") + errors[i].message;
						}
					}
				} else {
					message += (message.length > 0 ? "\n" : "") + "Unknown error";
				}

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			} else {
				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(actionRemoveBeneficiary);
	},

	/**
	 *  DO NOT REMOVE - WILL BE USED WHEN DOCFUSION IS READY ******
	 *
	actionEmailStopOrderHistory: function(component, event, helper) {

		var caseId = component.get('v.caseId');
		var email = component.get('v.clientEmail');
		var stopOrderHistoryMap = component.get('v.mapValues');

		var actionEmail = component.get("c.sendStopOrderHistory");

		actionEmail.setParams({
			"jsonStr" : JSON.stringify(stopOrderHistoryMap),
			"emailAddress" : email,
			"caseRecordId" : caseId
		});

		// Add callback behavior for when response is received
		actionEmail.setCallback(this, function(response) {

			var state = response.getState();
			var message = '';

			if (component.isValid() && state === "SUCCESS") {

				var reponseEmail = response.getReturnValue();

				var toast = helper.getToast("Success", reponseEmail, "Success");

				toast.fire();

				component.set("v.isEmailStopOrderHistoryOpen", false);


			}else if(state === "ERROR"){
				var message = '';
				var errors = response.getError();
				if (errors) {
					for(var i=0; i < errors.length; i++) {
						for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
							message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
						}
						if(errors[i].fieldErrors) {
							for(var fieldError in errors[i].fieldErrors) {
								var thisFieldError = errors[i].fieldErrors[fieldError];
								for(var j=0; j < thisFieldError.length; j++) {
									message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
								}
							}
						}
						if(errors[i].message) {
							message += (message.length > 0 ? '\n' : '') + errors[i].message;
						}
					}
				}else{
					message += (message.length > 0 ? '\n' : '') + 'Unknown error';
				}

				var toast = helper.getToast("Error", message, "error");

				toast.fire();


			} else {

				var errors = response.getError();

				var toast = helper.getToast("Error", message, "error");

				toast.fire();

			}
		});

		// Send action off to be executed
		if( component.get('v.clientEmail') ){

			$A.enqueueAction(actionEmail);

		}else{

			var toast = helper.getToast("Warning", "Please provide a valid email address", "warning");

			toast.fire();
		}

	},
	**/

	closeCase: function (component, event, helper) {
		component.set("v.isModalShow", true);
	},

	executeJob: function (component, event, helper) {
		component.set("v.isModalShow", false);
		component.set("v.executeAnotherJob", true);
		component.set("v.executeJobs", false);
		//component.set("v.showButton" , false);
		component.set("v.message", "Click next to select another job");
	},

	closeModal: function (component, event, helper) {
		var caseId = component.get("v.caseId");

		var action = component.get("c.closeCaseAction");

		action.setParams({
			caseRecordId: caseId
		});

		action.setCallback(
			this,
			$A.getCallback(function (response) {
				var state = response.getState();

				if (state === "SUCCESS") {
					var toast = helper.getToast("Success", "Case Closed", "success");

					toast.fire();

					$A.get("e.force:refreshView").fire();
				} else if (state === "ERROR") {
					var toast = helper.getToast("Error", "There was an error closing the case", "error");

					toast.fire();
				}
			})
		);

		$A.enqueueAction(action);
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function called when clientIDnVObjectParent attribute value changes
	//closes case
	handleObjectChange: function (component, event, helper) {
		var cacheObject = component.get("v.clientIDnVObjectParent");
		if (!cacheObject) {
			component.set("v.isSpinner", true);
			//Close case
			component.find("statusFieldIDnV").set("v.value", "Closed");
			component.find("caseEditFormIDnV").submit();
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to set attributes once the caseEditFormIDnV has loaded
	handleCaseLoadIDnV: function (component, event, helper) {
		var serviceGroupsPollingAllowed = $A.get("$Label.c.Client_IDnV_Polling_Service_Groups");
		var currentServiceGroup = component.find("serviceGroupFieldIDnV").get("v.value");
		if (serviceGroupsPollingAllowed.includes(currentServiceGroup)) {
			component.set("v.clientCifCodeParent", component.find("clientCIFFieldIDnV").get("v.value"));
			component.set("v.allowClientIDnVPolling", true);
		}
	},

	//DBOOYSEN. W-008831. 2021/03/05
	//function to execute when the caseEditFormIDnV save is successful
	handleCaseSuccessIDnV: function (component, event, helper) {
		var caseNumber = component.find("caseNumberFieldIDnV").get("v.value");
		var cifNumber = component.find("clientCIFFieldIDnV").get("v.value");
		helper.fireStickyToast("Error!", "Call dropped. Case number: " + caseNumber + " was auto closed for the client with CIF: " + cifNumber, "error");
		component.set("v.isSpinner", false);

		//Close the case subTab to go to the previous consultants' view
		var workspaceAPI = component.find("workspace");
		workspaceAPI
			.getFocusedTabInfo()
			.then(function (response) {
				var focusedTabId = response.tabId;
				workspaceAPI.closeTab({ tabId: focusedTabId });
			})
			.catch(function (error) {
				console.log("StopOrderMaintenanceController.handleCaseSuccessIDnV workspaceAPI error: " + error);
			});
	},

	validateRequiredFields: function (component, event, helper) {
		if (helper.allFieldsValid(component, event, helper)) {
			helper.actionEditBeneficiary(component, event, helper);
		} else {
			var toast = helper.getToast("Error", "Please ensure all required fields are populated", "error");
			toast.fire();
		}
	}
});