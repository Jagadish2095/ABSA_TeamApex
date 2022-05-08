({
	doInit: function (component, event, helper) {
		// to get loged User Id
		var userId = $A.get("$SObjectType.CurrentUser.Id");
		component.set("v.currentUserId", userId);
	},

	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if (eventParams.changeType === "LOADED") {
			// Set the current User site code field value in currentUserSiteCode attribute

			if (component.get("v.userRecord.SiteCode__c")) {
				component.set("v.currentUserSiteCode", component.get("v.userRecord.SiteCode__c"));
			}

			// Set the sObjectRecord CIF field value in currentRecordCIF attribute
			// If it is Lead details page then it will set CIF field value from Lead Object
			// If it is Person Account details page then it will set CIF field value from Person Account Object

			if (component.get("v.sObjectRecord.CIF__c")) {
				component.set("v.currentRecordCIF", component.get("v.sObjectRecord.CIF__c"));
			}

			// Check validations to call getCustomerHold helper method to get active Imposed Customer Holds

			if (component.get("v.sObjectRecord.CIF__c") && component.get("v.userRecord.SiteCode__c")) {
				helper.getCustomerHold(component, event, helper);
			}
		} else if (eventParams.changeType === "CHANGED") {
			// record is changed
		} else if (eventParams.changeType === "REMOVED") {
			// record is deleted
		} else if (eventParams.changeType === "ERROR") {
			// there’s an error while loading, saving, or deleting the record
		}
	}
});