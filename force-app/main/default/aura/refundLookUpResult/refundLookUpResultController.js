({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
        var getSelectReasonGroup = component.get("v.reasonGroup");
        var getSelectCategory= component.get("v.category");
        var getSelectRefundId= component.get("v.refundReasonId");
        
        var compEvent = component.getEvent("selectedDependentRecordEvent");
        // set the Selected sObject Record and branch code to the event attribute.  
        compEvent.setParams({
            "recordByEvent" : getSelectRecord,
            "recordReasonGroupEvent": getSelectReasonGroup,
            "categoryEvent": getSelectCategory,
            "refundReasonIdEvent": getSelectRefundId
            
        });  
        compEvent.fire();
        
    }
})