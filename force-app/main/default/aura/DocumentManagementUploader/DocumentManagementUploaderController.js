({
    doInit: function(component, event, helper) {
        helper.fetchFileTypesPickListVal(component);
        //helper.fetchDocumentMetadata(component);
    },
   
    handleFilesChange: function(component, event, helper) {
        var fileName = 'No File Selected..';
        if (event.getSource().get("v.files").length > 0) {
            fileName = event.getSource().get("v.files")[0]['name'];
        }
        component.set("v.fileName", fileName);
    },
    
    doSave: function(component, event, helper) {
        if (component.find("fileId").get("v.files") && component.find("fileId").get("v.files").length > 0) {
            helper.upload(component, event);
        } else {
            alert('Please Select a Valid File');
        }
    },
    
    onPicklistDocumentChange: function(component, event, helper) {
        var documents = component.get("v.documentMetadata");
        component.set("v.selectSignedManuallyOption", false);
        component.set("v.disableRadioButtonGroup", true);
        for (var i = 0; i < documents.length; i++) {
            if(documents[i].Document_Type__c == component.get("v.fileType") && documents[i].Signature_Required__c) {
                component.set("v.disableRadioButtonGroup", false);
            }
        }
    }
});