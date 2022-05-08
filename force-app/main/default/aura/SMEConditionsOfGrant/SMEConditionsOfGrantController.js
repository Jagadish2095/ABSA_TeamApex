({
    doInit: function (component, event, helper) {
        helper.getApplication(component,event,helper);
        
    },
    OnSubmit : function(component, event, helper) {
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
        var sectionValue = component.get("v.showSection");
        var items= component.get("v.items")
        if(!sectionValue){
            component.set("v.showSection", true);
            
        }
        else{
            items.push(2);
            component.set("v.items",items);
        }
        }
    },
    OnSubmitIC : function(component, event, helper) {
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
        var sectionValue = component.get("v.showSectionIC");
        var items= component.get("v.itemsIC")
        if(!sectionValue){
            component.set("v.showSectionIC", true);
            
        }
        else{
            items.push(2);
            component.set("v.itemsIC",items);
        }
        }
    },
    handleComponentEvent : function(cmp, event) {
        // Get value from Event
        var selectedMemberValue = event.getParam("selectedMemberValue");
        var ACType = event.getParam("ACType");
        if(ACType=='Customer Condition'){
            var items = cmp.get("v.ExistingConditionsList");
            items.splice(selectedMemberValue,1);
            cmp.set("v.ExistingConditionsList", items);  
        }
        else if(ACType=='Internal Condition'){
            var items = cmp.get("v.ExistingConditionsListIC");
            items.splice(selectedMemberValue,1);
            cmp.set("v.ExistingConditionsListIC", items);
        }
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title": "Success!",
            "type" : "success",
            "message": "The record has been deleted successfully."
        });
        toastEvent.fire();
    }
    
    
    
    
})