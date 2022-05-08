/**
 * @description       :
 * @author            : Nagpal
 * @group             :
 * @last modified on  : 2021-09-08
 * @last modified by  : humbelani.denge@absa.africa
 * @work Id: W-014033
 **/
({
	/****************@ Author: Nagpal **************************************
	 ****************@ Date: 2021-06-04**************************************
	 ****************@ Work Id: W-011445 *************************************
	 ***@ Description: Method to handle********/

	// get logged  user
	doInit: function (component, event, helper) {
		var action = component.get("c.fetchUser");
		var placeHolder;
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var storeResponse = response.getReturnValue();
				placeHolder = $A.get("$Label.c.How_are_you_feeling_today") + " " + storeResponse.FirstName + "?";
				component.set("v.placeHolder", placeHolder);
				component.set("v.logUserID", storeResponse.Id);
			}
		});
		$A.enqueueAction(action);

		var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		component.set("v.selectedDate", today);
		helper.getGroupsHelper(component, event, helper);
	},

	// Select Mood Method checkbox
	SelectMood: function (component, event) {
		var changeValue = event.getParam("value");
		component.set("v.holdStaticResourcURL", "");
		component.set("v.nameStaticResourc", "");
		if (changeValue == "Lit") {
			component.set("v.GifStoreValue", changeValue);
		} else if (changeValue == "So-So") {
			component.set("v.GifStoreValue", changeValue);
		} else if (changeValue == "Cranky") {
			component.set("v.GifStoreValue", changeValue);
		}
	},

	// method for store value in aura attribute based on the user select mood
	saveSelectedGifAndMood: function (component, event, helper) {
		var input = event.target.id;

		if (input) {
			if (input == "Lit1") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit1") + "/Lit/Lit1.gif");
				component.set("v.nameStaticResourc", "Lit 1");
			} else if (input == "Lit2") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit1") + "/Lit/Lit2.gif");
				component.set("v.nameStaticResourc", "Lit 2");
			} else if (input == "Lit3") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit1") + "/Lit/Lit3.gif");
				component.set("v.nameStaticResourc", "Lit 3");
			} else if (input == "Lit4") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit1") + "/Lit/Lit4.gif");
				component.set("v.nameStaticResourc", "Lit 4");
			} else if (input == "Lit5") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit2") + "/Lit/Lit5.gif");
				component.set("v.nameStaticResourc", "Lit 5");
			} else if (input == "Lit6") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit1") + "/Lit/Lit6.gif");
				component.set("v.nameStaticResourc", "Lit 6");
			} else if (input == "Lit7") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit3") + "/Lit/Lit7.gif");
				component.set("v.nameStaticResourc", "Lit 7");
			} else if (input == "Lit8") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Lit3") + "/Lit/Lit8.gif");
				component.set("v.nameStaticResourc", "Lit 8");
			} else if (input == "Soso1") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso") + "/Soso/Soso1.gif");
				component.set("v.nameStaticResourc", "So-So 1");
			} else if (input == "Soso2") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso") + "/Soso/Soso2.gif");
				component.set("v.nameStaticResourc", "So-So 2");
			} else if (input == "Soso3") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso") + "/Soso/Soso3.gif");
				component.set("v.nameStaticResourc", "So-So 3");
			} else if (input == "Soso4") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso2") + "/Soso/Soso4.gif");
				component.set("v.nameStaticResourc", "So-So 4");
			} else if (input == "Soso5") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso2") + "/Soso/Soso5.gif");
				component.set("v.nameStaticResourc", "So-So 5");
			} else if (input == "Soso6") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso2") + "/Soso/Soso6.gif");
				component.set("v.nameStaticResourc", "So-So 6");
			} else if (input == "Soso7") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso3") + "/Soso/Soso7.gif");
				component.set("v.nameStaticResourc", "So-So 7");
			} else if (input == "Soso8") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Soso3") + "/Soso/Soso8.gif");
				component.set("v.nameStaticResourc", "So-So 8");
			} else if (input == "Cranky1") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky1") + "/Cranky/Cranky1.gif");
				component.set("v.nameStaticResourc", "Cranky 1");
			} else if (input == "Cranky2") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky1") + "/Cranky/Cranky2.gif");
				component.set("v.nameStaticResourc", "Cranky 2");
			} else if (input == "Cranky3") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky1") + "/Cranky/Cranky3.gif");
				component.set("v.nameStaticResourc", "Cranky 3");
			} else if (input == "Cranky4") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky1") + "/Cranky/Cranky4.gif");
				component.set("v.nameStaticResourc", "Cranky 4");
			} else if (input == "Cranky5") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky2") + "/Cranky/Cranky5.gif");
				component.set("v.nameStaticResourc", "Cranky 5");
			} else if (input == "Cranky6") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky2") + "/Cranky/Cranky6.gif");
				component.set("v.nameStaticResourc", "Cranky 6");
			} else if (input == "Cranky7") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky2") + "/Cranky/Cranky7.gif");
				component.set("v.nameStaticResourc", "Cranky 7");
			} else if (input == "Cranky8") {
				component.set("v.holdStaticResourcURL", $A.get("$Resource.Cranky2") + "/Cranky/Cranky8.gif");
				component.set("v.nameStaticResourc", "Cranky 8");
			}
		}
	},

	// Create Collaboration object record method start
	createCollaNewRecord: function (component, event, helper) {
		var gifMood = component.get("v.GifStoreValue");
		var name = component.get("v.nameStaticResourc");
		var action = component.get("c.createCollaboration");
		if (name) {
			action.setParams({
				name: name,
				mood: gifMood,
				gif: component.get("v.holdStaticResourcURL"),
				userId: component.get("v.logUserID"),
				collaborationGroupId: component.get("v.recordId")
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state == "SUCCESS") {
					var result = response.getReturnValue();
					if (result == "Success") {
						component.set("v.errorMessage", "");
						// Fire toast to show record successfully create
						helper.fireToastEvent("Success!", "The Collaboration record successfully Created.", "success");
					} else {
						// Fire toast to show already selected your mood for today.
						helper.fireToastEvent("Error!", result, "error");
					}
					//When the result is success or a user has captured their mood should the Emo Board results be displayed
					if (result != "You are not a member of any team") {
						component.set("v.showEMOBoard", false);
						helper.getCollaborationMoodHelper(component, event, helper);
						component.set("v.showEMODashboard", true);
						component.set("v.showOnThisDate", true);
					}
				} else if (state === "ERROR") {
					var error = response.getError();
					helper.fireToastEvent("Error!", JSON.stringify(error), "error");
				} else {
					component.set("v.errorMessage", "Unexpected error occurred, EMOBoards.getCollaborationMood state returned: " + state);
				}
			});
			$A.enqueueAction(action);
		} else {
			helper.fireToastEvent("Error!", "Please select how are you feeling today and your expression.", "error");
		}
	},

	// On change date geting list of mood and respective users
	handleDateChange: function (component, event, helper) {
		var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
		var selectedDateValue = component.get("v.selectedDate");
		var recordId = component.get("v.recordId");

		if (selectedDateValue > today) {
			// Fire toast to show not allowed to select future date
			helper.fireToastEvent("Error!", "You are not allowed to select future date.", "error");
			component.set("v.showEMODashboard", false);
			component.set("v.CollaborationList", "");
		} else if (recordId == null && recordId == "") {
			component.set("v.showEMODashboard", false);
			component.set("v.CollaborationList", "");
		} else {
			helper.getCollaborationMoodHelper(component, event, helper);
		}
	},

	// Method for hide EMO Board after View team mood button click
	viewTeamMood: function (component, event, helper) {
		component.set("v.showOnThisDate", true);
		component.set("v.showEMOBoard", false);
		helper.getCollaborationMoodHelper(component, event, helper);
	}
});