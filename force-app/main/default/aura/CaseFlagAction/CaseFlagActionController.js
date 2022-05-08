({
	clickSpam : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.flagCase");
        
        action.setParams({
            "caseId":component.get("v.recordId"),
            "theAction":"Spam / Junk"
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {

                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case flagged as Spam",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }else{
                
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error while flagging this email as Spam",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
        component.set("v.isOpen", false);
    },
    clickOOO : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.flagCase");
        
        action.setParams({
            "caseId":component.get("v.recordId"),
            "theAction":"Out-of-Office"
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
                

                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case flagged as Out of Office",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                
                //Refresh the related list after the home navigation
                $A.get("e.force:refreshView").fire();
            }else{
                
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error while flagging this email as Out of Office",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    clickSentToQ : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.flagCase");
        
        action.setParams({
            "caseId":component.get("v.recordId"),
            "theAction":"Sent to Queue"
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
                

                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case flagged as Sent to Queue",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                
                //Refresh the related list after the home navigation
                $A.get("e.force:refreshView").fire();
            }else{
                
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error while flagging this email as Sent to Queue",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    clickFollowUp : function(component, event, helper) {
        
        helper.showSpinner(component);
        
        var action = component.get("c.flagCase");
        
        action.setParams({
            "caseId":component.get("v.recordId"),
            "theAction":"Follow Up"
        });
        
        // Add callback behavior for when response is received
        action.setCallback(this, function(response) {
         
        var state = response.getState();
         
            if (component.isValid() && state === "SUCCESS") {
                

                // show success notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Case flagged as Follow Up",
                    "type":"success"
                });
                
                toastEvent.fire();
                helper.hideSpinner(component);
                
                helper.closeFocusedTab(component);
                //helper.navHome(component, event, helper);
                
                //Refresh the related list after the home navigation
                $A.get("e.force:refreshView").fire();
            }else{
                
                // show error notification
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": "There was an error while flagging this email as Follow Up",
                    "type":"error"
                });
                
                toastEvent.fire();
                
                helper.hideSpinner(component);
        
                 // refresh record detail
                $A.get("e.force:refreshView").fire();
            }
       });

        // Send action off to be executed
        $A.enqueueAction(action);
    },
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpen", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
   },    
})