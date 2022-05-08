({
	/*
	* Added by Sandeep Golla on 24/05/2021
	*/
	handleCreateLoad: function (component, event, helper) {

		var recUi = event.getParam("recordUi");
		if(recUi.record.fields["Adverse_Media_Report__c"].value) {
			component.set("v.AdversMediaReport", recUi.record.fields["Adverse_Media_Report__c"].value);
		}
		if(recUi.record.fields["Reason_for_Adverse_Media_Report__c"].value) {
			component.set("v.MediaReportReason", recUi.record.fields["Reason_for_Adverse_Media_Report__c"].value);
		}
	},

	/*
	* Updated by Sandeep Golla on 24/05/2021
	* Added validation logic for the fields
	*/
	handleClick: function (component, event, helper) {
		var showValidationError = false;
		var vaildationFailReason = "";

		if (!component.get("v.AdversMediaReport")) {
			showValidationError = true;
			vaildationFailReason = "Adverse Media Report should not be Blank";
		} else if (!component.get("v.MediaReportReason")) {
			showValidationError = true;
			vaildationFailReason = "Reason for Adverse Media Report should not be Blank";
		}

		if (showValidationError) {
			helper.showErrorToast(component, vaildationFailReason);
		} else {
			var files = component.find("fileid").get("v.files");
			var file;
			var fileContents;
			if (files != null && files.length > 0) {
				file = files[0];
				var objFileReader = new FileReader();
				objFileReader.onload = $A.getCallback(function () {
					component.set("v.showSpinner", true);
					fileContents = objFileReader.result;
					var base64 = "base64,";
					var dataStart = fileContents.indexOf(base64) + base64.length;
					fileContents = fileContents.substring(dataStart);
					helper.submitEDDRequest(component, event, true, file, fileContents);
				});
				objFileReader.readAsDataURL(file);
			} else {
				component.set("v.showSpinner", true);
				helper.submitEDDRequest(component, event, false, file, fileContents);
			}
		}
	},
	handleFilesChange: function (component, event, helper) {
		var fileName = "No File Selected..";
		if (event.getSource().get("v.files").length > 0) {
			fileName = event.getSource().get("v.files")[0]["name"];
		}
		component.set("v.fileName", fileName);
	},
	onMediaReportChange: function (component, event, helper) {
		console.log("inside onMediaReportChange");
		console.log(component.find("mediareportId").get("v.value"));
		component.set("v.AdversMediaReport", component.find("mediareportId").get("v.value"));
	},
	onReportReasonChange: function (component, event, helper) {
		console.log("onMediaReportChange");
		console.log(component.find("reportreasonId").get("v.value"));
		component.set("v.MediaReportReason", component.find("reportreasonId").get("v.value"));
	}
});