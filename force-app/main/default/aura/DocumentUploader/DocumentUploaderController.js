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
   * @description initiate function to fetch pick list values for filetype.
   * @created 2019-06-14 by Robert McLean.
   **/

    doInit: function(component, event, helper) {
        helper.fetchFileTypesPickListVal(component);
        helper.fetchDocumentMetadata(component);
        helper.fetchDocumentTypePickListVal(component);
        helper.fetchOppRecordTypeName(component);  // Added by Prashanth Boeni
       helper.fetchApplicationPicklistVal(component);  // Added by Prashanth Boeni   
       helper.fetchOpportunityStage(component);// W-08562
    },

   /**
   * @description handleFilesChange function.
   **/
    handleFilesChange: function(component, event, helper) {
        var fileName = "No File Selected..";
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]["name"];
            var fExtension=fileName.split('.').pop();
            component.set("v.fileExtension",fExtension);
        }
        component.set("v.fileName", fileName);
    },
   /**
   * @description doSave function.
   **/
    doSave: function(component, event, helper) {
       //W-008562
        if(component.get("v.oppStage") == 'Closed'){
            helper.closedOpportunityValidation(component, event,helper);
        }else{
       if (!component.get("v.disableRadioButtonGroup")) {
            var checkCmp = component.find("radioGrp");
            if (checkCmp.get("v.value") != 'Yes' && checkCmp.get("v.value") != 'No') {
            	alert("Please indicate if this document has been signed manually");
            } else if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {
                if (component.get("v.fileType").length > 0) {
                    helper.upload(component, event);
                    
                } else {
                    alert("Please Select File Type");
                    console.log(component.get("v.relatedPartyId"));
                }
            } else {
                alert("Please Select a Valid File");
            }
        } else if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {

            if (component.get("v.fileType").length > 0 && component.get("v.fileType") != 'Choose one...') {
                helper.upload(component, event);
            } else {
                alert("Please Select File Type");
            }
        }else {
            alert("Please Select a Valid File");
        }
        }
    },

    onPicklistDocumentChange: function(component, event, helper) {
        var documents = component.get("v.documentMetadata");
        var fileType = component.get("v.fileType");
        console.log('documentMetadata '+JSON.stringify(documents));
        for(var i in documents){
            if(documents[i].Document_Type__c == fileType){
                //alert(documents[i].Document_Source__c);
                component.set("v.documentSource",documents[i].Document_Source__c);
                break;
            }
        }
        var radioGrp= component.find("radioGrp");

        var action = component.get("c.validateQAProcess");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getReturnValue();
            console.log("response"+state);
            if (state === true) {
                 console.log("In True");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "title": "Error!",
                    "message": "You cannot make changes as this opportunity is undergoing QA review."
                });
                toastEvent.fire();
            }
            else {
                $A.util.addClass(radioGrp, 'slds-hide');
                component.set("v.selectSignedManuallyOption", false);
                component.set("v.disableRadioButtonGroup", true);
                for (var i = 0; i < documents.length; i++) {
                    if(documents[i].Document_Type__c == component.get("v.fileType") && documents[i].Signature_Required__c) {
                        component.set("v.disableRadioButtonGroup", false);
                        $A.util.removeClass(radioGrp, 'slds-hide');
                    }
                }
            }
        });
      $A.enqueueAction(action);
    },

    onPicklistDocumentTypeChange: function(component, event, helper) {
        helper.fetchChildDocumentPickListVal(component);
    },

    handleRelatedParty: function(component, event, helper) {
        console.log("handleRelatedParty 70");
        var relatedPartyID = event.getParam("relatedPartyID");
        component.set("v.relatedPartyID", relatedPartyID);
        console.log(" 74 Related Party " + component.get("v.relatedPartyID"));
    },
    handleUploadFinished: function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
        var uploadedDocumentId = '';
        uploadedFiles.forEach(file =>uploadedDocumentId = file.documentId);
        //,component.set("v.fileName",file.name)
        component.set("v.uploadedDocumentId",uploadedDocumentId);
    },
    handleUploadFileToRelated: function(component, event, helper) {
        var appOppId = component.get("v.applicationId");
        var documentType = component.get("v.documentType");
        var fileType = component.get("v.fileType");

            var uploadedDocumentId = component.get("v.uploadedDocumentId");
            helper.upalodFileToRelatedCaseOpp(component,uploadedDocumentId);
    },
    getFiles: function(component, event, helper) {
        component.set("v.showFilesPopup",true);
        helper.getFiles(component, event, helper);
    },
    saveSelectedFile : function(component, event, helper) {
        component.set("v.showFilesPopup",false);
    },
    closeModelFiles : function(component, event, helper) {
        component.set("v.showFilesPopup",false);
    },
    doSaveFile : function(component, event, helper) {
        var selectedFile = component.get("v.selectedFile");
        //alert(selectedFile);
        helper.addDocumentWithFile(component, event,selectedFile);
    }
});