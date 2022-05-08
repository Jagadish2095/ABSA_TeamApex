({

    generateDocument : function(component, docName) {
        component.set("v.showSpinner", true);
        var recordId = component.get("v.recordId");
        console.log('Generating ' + docName + ' <<<>>> ' + recordId);
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

})