({
    doInit: function (component, event, helper) {
        helper.getFinancialByAccountId(component);
        helper.getAccClientType(component);
    },

    navigateFinancialStatement: function (component, event, helper) {
        var ctarget = event.currentTarget;
        var id_str = ctarget.dataset.value;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": id_str
        });
        navEvt.fire();
    },

    createFinancialStatement: function (component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:ApplicationFinancialsCapture",
            componentAttributes: {
                recordAccId: component.get("v.recordId"),
                invokedFromAccount: true,
                recordClientName: component.get("v.fromAccnt.Name"),
                recordClientCode: component.get("v.fromAccnt.CIF__c")
            }
        });
        evt.fire();
    },

    handleUploadFinished: function (component, event, helper) {
        var uploadedFiles = event.getParam("files");
        component.set("v.fileCount", uploadedFiles.length);
        let message = "File upload successfully.";
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": message
        });
        toastEvent.fire();
    },

    openFinancialUploadModal: function (component, event, helper) {
        component.set("v.showSaveBtn", false);
        component.set("v.showFinancialUploadModal", true);
    },

    closeFinancialUploadModal: function (component, event, helper) {
        component.set("v.showFinancialUploadModal", false);
    },

    submitCapture: function (component, event, helper) {
        component.set("v.showFinancialUploadModal", false);
        if (component.get("v.fileCount") > 0) {
            helper.createCase(component);
        }
        else {
            let message = "Please upload Financials Statement document.";
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type": "error",
                "message": message
            });
            toastEvent.fire();
        }
    },

    fetchClientType: function (component, event, helper) {
        component.set("v.showSpinner", true);
    }
})