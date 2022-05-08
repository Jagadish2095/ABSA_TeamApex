/**
 * @description controller for DocumnetUploade component .
 * @author Nelson Chisoko. on 2019/02/19.
 * @created 2019-03-31
 * @modified 2019-04-01 by Masimba Chingwende.
 * @modified 2019-06-14 by Robert McLean.
 * @Change description added init function to get pick list values
 */
({
    /**
   * @description Set file size attributes.
   **/
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb
    /**
   * @description upload function.
   **/
    upload: function(component, event) {
        component.set("v.showLoadingSpinner", true);
        var fileInput = component.find("fileId").get("v.files");
        var file = fileInput[0];
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            component.set(
                "v.fileName",
                "Alert : File size cannot exceed " +
                self.MAX_FILE_SIZE +
                " bytes.\n" +
                " Selected file size: " +
                file.size
            );
            return;
        }
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function() {
            var fileContents = objFileReader.result;
            var base64 = "base64,";
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });
        objFileReader.readAsDataURL(file);
    },
    /**
   * @description upload files function.
   **/
    uploadProcess: function(component, file, fileContents) {
        var startPosition = 0;
        var relatedPartyId = component.get("v.relatedPartyID");
        console.log("51 relatedPartyId " + relatedPartyId);
        // calculate the end size or endPostion using Math.min() function which is return the min. value
        var endPosition = Math.min(
            fileContents.length,
            startPosition + this.CHUNK_SIZE
        );
        // start with the initial chunk, and set the attachId(last parameter)is null in begin
        this.uploadInChunk(
            component,
            file,
            fileContents,
            startPosition,
            endPosition,
            "",
            startPosition + this.CHUNK_SIZE > fileContents.length,
            relatedPartyId
        );
    },
    /**
   * @description upload chunks function.
   **/
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, isDone, event, relatedPartyId) {
        var getchunk = fileContents.substring(startPosition, endPosition);
          console.log("Related party ID " + component.get("v.relatedPartyID"));
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            done: isDone,
            documentType: component.get("v.fileType"),
            signedManually: '',
            relatedPartyId: null//component.get("v.relatedPartyID")
        });
        action.setCallback(this, function(response) {
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                startPosition = endPosition;
                endPosition = Math.min(
                    fileContents.length,
                    startPosition + this.CHUNK_SIZE
                );
                // check if the start position is still less then end position
                // then call again 'uploadInChunk' method ,
                // else, display alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(
                        component,
                        file,
                        fileContents,
                        startPosition,
                        endPosition,
                        attachId,
                        startPosition + this.CHUNK_SIZE > fileContents.length,
                        relatedPartyId
                    );
                } else {
                    component.set("v.fileName", "File is uploaded successfully!!");
                    component.set("v.showLoadingSpinner", false);
                    /*var compEvent = component.getEvent("refreshListEvent");
                    compEvent.fire();*/
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
        $A.enqueueAction(action);
    },    
       
    fetchFileTypesPickListVal: function(component) {
        var objectName = component.get("v.objectName");
        console.log('Covenant ----> '+ objectName);
        var action = component.get("c.getFileTypePickList");
        action.setParams({
            objectName: objectName,
            selectedField: "Type__c",
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            
            var list = response.getReturnValue();
            console.log('List --->' + list);
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },
    
    fetchDocumentMetadata: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentMetadata");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.documentMetadata", data);
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }
});