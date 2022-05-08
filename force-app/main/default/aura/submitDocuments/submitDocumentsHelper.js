({
    getAllEmails: function (component) {
		component.set("v.showSpinner", true);
        
        var oppId = component.get("v.recordId");
        var action = component.get("c.getEmails");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var opts = [];
                for (var i = 0; i < data.length; i++) {
                     opts.push({
                        class: "optionClass",
                        label: data[i],
                        value: data[i]
                    });
                }
               
                component.set("v.emailOptions", opts);
            }
            component.set("v.showSpinner", false);
            component.set("v.selectedEmail", data[0]);
        });
        $A.enqueueAction(action);
    },
    
    sendDocsDefault: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var emailAddress = component.get("v.selectedEmail");
        var action = component.get("c.sendEmail");
        action.setParams({
            "oppId": oppId,
            "emailAddress": emailAddress,
            "isAlternative": false
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if(a.getReturnValue() == true){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Documents Successfully Sent.",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error sending new documents. Please try again!",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else{
               	// show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error sending new documents. Please try again!",
                    "type":"error"
                });
                toastEvent.fire(); 
            }
            component.set("v.showSpinner", false);
            var a = component.get('c.doInit');
        	$A.enqueueAction(a);
        });
        $A.enqueueAction(action);
    },
    
    checkPolicyExists: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");

        var action = component.get("c.getPolicyNumber");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if(a.getReturnValue() == true){
                   component.set("v.showPolicyNotCompleted", false); 
                }
                else{
                   component.set("v.showPolicyNotCompleted", true);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    getEmailStatus: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");

        var action = component.get("c.checkEmailStatus");
        action.setParams({
            "oppId": oppId
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if(a.getReturnValue() == true){
                   component.set("v.emailStatus", true); 
                }
                else{
                   component.set("v.emailStatus", false);
                }
            }
            component.set("v.showSpinner", false);
        });
        $A.enqueueAction(action);
    },
    
    sendDocsAlternative: function (component) {
        component.set("v.showSpinner", true);

        var oppId = component.get("v.recordId");
        var altEmailAddress = component.get("v.alternativeEmail");

        var action = component.get("c.sendAlternativeEmail");
        action.setParams({
            "oppId": oppId,
            "altEmailAddress": altEmailAddress
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if(a.getReturnValue() == true){
                    // show success notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "Documents Successfully Sent.",
                        "type":"success"
                    });
                    toastEvent.fire();
                }
                else{
                    // show error notification
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Error sending new documents. Please try again!",
                        "type":"error"
                    });
                    toastEvent.fire();
                }
            }
            else{
               	// show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error sending new documents. Please try again!",
                    "type":"error"
                });
                toastEvent.fire(); 
            }
            
            component.set("v.showSpinner", true);
            var a = component.get('c.doInit');
        	$A.enqueueAction(a);
        });
        $A.enqueueAction(action);
    },
        
})