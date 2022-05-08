({
    //Helper Class
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000,      //Chunk Max size 750Kb
    
    fetchChildDocumentPickListVal: function(component) {
        var action = component.get("c.getDocumentSubType");
        action.setParams({
            ParentDocumentType: component.get("v.parentDocumentType")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            console.log("Respone 178 " + JSON.stringify(list));
            component.set("v.childDocumentPicklistValues", list);
            component.set("v.showStartSpinner", false);
            component.set("v.isUpload", true);
        });
        $A.enqueueAction(action);
    },
    
    //function which will upload the document from the dashboard to AMBER
    uploadHelper: function(component, event) {
        component.set("v.showSmallSpinner", true);
        component.set('v.goldenSourceButton',true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showSmallSpinner", false);
            component.set("v.fileName", 'Alert : File Size Cannot Exceed ' + self.MAX_FILE_SIZE + ' Bytes.\n' + ' Selected File Size: ' + file.size);
            return;
        }
        var objFileReader = new FileReader();
        
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    
    uploadProcess: function(component, file, fileContents) {
        var startPosition = 0;
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
        
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '');
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId) {
        // call the apex method 'saveInChunk'
        //alert('inside upload chunk, isdone value is --> '+isDone);
        //alert('inside upload chunk, attachid value is --> '+attachId);
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveInChunk");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            documentType: component.get("v.parentDocumentType")
        });
        
        // set call back
        action.setCallback(this, function(response) {
            // store the response/Attachment Id
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion
                // then call again 'uploadInChunk' method ,
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId);
                } else {
                    var documentType = component.get("v.parentDocumentType");
                    var subDocumentType = component.get("v.documentSType");
                    this.uploadToAmber(component, attachId, documentType,subDocumentType);
                }
                // handle the response errors
            } else{
                var errors = response.getError();
                var msg = 'Failed to upload Document, '+errors[0].message;
                var type= 'error';
                this.showToast(component, event, msg, type );
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }, 
    
    uploadToAmber: function(component, attachId, documentType,subDocumentType) {
        var action = component.get("c.completeUpload");
        action.setParams({
            fileId : attachId,
            documentType : documentType,
            subDocumentType1 : component.get("v.documentSType")
        });
        action.setCallback(this, function(response) {
            var msg;
            var type;
            var state = response.getState();
            if (state === "SUCCESS") {
               var pId = response.getReturnValue(); 
                if(pId != null && pId != ''){
                    msg = 'The File Has Been Uploaded Successfully !!!';
                    type = 'success';
                    this.showSuccessToast(component, event, msg);
                }
                else{
                    msg = 'Failed To Upload the document in Amber';
                	type = 'error';
                	this.showToast(component, event, msg, type);
                }
            }
            else{
                var errors = response.getError();
                //alert(errors[0].message);
                msg = errors[0].message;
                type = 'error';
                this.showToast(component, event, msg, type);
            }
    		component.set("v.isUpload", false);
            component.set("v.isUploadInit", false);
            component.set("v.showSmallSpinner", false);
            component.set("v.fileName", 'No File Selected..');
			component.set("v.isUploading", true);
            
        });
        $A.enqueueAction(action);
    },
    
    showSuccessToast : function(component, event, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": message
        });
        toastEvent.fire();
    },
    
    showToast : function(component, event, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" : type,
            "message": message,
            "mode":"sticky"
        });
        toastEvent.fire();
    },
})