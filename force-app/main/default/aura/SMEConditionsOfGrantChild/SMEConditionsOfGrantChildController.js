({
    Remove : function(component, event, helper) {
        var approver = component.get("v.simpleRecord");
        var approverId= approver.Approval_Owner__c;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(approverId==null || approverId!=userId){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{
        component.set("v.showSubSection", false);
        var ACrecordId = component.get("v.ACId");
        var IsExisting = component.get("v.IsExisting");
        if(ACrecordId != null && ACrecordId !='' && IsExisting){
            var action = component.get("c.deleteApplicationConditions");
            action.setParams({
                "appCondition": ACrecordId
            });
            action.setCallback(this, function (response) {
                if (response.getState() == "SUCCESS") {
                      var cmpEvent = component.getEvent("cmpCOGEvent");
                      cmpEvent.setParams( { "selectedMemberValue" : component.get("v.index"),
                                           "ACType":component.get("v.ACType")} ); 
                      cmpEvent.fire();  
                    
                    
                }
                else {
                    this.showError(response, "Remove");
                }
            });
            $A.enqueueAction(action);  
        }
        }
        
    },
    
    OnSave : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        //  alert('Toast fired');
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": "The record has been inserted successfully."
        });
        toastEvent.fire();
        /*   component.find('field').forEach(function(f) {
            f.reset();
        });
         $A.get("e.force:refreshView").fire();    */
        
    },
    handleSubmit: function(component, event, helper) {
        event.preventDefault();       // stop the form from submitting
           var approver = component.get("v.simpleRecord");
           var approverId= approver.Approval_Owner__c;
           var userId = $A.get("$SObjectType.CurrentUser.Id");
        if(approverId==null || approverId!=userId){
          var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type": "error",
                "title": "Error!",
                "message": "Only the allocated sanctioner can make changes to this record"
            });
             toastEvent.fire();     
        }
        else{
            var fields = event.getParam('fields');
          
            component.find('recordHandler').submit(fields);
        }
     },
    handleSuccess: function(component, event) {
        //var updatedRecord = JSON.parse(JSON.stringify(event.getParams()));
        console.log(component.get("v.recordIdC"));
        var record = event.getParam("response");
        console.log('onsuccess: ', record.id);
        component.set("v.ACId",record.id);
        component.set("v.IsExisting",true);
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": "The record has been inserted/updated successfully."
        });
        toastEvent.fire();
    },
    showError: function (response, errorMethod) {
        var message = "";
        var errors = response.getError();
        if (errors) {
            for (var i = 0; i < errors.length; i++) {
                for (var j = 0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].pageErrors[j].message;
                }
                if (errors[i].fieldErrors) {
                    for (var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for (var j = 0; j < thisFieldError.length; j++) {
                            message += (message.length > 0 ? "\n" : "") + thisFieldError[j].message;
                        }
                    }
                }
                if (errors[i].message) {
                    message += (message.length > 0 ? "\n" : "") + errors[i].message;
                }
            }
        } else {
            message += (message.length > 0 ? "\n" : "") + "Unknown error";
        }
        
        // show error notification
        var toastEvent = this.getToast("Error: SMECnditionsOfGrant" + errorMethod + "! ", message, "Error");
        toastEvent.fire();
    },
    getToast: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            duration: 10000,
            title: title,
            message: msg,
            type: type
        });
        
        return toastEvent;
    },
})