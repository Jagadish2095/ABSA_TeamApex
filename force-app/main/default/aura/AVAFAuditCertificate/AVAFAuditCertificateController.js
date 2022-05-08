({
	//executes on component initialization to setup data
	doInit: function (component, event, helper) {
       
		component.set("v.optionsMonth", [
			{ label: "None", value: "None" },
			{ label: "January", value: "01" },
			{ label: "February", value: "02" },
			{ label: "March", value: "03" },
			{ label: "April", value: "04" },
			{ label: "May", value: "05" },
			{ label: "June", value: "06" },
			{ label: "July", value: "07" },
			{ label: "August", value: "08" },
			{ label: "September", value: "09" },
			{ label: "October", value: "10" },
			{ label: "November", value: "11" },
			{ label: "December", value: "12" }
		]);
		var yearLists = [];
		var currentDate = new Date();
		yearLists.push("None");
		//dynamically assigning the list of calendar years each year
		for (var year = 2010; year <= currentDate.getFullYear(); year++) {
			yearLists.push(year);
		}
		component.set("v.optionsYear", yearLists);
	},

	//function launched from the Send Audit Certificate btn to set values and call the helper function to request the AVAF Audit Certificate
	sendAuditCertificate: function (component, event, helper) {
		var dateOutput = component.get("v.selectedYear") + component.get("v.selectedMonth");
		
        //H.Denge future date validation 2021/08/04
		if (component.get("v.selectedYear") != "None" && component.get("v.selectedMonth") != "None") {
            var today = new Date();
            if(component.get("v.selectedYear") == today.getFullYear() && today.getMonth() + 1 < component.get("v.selectedMonth")){
				helper.fireToast('Error', 'Date Cannot Be In The Future', 'Error');
                return;
            }
            
            var clientEmail;
			if (component.get("v.isBusinessAccountFromFlow")) {
				//Business client
				clientEmail = component.find("activeEmailField").get("v.value");
			} else {
				//Individual client
				clientEmail = component.find("personEmailField").get("v.value");
			}
			component.set("v.clientEmail", clientEmail);

			helper.auditCertificateRequestHelper(component, event, helper, dateOutput);
		} else {
			helper.fireToast("Error!", "Select the month and year", "error");
		}
	}
});