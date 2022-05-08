({
    onChangeValue : function(component, event, helper) {
        component.set("v.Fraudoutcome",component.find('outCome').get('v.value'));
        component.set("v.showCommentSection", false);
        component.set("v.closeCase", false);
        component.set("v.showReminder",false);
        component.set("v.showReminderButton",false);
        if(component.get('v.Fraudoutcome') != 'Application Fraud'){
            component.set("v.fraudType", null);
        }
        if(component.get('v.Fraudoutcome') == 'Transactional Fraud'){
            component.set("v.targetQueue", $A.get("$Label.c.Complaints_EB_Collections"));
        }
        helper.toggleCommentsVisibility(component);
    },
    
    onRadioButtonChange : function(component, event, helper) {
        
        component.set("v.showCommentSection", false);
        var selectedValue = event.getSource().get("v.label");
        component.set("v.closeCase", false);
        component.set("v.fraudType",selectedValue);
        helper.toggleCommentsVisibility(component);
        component.set("v.showReminderButton",false);
         //component.set("v.showReminder",false);
        if(selectedValue == '1st party fraud'){
            component.set("v.targetQueue", $A.get("$Label.c.First_Party_Fraud"));
            component.set("v.showReminder",false);
            
        }else if(selectedValue == '3rd party fraud'){
            
            if(component.find("type").get("v.value")=== 'Early Risk Detection Holding Case'){
                
                var action = component.get("c.checkDueDate");
                action.setParams({
                    caseId: component.get("v.caseIdFromFlow")
                });
                action.setCallback(this, function(response){
                    var state = response.getState();
                    var responseValue = response.getReturnValue();
                    
                    if(state === "SUCCESS") {
                        if(responseValue === true){
                            component.set("v.closeCase", true);
                        }
                    }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                component.set("v.errorMessage", errors[0].message);
                            }
                        }
                        else {
                            component.set("v.errorMessage", "returned error");
                        }
                    }   
                });
                $A.enqueueAction(action);
            } 
            component.set("v.showReminder",true);
        }
        
    },
    
    getcloseCase : function(component, event, helper){
        helper.handleAddComment(component, event, helper);
        helper.CloseCase(component, event, helper);
    },
    
    BacktoCollections: function(component, event, helper){
        
        if(component.get('v.fraudType') == '1st party fraud'){
            if(!component.get("v.newComment")){
                helper.fireToastEvent("Error!", "case comments cannot be empty", "Error");
                return;
            }
        }
        if(component.get('v.Fraudoutcome') == 'Transactional Fraud'){
            helper.TransferCase(component, event, helper);
            return;
        }
        helper.handleAddComment(component, event, helper);
    },
    
    getDateFromInput: function(component, event, helper) {
        
        component.set("v.showReminderButton",true);   
    },
    
    sendReminder : function(component, event, helper) {
        
        helper.handleAddComment(component, event, helper);
        helper.setReminder(component, event,helper);
    },
    
    refreshView: function (component, event, helper) {
        $A.get("e.force:refreshView").fire();
    }
    
})