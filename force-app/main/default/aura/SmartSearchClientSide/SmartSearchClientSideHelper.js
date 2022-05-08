({
	FilterRecords: function (component, event) {
		// Data showing on the table
		var dataVar = component.get("v.dataToDisplay");

		//All data
		var allDataVar = [];
		var allData = component.get("v.UnfilteredData");
		allDataVar = allData;

		//Search keyword
		var searchKey = component.get("v.searchKeyword");

		var filteredData;
		if (dataVar != undefined) {
			if (dataVar.length > 0) {
				filteredData = allDataVar.filter(function (elem) {
					return (
						elem.sourceStatementRef.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
						elem.targetInstCode.toLowerCase().indexOf(searchKey.toLowerCase()) > -1 ||
						elem.ivrNominate.toLowerCase().indexOf(searchKey.toLowerCase()) > -1
					);
				});

				//Sort data
				filteredData.sort((a, b) => (a.sourceStatementRef > b.sourceStatementRef ? 1 : -1));
			}
		}

		component.set("v.dataToDisplay", filteredData);

		// check if searchKey is blank
		if (searchKey == "") {
			// set unfiltered data to data in the table.
			component.set("v.data", component.get("v.UnfilteredData"));
		}
	}
});