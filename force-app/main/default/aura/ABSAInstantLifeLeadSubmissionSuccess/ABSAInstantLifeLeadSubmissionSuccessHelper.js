({
		fetchAccountRecord: function (component, event, helper) {
		var action = component.get("c.getAccount");
		action.setParams({
			recordId: component.get('v.accountRecordId')
		});

		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var accRec = JSON.stringify(response.getReturnValue());
				console.log("accRec@@" + accRec);
                var accRec1 = response.getReturnValue();
                component.set("v.emailAddress", accRec1.PersonEmail);
               
			} else {
				console.log("Failed with staterec: " + JSON.stringify(response.getReturnValue()));
			}
		});

		$A.enqueueAction(action);
	},
})