/**
 * @description       :
 * @author            : Nagpal
 * @group             :
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @Work Id: W-014033
 **/
({
	/****************@ Author: Nagpal **************************************
	 ****************@ Date: 2021-06-04**************************************
	 ****************@ Work Id: W-011445 *************************************
	 ***@ Description: Method Added by Nagpal ********/

	// returning the list of records from collaboration based on selected date.
	getCollaborationMoodHelper: function (component, event, helper) {
		var selectedDate = component.get("v.selectedDate");
		var recordId = component.get("v.recordId");
		if (recordId != null && recordId != "") {
			var action = component.get("c.getCollaborationMood");
			action.setParams({
				selectedMoodDate: selectedDate,
				groupMemberId: recordId
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state == "SUCCESS") {
					var result = response.getReturnValue();
					if (result.length > 0) {
						component.set("v.showEMODashboard", true);
						component.set("v.CollaborationList", result);
						let listLength = result.length;
						let cranckyRecordsize = 0;
						let sosoRecordSize = 0;
						let litRecordSize = 0;
						result.forEach(function (item) {
							if (item.Capture_Mood__c == "Cranky") {
								cranckyRecordsize += 1;
							} else if (item.Capture_Mood__c == "Lit") {
								litRecordSize += 1;
							} else {
								//Mood = So-So
								sosoRecordSize += 1;
							}
						});
						// Calculating the percentage of mood
						let cranckyPercentage = Math.round((cranckyRecordsize / listLength) * 100);
						let sosoPercentage = Math.round((sosoRecordSize / listLength) * 100);
						let litPercentage = Math.round((litRecordSize / listLength) * 100);
						component.set("v.crankyPercentage", cranckyPercentage);
						component.set("v.soSoPercentage", sosoPercentage);
						component.set("v.litPercentage", litPercentage);

						var getMaxPercentage = Math.max(cranckyPercentage, sosoPercentage, litPercentage);

						// conditions for showing average team mood
						if (cranckyPercentage == getMaxPercentage) {
							component.set("v.moodStoreName", "Cranky");
							component.set("v.storeAvrageImg", $A.get("$Resource.Average_Cranky"));
						} else if (sosoPercentage == getMaxPercentage) {
							component.set("v.moodStoreName", "So-So");
							component.set("v.storeAvrageImg", $A.get("$Resource.Average_Soso"));
						} else if (litPercentage == getMaxPercentage) {
							component.set("v.moodStoreName", "Lit");
							component.set("v.storeAvrageImg", $A.get("$Resource.Average_Lit"));
						} else {
							component.set("v.moodStoreName", "Equal");
						}
					} else {
						component.set("v.showOnThisDate", true);
						component.set("v.showEMODashboard", false);
						component.set("v.CollaborationList", "");
						this.fireToastEvent("Alert!", "There is no record found on selected date", "Alert");
					}
				} else if (state === "ERROR") {
					var errors = response.getError();
					component.set("v.errorMessage", "Apex error EMOBoards.getCollaborationMood: " + JSON.stringify(errors));
				} else {
					component.set("v.errorMessage", "Unexpected error occurred, EMOBoards.getCollaborationMood state returned: " + state);
				}
			});
			$A.enqueueAction(action);
		} else {
			component.set("v.showEMODashboard", false);
			component.set("v.CollaborationList", "");
			//this.fireToastEvent("Error!", "You are not memeber of any team", "error");
		}
	},

	// Massage after save record
	fireToastEvent: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	getGroupsHelper: function (component, event, helper) {
		var action = component.get("c.getGroupMemberInfo");
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				if (returnValues != null && returnValues.length > 0) {
					component.set("v.groupMemberInfoList", returnValues);
					component.set("v.selectedGroup", returnValues[0].CollaborationGroupId);
					if (returnValues.length == 1) {
						component.set("v.selectTeamReadOnly", true);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
		});
		$A.enqueueAction(action);
	}
});