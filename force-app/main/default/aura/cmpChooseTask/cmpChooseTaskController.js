/****************@ Author: Chandra********************************
 ****************@ Date: 03/09/2019*******************************
 ****************@ Work Id: W-002766******************************
 ****************@ Description: Method to handle component event**/
({
	handleComponentEvent: function (component, event, helper) {
		var selectedJob = event.getParam("selectedJob");
		if (selectedJob.ObjectRef == "Service_Group_Type__c") {
			var voiceSalesProducts = $A.get("$Label.c.Voice_Sales_Products").split(";");
			console.log(`voiceSalesProducts: ${voiceSalesProducts}`);

			if (
				selectedJob.Service_Type__r.Case_Record_Type__c == $A.get("$Label.c.ATM") ||
				selectedJob.Service_Type__r.Case_Record_Type__c == $A.get("$Label.c.Complaint") ||
				selectedJob.Service_Type__r.Case_Record_Type__c == $A.get("$Label.c.Non_Confidential_Fraud")
			) {
				var evt = $A.get("e.force:navigateToComponent");
				evt.setParams({
					componentDef: "c:CaseOverride",
					componentAttributes: {
						accountId: component.get("v.recordId"),
						searchValue: component.get("v.accountRecord.Name"),
						isNotValidSearchValue: false
					}
				});
				evt.fire();

				//TdB - Create Opportunity in Code and Navigate to newly created Opportunity
			} else if (selectedJob.Service_Type__r.Name === $A.get("$Label.c.New_Credit_Product")) {
				var action = component.get("c.createNewOpportunity");

				action.setParams({
					accRecordId: component.get("v.recordId"),
					recordTypeDevName: "Credit_Onboarding"
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
							var toast = helper.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

							toast.fire();
						}
					} else if (state === "ERROR") {
						var toast = helper.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

						toast.fire();
					}
				});

				// Send action off to be executed
				$A.enqueueAction(action);
			} else if (selectedJob.Service_Type__r.Name === $A.get("$Label.c.Credit_Maintenance")) {
				//create covid 19 opportunity

				var action = component.get("c.createNewOpportunity");

				action.setParams({
					accRecordId: component.get("v.recordId"),
					recordTypeDevName: "Credit_Maintenance"
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
							var toast = helper.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

							toast.fire();
						}
					} else if (state === "ERROR") {
						var toast = helper.getToast("Error", "Opportunity could not be created. Please contact your Salesforce Admin", "error");

						toast.fire();
					}
				});

				// Send action off to be executed
				$A.enqueueAction(action);

				// W-019387 Hloni Matsoso 14/03/2022
				// Foe Voice (CC, CQ & SV), create opportunity & run configured flow
				} else if (voiceSalesProducts.includes(selectedJob.Service_Type__r.Name, 0)) {
					helper.createVoiceOpportunity(component, selectedJob.Service_Type__r.Name);
				}else {
				//The case gets created from either one of the helper function called below after setting the caseRecordTypeId
				if (selectedJob.Service_Type__r && selectedJob.Service_Type__r.Case_Record_Type__c) {
					console.log("selectedJob: " + selectedJob.Service_Type__r.Case_Record_Type__c);
					helper.getRecordTypeIdByServiceType(component, event, helper);
				} else {
					helper.getRecordTypeId(component, event, helper);
				}
			}
		} else {
			if (selectedJob.Sales_Process_Type__r.Name == "Voice Sales Product Onboarding") {
				var evt = $A.get("e.force:navigateToComponent");
				evt.setParams({
					componentDef: "c:BranchFlow",
					componentAttributes: {
						flowName: "VoiceCustomerProductOnboarding",
						recordId: component.get("v.recordId")
					}
				});
				evt.fire();
			}
		}
	},

	doInit: function (component, event, helper) {
		// Prepare a new record from template
		component.find("caseRecordCreator").getNewRecord(
			"Case",
			null,
			false,
			$A.getCallback(function () {
				var rec = component.get("v.newCase");
				var error = component.get("v.newCaseError");
				if (error || rec === null) {
					console.log("Error initializing record template: " + error);
				} else {
					console.log("Record template initialized: " + rec.apiName);
				}
			})
		);
	},

	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if (eventParams.changeType === "LOADED") {
			console.log("Record is loaded successfully.");
		} else if (eventParams.changeType === "CHANGED") {
			// record is changed
		} else if (eventParams.changeType === "REMOVED") {
			// record is deleted
		} else if (eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving, or deleting the record
		}
	}
});