({
	getGroupsHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var groupList = [];
		var tableActions = [
			{
				label: "Edit",
				name: "editChallenge",
				title: "Click to View and Edit Challenge"
			},
			{
				label: "Delete",
				name: "deleteChallenge",
				title: "Click to Delete Challenge"
			},
			{
				label: "Assign",
				name: "assignWinner",
				title: "Click to assign winner for Challenge"
			}
		];

		var action = component.get("c.getGroupMemberInformation");
		action.setParam("groupId", component.get("v.recordId"));
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var returnValues = response.getReturnValue();
				if (returnValues.length > 0) {
					for (var i = 0; i < returnValues.length; i++) {
						groupList.push(returnValues[i]);
						if (returnValues[i].CollaborationRole == "Admin") {
							component.set("v.isGroupMemberAdmin", true);

							component.set("v.columns", [
								{
									label: "Select challenge",
									fieldName: "Select_Challenge__c",
									type: "text"
								},
								{
									label: "What are you looking for in a winner",
									fieldName: "Winner_Criteria__c",
									type: "text"
								},
								{
									label: "When will the challenge end",
									fieldName: "End_Date__c",
									type: "date"
								},
								{
									label: "Action",
									type: "action",
									typeAttributes: { rowActions: tableActions }
								}
							]);
						} else {
							component.set("v.isGroupMemberAdmin", false);
							component.set("v.columns", [
								{
									label: "Select challenge",
									fieldName: "Select_Challenge__c",
									type: "text"
								},
								{
									label: "What are you looking for in a winner",
									fieldName: "Winner_Criteria__c",
									type: "text"
								},
								{
									label: "When will the challenge end",
									fieldName: "End_Date__c",
									type: "date"
								}
							]);
						}
					}
				}
				helper.getWeeklyChallengeHelper(component, event, helper);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
				helper.hideSpinner(component);
			}
			component.set("v.groupMemberInfoList", groupList);
		});
		$A.enqueueAction(action);
	},

	getWeeklyChallengeHelper: function (component, event, helper) {
		var tempCurrentChallenge = [];
		var tempPreviousChallenge = [];
		var action = component.get("c.getWeeklyChallenge");
		action.setParam("collaborationGroupId", component.get("v.collaborationGroupId"));
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var responseValues = response.getReturnValue();
				for (var i = 0; i < responseValues.length; i++) {
					if (responseValues[i].End_Date__c >= $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")) {
						tempCurrentChallenge.push(responseValues[i]);
					} else if (responseValues[i].End_Date__c < $A.localizationService.formatDate(new Date(), "YYYY-MM-DD")) {
						tempPreviousChallenge.push(responseValues[i]);
					}
				}
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			component.set("v.activeWeeklyChallengeList", tempCurrentChallenge);
			component.set("v.previousWeeklyChallengeList", tempPreviousChallenge);
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	createNewWeeklyChallengeHelper: function (component, event, helper, buttonTitle) {
		var selectChallengeField = component.get("v.selectChallengeField");
		var recordId;
		var selectedChallenge;
		var otherChallenge;
		var msg;
		//To show the toast message depending on the action
		//Assign recordId param based on the action
		if (buttonTitle == "ADD") {
			recordId = "";
			msg = "New Challenge Created Successfully";
		} else if (buttonTitle == "EDIT") {
			recordId = component.get("v.recordId");
			msg = "Challenge Edited Successfully";
		}
		//The picklist condition for the value "Other" and assigning the params
		if (selectChallengeField == "Other") {
			selectedChallenge = "";
			otherChallenge = component.get("v.newChallengeNameField");
		} else {
			selectedChallenge = component.get("v.selectChallengeField");
			otherChallenge = "";
		}
		helper.showSpinner(component);
		var action = component.get("c.createWeeklyChallenge");
		action.setParams({
			selectedChallenge: selectedChallenge,
			otherChallenge: otherChallenge,
			lookWinner: component.get("v.lookingWinnerField"),
			endDate: component.get("v.challengeEndField"),
			buttonAction: buttonTitle,
			recordId: recordId, //challenge record Id for edit
			collaborationGroupId: component.get("v.collaborationGroupId")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				helper.getWeeklyChallengeHelper(component, event, helper);
				component.set("v.selectChallengeField", "");
				component.set("v.lookingWinnerField", "");
				component.set("v.challengeEndField", "");
				component.set("v.newChallengeNameField", "");
				helper.fireToast("success!", msg, "success");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	assignWinnerHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.assignWinner");
		action.setParams({
			recordId: component.get("v.recordId"),
			winner: component.get("v.selectWinnerField"),
			duration: component.get("v.durationField"),
			startDate: component.get("v.durationStartDateField"),
			comment: component.get("v.winnerCommentField")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state == "SUCCESS") {
				helper.fireToast("success!", "Winner assigned to the Challenge Successfully", "success");
				component.set("v.selectWinnerField", "");
				component.set("v.durationField", "");
				component.set("v.durationStartDateField", "");
				component.set("v.winnerCommentField", "");
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	//getting the group members based on the collaboration group id
	getGroupMemberHelper: function (component, event, helper) {
		helper.showSpinner(component);
		var action = component.get("c.getGroupMembers");
		action.setParam("collaborationGroupId", component.get("v.collaborationGroupId"));
		action.setCallback(this, function (response) {
			var state = response.getState();

			if (state == "SUCCESS") {
				var responseValues = response.getReturnValue();
				component.set("v.groupMembersList", responseValues);
			} else if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			helper.hideSpinner(component);
		});

		$A.enqueueAction(action);
	},

	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	},

	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	}
});