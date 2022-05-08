({
    
    
    doInit : function(component, event, helper) {
         
        if(!$A.util.isUndefinedOrNull(component.get("v.selectedAccountNumber")) && 
           !$A.util.isUndefinedOrNull(component.get("v.selectedProductValue")) ){            
            component.set("v.validSelection", true);             
        }
        
    },
    
    onAccountSubmit: function(component, event, helper) { 
         helper.showSpinner(component);
        component.set('v.accountInfoResponse',null); 
        if(component.get('v.selectedAccountNumber') == ''){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "message": "Please Select Account!",
                "type":"error"
            });
            toastEvent.fire(); 
             helper.hideSpinner(component);
        }else { 
            helper.getNHAccountInfoHelper(component, event, helper);
        }
    },
    caseCloseController: function(component, event, helper) { 
        debugger;
        helper.caseCurrentCaseHelper(component, event, helper);
    }
})