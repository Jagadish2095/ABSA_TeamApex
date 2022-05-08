({
       
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    onblur : function(component,event,helper){       
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    keyPressController : function(component, event, helper) {
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");

        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfBankRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');          
        } 
         
    },
    
    clearBranchName :function(component,event,helper){ 
        
        var recordToBeclear = event.getParam("clearBankName");
        $A.enqueueAction(component.get('c.clear'));
        
    },
    
    // function for clear the Record Selection 
    clear :function(component,event,helper){
        var pillTarget = component.find("lookup-pill");
        var lookUpTarget = component.find("lookupField"); 
        
        $A.util.addClass(pillTarget, 'slds-hide');
        $A.util.removeClass(pillTarget, 'slds-show');
        
        $A.util.addClass(lookUpTarget, 'slds-show');
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        
        //component.set("v.searchbyBankName",null);
        component.set("v.listOfBankRecords", null );
        component.set("v.bankName", {} );  
        component.set("v.accountNumber",null);
        component.set("v.branchCode",null);
       
    },
    
    // This function call when the end user select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        
        // Get the selected dependent branch record and Branch code from the COMPONENT event 	 
        var selectedBankNameGetFromEvent = event.getParam("bankNameEvent");
        var selectedAccountNumberGetFromEvent = event.getParam("accountNoEvent");
        var selectedbranchCodeGetFromEvent = event.getParam("branchCodeEvent");
        
        component.set("v.bankName" , selectedBankNameGetFromEvent); 
        component.set("v.accountNumber" , selectedAccountNumberGetFromEvent); 
        component.set("v.branchCode" , selectedbranchCodeGetFromEvent); 
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');

    }
    
})