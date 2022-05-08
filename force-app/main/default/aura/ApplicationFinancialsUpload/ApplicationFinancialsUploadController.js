({
    doInit: function (component, event, helper) {
        helper.loadClientData(component, event, helper);
    },

    handleUploadFinished: function (component, event, helper) {
        //Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        //alert("Files uploaded : " + uploadedFiles.length);
        //Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    },

    openFinancialUploadModal: function (component, event, helper) {
        component.set("v.showFinancialUploadModal", true);
    },

    closeFinancialUploadModal: function (component, event, helper) {
        component.set("v.showFinancialUploadModal", false);
    },

    submitCapture: function (component, event, helper) {
        component.set("v.showFinancialUploadModal", false);
        if (component.get("v.fileCount") > 0) {
            helper.createCase(component, event, helper);
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

    navigateToFinancialStatement: function (component, event, helper) {
        if (!$A.util.isEmpty(component.get("v.Account.Id"))) {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:ApplicationFinancialsCapture",
                componentAttributes: {
                    recordAccId: component.get("v.Account.Id"),
                    invokedFromAccount: true,
                    recordClientName: component.get("v.Account.Name"),
                    recordClientCode: component.get("v.Account.CIF__c")
                }
            });
            evt.fire();

            /*var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": component.get("v.Account.Id"),
                "slideDevName": "related"
            });
            navEvt.fire();*/
        }
    },

    showButton: function (component, event, helper) {
        var cmpTarget = component.find('acceptButton');
        $A.util.toggleClass(cmpTarget, "slds-hide");

    }
})