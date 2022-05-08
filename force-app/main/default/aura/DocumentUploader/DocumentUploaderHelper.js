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
            component.set("v.fileName", "Alert : File size cannot exceed " + self.MAX_FILE_SIZE + " bytes.\n" + " Selected file size: " + file.size);
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
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
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
     * Modied by Prashanth Boeni
     **/

    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, isDone, event, relatedPartyId) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        var signedManually = false;

        var isCAFApplication = component.get("v.isCAFApplication");
        var appOppId = component.get("v.applicationId");
        var recId = component.get("v.recordId");
        if (isCAFApplication == true) {
            /*  if(component.get("v.applicationId").length > 0){  */
            var action = component.get("c.saveChunkCAF");
            action.setParams({
                parentId: component.get("v.recordId"),
                oppApplicationId: appOppId,
                fileName: file.name,
                base64Data: encodeURIComponent(getchunk),
                contentType: file.type,
                fileId: attachId,
                done: isDone,
                documentType: component.get("v.fileType"),
                signedManually: signedManually,
                relatedPartyId: component.get("v.relatedPartyID"),
                fExt: component.get("v.fileExtension")
            });
            action.setCallback(this, function(response) {
                attachId = response.getReturnValue();
                var state = response.getState();
                if (state === "SUCCESS") {
                    startPosition = endPosition;
                    endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
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
                        component.set("v.fileName", "File is uploaded successfully");
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

            /*   }else{ alert("Please Select File Type"); }   */
        } else {
            if (isCAFApplication == false) {
                var checkCmp = component.find("radioGrp");
                if (checkCmp.get("v.value") == "Yes") {
                    signedManually = true;
                }
            }
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
                signedManually: signedManually,
                relatedPartyId: component.get("v.relatedPartyID")
            });
            action.setCallback(this, function(response) {
                attachId = response.getReturnValue();
                var state = response.getState();
                if (state === "SUCCESS") {
                    startPosition = endPosition;
                    endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
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
                        component.set("v.fileName", "File is uploaded successfully");
                        component.set("v.showLoadingSpinner", false);
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            type: "success",
                            title: "Success!",
                            message: "File is uploaded successfully, Please refresh the document section before continuing with the application."
                        });
                        toastEvent.fire();
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
        }
    },

    fetchFileTypesPickListVal: function(component) {
        var action = component.get("c.getFileTypePickList");
        action.setParams({
            objectName: "Document__c",
            selectedField: "Type__c",
            caseId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.picklistValues", list);
        });
        $A.enqueueAction(action);
    },

    fetchDocumentTypePickListVal: function(component) {
        var action = component.get("c.getDocumentTypePickList");
        action.setParams({
            objectName: "Document_Template__c",
            selectedField: "Parent_Document_Type__c"
                //caseId: component.get("v.recordId") - removed by Tinashe
        });
        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            component.set("v.documentTypePickList", list);
        });
        $A.enqueueAction(action);
    },

    fetchChildDocumentPickListVal: function(component) {
        var action = component.get("c.getDocumentNamePickList");

        console.log("Document type 168 " + component.get("v.documentType") + " record Id " + component.get("v.recordId"));

        action.setParams({
            documentType: component.get("v.documentType"),
            caseId: component.get("v.recordId")
        });

        action.setCallback(this, function(response) {
            var list = response.getReturnValue();
            console.log("Respone 178 " + JSON.stringify(list));
            component.set("v.childDocumentPicklistValues", list);
        });
        $A.enqueueAction(action);
    },

    fetchDocumentMetadata: function(component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentMetadata");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.documentMetadata", data);
            } else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchOppRecordTypeName: function(component) {
        var action = component.get("c.getRecordTypeName");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.isCAFApplication", data);
                this.isOppRecordCheck(component);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    isOppRecordCheck: function(component) {
        var action = component.get("c.isOppRecord");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.isOppcase", data);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    fetchApplicationPicklistVal: function(component) {
        var action = component.get("c.getApplicationNames");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.applicationPicklistValues", data);
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    upalodFileToRelatedCaseOpp: function(component, uploadedDocumentId) {
        var appOppId = component.get("v.applicationId");
        var action = component.get("c.uploadFileToRelatedList");
        action.setParams({
            parentId: component.get("v.recordId"),
            applicationId: appOppId,
            uploadedDocumentId: uploadedDocumentId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.uploadedDocumentId", "");
                component.set("v.fileName", "");
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    getFiles: function(component, event, helper) {
        var action = component.get("c.geFilesForParentRecord");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data != null && data != undefined) {
                    var optionArray = [];
                    for (var i in data) {
                        var option = {
                            label: data[i].Title,
                            value: data[i].Id
                        };
                        optionArray.push(option);
                    }
                    component.set("v.fileoptions", optionArray);
                }
            } else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
    addDocumentWithFile: function(component, event, selectedFile) {
        var fileType = component.get("v.fileType");
        //alert(fileType);
        component.set("v.showLoadingSpinner", true);
        var action = component.get("c.addDocumentItemWithFileId");
        action.setParams({
            contentDocId: selectedFile,
            parentId: component.get("v.recordId"),
            oppApplicationId: component.get("v.applicationId"),
            signedManually: false,
            relatedPartyId: component.get("v.relatedPartyID"),
            fileType: fileType
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
            } else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showLoadingSpinner", false);
        });
        $A.enqueueAction(action);
    },
    //W-008562
    fetchOpportunityStage: function(component) {
        var action = component.get("c.validateOpportunityStage");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var stage = response.getReturnValue();
                component.set("v.oppStage", stage);
                if (component.get("v.oppStage") == "Closed") {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        type: "error",
                        title: "Error!",
                        message: "You cannot make changes as this opportunity is already Closed."
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },

    // W-8562 - Closed opportunity validation
    closedOpportunityValidation: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: "You are not allowed to upload any documents as it is associated with closed opportunity"
        });
        toastEvent.fire();
    }
});