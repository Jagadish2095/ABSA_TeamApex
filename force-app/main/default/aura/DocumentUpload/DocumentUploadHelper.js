({
	MAX_FILE_SIZE: 50000000, //Max file size 50 MB
	CHUNK_SIZE: 750000, //Chunk Max size 750Kb

	uploadHelper: function (component, event) {
		// start/show the loading spinner
		component.set("v.showLoadingSpinner", true);
		// get the selected files using aura:id [return array of files]
		var fileInput = component.find("fileId").get("v.files");
		// get the first file using array index[0]
		var file = fileInput[0];
		var self = this;
		// check the selected file size, if select file size greter then MAX_FILE_SIZE,
		// then show a alert msg to user,hide the loading spinner and return from function
		if (file.size > self.MAX_FILE_SIZE) {
			component.set("v.showLoadingSpinner", false);
			component.set("v.fileName", "Alert : File size cannot exceed " + self.MAX_FILE_SIZE + " bytes.\n" + " Selected file size: " + file.size);
			return;
		}

		// create a FileReader object
		var objFileReader = new FileReader();
		// set onload function of FileReader object
		objFileReader.onload = $A.getCallback(function () {
			var fileContents = objFileReader.result;
			var base64 = "base64,";
			var dataStart = fileContents.indexOf(base64) + base64.length;

			fileContents = fileContents.substring(dataStart);
			// call the uploadProcess method
			self.uploadProcess(component, file, fileContents);
		});

		objFileReader.readAsDataURL(file);
	},

	uploadProcess: function (component, file, fileContents) {
		// set a default size or startpostiton as 0
		var startPosition = 0;
		// calculate the end size or endPostion using Math.min() function which is return the min. value
		var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

		// start with the initial chunk, and set the attachId(last parameter)is null in begin
		this.uploadInChunk(component, file, fileContents, startPosition, endPosition, "", startPosition + this.CHUNK_SIZE > fileContents.length);
	},

	uploadInChunk: function (component, file, fileContents, startPosition, endPosition, attachId, isDone) {
		// call the apex method 'saveChunk'
		//alert('isDone'+JSON.stringify(isDone))

		var getchunk = fileContents.substring(startPosition, endPosition);
		var action = component.get("c.saveChunk");
		action.setParams({
			parentId: component.get("v.parentId"),
			fileName: file.name,
			base64Data: encodeURIComponent(getchunk),
			contentType: file.type,
			fileId: attachId,
			done: isDone,
			documentType: "Attestation"
		});

		// set call back
		action.setCallback(this, function (response) {
			// store the response / Attachment Id
			attachId = response.getReturnValue();
			var state = response.getState();
			if (state === "SUCCESS") {
				// update the start position with end postion
				startPosition = endPosition;
				endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
				if (startPosition < endPosition) {
					this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
				} else {
					// alert('uploaded');
					component.set("v.showLoadingSpinner", false);
					component.set("v.isCheckUpload", true);
					window.setTimeout(
						$A.getCallback(function () {
							component.set("v.isOpen", false);
							var cmpEvent = component.getEvent("upload");

							cmpEvent.setParams({
								message: false,
								uploadcheck: component.get("v.isCheckUpload")
							});
							cmpEvent.fire();
						}),
						5000
					);
				}
				// handle the response errors
			} else if (state === "INCOMPLETE") {
				alert("From server: " + response.getReturnValue());
			} else if (state === "ERROR") {
				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title: "Error!",
					message: "Error with uplading Document.",
					type: "error"
				});
				toastEvent.fire();
			}
		});
		// enqueue the action
		$A.enqueueAction(action);
	}
});