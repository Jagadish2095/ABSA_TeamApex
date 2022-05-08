({
	showSuccessToast: function (component, msg) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			type: "success",
			message: msg
		});
		toastEvent.fire();
	},
	showErrorToast: function (component, msg) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Error!",
			type: "error",
			message: msg
		});
		toastEvent.fire();
	},
	submitEDDRequest: function (component, event, isFileUploaded, file, fileContents) {
		component.set("v.showSpinner", true);
		var action = component.get("c.updateEddDetails");
		console.log(component.get("v.MediaReportReason"));
		console.log(component.get("v.AdversMediaReport"));
		if (isFileUploaded) {
			action.setParams({
				caseId: component.get("v.recordId"),
				mediaReportReason: component.get("v.MediaReportReason"),
				adverseMediaReport: component.get("v.AdversMediaReport"),
				fileName: file.name,
				base64Data: encodeURIComponent(fileContents),
				contentType: file.type,
				isFileUploaded: isFileUploaded
			});
		} else {
			action.setParams({
				caseId: component.get("v.recordId"),
				mediaReportReason: component.get("v.MediaReportReason"),
				adverseMediaReport: component.get("v.AdversMediaReport"),
				fileName: "",
				base64Data: "",
				contentType: "",
				isFileUploaded: isFileUploaded
			});
		}

		// Add callback behavior for when response is received
		action.setCallback(this, function (response) {
			var state = response.getState();
			var msg = response.getReturnValue();
			if (state === "SUCCESS" && msg === "SUCCESS") {
				component.set("v.showSpinner", false);
				var message = "Request has been send to EDD Queue!.";
				this.showSuccessToast(component, message);
			} else if (state === "SUCCESS" && msg !== "SUCCESS") {
				component.set("v.showSpinner", false);
				this.showSuccessToast(component, msg);
			} else if (state === "ERROR") {
				var message = "";
				var errors = response.getError();
				if (errors) {
					message = errors[0].message;
					component.set("v.showSpinner", false);
					this.showErrorToast(component, message);
				}
			}
		});
		$A.enqueueAction(action);
	}
});