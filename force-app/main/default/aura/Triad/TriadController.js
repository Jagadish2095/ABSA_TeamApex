({
	doInit: function (component, event, helper) {
		//get Application related to Opportunity
		//helper.getApplication(component);

		//get monthly data
		helper.getTriadData(component);
	},

	getTriads: function (component, event, helper) {
		helper.getTriadList(component);
	},

	setValues: function (component, event, helper) {
		var changeType = event.getParams().changeType;

		if (changeType === "ERROR") { /* handle error; do this first! */ }
		else if (changeType === "LOADED") {
			//call back method
		}
		else if (changeType === "REMOVED") { /* handle record removal */ }
		else if (changeType === "CHANGED") {

		}
	},
})