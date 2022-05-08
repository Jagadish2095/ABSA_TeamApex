({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectRecord = component.get("v.oRecord");
        var getSelectTransactionType = component.get("v.transactionTypeSelected");
        var getGLAccountNumber = component.get("v.glAccountNumber");
        var getTypeGroup = component.get("v.typeGroup");
        var getInternalProduct = component.get("v.internalProduct");
        var getVatable= component.get("v.vatable");
        var getStatementNarrative = component.get("v.statementNarrative");
        var getTransactionTypeId = component.get("v.transactionTypeId");
        
        var compEvent = component.getEvent("oSelectedDependentRecordEvent");
        // set the Selected sObject Record and branch code to the event attribute.  
        compEvent.setParams({
            "recordByEvent" : getSelectRecord,
            "recordTransactionTypeEvent": getSelectTransactionType,
            "glAccountNumber": getGLAccountNumber,
            "typeGroup": getTypeGroup, 
            "internalProduct": getInternalProduct,  
            "vatable": getVatable,  
            "statementNarrative": getStatementNarrative,  
            "transactionTypeId": getTransactionTypeId,  
            
        });  
        compEvent.fire();
        
    }
})