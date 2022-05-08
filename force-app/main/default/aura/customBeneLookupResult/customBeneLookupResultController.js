({
    selectRecord : function(component, event, helper){      
        // get the selected record from list  
        var getSelectedbankName = component.get("v.bankName");
        var getSelectedAccountNumber = component.get("v.accountNumber");   
        var getSelectedBranchCode = component.get("v.branchCode");      
        var compEvent = component.getEvent("selectedBeneficiaryListedRecordEvent");
        
        compEvent.setParams({
            "bankNameEvent" : getSelectedbankName,
            "accountNoEvent": getSelectedAccountNumber,
            "branchCodeEvent": getSelectedBranchCode   
        });  
        compEvent.fire();
        
    },
    

    
    
})