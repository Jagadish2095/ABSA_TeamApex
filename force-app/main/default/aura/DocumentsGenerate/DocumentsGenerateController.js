({
    doInit: function(component, event, helper) {
        helper.fetchFileTypesPickListVal(component, 'Type__c');
        helper.checkCasaValidity(component);
    },
    
    doGenerate: function(component, event, helper) {
        if (component.get("v.fileType") == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To generate a document please select the type of document to generate.",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            console.log("doGenerate");
            helper.generateDocument(component, event, helper);
        }
    },

    // Tinashe - New Document Generation
    doNewGenerate: function(component, event, helper) {
        if (component.get("v.fileType") == '') {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams ({
                "title": "Error!",
                "message": "To generate a document please select the type of document to generate.",
                "type": "error"
            });
            toastEvent.fire();
        } else {
            console.log("doNewGenerate");
            helper.generateNewDocument(component, event, helper);
        }
    },
    // end Tinashe
})