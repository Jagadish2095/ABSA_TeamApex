({
	doInit: function (component, event, helper) {
		component.set("v.collaborationGroupId", component.get("v.recordId")); // recordid attribute is used for the CRUD operations on challenge record
		//fetching the groups based on the user id
		helper.getGroupsHelper(component, event, helper);
	},

	//this function will be called when an action is selected in datatable
	challengeRowAction: function (component, event, helper) {
		var action = event.getParam("action");
		var challenge = event.getParam("row");
		switch (action.name) {
			case "editChallenge":
				component.set("v.recordId", challenge.Id);
				component.set("v.isShowModal", "true");
				component.set("v.isNewChallengeModal", "true");
				component.set("v.isChallengeModalFooter", "true");
				component.set("v.selectChallengeField", challenge.Select_Challenge__c);
				component.set("v.lookingWinnerField", challenge.Winner_Criteria__c);
				component.set("v.challengeEndField", challenge.End_Date__c);
				component.find("actionButton").set("v.label", "Save");
				component.find("actionButton").set("v.title", "EDIT");
				break;
			case "deleteChallenge":
				component.set("v.recordId", challenge.Id);
				component.set("v.isShowModal", "true");
				component.set("v.isDeleteChallengeModal", "true");
				component.set("v.isChallengeModalFooter", "false");
				break;
			case "assignWinner":
				component.set("v.recordId", challenge.Id);
				component.set("v.isShowModal", "true");
				component.set("v.isChallengeModalFooter", "true");
				component.set("v.isAssignWinnerModal", "true");
				component.find("actionButton").set("v.label", "Assign");
				component.find("actionButton").set("v.title", "ASSIGN");
				helper.getGroupMemberHelper(component, event, helper);
				break;
			default:
				component.set("v.recordId", "");
				break;
		}
	},

	//this function called when the new challenge button is clicked
	handleNewChallenge: function (component, event, helper) {
		component.set("v.isShowModal", "true");
		component.set("v.isNewChallengeModal", "true");
		component.set("v.isChallengeModalFooter", "true");
		component.set("v.selectChallengeField", "");
		component.set("v.lookingWinnerField", "");
		component.set("v.challengeEndField", "");
		component.find("actionButton").set("v.label", "Save");
		component.find("actionButton").set("v.title", "ADD");
	},

	//this function is called for close/cancel actions
	closeModal: function (component) {
		component.set("v.isShowModal", "false");
		component.set("v.isNewChallengeModal", "false");
		component.set("v.isChallengeOtherModal", "false");
		component.set("v.isAssignWinnerModal", "false");
		component.set("v.isChallengeOtherModal", "false");
		component.set("v.isDeleteChallengeModal", "false");
		component.set("v.isChallengeModalFooter", "false");

		component.set("v.selectWinnerField", "");
		component.set("v.durationField", "");
		component.set("v.durationStartDateField", "");
		component.set("v.winnerCommentField", "");
		component.set("v.selectChallengeField", "");
		component.set("v.lookingWinnerField", "");
		component.set("v.challengeEndField", "");
		component.set("v.newChallengeNameField", "");
	},

	//function invoked when Modal Button actions are called
	weeklyChallenge: function (component, event, helper) {
		var buttonTitle = event.getSource().get("v.title");
		//getting the list of group member
		//formatted date to validate on date fields....
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth() + 1; //January is 0!
		var yyyy = today.getFullYear();
		// if date is less then 10, then append 0 before date
		if (dd < 10) {
			dd = "0" + dd;
		}
		// if month is less then 10, then append 0 before date
		if (mm < 10) {
			mm = "0" + mm;
		}
		var todayFormattedDateTT = yyyy + "-" + mm + "-" + dd;

		//validations for the fields...
		var selectedChallenge = component.get("v.selectChallengeField");
		var otherChallenge = component.get("v.newChallengeNameField");
		var lookWinner = component.get("v.lookingWinnerField");
		var endDate = component.get("v.challengeEndField");
		var winner = component.get("v.selectWinnerField");
		var duration = component.get("v.durationField");
		var startDate = component.get("v.durationStartDateField");
		var comment = component.get("v.winnerCommentField");
		var isOtherChallengeEmpty;

		if (buttonTitle == "ADD" || buttonTitle == "EDIT") {
			if (selectedChallenge == "Other") {
				if ($A.util.isEmpty(otherChallenge)) {
					isOtherChallengeEmpty = true;
				}
			}

			if ($A.util.isEmpty(selectedChallenge) || selectedChallenge == "None") {
				helper.fireToast("Error!", "Challenge cannot be empty", "error");
			} else if ($A.util.isEmpty(lookWinner)) {
				helper.fireToast("Error!", "What are you looking for in a winner cannot be empty", "error");
			} else if ($A.util.isEmpty(endDate)) {
				helper.fireToast("Error!", "Challenge end date cannot be empty", "error");
			} else if (endDate < todayFormattedDateTT) {
				helper.fireToast("Error!", "Challenge end date must be in future", "error");
			} else if (isOtherChallengeEmpty) {
				helper.fireToast("Error!", "New Challenge cannot be empty", "error");
			} else {
				helper.createNewWeeklyChallengeHelper(component, event, helper, buttonTitle);
				component.set("v.isShowModal", "false");
				component.set("v.isNewChallengeModal", "false");
				component.set("v.isChallengeOtherModal", "false");
				component.set("v.isChallengeModalFooter", "false");
			}
		} else if (buttonTitle == "ASSIGN") {
			//checking the assign winner Id with the group member Id to filter the Id belongs to that group
			if ($A.util.isEmpty(winner)) {
				helper.fireToast("Error!", "Winner field cannot be empty", "error");
			} else if ($A.util.isEmpty(duration) || duration == "None") {
				helper.fireToast("Error!", "Duration cannot be empty", "error");
			} else if ($A.util.isEmpty(startDate)) {
				helper.fireToast("Error!", "Start date cannot be empty", "error");
			} else if (startDate < todayFormattedDateTT || startDate < endDate) {
				helper.fireToast("Error!", "Start date must be in future(Challenge end date)", "error");
			} else if ($A.util.isEmpty(comment)) {
				helper.fireToast("Error!", "Comment field cannot be empty", "error");
			} else {
				helper.assignWinnerHelper(component, event, helper);
				component.set("v.isShowModal", "false");
				component.set("v.isAssignWinnerModal", "false");
			}
		}
	},

	//when the selected challenge picklist value is "other" to display the new challenge input field.
	onchangeSelectChallenge: function (component, event, helper) {
		if (event.getParam("value") == "Other") {
			component.set("v.isChallengeOtherModal", true);
		} else {
			component.set("v.isChallengeOtherModal", false);
		}
	},

	//function for the delete LDS, to delete the weekly challenge record...
	handleDeleteChallenge: function (component, event, helper) {
		component.find("recordHandler").deleteRecord(
			$A.getCallback(function (deleteResult) {
				if (deleteResult.state === "SUCCESS") {
					component.set("v.isShowModal", "false");
					component.set("v.isDeleteChallengeModal", "false");
					helper.getWeeklyChallengeHelper(component, event, helper);
				} else if (deleteResult.state === "ERROR") {
					var message = "Problem deleting record, error: " + JSON.stringify(deleteResult.error);
					component.set("v.errorMessageModal", message);
				}
			})
		);
	},

	/**
	 * Control the component behavior here when record is changed (via any component)
	 */
	handleRecordResponse: function (component, event, helper) {
		var eventParams = event.getParams();
		if (eventParams.changeType === "REMOVED") {
			// record is deleted, show a toast UI message
			helper.fireToast("success!", "Challenge deleted Successfully", "success");
		} else if (eventParams.changeType === "ERROR") {
			component.set("v.errorMessage", JSON.stringify(eventParams));
		}
	}
});