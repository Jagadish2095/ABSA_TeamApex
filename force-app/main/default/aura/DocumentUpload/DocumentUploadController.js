({
	doSave: function (component, event, helper) {
		if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {
			helper.uploadHelper(component, event);
		} else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Error!",
				message: "Please select a valid File.",
				type: "error"
			});
			toastEvent.fire();
		}
	},

	handleFilesChange: function (component, event, helper) {
		var fileName = "No File Selected..";
		if (event.getSource().get("v.files").length > 0) {
			fileName = event.getSource().get("v.files")[0]["name"];
		}
		component.set("v.fileName", fileName);
	},
	closeModel: function (component, event, helper) {
		component.set("v.isOpen", false);
		var cmpEvent = component.getEvent("upload");

		cmpEvent.setParams({
			message: false,
			uploadcheck: component.get("v.isCheckUpload")
		});
		cmpEvent.fire();
		//alert('cmpEvent'+cmpEvent)
	}
});