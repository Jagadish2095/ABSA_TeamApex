({

    setSelectedTransactionTypeName : function(component, event, helper) {
        console.log("setSelectedTransactionTypeName");
        var params = event.getParam('arguments');
        component.set("v.selectedRecord" , params.selectedTransactionType);
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    
    onfocus : function(component,event,helper){
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
       
        var getProduct= component.get("v.dselectedProductType");
        
        var getInputkeyWord = '';
    
        helper.searchHelper(component,event,getInputkeyWord,getProduct);
    },
    
    onblur : function(component,event,helper){       
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    keyPressController : function(component, event, helper) {
        
        //get Bank name
        var getProduct= component.get("v.dselectedProductType");
        console.log('getProduct ' + getProduct);
        
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        
        
        if( getInputkeyWord.length > 0 ){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord,getProduct);
        }
        else{  
            component.set("v.listOfTransactionsRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
            
        } 
        
        if( getProduct ==''){
            
            component.set("v.Message", 'Please select the product First ...'); 
        }
        
    },
    
    clearBranchName :function(component,event,helper){ 
        
        var recordToBeclear = event.getParam("clearBranchName");
        
        // clear attribute dselectedProductType which contain bankName
        component.set("v.dselectedProductType",null);
        //call clear function of same js controller
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
        component.set("v.listOfTransactionsRecords", null );
        component.set("v.selectedRecord", {} );  
        //component.set("v.branchCodeSelected",null);
    },
    
    // This function call when the end user select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
 
        var selectedRecordByEvent = event.getParam("recordByEvent");
        component.set("v.selectedRecord" , selectedRecordByEvent); 

        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show'); 
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
        
        
    },
})