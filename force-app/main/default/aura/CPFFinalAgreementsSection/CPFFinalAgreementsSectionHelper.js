({
	updateOppFormStatus : function(component, formStatus) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.updateOppFormStatus");
        action.setParams({
            formStatus: formStatus,
            oppId: recordId
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var responseValue = response.getReturnValue();
                if (responseValue != null) {
                    //helper.fireToast("Success!", "Draft document generated successfully.", "success");
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to update Form Status field Failed. Error : [' + JSON.stringify(errors) + ']');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            } else {
                console.log('Callback to update Form Status field Failed.');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    generateCPFDocument : function(component, docName) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        var action = component.get("c.generateDoc");
        action.setParams({
            oppId: recordId,
            templatename: docName
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
				var responseValue = response.getReturnValue();
                if(responseValue.success == "true")
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": docName + " document successfully generated.",
                        "type":"success"
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error generating document " + docName,
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            } else if(response.getState() === "ERROR"){
                var errors = response.getError();
                console.log('Callback to generateDoc Failed. Error : [' + JSON.stringify(errors) + ']');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            } else {
                console.log('Callback to generateDoc Failed.');
                //helper.fireToast("Error!", "Draft document not generated successfully.", "error");
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    fetchDocuments: function (component) {
        component.set("v.showSpinner", true);
        var action = component.get("c.getDocumentList");
        action.setParams({
            "opportunityId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                data.forEach(function(data){
                    data.ownerName = data.Owner.Name;
                    var nm = data.Name;
                    if (component.get("v.creditApprovalDocStatus") == 'Need file, Incomplete' && nm.includes("Credit Approved")) {
                        component.set("v.creditApprovalDocStatus","No signature needed, complete");
                    }
                    if (component.get("v.standardDocStatus") == 'Need file, Incomplete' && nm.includes("MBBL Standard Terms")) {
                        component.set("v.standardDocStatus","No signature needed, complete");
                    }
                });
                component.set("v.dataAudit", data);
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

        /**
        * @description download function to download file from ECM.
        **/
    download: function (cmp, row) {
        cmp.set('v.showSpinner', true);
        var action = cmp.get('c.getDocumentContent');
        action.setParams({
            "documentId": row.Id
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
                element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('download', row.Name);
                element.style.display = 'none';
                document.body.appendChild(element);
                element.click();
                document.body.removeChild(element);
            } else {
                console.log("Download failed ...");
            }
            cmp.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },
})