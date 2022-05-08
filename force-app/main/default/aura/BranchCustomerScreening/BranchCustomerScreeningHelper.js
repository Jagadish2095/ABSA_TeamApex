({
	CallScreening: function (component, helper) {
		return new Promise(function (resolve, reject) {
			let action = component.get("c.callScreening");
			var recordId = component.get("v.recordId");
			action.setParams({
				objId: recordId
			});
			action.setCallback(this, function (response) {
				var state = response.getState();
				if (state == "SUCCESS") {
					component.set("v.screeningResult", response.getReturnValue());
					var screeningResult = JSON.parse(response.getReturnValue());
					if (screeningResult != null && screeningResult.statusCode == 200) {
						if (screeningResult.msg == null) {
							reject("Failed: An error occurred during screening");
						}
						if (screeningResult.msg.toLowerCase().indexOf("succes") < 0) {
							reject("Failed: " + screeningResult.msg);
						}
						if (screeningResult.refNo != null && screeningResult.refNo != "") {
							component.set("v.casaReferenceNumber", screeningResult.refNo);
							resolve(screeningResult.casaStatus);
						} else {
							reject("Failed: No reference number");
						}
					}
				} else if (response.getState() === "ERROR") {
					var errors = response.getError();
					reject(JSON.stringify(errors));
				}
			});
			$A.enqueueAction(action);
		});
	},

	setCasaStatusMessage: function (component, sentence) {
		let status = sentence.toLowerCase().split(" ");
		for (let i = 0; i < status.length; i++) {
			status[i] = status[i][0].toUpperCase() + status[i].slice(1);
		}
		component.set("v.casaStatusMessage", status.join(""));
	}
});