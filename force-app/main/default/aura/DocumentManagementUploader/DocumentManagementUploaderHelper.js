/**
 * A helper to upload relatively large files upto 4.5 MB.
 */
({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb 
    
    upload: function(component, event) { 
        component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this; 
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            return;
        }
 
        // create a FileReader object 
        var objFileReader = new FileReader();
        // set onload function of FileReader object   
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
 
            fileContents = fileContents.substring(dataStart);
            // call the uploadProcess method 
            self.uploadProcess(component, file, fileContents);
        });
 
        objFileReader.readAsDataURL(file);
    },
 
    uploadProcess: function(component, file, fileContents) {
        // set a default size or startpostiton as 0 
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value   
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
 
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', (startPosition + this.CHUNK_SIZE) > fileContents.length);
    },
 
 
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, isDone) {
        // call the apex method 'saveChunk'
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            //parentId: component.get("v.recordId"),
            //fileName: file.name,
            //base64Data: encodeURIComponent(getchunk),
            //contentType: file.type,
            //fileId: attachId,
            //done: isDone
            
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            done: isDone,
            documentType: component.get("v.fileType")
        });
 
        // set call back 
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end position
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start position is still less then end position 
                // then call again 'uploadInChunk' method , 
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, (startPosition + this.CHUNK_SIZE) > fileContents.length);
                } else {
                    //alert('your File is uploaded successfully');
                	//this.completeUpload(attachId);
                	component.set("v.fileName", "File is uploaded successfully");
                    component.set("v.showLoadingSpinner", false);
                }
                // handle the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    },
    
    completeUpload: function (attachId) {
    	var action = component.get("c.completeUpload");
        action.setParams({
            fileId: attachId
        });
        action.setCallback(this, function(response) {
            // store the response / Attachment Id   
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
            	console.log("Completing file upload ..." + attachId);
            } else {
            	console.error("Error completing file upload ..." + attachId);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchFileTypesPickListVal: function(component) {
        var action = component.get("c.getFileTypePickList");
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    }
})