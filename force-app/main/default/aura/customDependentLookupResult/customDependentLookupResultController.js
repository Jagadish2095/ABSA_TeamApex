({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
        var getSelectBranchRecord = component.get("v.obranchCodeSelected");
        
        var compEvent = component.getEvent("oSelectedDependentRecordEvent");
        // set the Selected sObject Record and branch code to the event attribute.  
        compEvent.setParams({
            "recordByEvent" : getSelectRecord,
            "recordBranchCodeEvent": getSelectBranchRecord
            
        });  
        compEvent.fire();
        
    }
})