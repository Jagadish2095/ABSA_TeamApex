({
	handleRecordUpdated: function (component, event, helper) {
		var eventParams = event.getParams();
		if (eventParams.changeType === "LOADED" && !component.get("v.clientCodeP")) {
			component.set("v.clientCodeP", component.get("v.simpleRecord.CIF__c"));
			helper.getClientData(component, event, helper);
		} else if (eventParams.changeType === "ERROR") {
			component.set("v.errorMessage", "Error retrieving value added services & registered channels!");
		}
	}
});