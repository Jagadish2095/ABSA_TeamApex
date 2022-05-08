({
	getMonthlyValueData: function (component, event) {

		var action = component.get("c.getMonthlyValues");

		action.setParams({
			"appId": component.get("v.appID")
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {

				var results = response.getReturnValue();

				console.log('results---', results);
				var records = response.getReturnValue();
				records.sort(function (a, b) {
					var dateA = new Date(a.Month__c), dateB = new Date(b.Month__c);

					return dateB - dateA;
				});
				component.set("v.monthlydata", records);
				component.set("v.showSpinner", false);
			} else {
				console.log("Failed with state: " + JSON.stringify(response));
			}

		});

		$A.enqueueAction(action);


	}
})