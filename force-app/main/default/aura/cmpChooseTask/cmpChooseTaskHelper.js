/****************@ Author: Chandra********************************
 ****************@ Date: 03/09/2019*******************************
 ****************@ Work Id: W-002766******************************
 ****************@ Description: Method to get Record Type**/
({
	getRecordTypeId: function (component, event, helper) {
		var action = component.get("c.getRecordTypeId");
		var selectedJob = event.getParam("selectedJob");

		action.setParams({
			developerName: component.get("v.developerName"),
			sobjectName: component.get("v.sObjectName")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var caseRecordTypeId = response.getReturnValue();
				component.set("v.caseRecordTypeId", caseRecordTypeId);
				helper.getUCID(component, event, helper, selectedJob);
				helper.createNewCaseRecord(component, event, helper, selectedJob);
			}
		});
		$A.enqueueAction(action);
	},

	getRecordTypeIdByServiceType: function (component, event, helper) {
		var action = component.get("c.getRecordTypeIdFromServiceType");
		var selectedJob = event.getParam("selectedJob");

		action.setParams({
			recordTypeName: selectedJob.Service_Type__r.Case_Record_Type__c,
			sobjectName: component.get("v.sObjectName")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var caseRecordTypeId = response.getReturnValue();
				component.set("v.caseRecordTypeId", caseRecordTypeId);
				helper.getUCID(component, event, helper, selectedJob);
				helper.createNewCaseRecord(component, event, helper, selectedJob);
			}
		});
		$A.enqueueAction(action);
	},

	// W-019387 Hloni Matsoso 14/03/2022
	// Foe Voice (CC, CQ & SV), create opportunity & run configured flow
	createVoiceOpportunity: function(component, serviceJobName){
		var action = component.get("c.createVoiceProductOnboardingOpportunity");

		action.setParams({
			accRecordId: component.get("v.recordId"),
			recordTypeDevName: "Product_Onboarding",
			processType: serviceJobName,
			salesProcessType: "Voice Sales Product Onboarding"
		});

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var message;

			var state = response.getState();

			if (component.isValid() && state === "SUCCESS") {
				var oppId = response.getReturnValue();

				//Navigate to Opportunity
				if (oppId != null) {
					console.log("opportunityRecordId : " + oppId);

					var navEvt = $A.get("e.force:navigateToSObject");
					navEvt.setParams({
						recordId: oppId
					});
					navEvt.fire();
				}
				//Error when inserting Opportunity
				else {
					var toast = this.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

					toast.fire();
				}
			} else if (state === "ERROR") {
				var toast = this.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

				toast.fire();
			}
		});

		// Send action off to be executed
		$A.enqueueAction(action);
	},

	createNewCaseRecord: function (component, event, helper, selectedJob) {
		if (component.get("v.recordId") != undefined) {
			component.set("v.newCaseField.AccountId", component.get("v.recordId"));
		}
		console.log("Case Record Id -----> " + component.get("v.currentCaseId"));

		if (component.get("v.currentCaseId") != undefined) {
			component.set("v.newCaseField.ParentId", component.get("v.currentCaseId"));
		}

		if (selectedJob.Service_Type__r.Name != undefined) {
			component.set("v.newCaseField.Subject", selectedJob.Service_Type__r.Name);
		}

		if (selectedJob.Service_Type__r.Case_Record_Type__c === "Deceased Estate") {
			component.set("v.newCaseField.Status", $A.get("$Label.c.Prepare_Estate"));
		} else {
			component.set("v.newCaseField.Status", $A.get("$Label.c.In_Progress"));
		}
		component.set("v.newCaseField.Case_Ownership__c", $A.get("$Label.c.I_will_Resolve"));
		component.set("v.newCaseField.Origin", $A.get("$Label.c.What_do_you_want_to_do_today"));

		if (component.get("v.caseRecordTypeId") != undefined) {
			component.set("v.newCaseField.RecordTypeId", component.get("v.caseRecordTypeId"));
		}
		if (selectedJob.Service_Type__r.Type__c != undefined) {
			component.set("v.newCaseField.Type", selectedJob.Service_Type__r.Type__c);
		}
		if (selectedJob.Service_Type__r.Name != undefined) {
			component.set("v.newCaseField.Type__c", selectedJob.Service_Type__r.Name);
		}
		if (selectedJob.Service_Type__r.Subtype__c != undefined) {
			component.set("v.newCaseField.Subtype__c", selectedJob.Service_Type__r.Subtype__c);
		}
		if (selectedJob.Service_Type__r.Product__c != undefined) {
			component.set("v.newCaseField.Product__c", selectedJob.Service_Type__r.Product__c);
		}

		if (selectedJob.Service_Group__r.Name != undefined) {
			component.set("v.newCaseField.sd_Service_Group__c", selectedJob.Service_Group__r.Name);
			component.set("v.newCaseField.sd_Original_Service_Group__c", selectedJob.Service_Group__r.Name);
		}

		if (selectedJob.Id != undefined) {
			component.set("v.newCaseField.sd_Service_Group_Type_Id__c", selectedJob.Id);
		}

		if (selectedJob.Service_Group__r.Queue__c != undefined) {
			component.set("v.newCaseField.sd_Original_Service_Queue__c", selectedJob.Service_Group__r.Queue__c);
		}

		if (selectedJob.Service_Level__c != undefined) {
			component.set("v.newCaseField.sd_Service_Level_Id__c", selectedJob.Service_Level__c);
		}

		if (selectedJob.Service_Group__c != undefined) {
			component.set("v.newCaseField.sd_Service_Group_Id__c", selectedJob.Service_Group__c);
		}

		if (selectedJob.sd_Communication_Plan_Id__c != undefined) {
			component.set("v.newCaseField.sd_Communication_Plan_Id__c", selectedJob.sd_Communication_Plan_Id__c);
		}

		if (selectedJob.Service_Group__r.Business_Hours__c != undefined) {
			component.set("v.newCaseField.BusinessHoursId", selectedJob.Service_Group__r.Business_Hours__c);
		}

		if (selectedJob.Service_Group__r.Response_Email_Address__c != undefined) {
			component.set("v.newCaseField.sd_Response_Email_Address__c", selectedJob.Service_Group__r.Response_Email_Address__c);
		}

		if (component.get("v.accountRecord.Phone") != undefined) {
			component.set("v.newCaseField.Phone__c", component.get("v.accountRecord.Phone"));
		}
		if (component.get("v.accountRecord.PersonEmail") != undefined) {
			component.set("v.newCaseField.Email__c", component.get("v.accountRecord.PersonEmail"));
		}
		if (component.get("v.accountRecord.Communication_Method__c") != undefined) {
			component.set("v.newCaseField.Communication_Method__c", component.get("v.accountRecord.Communication_Method__c"));
		}
		//Added by chandra dated 04/05/21 against W-011933
		if (component.get("v.ucid") != undefined) {
			component.set("v.newCaseField.UCID__c", component.get("v.ucid"));
		}

		component.find("caseRecordCreator").saveRecord(function (saveResult) {
			if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
				// record is saved successfully

				var childComponent = component.find("siteLookupChild");
				childComponent.clearMethod();

				//changes to naviagate to sobject
				var navEvt = $A.get("e.force:navigateToSObject");
				navEvt.setParams({
					recordId: component.get("v.newCaseField.Id"),
					slideDevName: "detail"
				});
				navEvt.fire();

				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					title: "Saved",
					type: "success",
					message: "New case created."
				});
				resultsToast.fire();
			} else if (saveResult.state === "INCOMPLETE") {
			} else if (saveResult.state === "ERROR") {
				// handle the error state
				console.log("Problem saving case, error: " + JSON.stringify(saveResult.error));
			} else {
				console.log("Unknown problem, state: " + saveResult.state + ", error: " + JSON.stringify(saveResult.error));
			}
		});
	},
	//Function to show toast for Errors/Warning/Success
	getToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");

		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});

		return toastEvent;
	},

	/****************@ Author: Chandra*******************************
	 ****************@ Date: 04/05/2021*******************************
	 ****************@ Work Id: W-011933******************************
	 ****************@ Description: Method to get UCID***************/
	getUCID: function (component, event, helper, selectedJob) {
		var action = component.get("c.getUCIDValueFromSessionCache");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var response = response.getReturnValue();
				component.set("v.ucid", response);
				helper.createNewCaseRecord(component, event, helper, selectedJob);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", "Error received in getUCID method. Error: " + JSON.stringify(errors));
			} else {
				component.set("v.errorMessage", "Unknown error in getUCID method. State: " + state);
			}
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
	}
	
});