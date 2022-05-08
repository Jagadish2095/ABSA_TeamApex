({
	doInit: function (component, event, helper) {
		var displayData = component.get("v.dataToDisplay");

		//component.set("v.UnfilteredData",displayData);

		if (displayData != null || displayData != undefined) {
			displayData.sort((a, b) => (a.instrRefName > b.instrRefName ? 1 : -1));
			component.set("v.UnfilteredData", displayData);
		}
	},

	doFilter: function (component, event, helper) {
		helper.FilterRecords(component, event);
	},

	//This function will handle Clear Search button
	clearSearch: function (component, event, helper) {
		component.set("v.searchKeyword", "");
	},

	/** this function will handle component event */
	handleEvent: function (component, event, helper) {
		//get the record in given event
		var selectedResult = event.getParam("beneficiaryEventRecord");

		//set the selected record
		component.set("v.selectedRecord", selectedResult);
		component.set("v.hideTable", true);
	}
});