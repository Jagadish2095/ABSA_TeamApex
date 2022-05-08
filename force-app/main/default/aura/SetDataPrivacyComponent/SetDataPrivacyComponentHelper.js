({
	// getting value of data privacy flag field
	doInit_Helper: function (component, event) {
		var getBatchsAction = component.get("c.getPiklistValues");
		getBatchsAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var list = [];
				for (var i = 0; i < result.length; i++) {
					var obj = {};
					obj.label = result[i];
					obj.value = result[i];
					list.push(obj);
				}
				component.set("v.PicklistOptions", list);
			}
		});
		$A.enqueueAction(getBatchsAction);
	},

	// Submiiting data flag to C1V
	// Updating account flag with the selected value
	doSubmitData: function (component, event) {
		this.showSpinner(component);
		var updateData = component.get("v.selectedValue");
		var privacyDatStr = "";
		for (var i = 0; i < updateData.length; i++) {
			privacyDatStr = updateData[i] + "," + privacyDatStr;
		}

		var setC1VDataAction = component.get("c.callC1VCreateAPI");
		setC1VDataAction.setParams({
			caseId: component.get("v.recordId"),
			privacyData: privacyDatStr
		});
		// sending data to C1V
		setC1VDataAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				if (response.getReturnValue() == "Success") {
					var setPrivacyDataAction = component.get("c.updateDataPrivacyFlag");
					setPrivacyDataAction.setParams({
						caseId: component.get("v.recordId"),
						privacyData: privacyDatStr
					});

					// update flag on account
					setPrivacyDataAction.setCallback(this, function (respnse) {
						var state2 = respnse.getState();
						if (state2 === "SUCCESS") {
							this.fireToast("Data Privacy Flag", "flag/flags set successfully.", "SUCCESS");
							$A.get("e.force:closeQuickAction").fire();
						} else {
							var errors2 = respnse.getError();
							component.set("v.errorMessage", errors2[0].message);
						}
					});
					$A.enqueueAction(setPrivacyDataAction);
				} else {
					component.set("v.errorMessage", response.getReturnValue());
				}
			}
			if (state === "ERROR") {
				var errors = response.getError();
				component.set("v.errorMessage", errors[0].message);
			}
			this.hideSpinner(component);
		});
		$A.enqueueAction(setC1VDataAction);
	},

	//Lightning toastie
	fireToast: function (title, msg, type) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: title,
			message: msg,
			type: type
		});
		toastEvent.fire();
	},

	//Show Spinner
	showSpinner: function (component) {
		component.set("v.isSpinner", true);
	},

	//Hide Spinner
	hideSpinner: function (component) {
		component.set("v.isSpinner", false);
	}
});