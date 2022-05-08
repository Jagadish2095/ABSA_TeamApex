({
    TransferCase : function(component, event) {
        var rid = component.get("v.caseIdFromFlow");
       
        var selectvalue = component.get("v.targetQueue");
        var action = component.get("c.transferCase");  
        action.setParams({
            "caseId": rid,
            "queueName": selectvalue
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                window.location.reload(true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                }
                else {
                    component.set("v.errorMessage", "Error in Routing case");
                }
            }   
        });
        
        $A.enqueueAction(action);
    },
    
    handleAddComment: function(component, event, helper) {
        
        // action to create new case comment
        var addCommentAction = component.get("c.addCaseComment");
        addCommentAction.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            commentBody: component.get("v.newComment"),
        });
        
        // response handler for the action
        addCommentAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                this.TransferCase(component, event, helper);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                }else {
                    component.set("v.errorMessage", "comment not saved");
                }
            }   
        });
        
        $A.enqueueAction(addCommentAction);        
    },
    
    toggleCommentsVisibility: function(component){
        
        var selectedValue = component.get("v.fraudType");
        
        if((selectedValue == '1st party fraud' || selectedValue == '3rd party fraud')&& component.get("v.Fraudoutcome") == 'Application Fraud'){
            component.set("v.showCommentSection", true);
        }else if(component.get("v.Fraudoutcome") == 'No Fraud'){
            component.set("v.showCommentSection", true);
        }else{
            component.set("v.showCommentSection", false);
        }
    },
    
    fireToastEvent: function (title, msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: msg,
            type: type
        });
        toastEvent.fire();
    },
    
    CloseCase : function(component, event, helper){
        component.find("statusField").set("v.value", "Closed");
        component.find("outOfSLA").set("v.value", "case closed");
        component.find("outOfSLAReason").set("v.value", "Turn-around Times/SLA");
        component.find("caseCloseEditForm").submit();
        $A.get("e.force:refreshView").fire();
    },
    setReminder: function(component, event, helper){
        var datetime = component.get("v.selectDate");
        
        var action = component.get("c.createReminder");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow"),
            dateFromCalendar: component.get("v.selectDate"),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                helper.fireToastEvent("Success!", "Reminder sent successfully", "Success");
                //$A.get("e.force:refreshView").fire();
                helper.caseTransfer(component, event, helper);
                
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                }
                else {
                    component.set("v.errorMessage", "reminder not sent");
                }
            }   
        });
        
        $A.enqueueAction(action);    
    },
   caseTransfer : function(component, event, helper){
        
        
        var action = component.get("c.pauseCaseAndCreateReminder");
        action.setParams({
            caseId: component.get("v.caseIdFromFlow")
        });
         action.setCallback(this, function(response) {
            var state = response.getState();
             var responseValue = response.getReturnValue();
             
            if(state === "SUCCESS") {
                component.set("v.storeBoolean",responseValue);
                
                //window.location.reload(true);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage", errors[0].message);
                    }
                }
                else {
                    component.set("v.errorMessage", "case not transferred");
                }
            }   
        });
       $A.enqueueAction(action);
    }
})