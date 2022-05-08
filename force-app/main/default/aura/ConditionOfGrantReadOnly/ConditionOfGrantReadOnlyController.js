({
    doInit: function (component, event, helper) {
        component.set('v.columns', [
            {label: 'CONDITION CATEGORY', fieldName: 'Category__c', type: 'text',initialWidth: 200},
            {label: 'CONDITION TYPE', fieldName: 'Condition__c', type: 'text',wrapText: true,initialWidth: 300},
            {label: 'COMMENT', fieldName: 'Comment__c', type: 'text',wrapText: true,initialWidth: 705}
         ]);
        helper.getApplication(component,event,helper);
        
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