({
    fetchFileTypesPickListVal: function(component, fieldName) {
        var action = component.get("c.getDocumentSelectOptions");
        	action.setParams({
        	"fld": fieldName
        });
                
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var list = response.getReturnValue();
            	component.set("v.picklistValues", list);
            }
        });
        $A.enqueueAction(action);
    },
    fetchDocumentGenerationPickListVal: function(component, fieldName) {
        var action = component.get("c.getDocumentSelectOptions");
        	action.setParams({
        	"fld": fieldName
        });
                
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var list = response.getReturnValue();
            	component.set("v.picklistValues", list);
            }
        });
        $A.enqueueAction(action);
    },
    
    checkCasaValidity: function (component) {
        component.set("v.showSpinner", true);
        var oppId = component.get("v.recordId");
        var action = component.get("c.checkCASAValidity");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var casaValidity = response.getReturnValue();
                if(casaValidity == 'Valid'){
                    component.set("v.showDocumentScreen", true);
                    component.set("v.showCasaNotCompleted", false);
                    
                }else{
                    component.set("v.showDocumentScreen", false);
                    component.set("v.showCasaNotCompleted", true);
                }
            }
        });
        component.set("v.showSpinner", false);
        $A.enqueueAction(action);
    },
    
    generateDocument: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("generateDocument");
        var action = component.get("c.generateDocument");
        	action.setParams({
        	"opportunityId": component.get("v.recordId"),
            "templateName": component.get("v.fileType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("Response from generate document : " + JSON.stringify(result));
				if(result.success == "true")
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": component.get("v.fileType") + " document successfully generated.",
                        "type":"success"
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error generating document " + component.get("v.fileType"),
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },

    // Tinashe - New Document Generation
    generateNewDocument: function(component, event, helper) {
        component.set("v.showSpinner", true);
        console.log("generateNewDocument");
        var action = component.get("c.generateNewDocument");
        	action.setParams({
        	"opportunityId": component.get("v.recordId"),
            "templateName": component.get("v.fileType") // I have an issue with this template name use - Tinashe
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log("Response from generate document : " + JSON.stringify(result));
				if(result.success == "true")
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": component.get("v.fileType") + " document successfully generated.",
                        "type":"success"
                    });
                    toastEvent.fire();
                } else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error generating document " + component.get("v.fileType"),
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else {
                console.log("Failed with state: " + state);
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    }
    // end Tinashe
})